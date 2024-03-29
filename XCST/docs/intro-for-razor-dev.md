---
title: XCST Introduction for the Razor Developer
---

XCST is a middle ground between XSLT and Razor. Being XML, it has a stricter syntax, but at the same time there's more flexibility with what you can do with your code. If you are familiar with XSLT and XML then picking up XCST should be easy. If you don't, then this guide is for you.

Modules
-------
A Razor page is a script that is executed from top to bottom. It has a body, which can include markup, text, code blocks and sections. It can also have declarations such as functions and helpers, which are not part of the body and are not affected by order. A Razor page has therefore a single point of entry, its body.

```csharp
@using System

Hello World, it's @DateTime.Now
```

An XCST page has no body, only declarations. You can define a template named `c:initial-template` which acts as the default entry point, but you can also choose other templates and functions to start your program.

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:import-namespace ns='System'/>

   <c:template name='c:initial-template' expand-text='yes'>
      Hello World, it's {DateTime.Now}
   </c:template>

</c:module>
```

Value templates
---------------
In Razor you use the `@` symbol to mix expressions with text and markup.

```csharp
Hello World, it's @DateTime.Now
```

In XCST you use curly braces, just like in [interpolated strings][2].

```xml
Hello World, it's {DateTime.Now}
```

Because sometimes you need to use curly braces in content such as CSS and JavaScript, you declare `[c:]expand-text='yes'` to enable this feature. `[c:]expand-text` is a [standard attribute][7] that can be used on any XCST element and any literal result element (prefixed).

Value templates always work for attribute values. To output curly braces you have to double them.

```xml
<div data-opts='{{"{{"}}"foo":1{{"}}"}}'/>
```

An alternative to value templates is the [`c:value-of`](../c/value-of.html) instruction.

```xml
Hello World, it's <c:value-of value='DateTime.Now'/>
```

Instructions
------------
In Razor you can mix C# statements with markup.

```csharp
@if (IsPost) {
   <p>This page was posted using the Submit button.</p>
} else {
   <p>This was the first request for this page.</p>
}
```

In XCST you can mix instructions with markup.

```xml
<c:choose>
   <c:when test='IsPost'>
      <p>This page was posted using the Submit button.</p>
   </c:when>
   <c:otherwise>
      <p>This was the first request for this page.</p>
   </c:otherwise>
</c:choose>
```

Script blocks
-------------
There's no need to use instructions if you can express it in C#, use [`c:script`](../c/script.html) to put code anywhere you need it.

```xml
<c:script>
   <![CDATA[

   var result = "";
   
   if (IsPost) {
      result = "This page was posted using the Submit button.";
   } else {
      result = "This was the first request for this page.";
   }
   ]]>
</c:script>
<p>{result}</p>
```

Working with attributes
-----------------------
Razor has several tricks to work with attributes. For instance, in the following example, if `className` is null the class attribute is omitted.

```csharp
<div class="@className"></div>
```

In XCST you have to use the [`c:attribute`](../c/attribute.html) instruction to conditionally output an attribute.

```xml
<div>
   <c:if test='className != null'>
      <c:attribute name='class' value='className'/>
   </c:if>
</div>
```

Razor also understands [boolean attributes][3].

```csharp
<input type="checkbox" checked="@isChecked"/>
```

If `isChecked` evaluates to `false` the attribute is omitted. If its `true`, the output is:

```html
<input type="checkbox" checked/>
```

In XCST, like in the previous example, use [`c:attribute`](../c/attribute.html) to conditionally output an attribute.

```xml
<input type='checkbox'>
   <c:if test='isChecked'>
      <c:attribute name='checked'>checked</c:attribute>
   </c:if>
</input>
```

There are even more tricks related to attributes in Razor. It should be clear by now that Razor was designed specifically for HTML generation, while XCST is suitable for generating XML, HTML and text.

Last attribute trick, URL resolution in Razor:

```html
<script src="~/myscript.js"></script>
```

In XCST pages/views you can use `Url.Href` or `Url.Content`.

```xml
<script src='{Url.Href("~/myscript.js")}'></script>
<script src='{Url.Content("~/myscript.js")}'></script>
```

Whitespace
----------
In Razor, whitespace in markup and text is significant and outputs unchanged.

In XCST, whitespace between elements is ignored. The following three examples are semantically the same.

```xml
<ul><li>Alpha</li><li>Tango</li><li>Charly</li></ul>
```

```xml
<ul>
   <li>Alpha</li>
   <li>Tango</li>
   <li>Charly</li>
