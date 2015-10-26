---
title: "Patterns for ASP.NET MVC Plugins: View Models"
date: 2012-07-24 00:01:00 -0400
tags: [asp.net mvc, patterns, plugin]
---

The goal of these patterns is to provide a consistent experience for plugin consumers (application developers), minimize the amount of configuration required to get a plugin working in the host application and maximize the plugin's flexibility to customize its behavior.

This is the second post of the series, see also the other posts:

1. [Routes, Controllers and Configuration][1]
2. *View Models*
3. [Demo: Implementing a contact form plugin][2]

Basic patterns
--------------
<strong id="pattern-viewmodels-use">Always use strongly-typed view models</strong>. Don't use ViewData, ViewBag or a dynamic/anonymous object, always create a specialized view model class for each view. Application developers will appreciate it when customizing views.

<strong id="pattern-viewmodels-naming">Name view models after the view plus the "ViewModel" suffix</strong>. e.g. for the Index view create an IndexViewModel class. Although ViewModel is a long suffix, it makes it very clear for the developer to understand what's the purpose of the class, and to differentiate from other kinds of models the plugin might have. If you have more than one controller use the controller name as prefix, e.g. FooIndexViewModel.

<del>**Customize display names using DisplayNameAttribute instead of DisplayAttribute**. There are two ways of customizing the display names of types and properties. You can use the Name property of the [DisplayAttribute][3] or you can use the [DisplayNameAttribute][4], the framework recognizes both in that order. You should use DisplayNameAttribute because it's specifically design for that purpose (DisplayAttribute has many other properties), and more importantly because DisplayAttribute is sealed and DisplayNameAttribute isn't. If some component needs to customize how display names are computed subclassing DisplayNameAttribute is the only way, a common example is reading display names from resource files for localization. You can still use DisplayAttribute for all the other properties it has, just don't use Name.</del> <ins>**Update:** I was under the impression that DisplayAttribute did not support localization, but I was wrong. DisplayAttribute fixes two issues about DisplayNameAttribute: 1) It supports localization, 2) It can be applied to fields (e.g. enums members). So, if your plugin targets .NET 4 or higher you should use DisplayAttribute. If you care about maximum compatibility, e.g. with libraries that target .NET 2-3.5, or that maybe recognize only one of them, you should use both.</ins>

<strong id="pattern-viewmodels-display-order">Set Display(Order) for all properties</strong>. When you subclass a model to add more properties, these added properties will appear at the top of the form, before the properties from the base class. Normally you want fields in a form to be sorted by importance, so in most cases it would make more sense to see the subclass properties at the bottom. Since that is not the case you should explicitly set Display(Order) on all properties. Note that having more than one property with the same Order value is allowed, in that case the subclass property also goes first.

<strong id="pattern-viewmodels-data-type-attr">Use the DataTypeAttribute when appropiate</strong>. See if your properties are used for values that can be represented by one of the members in the [DataType][5] enumeration. Common cases are Password, MultilineText and EmailAddress. Setting this attribute makes it easier to customize display and editor templates for each of these types of values.

View Models, Input Models and Output Models
-------------------------------------------
I want to make a distinction between the different kinds of models, based on their purpose. A **view model** is a model for the view, it defines the data that the view needs and uses, nothing less nothing more. An **input model** defines the data that an action takes as input, e.g. from a form submission. An **output model** defines the data that is the result of an action, e.g. search results. Some actions have inputs but no outputs (e.g. actions that redirect), some actions have outputs but no inputs, and some have both inputs and outputs.

<strong id="pattern-viewmodels-separate-classes">Define separate classes for input and output models, plus a view model class that reference the other two</strong>. Instead of defining a single view model class that contain both input and output properties define a class for each of these types of models, plus a view model class with an **InputModel** property (for actions that have inputs) and an **OutputModel** property (for actions that have outputs).

Although the framework has a BindAttribute and several [Try]UpdateModel overloads where you can specify which input properties should be bound, or which output properties should not be bound, using it means that every time you want to extend an input or output model you would have to update the action code, which is not an option for precompiled plugins. The following sections talk about input and output model extensibility.

Another reason for having separate input and output models is editor and display templates. Application developers should be able to customize editor and display templates for specific types without having to override an entire view to do so.

Input Models
------------
<strong id="pattern-viewmodels-inputmodel-naming">Name input models after the action method name plus the "Input" suffix</strong>. e.g. for the ChangeEmail action create the ChangeEmailInput input model. Notice I said action method name instead of action name, sometimes action names are shortened (e.g. using the ActionNameAttribute) or changed in some way to make the URL suit a particular style. The name of input models should be meaningful to application developers and don't need to match the action URL. If you have more than one controller use the controller name as prefix, e.g. AccountChangeEmailInput.

