---
title: XCST
---

**XCST (eXtensible C-Sharp Templates)** is a language for transforming objects into XML documents. It is based on a subset of XSLT (no `apply-templates`) but using C# as expression language and data model, instead of XPath.

XCST compiles to C#. The XCST compiler transforms XCST instructions to C# statements, using the expressions contained in the instructions. Here's an example:

```xml
<ul>
   <c:for-each name='n' in='System.Linq.Enumerable.Range(1, 5)' expand-text='yes'>
      <li>{n}</li>
   </c:for-each>
</ul>
```

...which compiles to:

```csharp
WriteStartElement("ul", @""); {
   foreach (var n in System.Linq.Enumerable.Range(1, 5)) {
      WriteStartElement("li", @"");
      WriteString($@"{n}");
      WriteEndElement();
   }
}
WriteEndElement();
```

<div class="note">
Note how interpolated strings is an essential feature to support attribute and text value templates.
</div>

The generated code is compatible with `System.Xml.XmlWriter`'s API.

Here's a more complete example of an XCST module:

```xml
<?xml version="1.0" encoding="utf-8"?>
<c:module version='1.0' language='C#' xmlns:c='http://maxtoroq.github.io/XCST'>

   <c:use-functions in='System.Linq'/>

   <c:output method='html' indent='yes'/>

   <c:template name='c:initial-template' expand-text='yes'>
      <ul>
         <c:for-each name='n' in='Enumerable.Range(1, 5)'>
            <li>{n}</li>
         </c:for-each>
      </ul>
   </c:template>

</c:module>
```

XCST modules are XML files with declarations (`c:template`, `c:function`, `c:variable`, etc.) that can import other modules. Declarations are like methods, fields and classes in C#. Instructions are like statements (`if`, `foreach`, variable declarations) in C#.

Creating Nodes
--------------

### Creating Element Nodes

```xml
<c:element name='{(url != null) ? "a" : "span"}'>
   ...
</c:element>
```

### Creating Attribute Nodes

```xml
<li>
   <c:if test='isActive'>
      <c:attribute name='class'>active</c:attribute>
   </c:if>
   ...
</li>
```

### Creating Text Nodes

```xml
<c:text>This is literal text</text>
```

```xml
<c:value-of value='"This is computed text"'/>
```

You can use the `[c:]expand-text` standard attribute to enable text value templates:

```xml
<footer c:expand-text='yes'>Published on {DateTime.Now}.</footer>
```

### Creating Processing Instructions

```xml
<c:processing-instruction name='xml-stylesheet' expand-text='yes'>href='{Href("style.css")}' type='text/css'</c:processing-instruction>
<doc>
   ...
</doc>
```

Processing instructions (`<?foo ?>`) in XCST modules are ignored and not copied to the output.

###  Creating Namespace Nodes

```xml
<doc>
   <c:namespace name='xsi'>http://www.w3.org/2001/XMLSchema-instance</c:namespace>
   ...
</doc>
```

Namespace nodes in XCST modules are not copied to the output. This is different from XSLT.

### Creating Comments

```xml
<c:comment>This is a comment</c:comment>
```

Comments (`<!-- -->`) in XCST modules are ignored and not copied to the output.

Repetition
----------

### The `c:for-each` instruction

```xml
<ul>
   <c:for-each name='n' in='System.Linq.Enumerable.Range(1, 5)' expand-text='yes'>
      <c:sort order='descending'/>
      <li>{n}</li>
   </c:for-each>
</ul>
```

### The `c:iterate` instruction

While `c:for-each` supports sorting, `c:iterate` supports what in C# is known as jump statements, such as `continue` (using `c:next-iteration`) and `break` (using `c:break`).

```xml
<c:iterate name='transaction' in='transactions' expand-text='yes'>
   <c:param name='balance' value='0m'/>

   <c:variable name='newBalance' value='balance + transaction.Amount'/>
   <tr>
      <td>{transaction.Timestamp}</td>
      <td>{transaction.Amount}</td>
      <td>{newBalance}</td>
   </tr>
   <c:next-iteration>
      <c:with-param name='balance' value='newBalance'/>
   </c:next-iteration>
</c:iterate>
```

Conditional Processing
----------------------

### The `c:if` instruction

```xml
<li>
   <c:if test='isActive'>
      <c:attribute name='class'>active</c:attribute>
   </c:if>
   ...
</li>
```

### The `c:choose` instruction

```xml
<input>
   <c:choose>
      <c:when test='isDisabled'>
         <c:attribute name='disabled'>disabled</c:attribute>
      </c:when>
      <c:when test='isReadonly'>
         <c:attribute name='readonly'>readonly</c:attribute>
      </c:when>
   </c:choose>
</input>
```

### The `c:try` instruction

```xml
<c:try>
   <c:call-template name='make-the-world-a-better-place'/>
   <c:catch exception='InvalidOperationException'>
      <c:message>Houston, we have a problem</c:message>
   </c:catch>
</c:try>
```

Variables and Parameters
------------------------

### Variables

`c:variable` is both an instruction (for local variables) and a declaration (for global variables).

```xml
<c:variable name='number' value='1'/><!-- System.Int32 -->
<c:variable name='color' value='"red"'/><!-- System.String -->
<c:variable name='anotherColor'>blue</c:variable><!-- System.String -->
<c:variable name='date' value='DateTime.Today' as='DateTime'/>
```

### Parameters

Parameters can be defined for `c:module`, `c:template`, `c:function` and `c:iterate`.

```xml
<c:template name='mail-body'>
   <c:param name='contact' as='Contact' required='yes'/>
   ...
</c:template>
```

Callable Components
-------------------

### Calling Templates

```xml
<c:call-template name='mail-body'>
   <c:with-param name='contact' value='contact'/>
</c:call-template>
```

One of the most interesting features, if you are not familiar with XSLT 2.0, are tunnel parameters. From the [XSLT spec](http://www.w3.org/TR/xslt-30/#tunnel-params):

> A parameter passed to a template may be defined as a tunnel parameter. Tunnel parameters have the property that they are automatically passed on by the called template to any further templates that it calls, and so on recursively. Tunnel parameters thus allow values to be set that are accessible during an entire phase of stylesheet processing, without the need for each template that is used during that phase to be aware of the parameter.

```xml
<c:template name='c:initial-template'>
   <c:call-template name='html'>
      <c:with-param name='contact' value='new Contact()' tunnel='yes'/>
   </c:call-template>
</c:template>

<c:template name='html'>
   <html>
      <body>
         <c:call-template name='content'/>
      </body>
   </html>
</c:template>

<c:template name='content'>
   <c:param name='contact' as='Contact' tunnel='yes'/>
   ...
</c:template>
```

<div class="note">This page is Work In Progress</div>

<div style="text-align: center">
   <iframe src="/github-btn.html?user={{site.github.owner_name}}&repo=XCST&type=star&size=large" frameborder="0" scrolling="0" width="80px" height="30px"></iframe>
</div>
