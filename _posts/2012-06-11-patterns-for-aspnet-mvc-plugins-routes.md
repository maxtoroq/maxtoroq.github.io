---
title: "Patterns for ASP.NET MVC Plugins: Routes, Controllers and Configuration"
date: 2012-06-11 00:43:00 -0400
tags: [asp.net mvc, patterns, plugin]
---

The goal of these patterns is to provide a consistent experience for plugin consumers (application developers), minimize the amount of configuration required to get a plugin working in the host application and maximize the plugin's flexibility to customize its behavior.

This post focuses on routes, controllers and configuration. Subsequent posts will focus on other aspects, such as views, models, localization, etc.

1. *Routes, Controllers and Configuration*
2. [View Models][1]
3. [Demo: Implementing a contact form plugin][2]

Routes
------
<strong id="pattern-routes-dont-require-custom">Don't require any custom route configuration</strong>, make it an option for prettier URLs. In practice this means the plugin shouldn't depend or assume a specific route configuration:

- **Don't refer to named routes** e.g. `Url.RouteUrl("routeName")`
- **Don't hardcode URLs** e.g. `return Redirect("/Foo/Bar")`

<strong id="pattern-routes-dont-add-to-global-table">Don't add routes to RouteTable.Routes.</strong> The application developer should decide how to expose the plugin, if at all. The plugin should work fine with the default route `{controller}/{action}/{id}`.

<strong id="pattern-routes-provide-custom-routes-sample-code">Provide sample code of custom routes</strong> the application developer can copy and paste into the host application for prettier URLs.

Controllers
-----------
<strong id="pattern-controllers-public">Make controllers public</strong> so they can be found by the DefaultControllerFactory.

<strong id="pattern-controllers-common-naming">Name controllers with common, widely used names</strong>. If the plugin is about authentication, AccountController; A blog, BlogController; A forum, ForumController. This makes the plugin default route friendly.

<strong id="pattern-controllers-id-param">Use a parameter named 'id' for unique identifier inputs</strong>. Again, make the inputs default route compatible.

<strong id="pattern-controllers-minimize">Minimize the number of controllers</strong>. Ideally, the plugin should consist of a single controller. If more than one controller is used, put them all in the same namespace.

<strong id="pattern-controllers-default-constructor">Provide a default constructor</strong> so they can be instantiated by DefaultControllerFactory. Beginners are usually not familiar nor comfortable with container assisted dependency injection (DI). The next section explains an alternate way of providing dependencies that doesn't require a DI container.

<strong id="pattern-controllers-constructor-dependencies">Provide constructors that take dependencies as arguments</strong> for applications already using a DI container.

There are two kinds of dependencies: **abstract** and **concrete**. These can also be viewed as **required** and **optional**. Abstract dependencies represent functionality that the application developer is **required** to implement before they can use the plugin. These take the form of abstract types or interfaces. Concrete dependencies represent functionality already provided by the plugin, but that the application developer has the **option** to customize. These take the form of non-abstract, non-static classes with virtual public and/or protected members.

<strong id="pattern-controllers-constructor-dependencies-all">Provide a constructor that take all abstract and concrete dependencies.</strong> Put abstract dependencies first, then concrete dependencies. Many DI containers use by default the constructor with most parameters. By having a constructor that take all dependencies, the application developer will have the option to subclass and customize any/all concrete dependencies with minimum configuration. **Do not provide another constructor with the same number of parameters.**

<strong id="pattern-controllers-constructor-dependencies-all-abstract-none-concrete">Provide a constructor that take all abstract dependencies and none of the concrete dependencies.</strong> Some DI containers (like [Autofac][3]) use by default the constructor with the most parameters **they know how to resolve**. Don't force developers to register concrete dependencies, make that an option.

<strong id="pattern-controllers-constructor-dependencies-all-abstract-some-concrete">Provide other constructors that take all abstract dependencies and some of the concrete dependencies.</strong> Don't force developers to register all concrete dependencies, if they only want to customize a subset of them.
 
The following is an example that follow these recommendations, `AccountRepository` and `PasswordService` are abstract (required) dependencies, and `FormsAuthenticationService` is concrete (optional).

```csharp
public class AccountController : Controller {

   readonly AccountService service;

   public AccountController() 
      : this(new AccountService()) { }

   public AccountController(AccountRepository repository, PasswordService passwordService)
      : this(new AccountService(repository, passwordService)) { }

   public AccountController(AccountRepository repository, PasswordService passwordService, FormsAuthenticationService formsAuthService) 
      : this(new AccountService(repository, passwordService, formsAuthService)) { }

   private AccountController(AccountService service) {
      this.service = service;
   }
}
```

Configuration
-------------
<strong id="pattern-configuration-class">Provide a class for the plugin's configuration settings</strong>. Make it an instance class with instance properties, not static, not singleton.

<strong id="pattern-configuration-data-token">Use the 'Configuration' data token to accept an instance of the configuration class</strong>. Here's an example:

```csharp
public class BlogController : Controller {
   
   BlogConfiguration config;

   protected override void Initialize(RequestContext requestContext) {
      
      base.Initialize(requestContext);

      this.config = requestContext.RouteData.DataTokens["Configuration"] as BlogConfiguration 
         ?? new BlogConfiguration();
   }
}
```

This is what the route registration could look like:

```csharp
routes.MapRoutes(null, "Blog/{action}/{id}"
   { controller = "Blog", action = "Index", id = UrlParameter.Optional },
   new[] { "CoolBlog.Controllers" })
   .DataTokens["Configuration"] = new BlogConfiguration {
      // Set config properties
   };
```

[MvcCodeRouting][4] also follows this pattern, with the Configuration setting:

```csharp
route.MapCodeRoutes(
   baseRoute: "Blog",
   rootController: typeof(CoolBlog.Controllers.BlogController),
   settings: new CodeRoutingSettings {
      Configuration = new CoolBlog.BlogConfiguration {
         // Set config properties
      }
   }
);
```

<strong id="pattern-configuration-resolver-properties">Provide Func&lt;&gt; properties for each dependency, and name them with the "Resolver" suffix</strong>. Here's an example:

```csharp
var config = new CoolBlog.BlogConfiguration {
   RepositoryResolver = () => new MyBlogRepository()
};
```

A DI container can also be used to resolve dependencies, if object composition or lifetime management is required:

```csharp
var config = new CoolBlog.BlogConfiguration {
   RepositoryResolver = () => container.Resolve<CoolBlog.BlogRepository>()
};
```

The advantage of associating the plugin's configuration instance, that include resolver properties for DI, with the plugin's route is that you can use more than one plugin instance per application, each with different configuration settings.

Conclusions
-----------
This post deals with what I think are the most important aspects of plugin development for ASP.NET MVC: routes, controllers and configuration. The MVC framework itself has a number of conventions that application developers are accustomed to; plugin developers should adhere to these conventions. This post proposes patterns that do not require a special infrastructure (e.g. common library for plugins) to work. Instead, it uses what the framework already provides. Plugins are just controllers exposed via routes, just like anything else in the host application. Hopefully these patterns will help you build plugins that are portable, flexible and easy to configure.

[1]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html
[2]: {{ site.url }}/2012/10/implementing-contact-form-plugin-for-aspnet-mvc.html
[3]: https://github.com/autofac/Autofac
[4]: http://mvccoderouting.codeplex.com/