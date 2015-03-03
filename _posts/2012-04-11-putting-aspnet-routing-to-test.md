---
title: Putting ASP.NET Routing to test
date: 2012-04-11 16:33:00 -0300
tags: [asp.net, asp.net mvc, routing]
---

This post is not about unit-testing your routes, it's about testing the features of ASP.NET Routing to verify and acquire an in-depth knowledge of its functionality.

Having used ASP.NET MVC for a long time I thought I had a complete understanding about how Routing worked, but the other day I wasn’t sure about something that thought should work and took for granted. So I decided to write some tests to clear my doubts and hopefully learn something new.

Some of these tests verify things you probably already know, if something is too obvious you can just skip to the next one. You don't need to follow the test code, but after each test I've included information on how to take advantage or how to avoid common issues&nbsp;of the tested functionality.

Test class setup
----------------
```csharp
RouteCollection routes;
UrlHelper Url;

[TestInitialize]
public void Init() {
         
   this.routes = new RouteCollection();

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.ApplicationPath).Returns("");
   httpContextMock.Setup(c => c.Response.ApplyAppPathModifier(It.IsAny<string>()))
      .Returns<string>(s => s);

   var routeData = new RouteData();
   var requestContext = new RequestContext(httpContextMock.Object, routeData);
         
   this.Url = new UrlHelper(requestContext, routes);
}
```

I'll be using [UrlHelper][1] to generate URLs because it has a nice API, but that doesn’t mean what I’m testing is specific to MVC, you could write the same tests using [RouteCollection.GetVirtualPath][2].

Name is optional
----------------
```csharp
[TestMethod]
public void NameIsOptional() { 
         
   routes.Clear();
   routes.MapRoute(null, "");
}
```

The route name is completely optional. I used to waste time trying to come up with a consistent naming convention and didn’t even use them.


Parameters are required by default
----------------------------------
```csharp
[TestMethod]
public void ParametersAreRequiredByDefault() {

   routes.Clear();
   routes.MapRoute(null, "{a}");

   Assert.IsNull(Url.RouteUrl(new { }));
   Assert.AreEqual(Url.RouteUrl(new { a = "b" }), "/b");

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/");

   Assert.IsNull(routes.GetRouteData(httpContextMock.Object));

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/b");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));
}
```

You should know this one, so I won’t say much about it. When you include a parameter in the URL pattern, that parameter is required for both incoming requests and URL generation.

In case you are not familiar with [UrlHelper.RouteUrl][3], `Url.Action("Index", "Home")` is equivalent to `Url.RouteUrl(new { action = "Index", controller = "Home" })`. I'm not using action and controller parameters to emphasize that: A. the tests are not specific to MVC; B. action and controller parameters are not special in any way.

Default value makes parameter optional
--------------------------------------
```csharp
[TestMethod]
public void DefaultValueMakesParameterOptional() {

   routes.Clear();
   routes.MapRoute(null, "{a}", new { a = "b" });

   Assert.AreEqual(Url.RouteUrl(new { }), "/");

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));
}
```

The title says it all. You should know this one also.

Can use null or empty string for parameter with default value
-------------------------------------------------------------
```csharp
[TestMethod]
public void CanUseNullOrEmptyStringForParameterWithDefaultValue() {

   routes.Clear();
   routes.MapRoute(null, "{a}", new { a = "b" });

   Assert.AreEqual(Url.RouteUrl(new { a = (string)null }), "/");
   Assert.AreEqual(Url.RouteUrl(new { a = "" }), "/");
}
```

In the previous test we verified that when a parameter is optional you can omit its value in URL generation. Using null or an empty string also works.

I like to take advantage of this one when generating URLs that refer to the default action of a controller, for example `Url.Action("")` or `Url.Action("", "Account")`. Note that for these to work the route **must** include the `{action}` token, I explain why on the next test.

Cannot use null or empty string for default value without parameter
-------------------------------------------------------------------
```csharp
[TestMethod]
public void CannotUseNullOrEmptyStringForDefaultValueWithoutParameter() {

   routes.Clear();
   routes.MapRoute(null, "a", new { b = "c" });

   Assert.IsNull(Url.RouteUrl(new { b = (string)null }));
   Assert.IsNull(Url.RouteUrl(new { b = "" }));
}
```

This one is interesting. If you have a default value without a corresponding parameter, using null or empty string for that value in URL generation does not match the route.

This is common when you have a route that is specific to a single controller or action, e.g.

```csharp
routes.MapRoute(null, "Products/Search",
   new { controller = "Products", action = "Search" });
```

