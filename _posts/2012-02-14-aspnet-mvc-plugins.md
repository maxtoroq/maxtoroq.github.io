---
layout: post
title: ASP.NET MVC Plugins
date: 2012-02-14T01:12:00-03:00
tags: [asp.net mvc, mvccoderouting, plugin]
---

There aren't many plugin solutions available for ASP.NET MVC, if you google *asp.net mvc plugins* you'll find many proof-of-concept on how to load views embedded as assembly resources, but few established projects. Loading embedded views is only one part of the puzzle, first we should focus on routing.

Routing
-------
[MvcContrib Portable Areas][1] solution to routing for plugins is a very simple one: Plugin = Area. And it works. All you have to do is:

1. Add a reference to the portable area assembly (or copy to 'bin').
2. Call `AreaRegistration.RegisterAllAreas()` on Application_Start.

The problem with this solution is **you are not in control of the URL space used by the plugin**. For example, Portable Areas includes a sample called LoginPortableArea. All routes defined by this area start with `Login/`, and, apparently, you cannot change that (unless, of course, you recompile the plugin). What if you don't want to use `Login/`, but `Account/` or `User/` instead?. What if you can't use `Login/`, because it's already being used in your application?

With [MvcCodeRouting][2] **you have complete control of the URL space used by the plugin**. This is how you register a plugin:

```csharp
void RegisterRoutes(RouteCollection routes) {
   
   routes.MapCodeRoutes(
      baseRoute: "Account",
      rootController: typeof(MvcAccount.AccountController),
      settings: new CodeRoutingSettings { 
         EnableEmbeddedViews = true
      }
   );
}
```

The *baseRoute* parameter specifies where you want to expose the plugin, it can be anything you want, even null, which means the plugin is exposed at the root of the application. The *rootController* parameter specifies the type of the controller that is the entry point for the plugin. MvcCodeRouting also create routes for other controllers in the same assembly. The *settings* parameter is used to customize the way routes are created, and to enable embedded views.

MvcCodeRouting is not a plugin-specific solution, you can use it to automatically create routes for your own controllers. In fact, the only plugin-related feature is views embedding.

Views
-----
MvcCodeRouting uses a custom [VirtualPathProvider][3] to load embedded views. This is an optional feature, if you want you can just copy all views to your application. You can also override embedded views using file views in your application. How does it work? The VirtualPathProvider implementation presents a merged view (no pun intended) of file and embedded views. When a view exists in both file system and the assembly, the file view takes precedence. This is how you enable embedded views:

```csharp
void RegisterViewEngines(ViewEngineCollection engines) {
   engines.EnableCodeRouting();
}
```

How to create a plugin using MvcCodeRouting
-------------------------------------------
For MvcCodeRouting a plugin is **an assembly with controllers, and optionally embedded views**. That's all. In fact, if your plugin routes are simple enough (`{controller}/{action}` or `{controller}/{action}/{id}`) you don't even need to reference the MvcCodeRouting assembly. You can use hierarchical (a.k.a. RESTful) and custom routes by decorating your code with attributes.

View resources must be named using the following format: `<assemblyName>.Views.<viewPath>`. That means you just need to create a 'Views' folder in root of your plugin project and put the views there (and set Build Action to 'Embedded Resource', of course):

![MvcAccount Embedded Views](/images/mvcaccount_embedded_views.png)

Conclusions
-----------
[MvcCodeRouting][1] makes it really easy to create and use plugins. The application developer (plugin user) is always in control of the URL space used by plugins, and can individually override views as needed. The plugin developer does not need to worry about how the plugin is exposed or how views are located.

[1]: http://portableareas.codeplex.com/
[2]: http://mvccoderouting.codeplex.com/
[3]: http://msdn.microsoft.com/library/system.web.hosting.virtualpathprovider