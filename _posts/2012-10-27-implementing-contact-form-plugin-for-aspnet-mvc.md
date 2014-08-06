---
layout: post
title: Implementing a contact form plugin for ASP.NET MVC
date: 2012-10-27 00:33:00 -0300
tags: [asp.net mvc, patterns, plugin]
---

The purpose of this post is to demonstrate the patterns presented in the *Patterns for ASP.NET MVC Plugins* series so far.

1. [Routes, Controllers and Configuration][1]
2. [View Models][2]
3. *Demo: Implementing a contact form plugin*

I've chosen the *contact form* scenario because it's a very common requirement most developers are familiar with. Also, the implementation is short and straightforward. The idea is that you focus on the patterns rather than the actual functionality of the plugin. The same patterns can be used to implement more interesting plugins.

Model
-----
The model for the plugin is a very simple one, only four fields that the user needs to enter.

```csharp
public class ContactInput {

   [Required]
   [StringLength(100)]
   [Display(Order = 1)]
   public virtual string Name { get; set; }

   [Required]
   [DataType(DataType.EmailAddress)]
   [StringLength(254)]
   [RegularExpression(@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*")]
   [Display(Order = 2)]
   public virtual string Email { get; set; }

   [Required]
   [StringLength(254)]
   [Display(Order = 3)]
   public virtual string Subject { get; set; }

   [Required]
   [StringLength(2000)]
   [DataType(DataType.MultilineText)]
   [Display(Order = 4)]
   public virtual string Message { get; set; }
}
```

This is what the series call an *Input Model*, which defines the data that an action takes as input.

Patterns used:

- [Set Display(Order) for all properties][3]
- [Name input models after the action method name plus the "Input" suffix][4]
  I'm deviating from the pattern here since the action method that uses this input model is Index and not Contact. I'm only using Index to make the URL as short and friendly as possible, and of course for compatibility with the default route. I think ContactInput is a much better name, since Index doesn't mean anything in this case.
- [Use the virtual modifier on all input model properties][5]
- [Use the DataTypeAttribute when appropiate][6]

Configuration
-------------
The following is the class used to provide configuration settings for the plugin.

```csharp
public class ContactConfiguration {

   public string From { get; set; }
   public string To { get; set; }
   public string CC { get; set; }
   public string Bcc { get; set; }
   public Func<ContactSender> ContactSenderResolver { get; set; }
}
```

`ContactSender` is the class that does the work. `ContactSenderResolver` is an optional setting used to provide a customized instance of `ContactSender`, we'll be using it later.

Patterns used:

