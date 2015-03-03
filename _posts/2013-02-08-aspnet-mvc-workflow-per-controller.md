---
title: "Rethinking ASP.NET MVC: Workflow per Controller"
date: 2013-02-08 19:50:00 -0300
tags: [asp.net mvc, mvccoderouting, patterns, routing]
---

[My most controversial answer][1] on StackOverflow is to a question about how to organize an ASP.NET MVC application. My answer was:

> Separating classes by category (Controllers, ViewModels, Filters etc.) is nonsense.
>
> If you want to write code for the Home section of your website (/) then create a folder named Home, and put there the HomeController, IndexViewModel, AboutViewModel, etc. and all related classes used by Home actions.
>
> If you have shared classes, like an ApplicationController, you can put it at the root of your project.
>
> Why separate things that are related (HomeController, IndexViewModel) and keep things together that have no relation at all (HomeController, AccountController) ?

This was downvoted for a long time. Eventually people started upvoting and now it's on the positive. People started to realize what a pain it is to maintain an app where the code for a single function is scattered all over the place. Categorization of information is useful if there's value in looking at all information of a certain category at once. For example, in Reflector you can look at all derived types of a certain type, which is super useful. Such function would be a great addition to Visual Studio. Back to MVC, if I could ask Visual Studio to show me all controllers, without having to put all controllers in the same directory/namespace, that would be great too. Because, when it comes to organizing code, keeping related types together is the best option for maintainability, specially of large codebases.

Controllers and Namespaces
--------------------------
So, for a long time I've been putting controllers and related view models in their own namespace. [MvcCodeRouting][2] makes it easy. But this lead to a new problem. Since, to take advantage of model validation and model metadata you have to write classes, it's natural in MVC to end up with a lot of classes. This lead to having namespaces with too many classes, many of these were unrelated view models. The problem started by having too many actions per controller. How many actions should a controller have? Some are going as far as having [one action per controller][3]. I wouldn't go that far. I think a controller should implement a single workflow, and that workflow should have its own namespace.

Workflow per Controller
-----------------------
So, what is a workflow? Let's take [MvcAccount][4] for example. There's a Reset Password function comprised of several actions:

1. `GET /Account/ResetPassword`
2. `POST /Account/ResetPassword`
3. `GET /Account/PasswordResetVerificationSent`
4. `GET /Account/RP` (by clicking on e-mail link)
5. `POST /Account/RP`
6. `GET /Account/PasswordReset`

To successfully reset a password you have go through this sequence of actions from start to finish. This is the Reset Password workflow, and should be represented in code by its own controller. This means going from:

```csharp
namespace MvcAccount {
   
   public class AccountController : Controller {

      public ActionResult ResetPassword() { ... }

      [HttpPost]
      public ActionResult ResetPassword(ResetPasswordInput input) { ... }

      public ActionResult PasswordResetVerificationSent() { ... }

      public ActionResult RP(string id) { ... }

      [HttpPost]
      public ActionResult RP(string id, FinishResetPasswordInput input) { ... }

      public ActionResult PasswordReset() { ... }

      // ... lots of other unrelated actions below
   }
}
```

...to:


```csharp
namespace MvcAccount.Password.Reset {

   public class ResetController : Controller {

      public ActionResult Reset() { ... }

      [HttpPost]
      public ActionResult Reset(ResetInput input) { ... }

      public ActionResult VerificationSent() { ... }

      public ActionResult Finish(string id) { ... }

      [HttpPost]
      public ActionResult Finish(string id, FinishInput input) {... }

      public ActionResult Done() { ... }
   }
}
```

### Pros

**Codebase neatly organized**: No more namespaces with too many classes. All of the Reset Password workflow classes, which includes the controller and view models, sit in the `MvcAccount.Password.Reset` namespace. The parent namespace, `MvcAccount.Password`, can also be used to group related workflows, e.g. `MvcAccount.Password.Change`. These can be considered related workflows because: a) they act on the same resource, or b) they share some infrastructure code (e.g. data access).

**Smaller controllers**: yep.

**Shorter names of actions and view models**: Namespaces gives us qualification and frees us from naming conflicts. `PasswordResetVerificationSent` becomes `VerificationSent`, and `FinishResetPasswordInput` becomes `FinishInput`. This also means shorter names for views.

**Simpler dependency injection**: Controller can take dependencies required by the workflow only.

**If implementation is simple enough you can move it to the controller class or workflow namespace**: I won't get into a religious war about where the service or domain layer should go, whether it should be separate from the web layer, etc. etc., but since the controller is a lot smaller, and the workflow namespace only has a few classes, then there's a lot more you can put there.

### Cons

**Can produce longer routes**: In some cases, it won't change much. For example, using MvcCodeRouting `/Account/PasswordResetVerificationSent` becomes `/Account/Password/Reset/VerificationSent`. But `/Account/ResetPassword` becomes `/Account/Password/Reset/Reset`. Why Reset twice? First Reset for the controller, second for the action. This can be avoided by changing the action to `Index`, but I don't think that's a good name considering what the action does. Perhaps having a second convention for default actions, one where the action name is the same as the controller name, would help. In any case, when conventional routes are too long you can always resort to custom routes. <ins class="update">**Update:** MvcCodeRouting v1.1 supports custom default actions.</ins>

How to avoid going back
-----------------------
**Don't let your routing solution dictate how to organize your code**. This was the mistake I made over and over. First I thought about the URL I wanted to implement, then I thought where in the project I had to put the code to implement that URL. This is how you end up with messy codebases. Always think first about the proper way to organize your code, then worry about routing and URLs.

Show me the code
----------------
[Before][4] → [After][5]

[1]: http://stackoverflow.com/a/1528571/39923
[2]: http://mvccoderouting.codeplex.com/
[3]: http://jeffreypalermo.com/blog/the-asp-net-mvc-actioncontroller-ndash-the-controllerless-action-or-actionless-controller/
[4]: https://github.com/maxtoroq/MvcAccount/tree/v0.8/src/MvcAccount
[5]: https://github.com/maxtoroq/MvcAccount/tree/master/src/MvcAccount