</ul>
```

```xml
<ul>
   <li>Alpha</li>
   
   <li>Tango</li>
   
   <li>Charly</li>
</ul>
```

The output for all three examples is:

```xml
<ul><li>Alpha</li><li>Tango</li><li>Charly</li></ul>
```

You can enable indentation using an output definition:

```xml
<c:output indent='yes'/>

<c:template name='c:initial-template'>
   <ul>
      <li>Alpha</li>
      <li>Tango</li>
      <li>Charly</li>
   </ul>
</c:template>
```

...or use `xml:space='preserve'` to make whitespace output unchanged:

```xml
<ul xml:space='preserve'>
   <li>Alpha</li>
   
   <li>Tango</li>
   
   <li>Charly</li>
</ul>
```

Comments
--------
In Razor:

```csharp
@* User cannot see this comment *@
<!-- User can see this comment -->
```

In XCST, XML comments are ignored. To output a comment use the [`c:comment`](../c/comment.html) instruction.

```xml
<!-- User cannot see this comment -->
<c:comment>User can see this comment</c:comment>
```

Templates
---------
Instead of putting all code in the body, in Razor you can split a page into several parts using helpers.

```csharp
@helper Form() {
   <form method="post">
      ...
   </form>
}
@helper Aside() {
   <aside>
      ...
   </aside>
}

<div class="row">
   <div class="col-md-8">@Form()</div>
   <div class="col-md-4">@Aside()</div>
</div>
```

In XCST you use [`c:template`](../c/template.html) for the same purpose. To call templates use the [`c:call-template`](../c/call-template.html) instruction.

```xml
<c:template name='form'>
   <form method='post'>
      ...
   </form>
</c:template>

<c:template name='aside'>
   <aside>
      ...
   </aside>
</c:template>

<c:template name='c:initial-template'>
   <div class='row'>
      <div class='col-md-8'>
         <c:call-template name='form'/>
      </div>
      <div class='col-md-4'>
         <c:call-template name='aside'/>
      </div>
   </div>
</c:template>
```

Functions and global variables
------------------------------
In Razor you use the `@functions` directive to define methods, fields or any other member you need to make available to the rest of the page.

```csharp
@functions {

   MyDatabase db = new();

   Product Edit(object id) {
      return db.Products.Find(id);
   }
}
```

In XCST you use [`c:function`](../c/function.html) to define a method and [`c:variable`](../c/variable.html) to define a property.

```xml
<c:variable name='db' value='new()' as='MyDatabase'/>

<c:function name='Edit' as='Product'>
   <c:param name='id'/>

   <c:return value='db.Products.Find(id)'/>
</c:function>
```

Unlike templates, you can call functions directly from C# code.

On the previous example, `db` is compiled to a property that is initialized lazily when used for the first time. This makes it really easy to declare global variables that reference other global variables, saving you from writing a lot of boilerplate code, e.g.:

```xml
<c:variable name='x' value='1' as='int'/>
<c:variable name='y' value='x + 1' as='int'/>
```

Layouts
-------
In Razor, you use the `Layout` property to set the layout in a content page.

```csharp
@{
   Layout = "_Layout.cshtml";
}

Hello World!
```

In XCST there's no such setting. There's no special support for layouts. What you do instead is:

**#1 Put the layout markup in a separate module**, e.g. `_layout.xcst`

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:template name='c:initial-template'>
      <c:call-template name='layout'/>
   </c:template>
   
   <c:template name='layout'>
      <html>
         <head>
            <c:call-template name='head'/>
         </head>
         <body>
            <header>
               ...
            </header>
            <div class='container'>
               <c:call-template name='content'/>
            </div>
            <c:call-template name='scripts'/>
         </body>
      </html>
   </c:template>

   <c:template name='head'/>
   
   <c:template name='content'/>
   
   <c:template name='scripts'/>

</c:module>
```

Note there are four templates, an initial template which calls the `layout` template, which in turn calls the `head`, `content` and `scripts` templates. The last three templates are empty, because is what the content page should *fill in*.

**#2 Import the layout module from the content page and override templates as needed**

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:import href='_layout.xcst'/>
   
   <c:template name='content'>
      Hello World!
   </c:template>
   