- [Provide a class for the plugin's configuration settings][7]
- [Provide Func&lt;> properties for each dependency,  and name them with the "Resolver" suffix][8]

Service
-------
The following is the definition of `ContactSender` (some code ommited for clarity).

```csharp
public class ContactSender {

   SmtpClient smtpClient;
   ContactConfiguration config;
      
   public virtual ContactInput CreateContactInput() {
      return new ContactInput();
   }

   protected virtual void InitializeContactInput(ContactInput input) { }

   public ContactInput Send() {

      ContactInput input = CreateContactInput();
      InitializeContactInput(input);

      return input;
   }

   public virtual bool Send(ContactInput input) {

      var message = new MailMessage {
         To = { this.config.To },
         ReplyToList = { new MailAddress(input.Email, input.Name) },
         Subject = input.Subject,
         Body = RenderViewAsString("_Mail", input)
      };

      if (this.config.From != null) {
         message.From = new MailAddress(this.config.From);
      }

      if (this.config.CC != null) {
         message.CC.Add(this.config.CC);
      }

      if (this.config.Bcc != null) {
         message.Bcc.Add(this.config.Bcc);
      }

      try {
         this.smtpClient.Send(message);

      } catch (SmtpException ex) {
            
         LogException(ex);

         return false;
      }

      return true;
   }
}
```

Patterns used:

- [Provide a virtual method for the creation of input models, and name it after the type name plus the "Create" prefix][9]
- [Provide a virtual method for the initialization of input models, and name it after the type name plus the "Initialize" prefix][10]

View Model
----------
```csharp
public class IndexViewModel {

   public ContactInput InputModel { get; private set; }

   public IndexViewModel(ContactInput inputModel) {
      this.InputModel = inputModel;
   }
}
```

Patterns used:

- [Always use strongly-typed view models][11]
- [Name view models after the view plus the "ViewModel" suffix][12]
- [Define separate classes for input and output models, plus a view model class that reference the other two][13]

View
----
```aspx-cs
@model IndexViewModel

@using (Html.BeginForm()) { 
   @Html.AntiForgeryToken()
   var inputHtml = HtmlUtil.HtmlHelperFor(Html, Model.InputModel);
   @inputHtml.EditorForModel()

   <input type="submit" />
}
```

Patterns used:

- [Create an HtmlHelper&lt;TModel> instance for form rendering, where TModel is the input model type][14]

Controller
----------
```csharp
[OutputCache(Location = OutputCacheLocation.None)]
public class ContactController : Controller {

   ContactSender service;

   public ContactController() { }

   public ContactController(ContactSender service) {
      this.service = service;
   }

   protected override void Initialize(RequestContext requestContext) {
         
      base.Initialize(requestContext);

      ContactConfiguration config = ContactConfiguration.Current(requestContext);

      this.service = config.RequireDependency(this.service);
   }

   [HttpGet]
   public ActionResult Index() {

      this.ViewData.Model = new IndexViewModel(this.service.Send());
         
      return View();
   }

   [HttpPost]
   public ActionResult Index(string foo) {

      ContactInput input = this.service.CreateContactInput();

      this.ViewData.Model = new IndexViewModel(input);
         
      if (!ModelBinderUtil.TryUpdateModel(input, this)) {
            
         this.Response.StatusCode = (int)HttpStatusCode.BadRequest;
         return View();
      }

      if (!this.service.Send(input)) {
            
         this.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
         return View();
      }

      return RedirectToAction("Success");
   }

   [HttpGet]
   public ActionResult Success() {
      return View();
   }
}
```

Patterns used:

- [Make controllers public][15]
- [Name controllers with common, widely used names][16]
- [Minimize the number of controllers][17]
- [Provide a default constructor][18]
- [Provide constructors that take dependencies as arguments][19]
- [Use the 'Configuration' data token to accept an instance of the configuration class][20]
- [Use a model binding implementation that supports subclassing][21]
- [Set Response.StatusCode to 400 (Bad Request) if model binding fails][22]

Using the plugin
----------------
This is how you can register the plugin using [MvcCodeRouting][23].

```csharp
public static void RegisterRoutes(RouteCollection routes) {
         
   routes.MapCodeRoutes(
      baseRoute: "Contact",
      rootController: typeof(ContactController),
      settings: new CodeRoutingSettings {
         EnableEmbeddedViews = true,
         Configuration = new ContactConfiguration {
            To = "contact@example.com"
         }
      }
   );
}
```

If you visit /Contact you'll see the contact form.

![Contact Form][25]

Adding a field to the form
--------------------------
Let's add a second plugin instance, this time with an extra field. First, we need to inherit `ContactInput` and add the new property.

```csharp
public class CustomContactInput : ContactInput {

   [Required]
   [Display(Name = "How did you hear about us?", Order = 3)]
   [UIHint("Source")]
   public virtual string Source { get; set; }
}
```

Next, inherit `ContactSender` and override `CreateContactInput`.

```csharp
public class CustomContactSender : ContactSender {

   public override ContactInput CreateContactInput() {
      return new CustomContactInput();
   }
}
```

Note the use of `UIHint("Source")` on the new property, let's add that editor template.

```csharp
@Html.DropDownList("", new[] { "Friend", "Advertisement", "Google", "Other" }
   .Select(s => new SelectListItem { Text = s, Value = s }), "")
```

Lastly, we register this new plugin instance.

```csharp
routes.MapCodeRoutes(
   baseRoute: "CustomContact",
   rootController: typeof(ContactController),
   settings: new CodeRoutingSettings {
      EnableEmbeddedViews = true,
      Configuration = new ContactConfiguration {
         To = "info@example.com",
         ContactSenderResolver = () => new Models.CustomContactSender()
      }
   }
);
```

Note I'm also using a different destination address (`To` configuration setting). If you visit /CustomContact you can see the form with the new field.

![Custom field][26]

Conclusions
-----------
Hopefully seeing the patterns in action makes their utility more clear. The goal is to provide a consistent experience for plugin consumers (application developers), minimize the amount of configuration required to get a plugin working in the host application and maximize the plugin's flexibility to customize its behavior.

[Source code][24]

[1]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html
[2]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html
[3]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-display-order
[4]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-inputmodel-naming
[5]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-inputmodel-virtual-properties
[6]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-data-type-attr
[7]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-configuration-class
[8]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-configuration-resolver-properties
[9]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-inputmodel-create
[10]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-inputmodel-initialize
[11]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-use
[12]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-naming
[13]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-separate-classes
[14]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-htmlhelper-for-inputmodel
[15]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-controllers-public
[16]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-controllers-common-naming
[17]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-controllers-minimize
[18]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-controllers-default-constructor
[19]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-controllers-constructor-dependencies
[20]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html#pattern-configuration-data-token
[21]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-modelbinding-inheritance
[22]: {{ site.url }}/2012/07/patterns-for-aspnet-mvc-plugins-viewmodels.html#pattern-viewmodels-modelbinding-failure-status-code
[23]: http://mvccoderouting.codeplex.com/
[24]: https://github.com/maxtoroq/MvcContact
[25]: {{ site.url }}/files/mvccontact_screenshot_1.png
[26]: {{ site.url }}/files/mvccontact_screenshot_2.png