Value must match default value without parameter or be omitted
--------------------------------------------------------------
```csharp
[TestMethod]
public void ValueMustMatchDefaultValueWithoutParameterOrBeOmitted() {

   routes.Clear();
   routes.MapRoute(null, "a", new { b = "c" });

   Assert.AreEqual(Url.RouteUrl(new { b = "c" }), "/a");
   Assert.AreEqual(Url.RouteUrl(new { }), "/a");
}
```

In the previous test we verified that using null or empty string does not work. Omitting the value or using the same value as the default works.

Going back to the `"Products/Search"` example, this test verifies that controller and action are constants that can either be omitted or provided with the same value to match the route. This is a nice feature that frees us from having to provide constraints for those values, e.g.

```csharp
routes.MapRoute(null, "Products/Search",
   new { controller = "Products", action = "Search" },
   new { controller = "Products", action = "Search" }); // Constraints are not needed!
```

Constraint limits the value-space of a parameter
------------------------------------------------
```csharp
[TestMethod]
public void ConstraintLimitsTheValueSpaceOfParameter() {

   routes.Clear();
   routes.MapRoute(null, "{a}", new { }, new { a = "b|c" });

   Assert.AreEqual(Url.RouteUrl(new { a = "b" }), "/b");
   Assert.AreEqual(Url.RouteUrl(new { a = "c" }), "/c");
   Assert.IsNull(Url.RouteUrl(new { a = "d" }));

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/b");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/c");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/d");

   Assert.IsNull(routes.GetRouteData(httpContextMock.Object));
}
```

You know this one. String constraints are treated as regular expressions, which work on both incoming request and URL generation. You can also provide an [IRouteConstraint][4] instance, which gives you the option to choose when to apply it, incoming request, URL generation or both.

Constraint tests the whole value
--------------------------------
```csharp
[TestMethod]
public void ConstraintTestsTheWholeValue() {
         
   routes.Clear();
   routes.MapRoute(null, "{a}", new { }, new { a = "b" });

   Assert.AreEqual(Url.RouteUrl(new { a = "b" }), "/b");
   Assert.IsNull(Url.RouteUrl(new { a = "b2" }));

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/b");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/b2");

   Assert.IsNull(routes.GetRouteData(httpContextMock.Object));
}
```

This is a nice feature. Whatever constraint you provide, the runtime wraps it in `^(yourconstraint)$` for you, so it matches the whole value and not just a portion.

Constraint for optional parameter should match an empty string if default value is empty string
-----------------------------------------------------------------------------------------------
```csharp
[TestMethod]
public void ConstraintForOptionalParameterShouldMatchAnEmptyStringIfDefaultValueIsEmptyString() {

   routes.Clear();
   routes.MapRoute(null, "{a}", new { a = "" }, new { a = "b" });

   Assert.IsNull(Url.RouteUrl(new { a = "" }));

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/");

   Assert.IsNull(routes.GetRouteData(httpContextMock.Object));

   //--------------------------------------

   routes.Clear();
   routes.MapRoute(null, "{a}", new { a = "" }, new { a = "(b)?" });

   Assert.AreEqual(Url.RouteUrl(new { a = "" }), "/");

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));

   //--------------------------------------

   routes.Clear();
   routes.MapRoute(null, "{a}", new { a = "b" }, new { a = "b" });

   Assert.AreEqual(Url.RouteUrl(new { a = "" }), "/");

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));
}
```

This one is in my view a design oversight, but not a big deal nonetheless. If you have a constraint for an optional parameter with an empty string default value, that constraint should match an empty string in case a value for that parameter is not provided. So, for instance if you have:

```csharp
routes.MapRoute(null, "Products/Browse/{sort}",
   new { controller = "Products", action = "Browse", sort = "" },
   new { sort = "popular|date" }); // Constraint should be "(popular|date)?"
```

If a value for sort is not provided the default value is used, and the constraint `"popular|date"` does not match an empty string, so it should be `"(popular|date)?"`. This also applies if the default value is [UrlParameter.Optional][5], or any value that returns an empty string from the `ToString()` method. Ideally, the constraint would be ignored when the default value is an empty string.

You won’t run into this issue for controller and action parameters, because you always provide non-empty defaults for those.

Current request values are used as defaults
-------------------------------------------
```csharp
[TestMethod]
public void CurrentRequestValuesAreUsedAsDefaults() {

   routes.Clear();
   routes.MapRoute(null, "{a}");

   var routeData = new RouteData {
      Values = { 
         { "a", "x" },
      }
   };

   var requestContext = new RequestContext(this.Url.RequestContext.HttpContext, routeData);
   var Url = new UrlHelper(requestContext, routes);

   Assert.AreEqual(Url.RouteUrl(new { }), "/x");
}
```

