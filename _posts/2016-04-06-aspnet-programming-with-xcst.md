---
title: "ASP.NET programming with XCST"
date: 2016-04-06 19:22:00 -0300
tags: [xcst, asp.net]
---

[XCST][1] is new page/view language available for ASP.NET. Just like Razor, it compiles to C#, but it offers much greater modularity, composability and extensibility. This post however won't go into much details, instead we'll jump right into building a contact form page. This will give you a quick idea about the look and feel of the language and learn some of its features.

Model
-----
The first thing we need to build a contact form page is a model that defines the fields for the form:

```xml
<c:type name='Contact'>
   <c:member name='Name' as='string' required='yes' min-length='2' max-length='50'/>
   <c:member name='Email' as='string' required='yes' max-length='255' data-type='EmailAddress' display-name='E-mail'/>
   <c:member name='Telephone' as='string' required='yes' min-length='8' max-length='20' data-type='PhoneNumber'/>
   <c:member name='Message' as='string' required='yes' max-length='2000' data-type='MultilineText'/>
</c:type>
```

The `c:type` declaration is used to define the type for our model. Although we could have done this in C# instead, `c:type` can be declared in the page right next to where it's used. Also note the validation and presentation attributes, these compile to `System.ComponentModel.DataAnnotations` attributes.

Mail template
-------------
```xml
<c:function name='MailBody' as='string'>
   <c:param name='contact' as='Contact'/>

   <c:return>
      <c:serialize method='html'>
         <a:model value='contact'>
            <dl>
               <a:display>
                  <a:member-template>
                     <dt>
                        <a:display-name/>
                        <c:text>:</c:text>
                     </dt>
                     <dd>
                        <a:display/>
                     </dd>
                  </a:member-template>
               </a:display>
            </dl>
         </a:model>
      </c:serialize>
   </c:return>
</c:function>
```

<div class="note" markdown="1">

Normally you'd put markup in a <code>c:template</code> declaration, but since the <code>MailMessage</code> class expects the mail body as a <code>string</code> we use <code>c:function</code> because it can be called directly from C# code.

</div>

The `c:serialize` instruction creates a `string` of anything defined inside of it.

The `a:model` instruction defines the model for descendant instructions. Because in MVC you get the model from the controller, there's only one model: `this.Model` (aka global model). Since this is not a view but a page, we use `a:model` to define a model, which can be used more that once in different parts of a page.

The `a:display` instruction (when it has no `name` or `for` attributes) works like `Html.DisplayForModel()` in Razor. This instruction is relative to the `a:model` we've just reviewed. Just like `Html.DisplayForModel()`, `a:display` executes a template for each of the members that are *displayable*. Additionally, `a:display` has a new feature: you can customize the template using the `a:member-template` element.

The `a:member-template` element defines a new model for its descendant instructions, which is a member (property) of the model used by `a:display`. That means descendant instructions like `a:display-name` and `a:display` work against the member and not the whole model. 

Send function
-------------
Now we can define the function that sends out the mail:

```xml
<c:function name='SendMail' as='bool'>
   <c:param name='contact' as='Contact'/>

   <c:script>
      <![CDATA[

      var message = new MailMessage {
         From = new MailAddress("noreply@example.com", this.Request.Url.Host),
         To = { contactTo },
         Subject = contactSubject,
         ReplyToList = { new MailAddress(contact.Email, contact.Name) },
         Body = MailBody(contact),
         IsBodyHtml = true
      };

      try {
         using (var smtp = new SmtpClient()) {
            smtp.Send(message);
         }
         return true;

      } catch (SmtpException) {

         this.ModelState.AddModelError("", "An unexpected error ocurred.");
         return false;
      }
      ]]>
   </c:script>
</c:function>
```

This is basically just C# inside a `c:script` instruction, which is used to put code wherever you need it. Note we are calling the `MailBody` function reviewed before.

Contact form
------------
```xml
<c:template name='content' expand-text='yes'>
   <c:param name='contact' as='Contact' required='yes' tunnel='yes'/>
   <c:param name='sent' as='bool' required='yes' tunnel='yes'/>

   <h1>{this.title}</h1>
   <a:model value='contact'>
      <c:if test='sent'>
         <div class='alert alert-success alert-dismissable'>
            <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&#215;</button>
            <c:text>Thanks for contacting us. We'll get back to you shortly.</c:text>
         </div>
      </c:if>
      <form method='post' class='form-horizontal'>
         <a:anti-forgery-token/>
         <a:validation-summary/>
         <a:editor with-params='new { labelColumnClass = "col-md-3", fieldColumnClass = "col-md-9" }'/>
         <div class='form-group'>
            <div class='col-md-offset-3 col-md-9'>
               <button type='submit' class='btn btn-primary'>Send</button>
            </div>
         </div>
      </form>
   </a:model>
</c:template>
```

So far we've defined two functions (one that calls the other) and one type used by both functions. The contact form however is defined in a `c:template` declaration. Templates are like helpers in Razor, and also serve as sections, but unlike sections it can have parameters.

This template has two parameters, one for the model and also a `bool` that indicates if the mail was sent. Both are marked as required and tunnel. I'll talk about tunnel parameters later. While function parameters are compiled to actual method parameters, template parameters are not. Template parameters are bound by name, not position, and are optional by default, unless you use `required='yes'`.

Note the heading `<h1>{this.title}</h1>`. Somewhere in the page there's a global variable named `title`, and we use string interpolation syntax to inject values in text nodes. This needs to be enabled using the `[c:]expand-text` standard attribute, to avoid conflicts with content that uses curly braces, like CSS and JavaScript.

The rest of the template should be familiar by now.

The glue
--------
```xml
<c:template name='c:initial-template'>
   <c:script>
      <![CDATA[

      var contact = new Contact();
      bool sent = false;

      if (IsPost) {

         AntiForgery.Validate();

         if (TryBind(contact)
            && SendMail(contact)) {

            sent = true;

            // clear form
            this.ModelState.Clear();
            contact = new Contact();
         }
      }
      ]]>
   </c:script>
   <c:next-template>
      <c:with-param name='contact' value='contact' tunnel='yes'/>
      <c:with-param name='sent' value='sent' tunnel='yes'/>
   </c:next-template>
</c:template>
```

`c:initial-template` is a special template that is the starting point of the program, like the `Main` method in a console app.

The code in the script is fairly simple.

The `c:next-template` instruction calls a template with the same name as the current template in an imported module. That means somewhere in the page there's a `c:import` declaration, which in this case imports the layout module. There's a lot more to say about modularity in XCST, but that's a topic for another post. The last thing to note is that the parameters passed to the next template have `tunnel='yes'`. This means basically two things: 1. The template we are calling doesn't require to have those parameters defined; 2. If the template we are calling calls other templates then those parameters are passed on, and so on. This is how we get those values to the `content` template we've defined.

Wrapping up
-----------
The complete page along with a runnable project can be found [here][2]. Questions, comments? below.

### Related Reading

- [XCST Introduction for the Razor Developer][3]

[1]: {{ site.url }}/XCST/
[2]: {{ site.github.owner_url }}/XCST-a/blob/master/samples/aspnet/contact.xcst
[3]: {{ site.url }}/XCST/docs/intro-for-razor-dev.html
