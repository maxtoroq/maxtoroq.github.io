---
title: Extending an action in ASP.NET MVC using NextMatch
date: 2015-03-09 15:27:00 -0300
tags: [asp.net mvc]
---

Routing offers many advantages for application composition. For instance, it's easier to reuse code by including pre-compiled (portable) modules. You can modify an action by defining an equivalent route that points to your own controller. This is similar to overriding an abstract or virtual method in C#.

On this post I explore the idea of extending an action, that is, overriding an action but also calling the overridden (base) action, similar to calling a base method in C#, but without inheritance.

## Use case: MvcAccount

[MvcAccount][1] has a pretty basic feature set. We're going to extend MvcAccount by adding two features:

1. **Different than last four passwords policy**: We'll override the *Change Password* action to enforce that new password are different that the last four passwords used.
2. **Password expiration**: We'll override the *Sign In* action and redirect to the *Change Password* action if the password is older than a time of our choosing.

## Routes

We start overriding both actions by registering two new routes before the base actions' routes. It's important to use the same controller and action names so we don't break URL generation and views location. By using a different namespace the framework can disambiguate between our controllers and MvcAccount's.

```csharp
routes.MapRoute(null, "Account/{action}", 
    new { controller = "Authentication" }, 
    new { action = new SetRouteConstraint("SignIn") }, 
    new[] { "MvcNextMatch.Controllers.Account.Authentication" });

routes.MapRoute(null, "Account/Password/Change/{action}", 
    new { controller = "Change", action = "Change" }, 
    new { action = new SetRouteConstraint("Change") }, 
    new[] { "MvcNextMatch.Controllers.Account.Password.Change" });

// MvcAccount's routes below
```

## Saving password history

Both features require access to the history of passwords. For this purpose we'll use this very simple model and repository:

```csharp
public class PasswordChange {

   public int UserId { get; set; }
   public string Password { get; set; }
   public DateTime CreatedOn { get; set; }
}

public abstract class PasswordChangeRepository {

   public abstract void PasswordChanged(PasswordChange passwordChange);
   public abstract ICollection<PasswordChange> GetLastFourPasswords(int userId);
}
```

*PasswordChanged* saves a *PasswordChange* model, and *GetLastFourPasswords* retrieves the last four *PasswordChange* models.

## Controllers

Time for the fun part. Our *ChangeController*:

```csharp
[Authorize]
public class ChangeController : Controller {

   // ... code omitted for clarity

   [HttpPost]
   public ActionResult Change(ChangeInput input) {

      User user;

      if (this.ModelState.IsValid
         && (user = this.accountRepo.FindUserByName(this.User.Identity.Name) as User) != null
         && this.passServ.PasswordEquals(input.CurrentPassword, user.Password)) {

         if (this.passwordChangeRepo.GetLastFourPasswords(user.Id).Any(p => p.Password == input.NewPassword)) {
         
            this.ModelState.AddModelError("NewPassword", "The new password must be different to your last four passwords.");
            return View();

         } else {

            ActionResult nextResult = this.NextMatch();

            if (this.ModelState.IsValid) { // Password was changed
            
               this.passwordChangeRepo.PasswordChanged(new PasswordChange {
                  UserId = user.Id,
                  CreatedOn = DateTime.Now,
                  Password = this.passServ.ProcessPasswordForStorage(input.NewPassword)
               });
            }

            return nextResult;
         }
      }

      return this.NextMatch();
   }
}
```

Our code runs only if: a) posted data is valid, b) can retrieve current user record, and c) provided current password is valid.

If the new password is the same as one of the last four passwords then we add the error to *ModelState* and return the view.

![Different than last four passwords policy][2]

If the new password is **not** one of the last four passwords, we call the base action using the *NextMatch* extension method. If the *ModelState* is valid that means the password was successfully changed, we save the password to the history and return the result.

If none of our code runs simply return *NextMatch*.

And our *AuthenticationController*:

```csharp
public class AuthenticationController : Controller {

   // ... code omitted for clarity

   [HttpPost]
   public ActionResult SignIn(SignInInput input) {
         
      ActionResult nextResult = this.NextMatch();

      User user;
      PasswordChange lastPassword;

      if (this.ModelState.IsValid
         && (user = this.accountRepo.FindUserByName(input.Username) as User) != null
         && ((lastPassword = this.passwordChangeRepo.GetLastFourPasswords(user.Id).FirstOrDefault()) == null
            || lastPassword.CreatedOn.Add(this.passwordDuration) < DateTime.Now)) {

         return RedirectToAction("", "Password.Change", new { expired = 1 });
      }

      return nextResult;
   }
}
```

First, call the base action. Then, if a) *ModelState* is valid (meaning sign-in succedeed), b) can retrieve user record, c) can retrieve last (same as current) password from history, and d) password expired, then redirect to the *Change Password* action. Otherwise, simply return the result.

![Password expiration][3]

## That's it!

We've taken an existing application and made two extensions to existing features by adding some code *around* them, but without forking the app or learning its internals.

This is not the only way to extend an MVC app. The alternatives are:

- **Using a domain service**: Perhaps the app exposes a domain service you can inherit and override. That's not the case for MvcAccount, but even if it were there are things that are usually not implemented in the domain layer, like redirects. Being in the application layer there's a lot more you can do, like modifying *ViewData*, *TempData*, action parameters, returning a different view, anything you want.

- **Using an action filter**: To use an action filter without modifying the app you'd have to register it globally, then check if the current action is the one you want to extend before executing your code. Action filters are more well suited for cross-cutting concerns.

## What's next

We need a better way to determine the outcome of calling a base action. Checking `ModelState.IsValid` works on this case, but it's not a general solution. There are many ways to represent errors and redirects in MVC, so the only way to unambiguously determine the outcome of an action is by using HTTP status codes. [ActionResult needs a StatusCode property][4].

Hope you like this.

[:octocat: Source code][5]

[1]: {{ site.url }}/MvcAccount/
[2]: {{ site.url }}/img/mvcnextmatch_screenshot_2.png
[3]: {{ site.url }}/img/mvcnextmatch_screenshot_1.png
[4]: https://github.com/aspnet/Mvc/issues/2109
[5]: https://github.com/maxtoroq/2015-03-aspnet-mvc-next-match
