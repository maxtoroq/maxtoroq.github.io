---
layout: post
title: "MvcPages: ASP.NET MVC without routes and controllers"
date: 2012-11-01 02:11:00 -0300
tags: [asp.net mvc, asp.net web pages, mvcpages]
---

I like developing with ASP.NET MVC, but sometimes I feel there are too many pieces involved. To develop a single function you have to (in no particular order):

- Create route (make sure it doesn't break other routes)
- Create controller/action
- Create view model
- Create view

... in addition to writing the model/service that does the actual work. Even though this layering gives you a lot of flexibility and testability, sometimes you don't need it. Do you really need all of the above to develop a simple contact form? Do you ever test your controllers/views? Do you have a lot of actions that just `return View()`?

ASP.NET Web Pages
-----------------

Web Pages has the simplicity I sometimes want, except you lose a lot of power. With Web Pages everything is parameter-based, there's no need to ever write a single class. MVC also has support for parameter-based approach (action method parameter binding, ViewData/ViewBag), but the really nice features such as attribute-based validation and forms generation (EditorForModel) work with classes. These are the features I'm not willing to give up.

MvcPages
--------
Forget about routes, forget about controllers, keep everything else. That's [MvcPages][1], a very small library with no original features, just a base page class that allows you to access MVC features directly from standalone Razor pages. For example, this is a standard Web Pages page:

```csharp
@{
   if (!User.Identity.IsAuthenticated) {
      FormsAuthentication.RedirectToLoginPage();
      return;
   }

   Validation.RequireField("currentPassword", "The current password field is required.");
   Validation.RequireField("newPassword", "The new password field is required.");
   
   Validation.Add("newPassword",
      Validator.StringLength(
         maxLength: 100,
         minLength: 6,
         errorMessage: "New password must be at least 6 characters"));
         
   Validation.Add("confirmPassword",
      Validator.Required("The confirm new password field is required."),
      Validator.EqualsTo("newPassword", "The new password and confirmation password do not match."));

   if (IsPost
      && Validation.IsValid()) {

      string currentPassword = Request.Form["currentPassword"];
      string newPassword = Request.Form["newPassword"];
      string confirmPassword = Request.Form["confirmPassword"];

      bool passwordChanged = true; /* code that changes password here */

      if (passwordChanged) {
         Response.Redirect("ChangePasswordSuccess");
         return;
      } else {
         ModelState.AddFormError("An error occurred when attempting to change the password. Please contact the site owner.");
      }
   }

   Page.Title = "Change Password";

   <h1>@Page.Title</h1>
   @Html.ValidationSummary("Password change was unsuccessful. Please correct the errors and try again.", true)
   
   <form method="post">
      <div class="editor-label">
         <label for="currentPassword">Current password</label>
      </div>
      <div class="editor-field">
         <input type="password" id="currentPassword" name="currentPassword" @Validation.For("currentPassword")/>
      </div>

      <div class="editor-label">
         <label for="newPassword">New password</label>
      </div>
      <div class="editor-field">
         <input type="password" id="newPassword" name="newPassword" @Validation.For("newPassword")/>
      </div>

      <div class="editor-label">
         <label for="confirmPassword">Confirm new password</label>
      </div>
      <div class="editor-field">
         <input type="password" id="confirmPassword" name="confirmPassword" @Validation.For("confirmPassword")/>
      </div>

      <br />
      <button>Change Password</button>
   </form>
}
```

Ugly, long, terrible. This is the same page using MvcPages:

```csharp
@using Samples.Account
@model ChangePasswordModel
@{
   var service = new AccountService(ModelState);
   
   if (!User.Identity.IsAuthenticated) {
      FormsAuthentication.RedirectToLoginPage();
      return;
   }

   if (IsPost
      && TryUpdateModel()
      && service.ChangePassword(Model)) {
      
      Response.Redirect("ChangePasswordSuccess");
      return;
   }

   ViewBag.Title = "Change Password";

   <h1>@ViewBag.Title</h1>
   @Html.ValidationSummary(true, "Password change was unsuccessful. Please correct the errors and try again.")
   
   using (Html.BeginForm()) {
      @Html.EditorForModel()
      <br />
      <button>Change Password</button>
   }
}
```

Same ol' MVC. You know the features: model binding, model validation, strongly-typed HTML helpers, editor and display templates, TempData, etc.

Also, a new feature: Layout compatibility. Ever tried using an MVC layout from Web Pages? you get:

<div style="background-color: white;">
<div style="color: red; font-family: Verdana; font-size: 18pt; font-weight: normal;">
Server Error in '/' Application.<br />
<hr color="silver" size="1" width="100%" />
</div>
<div style="color: maroon; font-family: Verdana; font-size: 14pt; font-weight: normal;">
<i>The view at '~/SomePage.cshtml' must derive from WebViewPage, or WebViewPage&lt;TModel&gt;.</i></div>
</div>

With MvcPages it's possible. You can now add Web Pages to your MVC app and use the same layout as your views.

Like it? [NuGet it][2], or [fork it][1], or whatever.

[1]: https://github.com/maxtoroq/MvcPages
[2]: http://www.nuget.org/packages/MvcPages