</c:module>
```

When you import a module you can override templates, functions and variables by simply creating a declaration with the same name. Also note this page doesn't have an initial template, we get that from the layout module.

In Razor, a common pattern for AJAX scenarios is to set `Layout` to `null` so only the content is served.

```csharp
@{
   if (Request.IsAjaxRequest()) {
      Layout = null;
   }
}
```

In XCST you have to call the `content` template instead.

```xml
<c:template name='c:initial-template'>
   <c:choose>
      <c:when test='IsAjax'>
         <c:call-template name='content'/>
      </c:when>
      <c:otherwise>
         <c:call-template name='layout'/>
      </c:otherwise>
   </c:choose>
</c:template>
```

<div class="note" markdown="1">

###### Note
Razor has <em>start pages</em> where you can set the layout for the whole site if you want. XCST has no such mechanism, to use a layout you have to explicitly import it.

</div>

Working with data and postbacks
-------------------------------
If you need to fetch some data, work with URL parameters or handle form postbacks, you can do it in the initial template and pass the results as **tunnel parameters** to make if available to the `content` template and other templates.

```xml
<c:template name='c:initial-template'>
   <c:script>
      <![CDATA[
      
      int id;
      Product product;
      
      if (!int.TryParse(UrlData[0], out id)
         || (product = Edit(id)) == null) {

         Response.StatusCode = 404;
         return;
      }
      ]]>
   </c:script>
   <c:next-template>
      <c:with-param name='product' value='product' tunnel='yes'/>
   </c:next-template>
</c:template>

<c:template name='content' expand-text='yes'>
   <c:param name='product' as='Product' tunnel='yes'/>
   
   <h1>{product.title}</h1>
   ...
</c:template>
```

The [`c:next-template`](../c/next-template.html) instruction is like [`c:call-template`](../c/call-template.html), except you don't specify a name, it calls the template with the same name as the current template in an imported module. On this case it calls `c:initial-template` from our [layout module](#layouts), which in turn calls the `layout` template. It's like calling a base method in C#. We could have called `layout` directly:

```xml
<c:call-template name='layout'>
   <c:with-param name='product' value='product' tunnel='yes'/>
