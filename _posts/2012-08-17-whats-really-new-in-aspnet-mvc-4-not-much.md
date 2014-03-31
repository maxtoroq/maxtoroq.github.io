---
layout: post
title: What's really new in ASP.NET MVC 4 (not much)
date: 2012-08-17 21:51:00 -0400
tags: [asp.net mvc, asp.net web api]
---

Attributes
----------
```csharp
[AttributeUsage(AttributeTargets.Method | AttributeTargets.Class, AllowMultiple=false, Inherited=true)]
public sealed class AllowAnonymousAttribute : Attribute
```

This new attribute allows you to secure an entire controller using `[Authorize]` but still expose individual actions for anonymous access.

```csharp
[AttributeUsage(AttributeTargets.Method, AllowMultiple=false, Inherited=true)]
public sealed class HttpHeadAttribute : ActionMethodSelectorAttribute

[AttributeUsage(AttributeTargets.Method, AllowMultiple=false, Inherited=true)]
public sealed class HttpOptionsAttribute : ActionMethodSelectorAttribute

[AttributeUsage(AttributeTargets.Method, AllowMultiple=false, Inherited=true)]
public sealed class HttpPatchAttribute : ActionMethodSelectorAttribute
```

These new attributes provide the same functionality as `[HttpPost]`, `[HttpGet]`, `[HttpPut]` and `[HttpDelete]`, but for HEAD, OPTIONS and PATCH HTTP methods. `[HttpHead]` is in my view useless, since the whole point of the HEAD method is the check if a GET request would succeed, therefore the same action that handles GET should handle HEAD. An `[HttpGetHead]` attribute would have been more useful, fortunately it's easy to implement.

New HtmlHelper extensions
-------------------------
```csharp
Html.DisplayName(string expression);
Html.DisplayNameFor(Expression<Func<TModel, TValue>> expression);
```

These extensions are used to get the display name of a type or property, before you had to get an instance of the ModelMetadata class for the type or property, now it's conveniently available from HtmlHelper.

```csharp
Html.TextBox(string name, object value, string format);
Html.TextBox(string name, object value, string format, IDictionary<string, object> htmlAttributes);
Html.TextBox(string name, object value, string format, object htmlAttributes);
Html.TextBoxFor(Expression<Func<TModel, TProperty>> expression, string format);
Html.TextBoxFor(Expression<Func<TModel, TProperty>> expression, string format, IDictionary<string, object> htmlAttributes);
Html.TextBoxFor(Expression<Func<TModel, TProperty>> expression, string format, object htmlAttributes);
```

These new overloads for rendering textboxes include an additional *format* parameter, which internally call `String.Format` to customize how the value is rendered.

```csharp
Html.Label(string expression, IDictionary<string, object> htmlAttributes);
Html.Label(string expression, object htmlAttributes);
Html.Label(string expression, string labelText, IDictionary<string, object> htmlAttributes);
Html.Label(string expression, string labelText, object htmlAttributes);
Html.LabelFor(Expression<Func<TModel, TValue>> expression, IDictionary<string, object> htmlAttributes);
Html.LabelFor(Expression<Func<TModel, TValue>> expression, object htmlAttributes);
Html.LabelFor(Expression<Func<TModel, TValue>> expression, string labelText);
Html.LabelFor(Expression<Func<TModel, TValue>> expression, string labelText, IDictionary<string, object> htmlAttributes);
Html.LabelFor(Expression<Func<TModel, TValue>> expression, string labelText, object htmlAttributes);
Html.LabelForModel(IDictionary<string, object> htmlAttributes);
Html.LabelForModel(object htmlAttributes);
Html.LabelForModel(string labelText, IDictionary<string, object> htmlAttributes);
Html.LabelForModel(string labelText, object htmlAttributes);
```

These new overloads for rendering labels include the standard *htmlAttributes* parameter, it was simply an oversight that these were not included in v3.

```csharp
Html.Id(string name);
Html.IdFor(Expression<Func<TModel, TProperty>> expression);
Html.IdForModel();
Html.Name(string name);
Html.NameFor(Expression<Func<TModel, TProperty>> expression);
Html.NameForModel();
```

These new extensions render the full id or name from a partial name or expression. This functionality was available in v3, but now it's much easier to call on HtmlHelper.

```csharp
Html.Value(string name);
Html.Value(string name, string format);
Html.ValueFor(Expression<Func<TModel, TProperty>> expression);
Html.ValueFor(Expression<Func<TModel, TProperty>> expression, string format);
Html.ValueForModel();
Html.ValueForModel(string format);
```

These new extensions render the value of a property from model state, view data or view model.

```csharp
public string FormatValue(object value, string format);
public IHtmlString Raw(object value);
```

These are not extensions but instance methods of HtmlHelper. `FormatValue` simply calls `String.Format`, and the new `Raw` overload allows you to pass any value without having to convert to string.

New UrlHelper methods
---------------------
```csharp
public string HttpRouteUrl(string routeName, object routeValues);
public string HttpRouteUrl(string routeName, RouteValueDictionary routeValues);
```

These new methods are used to generate URLs for Web Api routes. Apparently, Web Api routes are "special" and cannot be matched using `UrlHelper.RouteUrl`. Internally, these methods add an "httproute" entry to *routeValues*, and the GetVirtualPath method of the Web Api route classes (there's more than one) return null unless you include "httproute" in the values. What a mess...

New Controller properties
-------------------------
```csharp
public AsyncManager AsyncManager { get; }
public ProfileBase Profile { get; }
public ViewEngineCollection ViewEngineCollection { get; set; }
protected virtual Boolean DisableAsyncSupport { get; }
```

Profile is just a shortcut to `this.HttpContext.Profile`. ViewEngineCollection is just a shortcut to `ViewEngines.Engines`. The new async related properties are there because now all controllers are executed asynchronously by default.

That's about it
---------------
There are some other new types, some new members, some obsoleted members, some deleted or type-forwarded types, but I don't want to bore you and myself to death. There's nothing new in MVC 4, except for...

The real new features
---------------------

In reality there are only 2 new features, **Display Modes** and **returning Task from an async action**.

As I [pointed out before][1], Web Api is not MVC, it doesn't depend on MVC, it doesn't even depend on ASP.NET. Bundling and minification can be used on any ASP.NET project. jQuery UI, Entity Framework, OpenID, all separate libraries. This release feels more like v3.1 than v4.

MVC and Web Api
---------------
The reason because MVC and Web Api are released and distributed together is..., well..., I have no idea why. There's no technical reason behind that decision. I guess Microsoft thought people would probably use both on the same project. There's no Web Api project template on Visual Studio, you have to create an MVC project to use Web Api.

One year from now Microsoft will be eager to release Web Api v2 after recieving massive feedback and bug reports, will there be a new major release for MVC? I'm not sure, maybe they'll release a new major version, but with only a couple of new features just like this one. MVC is now on maintenence mode, just like Web Forms and LINQ to SQL. MVC 3 was already an excelent, mature and extensible framework. It's not up to Microsoft, but it's up to the community to build more cool stuff on top of it.

**Update**: The ASP.NET team have confirmed my suspicion on their [roadmap][2]:

> No new functionality will be added to the runtime components. Instead the area of focus will be enabling a richer set of templates for building various types of web applications developers need in addition to updating the current templates.

[1]: {{ site.url }}/2012/02/aspnet-mvc-4-beta-web-api-is-not-mvc.html
[2]: http://aspnetwebstack.codeplex.com/wikipage?title=Roadmap&version=35