---
title: Why ASP.NET MVC Routing sucks
date: 2014-02-20 17:20:00 -0300
tags: [asp.net mvc, asp.net web api, routing]
---

2434 questions with the [asp.net-mvc-routing][1] tag, plus 755 with [asp.net-mvc and routing][2], that's more than 3000 questions about routing only. Clearly, something is wrong.

In the beginning we had {controller}/{action}/{id}
--------------------------------------------------
AKA, the default route. Technically, we don't need more routes. Culturally, we need more routes. What are routes anyway? URL templates. And URLs are a way to identify resources. The main part of the URL is the path. The path represents a resource hierarchy. A hierarchy is used for organization. Naming (identification) and organization are essential in any information system. While the default route might suit your needs 80% of the times, that percentage gets smaller as your application gets bigger. Bigger app means more resources to organize, hence the need of a deeper hierarchy.

Then came {area}/{controller}/{action}/{id}
-------------------------------------------
MVC 2 introduced a feature called Areas. This is not only about having an additional level in your resource hierarchy, it also attempts to provide a better organization of your codebase. Areas are like sub-projects inside your main project, they have their own Views directory and stuff. Some like using areas, others don't like the complexity it introduces to the project structure. Although there are documented ways to [split areas into their own projects][3], it's not the default behavior.

Technically, areas work. Culturally, maybe you don't like the project structure, or you might need an even deeper resource hierarchy.

Custom routes
-------------
If conventional routes are too rigid you can always use custom routes. You decide exactly how to design your resource hierarchy, and how to organize your codebase. Win-win, right?

ASP.NET Routing is actually a very flexible system, I like it a lot. So, when I say ASP.NET MVC Routing sucks I mean how MVC integrates with Routing. And that integration is very simplistic. All MVC does is take values for controller and action, and optionally a namespace in case there are two controllers with the same name, and with that it finds the controller and invokes the action. How URLs map to controllers is 100% your responsibility.

So yes, custom routes is the most flexible option, except it's work, and error prone.

Problem: MVC is matching the wrong route
----------------------------------------
This is the most common issue you'll face when dealing with custom routes. This happens when one URL can be matched by more than one route. There are two solutions to this problem:

### 1. Changing the order

This typically means putting the routes with the most parameters/segments at the top.

#### Pros:

- Very easy to do.

#### Cons:

- Can result in having the least used routes at the top, which is inefficient.
- Every time you add a new route you have to test how it affects other routes.

### 2. Adding more constraints

If a parameter should only match a limited set of values you can add a constraint for that parameter.

#### Pros:

- You don't have to worry (so much) about routes order.
- You can put the most used routes at the top.
- Reject bad URLs earlier.

#### Cons:

- Every time you create/remove a valid value for the parameter (e.g. add/remove controller/action) you have to update the constraint. That means more configuration.

Out of the two solutions adding more constraints is the most robust. Ideally one URL should only be match by a single route, thus avoiding any ambiguities.

### Wow, this is a lot of work, are there any tools or techniques to help me out?

Yes. There are visual tools like [Route Debugger][4] and [Glimpse][5]. Others suggest [unit testing your routes][6]. If you have issues with URL generation some suggest you [use names for all your routes][7]:

> Use names for all your routes and always use the route name when generating URLs. Most of the time, letting routing sort out which route you want to use to generate an URL is really leaving it to chance. When generating an URL, you generally know exactly which route you want to link to, so you might as well specify it by name.

Using names is even more configuration, and results in coupling routes with your code.

The problem with these tools and techniques is that they treat the symptom and not the underlying condition.

Problem: Too much configuration
-------------------------------
Once you start using custom routes the convention over configuration principle is dead. You create a route specifying the controller and action, maybe regex constraints for parameters, maybe the namespace. That's all duplicated information about your code.

### Attribute Routing, solution?

Attribute Routing is the most popular alternative to custom routes. It eliminates some but not all of the configuration and duplication problems. For example, given the following code:

```csharp
[RoutePrefix("reviews")]
public class ReviewsController : Controller {

   // eg.: /reviews/5
   [Route("{reviewId:int}")]
   public ActionResult Show(int reviewId) { ... }

   // eg.: /reviews/5/edit
   [Route("{reviewId:int}/{action}")]
   public ActionResult Edit(int reviewId) { ... }
}
```

<del>Why do I need to specify "reviews" in the route prefix, if I could just take that information from the controller name? Same with parameter name and constraint.</del> <ins class="update"><strong>Update:</strong> Can use {controller} instead, but cannot avoid repeating the parameter name and type.</ins>

Problem: Performance
--------------------

[This post][8] talks about how StackOverflow faced some routing-related performance issues:

