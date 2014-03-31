---
layout: post
title: 5 reasons why you should use MvcCodeRouting
date: 2012-09-23 19:44:00 -0300
tags: [asp.net mvc, mvccoderouting, routing]
---

[MvcCodeRouting][1] v1.0 is out, this post highlights the library's most important features and why I believe is a must have for all ASP.NET MVC developers.

1. Convention over configuration
--------------------------------
Getting started with MvcCodeRouting in a new project, or integrating with an existing codebase, requires very little configuration, and many times no configuration at all. This is because the library recognizes that most of the time you follow the `{controller}/{action}` or `{controller}/{action}/{id}` convention. For example, let's take the [MvcMusicStore][2] application and use MvcCodeRouting on it:

```csharp
public static void RegisterRoutes(RouteCollection routes)
{
   routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

   //routes.MapRoute(
   //    "Default", // Route name
   //    "{controller}/{action}/{id}", // URL with parameters
   //    new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
   //);

   routes.MapCodeRoutes(
      rootController: typeof(Controllers.HomeController),
      settings: new CodeRoutingSettings {
         UseImplicitIdToken = true
      }
   );
}
```

Calling `MapCodeRoutes` is the only change required. You can build and run the application as if nothing changed. If you visit ~/routes.axd you can see the routes that MvcCodeRouting created:

```csharp
routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

routes.MapRoute(null, "{action}", 
    new { controller = @"Home", action = @"Index" }, 
    new { action = @"Index" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "StoreManager/{action}/{id}", 
    new { controller = @"StoreManager" }, 
    new { action = @"Delete|Details|Edit", id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "Store/Details/{id}", 
    new { controller = @"Store", action = @"Details" }, 
    new { id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "Checkout/Complete/{id}", 
    new { controller = @"Checkout", action = @"Complete" }, 
    new { id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "ShoppingCart/{action}/{id}", 
    new { controller = @"ShoppingCart" }, 
    new { action = @"AddToCart|RemoveFromCart", id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "Account/{action}", 
    new { controller = @"Account" }, 
    new { action = @"LogOn|LogOff|Register|ChangePassword|ChangePasswordSuccess" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "StoreManager/{action}", 
    new { controller = @"StoreManager", action = @"Index" }, 
    new { action = @"Index|Create|Edit" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "Store/{action}", 
    new { controller = @"Store", action = @"Index" }, 
    new { action = @"Index|Browse|GenreMenu" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "Checkout/AddressAndPayment", 
    new { controller = @"Checkout", action = @"AddressAndPayment" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "ShoppingCart/{action}", 
    new { controller = @"ShoppingCart", action = @"Index" }, 
    new { action = @"Index|CartSummary" }, 
    new[] { "MvcMusicStore.Controllers" });
```

OK, so the application worked fine with 1 route and now we have 10, how is that better? Well, in some aspects these routes work better (more on that follows), but the point I was trying to make here is **how easy it is to start using MvcCodeRouting**.

MvcMusicStore is actually not a very good case study, because it only uses the default route (`{controller}/{action}/{id}`). Routing presents no challenges when you only have one route, but real-world applications use more than one route, and that's when you start facing issues, since adding new routes can potentially break the existing ones.

2. Automatic route grouping, ordering and constraining
------------------------------------------------------
Instead of creating one route per action MvcCodeRouting groups similar actions to minimize the number of routes created. For instance, the routes for the `StoreManager` controller are:

```csharp
routes.MapRoute(null, "StoreManager/{action}/{id}", 
    new { controller = @"StoreManager" }, 
    new { action = @"Delete|Details|Edit", id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });

routes.MapRoute(null, "StoreManager/{action}", 
    new { controller = @"StoreManager", action = @"Index" }, 
    new { action = @"Index|Create|Edit" }, 
    new[] { "MvcMusicStore.Controllers" });
```

Since `Delete`, `Details` and `Edit` actions take an id parameter of the same type (Int32) only one route is created that can handle those actions. Keeping the **number of routes to a minimum makes route matching more efficient**.

Note that `Edit` is also listed in the second route, because there's also an `Edit` action that takes no parameters. The order of these routes affects URL generation. For example,

`Url.Action("Edit", "StoreManager", new { id = 1 })` returns `"/StoreManager/Edit/1"`,

but if you switch the order

`Url.Action("Edit", "StoreManager", new { id = 1 })` returns `"/StoreManager/Edit?id=1"` (note id in query string).

MvcCodeRouting knows **how to order routes to avoid URL generation issues**.

Using **constraints for the action token avoids route conflicts**. MvcCodeRouting also uses constraints for action parameters, which you can override on a per-parameter or per-site basis. Constraining also helps **keeping bad URLs out**, e.g. `/StoreManager/Edit/foo` doesn't match any route.

3. Custom routes
----------------
Now that we have conventional routes automatically created for us let's see how we can configure more customized routes. Let's change `Store/Details/{id}` to a more SEO friendly format, like `p/{id}/{slug}`.