<strong id="pattern-viewmodels-inputmodel-naming-edit">If you have <em>Create</em> and <em>Update</em> actions that have identical input models define a single input model named after the resource plus the "Edit" suffix</strong>. e.g. ProductEdit. This one is for actions that are more "resource oriented". If one of the models contains a subset of the other consider making one inherit the other to avoid having duplicate properties (defining identical properties is not the main issue, is more about all the metadata you put on them via attributes).

<strong id="pattern-viewmodels-inputmodel-no-id">Don't include unique identifier properties</strong>. Input models have no identity, if you are using an input model to provide changes to some existing resource pass in the resource identifier as a separate argument. For example, let's say we have an action to edit a single product:

```csharp
[HttpPost]
public ActionResult Edit(int id, ProductEdit input) {
   ...
}
```

The id parameter identifies the product, and the ProductEdit input model defines the properties that can be changed:

```csharp
[HttpPost]
public class ProductEdit {
   public string Name { get; set; }
   public decimal UnitPrice { get; set; }
}
```

If you want to display the id on the view you should include it in an output model.

<strong id="pattern-viewmodels-htmlhelper-for-inputmodel">Create an HtmlHelper&lt;TModel> instance for form rendering, where TModel is the input model type</strong>. It's common to use an input model as view model to provide strongly-typed HTML helpers for form controls and validation messages, e.g. `Html.EditorFor(p => p.SomeProperty)`. By having a separate input model type that the view model includes in a property, strongly-typed HTML helper calls are changed to something like `Html.EditorFor(p => p.InputModel.SomeProperty)`, which means all form fields will have the "InputModel." prefix. You can avoid this by creating an HtmlHelper&lt;TModel> instance, where TModel is the input model type. The following is an extension method for this purpose:

```csharp
public static class HtmlHelperFactoryExtensions {

   public static HtmlHelper<TModel> HtmlHelperFor<TModel>(this HtmlHelper htmlHelper) {
      return HtmlHelperFor(htmlHelper, default(TModel));
   }

   public static HtmlHelper<TModel> HtmlHelperFor<TModel>(this HtmlHelper htmlHelper, TModel model) {
      return HtmlHelperFor(htmlHelper, model, null);
   }

   public static HtmlHelper<TModel> HtmlHelperFor<TModel>(this HtmlHelper htmlHelper, TModel model, string htmlFieldPrefix) {

      var viewDataContainer = CreateViewDataContainer(htmlHelper.ViewData, model);

      TemplateInfo templateInfo = viewDataContainer.ViewData.TemplateInfo;

      if (!String.IsNullOrEmpty(htmlFieldPrefix))
         templateInfo.HtmlFieldPrefix = templateInfo.GetFullHtmlFieldName(htmlFieldPrefix);

      ViewContext viewContext = htmlHelper.ViewContext;
      ViewContext newViewContext = new ViewContext(viewContext.Controller.ControllerContext, viewContext.View, viewDataContainer.ViewData, viewContext.TempData, viewContext.Writer);

      return new HtmlHelper<TModel>(newViewContext, viewDataContainer, htmlHelper.RouteCollection);
   }

   static IViewDataContainer CreateViewDataContainer<TModel>(ViewDataDictionary viewData, TModel model) {

      var newViewData = new ViewDataDictionary<TModel>(viewData) {
         Model = model
      };

      newViewData.TemplateInfo = new TemplateInfo { 
         HtmlFieldPrefix = newViewData.TemplateInfo.HtmlFieldPrefix 
      };

      return new ViewDataContainer {
         ViewData = newViewData
      };
   }

   class ViewDataContainer : IViewDataContainer {
         
      public ViewDataDictionary ViewData { get; set; }
   }
}
```

This is how you use it in a view:

```aspx-cs
@using (Html.BeginForm()) {
   var inputHtml = Html.HtmlHelperFor(Model.InputModel);
   @inputHtml.EditorForModel()
   <input type="submit"/>
}
```

<strong id="pattern-viewmodels-selectlist-viewdata">Use ViewData to pass a [Multi]SelectList instance for multiple choice controls</strong>. This is one case where using ViewData has benefits. It provides an out-of-band way of making a [Multi]SelectList available to multiple choice HTML helpers such as DropDownList, which means the view that calls the helper does not need to provide it as argument or can just pass null. To avoid losing type safety you can use the following method:

```csharp
void SetSelectList<TModel, TProperty>(TModel model, Expression<Func<TModel, TProperty>> propertySelector, MultiSelectList list) {
   this.ViewData[ExpressionHelper.GetExpressionText(propertySelector)] = list;
}
```

This is how you use it:

```csharp
SetSelectList(model, m => m.Country, selectList);
```

<strong id="pattern-viewmodels-inputmodel-create">Provide a virtual method for the creation of input models, and name it after the type name plus the "Create" prefix</strong>. e.g.

```csharp
public virtual ChangeEmailInput CreateChangeEmailInput() {
   return new ChangeEmailInput();
}
```