> We pick nice friendly urls for all our various actions, which results in a pretty huge list of routes. We have upwards of 650 routes registered. The fact that we use attribute based routing makes creating lots of routes trivial.

650 routes !!?!?! I bet they hard-code URLs. OK, maybe you are not working on such a high-traffic website, but still worth considering.

Just to clarify, StackOverflow uses their own attribute-based routing solution, not MVC's solution, which in v5 supports [default routes][9] which can greatly reduce the number of routes.

### Solution?

Don't use so many routes :-) A combination of conventional and attribute routes might be better than just using one or the other. Also, in MVC 5 take advantage of default routes.

And for URL generation, [named routes helps][10], again. But it's a bad solution. A real solution would be to make routing fail faster when testing a route, by determining its relationship with the current route. Also, instead of regex constraints use `IRouteConstraint`, like the ones provided in the `System.Web.Mvc.Routing.Constraints` namespace.

Problem: "Magic strings" URL generation
---------------------------------------
This is actually a limitation of the C# language. There are a lot of scenarios were you need to use the name of a property or method and you have to hard-code it. There are alternatives though.

[MvcFutures][11] has an expression-based URL generation implementation. The downside is that it's up to 3 times slower than using strings.

Another good alternative is the [delegate-based approach][12] I blogged about recently. It's both fast and strongly-typed, but it needs an instance of the controller, so it doesn't work so well when linking to a different controller.

A completely different alternative is what [T4MVC][13] provides, which is a build-time code generation tool. I personally don't like the amount of code it generates, and how it changes my code by adding virtual modifiers and stuff.

### Solution?

Each alternative has its pros and cons, so it depends on your situation and personal preference.

Problem: Complexity
-------------------
Having conventional routes, attribute routes and areas, all different features that attempt to solve basically the same problem but from different angles, can be confusing and increase the complexity of your system. For instance, I find the relationship between areas and attribute routing confusing. A controller that uses the `RouteArea` attribute doesn't base its membership to an area on the project, namespace or folder it resides in. That's also more configuration and duplication.

### Solution?

I'd use conventional and attribute routing, and forget about areas. But that's just me.

Problem: Modularity
-------------------
Areas doesn't really help you design a deep resource hierarchy, or organize your codebase in a clean way. In my view, code is and should be organized using namespaces and projects, not some artificial concept that doesn't really help. In respect to routing, areas is just the default route with an additional segment. Areas only help you in two ways:

- URL generation is relative to the current area
- Views are located in the area specific folder

### Solution?

I guess you are stuck with areas if you want some kind of modularity.

Why do we need Routing anyways?
-------------------------------
Because the web server knows nothing about your code. It knows how to map URLs to files, but not to controllers. So, the real solution is having a tool that can deeply understand your code. In one word, Reflection. An abstraction on top of Routing.

But I don't see that coming from Microsoft. I think attribute routing is a good enough solution, and that will be the end of it. The biggest problem of all is modularity, and that's just too advanced to be considered.

My theory is this: Microsoft produces great languages and tools. The teams that produce them also use those languages and tools on a daily basis, so they have a passion to make it right. The teams that produce frameworks are not in the business of building real-world solutions with the frameworks they build.

But that's fine, I'm not complaining. I don't expect Microsoft to deliver everything I need.

### Further Reading
- [Rethinking ASP.NET MVC: Workflow per Controller][14]

[1]: http://stackoverflow.com/questions/tagged/asp.net-mvc-routing
[2]: http://stackoverflow.com/questions/tagged/asp.net-mvc+routing
[3]: http://msdn.microsoft.com/library/ee307987
[4]: http://haacked.com/archive/2008/03/13/url-routing-debugger.aspx/
[5]: http://getglimpse.com/
[6]: http://bradwilson.typepad.com/blog/2010/07/testing-routing-and-url-generation-in-aspnet-mvc.html
[7]: http://haacked.com/archive/2010/11/21/named-routes-to-the-rescue.aspx/
[8]: http://samsaffron.com/archive/2011/10/13/optimising-asp-net-mvc3-routing
[9]: http://blogs.msdn.com/b/webdev/archive/2013/10/17/attribute-routing-in-asp-net-mvc-5.aspx#default-route
[10]: http://weblogs.asp.net/leftslipper/archive/2008/12/17/optimizing-your-route-collection-for-url-generation-in-asp-net-mvc-and-more.aspx
[11]: http://www.nuget.org/packages/Mvc4Futures
[12]: {{ site.url }}/2013/04/delegate-based-strongly-typed-url.html
[13]: http://t4mvc.codeplex.com/
[14]: {{ site.url }}/2013/02/aspnet-mvc-workflow-per-controller.html