You can omit values when generating URLs, even for required parameters, and routing will use the current request values.

UrlHelper.Action uses the current request controller and action values as defaults
----------------------------------------------------------------------------------
```csharp
[TestMethod]
public void UrlHelperActionUsesTheCurrentRequestControllerAndActionValuesAsDefaults() {

   var routeData = new RouteData {
      Values = { 
         { "controller", "b" },
         { "action", "c" }
      }
   };

   var requestContext = new RequestContext(this.Url.RequestContext.HttpContext, routeData);
   var Url = new UrlHelper(requestContext, routes);

   routes.Clear();
   routes.MapRoute(null, "a", new { controller = "b", action = "c" });

   Assert.IsNull(Url.RouteUrl(new { controller = (string)null, action = (string)null }));
   Assert.AreEqual(Url.Action(null), "/a");
   Assert.AreEqual(Url.Action(null, (string)null), "/a");
}
```

The difference with this test and the previous test is that the previous is about ommiting values, this one is about using null values.

The [UrlHelper.Action][6] set of methods take actionName and controllerName string parameters. Calling these methods can be translated to something equivalent to `Url.RouteUrl(new { action = actionName, controller = controllerName })`. As we verified earlier in *Cannot use null or empty string for default value without parameter*, using null for actionName and/or controllerName can result in failing to match the desired route. For this reason `Url.Action` uses the current request controller and action values whenever null is used for actionName and/or controllerName.

This is a nice feature that allows us to generate URLs that refer to the current controller or action, e.g.

`Url.Action(null)` returns the URL of the current action.  
`Url.Action("Foo")` returns the URL of the Foo action in the current controller.  
`Url.Action(null, "Bar")` returns the URL of the action named like the current action, in the Bar controller.

Routing is case insensitive
---------------------------
```csharp
[TestMethod]
public void RoutingIsCaseInsensitive() {

   routes.Clear();
   routes.MapRoute(null, "a/{b}", new { a = "A" }, new { b = "xyz" });

   Assert.IsNotNull(Url.RouteUrl(new { a = "a", b = "XYZ" }));

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/A/XYZ");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));
}
```

Everything about routing is case insensitive, literal segments, default values and constraints.

Routes are evaluated in order
-----------------------------
```csharp
[TestMethod]
public void RoutesAreEvaluatedInOrder() {

   routes.Clear();
   routes.MapRoute(null, "{a}/{b}", new { b = "c" });
   routes.MapRoute(null, "{a}");

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/x");

   Assert.IsTrue(
      Object.ReferenceEquals(
         routes.GetVirtualPath(Url.RequestContext, new RouteValueDictionary(new { a = "x" })).Route, 
         routes.First()
      )
   );

   Assert.IsTrue(
      Object.ReferenceEquals(
         routes.GetRouteData(httpContextMock.Object).Route, 
         routes.First()
      )
   );

   var lastRoute = routes.Last();
   routes.Remove(lastRoute);
   routes.Insert(0, lastRoute);

   Assert.IsTrue(
      Object.ReferenceEquals(
         routes.GetVirtualPath(Url.RequestContext, new RouteValueDictionary(new { a = "x" })).Route,
         routes.First()
      )
   );

   Assert.IsTrue(
      Object.ReferenceEquals(
         routes.GetRouteData(httpContextMock.Object).Route,
         routes.First()
      )
   );
}
```

So far all tests involved a single route. If you have more than one route, the first one that matches is used, so the route registration order matters.

The larger your application gets, the more routes you'll have, and you'll eventually run into issues where the route matched is not the one you want to match. To solve these issues you have two choices:

### 1. Changing the order
This tipically means putting the routes with the most parameters/segments at the top.

#### Pros:

- Very easy to do.

#### Cons:

- Can result in having the least used routes at the top, which is inneficient.
- Everytime you add a new route you have to test how it affects other routes.

### 2. Adding constraints
If a parameter should only match a limited set of values you can add a constraint for that parameter.

#### Pros:

- You don't have to worry (so much) about routes order.
- You can put the most used routes at the top.
- Reject bad URLs earlier.

#### Cons:

- Everytime you create/remove a valid value for the parameter (e.g. add/remove controller/action) you have to update the constraint.

This test has shown us that routing can get tricky. That's why people have created tools to debug these kind of issues, like [Route Debugger][7] and [Glimpse][8]. Mmm..., if only there was a tool that automated route creation and made me forget about these issues altogether... Wait!, [there is][9]!