</c:call-template>
```

On this case it's a matter of personal preference to use [`c:next-template`](../c/next-template.html) or not. The above code is the equivalent of doing `return View(product);` in an MVC controlller.

The other key here is `tunnel='yes'` on [`c:with-param`](../c/with-param.html) and [`c:param`](../c/param.html). First, a couple of things about template parameters.

Unlike function parameters (which are compiled to actual method parameters), template parameters are bound by name, not position, and are optional by default, unless you declare `required='yes'`. Also like [global variables](#functions-and-global-variables), template parameters can have default values that can be any expression, not just constants, and can even reference other parameters.

When you use `tunnel='yes'` on [`c:with-param`](../c/with-param.html) it means the template you are calling doesn't require to have that parameter defined. Tunnel parameters are passed *in the background*, so to speak. If the template you are calling calls other templates, tunnel parameters are passed, and so on. That's how we get the `product` parameter to the `content` template, which also needs to declare `tunnel='yes'` on [`c:param`](../c/param.html) for it to work.

In short, template parameters are a huge improvement from Razor's helper parameters, `PageData`, `Page`, `ViewData` and `ViewBag`. It helps you organize your code in a proper functional style.

HTML Helpers
------------
In Razor, HTML helpers are provided usually as extension methods for the HtmlHelper class, e.g. `Html.TextBox("foo")`.

In XCST, HTML helpers are provided as [extension instructions][6]. Below is a table of the HTML helpers in Razor and their XCST counterpart.

Razor                                                 | XCST
----------------------------------------------------- | -------------------------
`Html.Action()`                                       | n/a
`Html.ActionLink()`                                   | n/a
`Html.AntiForgeryToken()`                             | `<a:antiforgery/>`
`Html.BeginForm()`                                    | n/a
`Html.BeginRouteForm()`                               | n/a
`Html.CheckBox("foo")`                                | `<a:checkbox name='foo'/>`
`Html.CheckBoxFor(p => p.foo)`                        | `<a:checkbox for='foo'/>`
`Html.Display("foo")`                                 | `<a:display name='foo'/>`
`Html.DisplayFor(p => p.foo)`                         | `<a:display for='foo'/>`
`Html.DisplayForModel()`                              | `<a:display/>`
`Html.DisplayName("foo")`                             | `<a:display-name name='foo'/>`
`Html.DisplayNameFor(p => p.foo)`                     | `<a:display-name for='foo'/>`
`Html.DisplayNameForModel()`                          | `<a:display-name/>`
`Html.DisplayText("foo")`                             | `<a:display-text name='foo'/>`
`Html.DisplayTextFor(p => p.foo)`                     | `<a:display-text for='foo'/>`
`Html.DisplayTextForModel()`                          | `<a:display-text/>`
`Html.DropDownList("foo")`                            | `<a:select name='foo'/>`
`Html.DropDownListFor(p => p.foo)`                    | `<a:select for='foo'/>`
`Html.Editor("foo")`                                  | `<a:editor name='foo'/>`
`Html.EditorFor(p => p.foo)`                          | `<a:editor for='foo'/>`
`Html.EditorForModel()`                               | `<a:editor/>`
`Html.EnumDropDownListFor()`                          | n/a
`Html.Hidden("foo")`                                  | `<a:hidden name='foo'/>`
`Html.HiddenFor(p => p.foo)`                          | `<a:hidden for='foo'/>`
`Html.HttpMethodOverride("DELETE")`                   | n/a
`Html.Label("foo")`                                   | `<a:label name='foo'/>`
`Html.LabelFor(p => p.foo)`                           | `<a:label for='foo'/>`
`Html.LabelForModel()`                                | `<a:label/>`
`Html.ListBox("foo")`                                 | `<a:select name='foo' multiple='true'/>`
`Html.ListBoxFor(p => p.foo)`                         | `<a:select for='foo' multiple='true'/>`
`Html.Partial()`                                      | see [RenderPage/RenderPartial](#renderpagerenderpartial)
`Html.Password("foo")`                                | `<a:input type='password' name='foo'/>`
`Html.PasswordFor(p => p.foo)`                        | `<a:input type='password' for='foo'/>`
`Html.RadioButton("foo")`                             | `<a:radio name='foo'/>`
`Html.RadioButtonFor(p => p.foo)`                     | `<a:radio for='foo'/>`
`Html.Raw("<foo>")`                                   | `<c:value-of value='"&lt;foo>"' disable-output-escaping='yes'/>`
`Html.RenderAction()`                                 | n/a
`Html.RenderPartial()`                                | see [RenderPage/RenderPartial](#renderpagerenderpartial)
`Html.RouteLink()`                                    | n/a
`Html.TextArea("foo")`                                | `<a:textarea name='foo'/>`
`Html.TextAreaFor(p => p.foo)`                        | `<a:textarea for='foo'/>`
`Html.TextBox("foo")`                                 | `<a:input name='foo'/>`
`Html.TextBoxFor(p => p.foo)`                         | `<a:input for='foo'/>`
`Html.ValidationMessage("foo")`                       | `<a:validation-message name='foo'/>`
`Html.ValidationMessageFor(p => p.foo)`               | `<a:validation-message for='foo'/>`
`Html.ValidationSummary(excludePropertyErrors: true)` | `<a:validation-summary/>` (It excludes property errors by default)

RenderPage/RenderPartial
------------------------
In Razor you use `RenderPage` or `RenderPartial` to execute another page.

```csharp
@{ RenderPartial("~/_MyPartial.cshtml", new ViewDataDictionary { { "foo", "foo" } }); }
```

In XCST you use [`c:invoke-package`](../c/invoke-package.html) in conjunction with the `LoadPage` method.

```xml
<c:invoke-package package='LoadPage("~/mypartial.xcst")' package-params='new { foo = "foo" }'/>
```

`model` directive
-----------------
In a Razor view you use the `@model` directive to specify the type of the `Model` (and `ViewData.Model`) property.

```csharp
@model System.DateTime
```

In XCST you use the `model` processing instruction.

```xml
<?xml version="1.0" encoding="utf-8"?>
<?model System.DateTime ?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>
   ...
</c:module>
```

Wrapping up
-----------
Any other Razor feature you are not sure how to translate to XCST? [Let me know][5].


[2]: https://msdn.microsoft.com/en-us/library/dn961160
[3]: https://www.w3.org/TR/html5/infrastructure.html#boolean-attributes
[5]: https://github.com/maxtoroq/XCST-a/discussions
[6]: ../a/
[7]: standard-attributes.html
