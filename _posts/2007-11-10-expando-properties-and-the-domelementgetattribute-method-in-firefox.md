---
title: Expando properties and the DomElement.getAttribute method in Firefox
date: 2007-11-10 00:52:50 -0400
tags: [dom, javascript]
originally_published_at: http://maxtoroq.wordpress.com/2007/11/10/expando-properties-and-the-domelementgetattribute-method-in-firefox/
comments: off
---

When working on a custom validator control with client-side script I had issues with the JavaScript code in Firefox. This is what I learnt.

ASP.NET 2.0 uses expando properties to attach additional information to validators, properties like `controltovalidate`, `errormessage`, `evaluationfunction`, etc. This is done programatically at the client, instead of just rendering invalid HTML attributes. Expando properties in JavaScript are perfectly legal. Here's an example of the generated code for two validators:

```javascript
var rutVal = document.all ? document.all["rutVal"] : document.getElementById("rutVal");
rutVal.controltovalidate = "TextBox1";
rutVal.errormessage = "RUT inválido";
rutVal.evaluationfunction = "ValidateRUT";
rutVal.required = "true";
rutVal.formatinput = "true";
var RequiredFieldValidator1 = document.all ? document.all["RequiredFieldValidator1"] : document.getElementById("RequiredFieldValidator1");
RequiredFieldValidator1.controltovalidate = "TextBox1";
RequiredFieldValidator1.errormessage = "RequiredFieldValidator";
RequiredFieldValidator1.evaluationfunction = "RequiredFieldValidatorEvaluateIsValid";
RequiredFieldValidator1.initialvalue = "";
```

To write the validation function you need to access these properties, so my first instinct was to use the getAttribute method, but this is what caused trouble in Firefox. Please pay attention to this: if the property is not part of the DOM definition for the element then getAttribute returns null. However, if the property is defined in the markup, in other words, as just another attribute, even if it makes the HTML invalid, getAttribute returns the value.

The example above matches the first case, the properties are not part of the definition for the element (validators use the `<span>` element), and these are set via code, not markup. So, how should I get the values? Easy, the object-oriented way. Just write `validator.propertyName`.

The safest practice is to try both ways. First you can try the `validator.propertyName` and if it returns null then try the getAttribute method. You can't go wrong now.
