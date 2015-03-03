---
title: Using action-based and verb-based routing in the same ApiController
date: 2013-11-18 16:22:00 -0300
tags: [asp.net web api]
---

Action method selection in Web API is a lot smarter than MVC's. The biggest difference is that the `action` route parameter is not required, allowing you to select an action based on the HTTP method of the request (verb-based). However, you can run into issues if you try to use both action-based and verb-based routing in the same ApiController.

The Problem
-----------
For example, let's say we have this route:

```csharp
routes.MapHttpRoute(null, "api/book/{action}", 
    new { controller = @"Book", action = RouteParameter.Optional }, 
    new { action = @"(search|new)?" });
```

And this controller:

```csharp
public class BookController : ApiController {

   public object Get() {
      ...
   }

   [HttpGet]
   public object Search() {
      ...
   }

   [HttpGet]
   public object New() {
      ...
   }
}
```

Everything works fine when you do `GET /api/book/search` or `GET /api/book/new`, but if you try `GET /api/book` you get the following error: *Multiple actions were found that match the request: Get() Search() New()*.

The first two cases work because, when the `action` parameter is used, it must match the action method name or alias (`[ActionName]` attribute), simple as that.

When the `action` parameter is **not** used, then action selection is done based on the HTTP method of the request. These includes methods named using the HTTP method as prefix (e.g. `Get` or `GetBook`), and methods decorated with a matching HTTP-verb attribute (e.g. `[HttpGet]`). By these rules, our three methods match and thus we get the error.

The Proposed Solutions
----------------------

This feature request was [reported][1], but sadly rejected. The proposed solution was, when doing verb-based matching and more than one method matches, exclude all methods decorated with HTTP-verb attributes. We need a way to tell the framework which methods are meant to match the `action` parameter and which are meant to match the HTTP method. It's obvious that using both an HTTP-verb attribute and a prefixed name at the same time makes no sense. This solution would be a perfectly good convention for the job.

Another solution proposed by another user, was the use of an attribute to explicitly specify which methods should match the `action` parameter:

```csharp
public class NamedActionAttribute : Attribute, IActionMethodSelector {
    public bool IsValidForRequest(HttpControllerContext controllerContext, MethodInfo methodInfo) {
        return controllerContext.RouteData.Values.ContainsKey("action");
    }
}
```

Unfortunately, the `IActionMethodSelector` interface is internal, so we cannot implement this outside the framework.

I'm disappointed that none of these solutions were accepted by the ASP.NET team. Their answer was "use attribute routing instead".

The Working Solution
--------------------
Web API has a service called `ApiControllerActionSelector` we can use to customize action selection.

```csharp
class CustomApiControllerActionSelector : ApiControllerActionSelector {

   public override HttpActionDescriptor SelectAction(HttpControllerContext controllerContext) {

      IHttpRouteData routeData = controllerContext.RouteData;
      bool containsAction = routeData.Values.ContainsKey("action");
         
      if (containsAction) {
         return base.SelectAction(controllerContext);
      }

      try {
         routeData.Values["action"] = controllerContext.Request.Method.Method;

         return base.SelectAction(controllerContext);

      } finally {

         routeData.Values.Remove("action");
      }
   }
}
```

What the above code does is, if the `action` parameter is not present then temporarily add it while we do action selection, using the value of the request HTTP method. This means we always do action-based selection, thus avoiding the problem. So, for `GET /api/book`, it matches the `Get` method, but it won't match `GetBook`.

Hope you like this. Don't forget to register the service, `Application_Start` would be a good place to do it:

```csharp
configuration.Services.Replace(typeof(IHttpActionSelector), new CustomApiControllerActionSelector());
```

BTW, this is built into [MvcCodeRouting][2] now :-)

[1]: https://aspnetwebstack.codeplex.com/workitem/184
[2]: https://mvccoderouting.codeplex.com/