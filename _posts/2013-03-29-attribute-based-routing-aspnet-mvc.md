---
title: Attribute-based routing coming to ASP.NET MVC and Web API v5
date: 2013-03-29 01:36:00 -0300
tags: [asp.net mvc, asp.net web api, routing]
---

<ins>**Update:** This post is based on early bits that later changed when v5 RTM was released. I suggest you read my post *[Why ASP.NET MVC Routing sucks][6]* instead.</ins>

Attribute-based routing is coming to ASP.NET MVC and Web API, according to the [roadmap][1]. They are basing the solution on the popular [AttributeRouting][2] project. At the date of writing this post only Web API support is working, you can play with it by installing the [nightly packages][3].

For a number of reasons I do not like the original project the ASP.NET team is basing on.

Not very DRY
------------
There are many things that could be infered by the code, yet you have to be explicit about it. For instance:

```csharp
[HttpGet("hello/{a:int}")]
public string Hello(int a) {
   return "Hi! " + a;
}
```

Why do I need to declare `int` in the route, if I could just take that information from the method parameter?

No grouping
-----------
Instead of grouping routes that are similar, all declared attribute routes map to a registered route. I don't like the idea of having [650 routes like StackOverflow][4]. It does not sound efficient. Can you imagine just looking at all those routes? What about matching the 650th route for URL generation? I bet StackOverflow hardcode's URLs.

No context
----------
Attribute routes are absolute, they do not take into account any information about where the action is located in the code, such as the controller, namespace, etc. This means the code that uses attribute routing is not portable.

Conventional vs. Custom Routes
------------------------------
The default route `{controller}/{action}/{id}` was not a bad start. You could develop a whole application without worrying about routing. Of course, at some point, the need for more customized routes arises. But that doesn't mean you should throw away conventions and use only custom routes. You just need a more flexible convention, and have the ability to do custom routes when needed. That's what [MvcCodeRouting][5] provides.

The good thing is that, just like Areas, you can just ignore attribute routing.

[1]: http://aspnetwebstack.codeplex.com/wikipage?title=Roadmap&version=48
[2]: http://attributerouting.net/
[3]: http://www.myget.org/gallery/aspnetwebstacknightly/
[4]: http://samsaffron.com/archive/2011/10/13/optimising-asp-net-mvc3-routing
[5]: http://mvccoderouting.codeplex.com/
[6]: {{ site.url }}/2014/02/why-aspnet-mvc-routing-sucks.html