Literal sub-segment bug
-----------------------
```csharp
[TestMethod]
public void LiteralSubsegmentBug() {

   routes.Clear();
   routes.MapRoute(null, "_{a}");

   var httpContextMock = new Mock<HttpContextBase>();
   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/_b");

   Assert.IsNotNull(routes.GetRouteData(httpContextMock.Object));

   httpContextMock.Setup(c => c.Request.AppRelativeCurrentExecutionFilePath)
      .Returns("~/__b");

   Assert.IsNull(routes.GetRouteData(httpContextMock.Object));
}
```

You can read more about this bug [here][10]. In short, literal sub-segments don't work very well, specially with string parameters. My recommendation is to use a constraint, and a custom type with a model binder to parse the parameter. For example, let's say you want to implement these URLs:

```text
products/{id}
products/{slug}-{id}
```

Both should be handled by the same action, the `{id}` part is required and `{slug}-` is optional. First, we create a type that holds both pieces of data:

```csharp
public class SlugIdentifier {

   public const string Pattern = @"((.+)-)?([1-9]\d*)";
   static readonly Regex Regex = new Regex(Pattern);

   public int Id { get; private set; }
   public string Slug { get; private set; }

   public static SlugIdentifier Parse(string identifier) {

      if (identifier == null) throw new ArgumentNullException("identifier");

      Match match = Regex.Match(identifier);

      if (!match.Success)
         throw new ArgumentException("identifier is invalid.", "identifier");

      return new SlugIdentifier(
         Int32.Parse(match.Groups[3].Value),
         match.Groups[2].Value
      );
   }

   public SlugIdentifier(int id, string slug) {
      this.Id = id;
      this.Slug = slug;
   }
}
```

Implementing the model binder is very easy:

```csharp
class SlugIdentifierModelBinder : IModelBinder {

   public object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext) {
      return SlugIdentifier.Parse(
         (string)bindingContext.ValueProvider.GetValue(bindingContext.ModelName).RawValue
      );
   }
}
```

And we register it on Application_Start:

```csharp
void RegisterModelBinders(ModelBinderDictionary binders) {
   binders.Add(typeof(SlugIdentifier), new SlugIdentifierModelBinder());
}
```

Finally, register the route:

```csharp
routes.MapRoute(null, "products/{id}",
   new { controller = "Products", Action = "Details" },
   new { id = SlugIdentifier.Pattern });
```

And we are done!

```csharp
public ActionResult Details(SlugIdentifier id) {
   ...
}
```

Two consecutive optional parameters bug
---------------------------------------
```csharp
//[TestMethod] // Appears to be fixed in .NET 4.5
public void TwoConsecutiveOptionalParametersBug() {

   routes.Clear();
   routes.MapRoute(null, "a/{b}/{c}", new { b = "", c = "" });

   Assert.IsNotNull(Url.RouteUrl(new { b = "1", c = "2" }));
   Assert.IsNotNull(Url.RouteUrl(new { b = "1" }));
   Assert.IsNull(Url.RouteUrl(new { }));
}
```

You can read more about this bug [here][11]. I was able to reproduce in .NET 4, but not in .NET 4.5, so apparently it’s fixed.

Conclusions
-----------
I think I've covered everything you need to know about how routes are matched for incoming requests and URL generation.

Routing is easy, if you have one route. The Routing system itself and ASP.NET MVC offer no help when it comes to detect issues like routes ambiguity. You have three choices: 1. unit-test your routes, 2. use debugging tools, 3. automate route creation.

Thanks for reading!

[1]: http://msdn.microsoft.com/library/system.web.mvc.urlhelper
[2]: http://msdn.microsoft.com/library/system.web.routing.routecollection.getvirtualpath
[3]: http://msdn.microsoft.com/library/system.web.mvc.urlhelper.routeurl
[4]: http://msdn.microsoft.com/library/system.web.routing.irouteconstraint
[5]: http://msdn.microsoft.com/library/system.web.mvc.urlparameter.optional
[6]: http://msdn.microsoft.com/library/system.web.mvc.urlhelper.action
[7]: http://haacked.com/archive/2008/03/13/url-routing-debugger.aspx
[8]: http://getglimpse.com/
[9]: http://mvccoderouting.codeplex.com/
[10]: http://stackoverflow.com/questions/4318373
[11]: http://haacked.com/archive/2011/02/20/routing-regression-with-two-consecutive-optional-url-parameters.aspx