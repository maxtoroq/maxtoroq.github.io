---
layout: post
title: Delegate-based strongly-typed URL generation in ASP.NET MVC
date: 2013-04-18 20:04:00 -0300
tags: [asp.net mvc]
---

The standard way of generating URLs in ASP.NET MVC involves hard-coding action, controller and parameter names:

```csharp
string url = Url.Action("Edit", new { id = 5 });
```

You are probably familiar with the expression tree-based strongly-typed URL generation approach, which is part of the [MvcFutures][1] library. It allows you to write code like this:

```csharp
string url = Url.Action(() => Edit(5));
```

Actually, MvcFutures does not extend `UrlHelper`, but it exposes the low-level implementation methods so you can easily write the extension method yourself. If you wanted to link to an action in a different controller you could do it like this:

```csharp
string url = Url.Action<ProductController>(c => c.Edit(5));
```

The downside of this expression tree-based approach is that it's slow, two or three times slower than the standard approach.

Delegate-based approach
-----------------------
Instead of expression trees, why not just use delegates?

```csharp
string url = Url.Action(Edit, 5);
```

The above code looks even better than the expression tree-based example, and is as fast as the standard approach. The only downside of using delegates is that you need a non-null instance of the controller, which is not a problem when linking to other actions in the same controller, but to link to a different controller you would have to create an instance:

```csharp
var controller = new ProductController();
string url = Url.Action(controller.Edit, 5);
```

The instantiation of a controller could involve the execution of unneeded initialization code, for the purposes of just creating a URL. This is where we go back to needing expression trees. Perhaps we could use [GetUninitializedObject][2], although I'm not sure how fast it is, and it doesn't work in medium trust.

Still, when linking to other actions in the same controller this is my new favorite approach. And it works in views also, like this:

```csharp
var controller = (MyController)ViewContext.Controller;
string url = Url.Action(controller.Edit, 5);
```

Implementation
--------------
The code is quite simple, don't let the overloads scare you. Generic type inference is key:

```csharp
static class StronglyTypedLinkExtensions {

   static readonly ConcurrentDictionary<MethodInfo, string> actionNames = new ConcurrentDictionary<MethodInfo, string>();

   public static string Action(this UrlHelper urlHelper, Func<ActionResult> action) {
      return ActionImpl(urlHelper, action, default(object[]));
   }

   public static string Action<T>(this UrlHelper urlHelper, Func<T, ActionResult> action, T arg) {
      return ActionImpl(urlHelper, action, arg);
   }

   public static string Action<T1, T2>(this UrlHelper urlHelper, Func<T1, T2, ActionResult> action, T1 arg1, T2 arg2) {
      return ActionImpl(urlHelper, action, arg1, arg2);
   }

   public static string Action<T1, T2, T3>(this UrlHelper urlHelper, Func<T1, T2, T3, ActionResult> action, T1 arg1, T2 arg2, T3 arg3) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3);
   }

   public static string Action<T1, T2, T3, T4>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4);
   }

   public static string Action<T1, T2, T3, T4, T5>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5);
   }

   public static string Action<T1, T2, T3, T4, T5, T6>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14, T15 arg15) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15);
   }

   public static string Action<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(this UrlHelper urlHelper, Func<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, ActionResult> action, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8, T9 arg9, T10 arg10, T11 arg11, T12 arg12, T13 arg13, T14 arg14, T15 arg15, T16 arg16) {
      return ActionImpl(urlHelper, action, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16);
   }

   static string ActionImpl(this UrlHelper urlHelper, Delegate action, params object[] args) {

      RouteValueDictionary values = null;

      if (args != null
         && args.Length > 0) {

         values = new RouteValueDictionary();

         var parameters = action.Method.GetParameters();

         for (int i = 0; i < parameters.Length; i++)
            values[parameters[i].Name] = args[i]; 
      }

      string actionName = actionNames.GetOrAdd(action.Method, m => {
            
         ActionNameAttribute attr = m
            .GetCustomAttributes(typeof(ActionNameAttribute), inherit: true)
            .Cast<ActionNameAttribute>()
            .SingleOrDefault();

         return (attr != null) ?
            attr.Name
            : m.Name;
      });

      return urlHelper.Action(actionName, values);
   }
}
```

[1]: http://www.nuget.org/packages/Mvc4Futures
[2]: http://msdn.microsoft.com/library/system.runtime.serialization.formatterservices.getuninitializedobject