This method should be defined in the controller dependency that uses the input model. By overriding this method you can return a subclass of the input model.

<strong id="pattern-viewmodels-inputmodel-initialize">Provide a virtual method for the initialization of input models, and name it after the type name plus the "Initialize" prefix</strong>. e.g.

```csharp
protected virtual void InitializeChangeEmailInput(ChangeEmailInput input) { }
```

This method should be defined in the controller dependency that uses the input model. This method is for providing default or initial values to form fields. You can also define additional parameters, e.g. if you want to initialize with persisted values. If the input model is used in more than one action append "For" to the method name plus the name of the method that uses the input model, e.g. InitializeProductEditForCreate, InitializeProductEditForUpdate.

<strong id="pattern-viewmodels-inputmodel-virtual-properties">Use the virtual modifier on all input model properties</strong>. This allows the subclass to add or override attributes.

<strong id="pattern-viewmodels-modelbinding-inheritance">Use a model binding implementation that supports subclassing</strong>. Unfortunately, the [Try]UpdateModel methods provided by the framework require that you explicitly declare the type you are binding at compile time, and if you attempt to bind a subclass instance the subclass properties are ignored. Even though they closed [the issue][6] claiming it's by design, let them know it's a bad design. Use the following code to workaround this issue:

```csharp
public static bool TryUpdateModel(object model, Controller controller) {

   if (model == null) throw new ArgumentNullException("model");
   if (controller == null) throw new ArgumentNullException("controller");

   Type modelType = model.GetType();

   ModelBinders.Binders
      .GetBinder(modelType)
      .BindModel(controller.ControllerContext, new ModelBindingContext {
         ModelMetadata = ModelMetadataProviders.Current.GetMetadataForType(() => model, modelType),
         ModelState = controller.ModelState,
         ValueProvider = controller.ValueProvider
      });

   return controller.ModelState.IsValid;
}
```

<strong id="pattern-viewmodels-modelbinding-failure-status-code">Set Response.StatusCode to 400 (Bad Request) if model binding fails</strong>. Although users don't know or care about the status codes, it's important to set an error status code for AJAX clients. Even if your plugin does not implement AJAX forms, the plugin consumer might want to enhance the plugin with AJAX submissions, and the only (appropriate) way to know if the request succeeded or not is by examining the response status code.

Output Models
-------------
<strong id="pattern-viewmodels-outputmodel-naming">Name output models after the action method name plus the "Result" suffix</strong>. e.g. SearchResult. If you have more than one controller use the controller name as prefix, e.g. ProductsSearchResult.

<strong id="pattern-viewmodels-output-on-viewmodel">Consider using view model properties for metadata and presentation data</strong>. It's usually cleaner to pass things like links, titles, messages or other unrelated pieces of data that the view needs, as properties of the view model. This might be data that complement the output model, but created in a different layer of the plugin (e.g. the "Cancel" link of a form). It can also be presentation-specific data, such as the active tab in a tabbed interface. In other words, output models should be used for "business" or "domain" data, and view models for application or presentation data. It's up to the plugin developer to decide where to draw the line, but should always prioritize usability from the application developer's perspective.

<strong id="pattern-viewmodels-outputmodel-create">Provide a virtual method for the creation of output models, and name it after the type name plus the "Create" prefix</strong>. e.g.

```csharp
protected virtual SearchResult CreateSearchResult() {
   return new SearchResult();
}
```

This method should be defined in the controller dependency that uses the output model. By overriding this method you can return a subclass of the output model.

<strong id="pattern-viewmodels-outputmodel-bind">Provide a virtual method for the binding of output models, and name it after the type name plus the "Bind" prefix</strong>. e.g.

```csharp
protected virtual void BindSearchResult(SearchResult result, object data) { }
```

This method should be defined in the controller dependency that uses the output model. The type of the second parameter is implementation-defined.

Conclusions
-----------
Good view model design can make a great difference in the plugin's customizability. We've covered ways to customize the data that comes in and out of the plugin, their presentation and validation metadata. Naming patterns are also very important for usability, it makes it easier for application developers to find and discover the types they need to use.

Tying it all together
---------------------
On the [next post][2] I'm going to dissect a sample plugin that implements most of the patterns presented on this series so far. Stay tuned.

[1]: {{ site.url }}/2012/06/patterns-for-aspnet-mvc-plugins-routes.html
[2]: {{ site.url }}/2012/10/implementing-contact-form-plugin-for-aspnet-mvc.html
[3]: http://msdn.microsoft.com/library/system.componentmodel.dataannotations.displayattribute
[4]: http://msdn.microsoft.com/library/system.componentmodel.displaynameattribute
[5]: http://msdn.microsoft.com/library/system.componentmodel.dataannotations.datatype
[6]: http://connect.microsoft.com/VisualStudio/feedback/details/483001