This is the current action code:

```csharp
public ActionResult Details(int id)
{
   var album = storeDB.Albums.Find(id);

   return View(album);
}
```

We'll change it to this:

```csharp
[CustomRoute("~/p/{id}/{slug}")]
public ActionResult Details([FromRoute]int id, [FromRoute]string slug = null)
{
   var album = storeDB.Albums.Find(id);

   if (album != null
      && album.Title != slug) {
      return RedirectToAction(null, new { id, slug = album.Title });
   }

   return View(album);
}
```

The use of the `CustomRoute` attribute should be self explanatory. The `FromRoute` attribute must be used on route parameters. Optional parameters are used to specify if the corresponding route parameter should be optional. Since we don't have a slug property in our model I'm using Title for now.

This is the resulting route definition:

```csharp
routes.MapRoute(null, "p/{id}/{slug}", 
    new { controller = @"Store", action = @"Details", slug = UrlParameter.Optional }, 
    new { id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });
```

As you can see, **custom routes are easy**.

4. Route formatting
-------------------
Now that we have SEO friendly routes let's see if we can make our conventional routes look prettier. A very common URL formatting convention is lower case hyphenated, this is how we can an implement it:

```csharp
routes.MapCodeRoutes(
   rootController: typeof(Controllers.HomeController),
   settings: new CodeRoutingSettings { 
      UseImplicitIdToken = true,
      RouteFormatter = args =>
         Regex.Replace(args.OriginalSegment, @"([a-z])([A-Z])", "$1-$2")
            .ToLowerInvariant()
   }
);
```

`RouteFormatter` is a delegate that takes information about a route segment and returns a modified segment. Routes now look like this one:

```csharp
routes.MapRoute(null, "shopping-cart/{action}/{id}", 
    new { controller = @"ShoppingCart" }, 
    new { action = @"add-to-cart|remove-from-cart", id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers" });
```

The beauty of route formatting is that it doesn't affect URL generation. For instance, `Url.Action("AddToCart", "ShoppingCart")` continues to work, even though the route uses `add-to-cart` and not `AddToCart`. **Route formatting is easy**.

5. Namespaces
-------------
Currently, the `StoreManager` controller only manages `Album`s, what about the other entities in our application, like `Artist` and `Genre`? Let's add actions for those too, but adding them to the `StoreManager` controller would make it grow too much and make the code hard to maintain, so instead let's create separate controllers in a sub-namespace:

```csharp
namespace MvcMusicStore.Controllers.StoreManager // <-- Note the sub-namespace
{
   [Authorize(Roles = "Administrator")]
   public class ArtistController : Controller 
   {
      public ActionResult Index() 
      {
         throw new NotImplementedException();
      }

      public ViewResult Details(int id) 
      {
         throw new NotImplementedException();         
      }

      public ViewResult Create() 
      {
         throw new NotImplementedException();
      }
   }

   [Authorize(Roles = "Administrator")]
   public class GenreController : Controller 
   {
      public ActionResult Index() 
      {
         throw new NotImplementedException();
      }

      public ViewResult Details(int id) 
      {
         throw new NotImplementedException();
      }

      public ViewResult Create() 
      {
         throw new NotImplementedException();
      }
   }
}
```

The routes created for these controllers are:

```csharp
routes.MapRoute(null, "store-manager/artist/details/{id}", 
    new { controller = @"Artist", action = @"Details" }, 
    new { id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers.StoreManager" });

routes.MapRoute(null, "store-manager/genre/details/{id}", 
    new { controller = @"Genre", action = @"Details" }, 
    new { id = @"0|-?[1-9]\d*" }, 
    new[] { "MvcMusicStore.Controllers.StoreManager" });

routes.MapRoute(null, "store-manager/artist/{action}", 
    new { controller = @"Artist", action = @"index" }, 
    new { action = @"index|create" }, 
    new[] { "MvcMusicStore.Controllers.StoreManager" });

routes.MapRoute(null, "store-manager/genre/{action}", 
    new { controller = @"Genre", action = @"index" }, 
    new { action = @"index|create" }, 
    new[] { "MvcMusicStore.Controllers.StoreManager" });
```

Unlike areas, **there's no limit to the depth of namespaces** you can use with MvcCodeRouting. There's also support for **namespace-aware views location**. For example, views for the `MvcMusicStore.Controllers.StoreManager.Artist` controller can be located in `~/Views/StoreManager/Artist/`.

Conclusions
-----------
[MvcCodeRouting][1] is an attempt to make you almost completely **forget about route management and routing issues**, a routing-based URL to code mapping solution. Give it a try!

For more information read the [documentation][3], if you have questions please use the project [forum][4].

[1]: http://mvccoderouting.codeplex.com/
[2]: http://mvcmusicstore.codeplex.com/
[3]: https://mvccoderouting.codeplex.com/documentation
[4]: https://mvccoderouting.codeplex.com/discussions