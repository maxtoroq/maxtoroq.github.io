---
title: Implementing a Delete button in ASP.NET MVC
date: 2012-08-11 18:17:00 -0400
tags: [asp.net mvc, html]
---

I've been reading the HTML 4 and 5 specs lately, more specifically about forms, and learned something new. I knew a button could have a name and value, what I didn't know is that a button is considered a successful control, which means its data is sent to the server, only if the form submission is triggered by that button. This is a cool feature that allows your server logic to know which button was clicked and perform different operations based on that. A very common scenario is implementing a delete button.

In the past I've done this in a number of ways: AJAX, a separate form, etc. Usually, people use a different POST action for delete, e.g.

```csharp
public ActionResult Edit(int id) {
   ...
}

[HttpPost]
public ActionResult Delete(int id) {
   ...
}
```

Taking advantage of the framework's support for X-HTTP-Method-Override, you can implement a delete button, on the same form, that POSTs to the same URL...

```csharp
public ActionResult Edit(int id) {
   ...
}

[HttpDelete]
public ActionResult Edit(int id, string foo) {
   ...
}
```

...like this:

```aspx-cs
@using (Html.BeginForm()) {
   <button>Save</button>
   <button name="X-HTTP-Method-Override" value="DELETE">Delete</button>
}
```

Easy, right? X-HTTP-Method-Override is sent only when you click the delete button.&nbsp;You can also include `onclick="return confirm('Are you sure?')"` for a confirmation dialog.

There's one catch though, validation. If the form is not valid it won't submit. This is rarely an issue, but it can happen if the user made some changes that leaves the form in an invalid state and then decides to delete the resource. HTML5 supports this scenario using the `formnovalidate` attribute on the button. The jQuery validation plugin doesn't seem to recognize this attribute, but you can achieve the same behavior using the `cancel` class on the button. So, this is the final version of our 100% declarative delete button:

```html
<button name="X-HTTP-Method-Override" value="DELETE" formnovalidate 
   class="cancel" onclick="return confirm('Are you sure?')">Delete</button>
```
