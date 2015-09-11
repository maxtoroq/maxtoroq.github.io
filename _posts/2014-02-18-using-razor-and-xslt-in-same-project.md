---
title: Using Razor and XSLT in the same project
date: 2014-02-18 16:15:00 -0300
tags: [asp.net mvc, razor, xslt]
---

I recently wrote about [Razor vs. XSLT][1], you can find good reasons to choose either one. The good thing is that you don't have to settle for one, you can use both at the same time, and that's what this post is about.

There are basically two ways to go: you can have most of your views in XSLT and some in Razor (forms would be a good reason), or you can use mostly Razor and some XSLT. This is of course no problem since ASP.NET MVC supports using multiple view engines at the same time. But, what about layouts? Does it mean we have to have a different layout file for each language? Not necessarily.

Razor view with XSLT layout
---------------------------
Let's say we have an XSLT layout like this:

```xslt
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:template match="/" name="main">
      <html>
         <head>
            <xsl:call-template name="head"/>
         </head>
         <body>
            <xsl:call-template name="content"/>
         </body>
      </html>
   </xsl:template>

   <xsl:template name="head"/>
   <xsl:template name="content"/>

</xsl:stylesheet>
```

To use it from Razor we need to:

- Use a helper stylesheet that imports the layout and injects the Razor content using `disable-output-escaping="yes"`.
- Use a helper Razor layout that renders the Razor view and passes the content as parameters to the helper stylesheet.

This is the Razor view:

```aspx-cs
@layout ~/Views/Shared/_XsltLayout.cshtml
@section head {
   <title>Razor / XSLT</title>
}

<p>This is a Razor view using an XSLT layout.</p>
```

It uses _XsltLayout.cshtml, which is the helper Razor layout:

```csharp
@{ 
   Html.RenderPartial("~/Views/Shared/_LayoutForRazor.xsl", (object)Model, new ViewDataDictionary(ViewData) { 
      { "section-head", (RenderSection("head", required: false) ?? (object)"").ToString() },
      { "section-content", RenderBody().ToString() }
   });
}
```

The helper Razor layout calls `RenderSection` and `RenderBody` and passes the result to _LayoutForRazor.xsl, which is the helper stylesheet:

```xslt
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:import href="_Layout.xsl"/>

   <xsl:param name="section-head"/>
   <xsl:param name="section-content"/>

   <xsl:template name="head">
      <xsl:value-of select="$section-head" disable-output-escaping="yes"/>
   </xsl:template>

   <xsl:template name="content">
      <xsl:value-of select="$section-content" disable-output-escaping="yes"/>
   </xsl:template>

</xsl:stylesheet>
```

The helper stylesheet imports the actual XSLT layout and injects the Razor content using `disable-output-escaping="yes"`.

XSLT view with Razor layout
---------------------------
This one is a bit trickier. Let's say we have a Razor layout like this:

```csharp
<html>
   <head>
      @RenderSection("head", required: false)
   </head>
   <body>
      @RenderBody()
   </body>
</html>
```

To use it from XSLT we need to:

- Use a helper stylesheet that can be used to render sections individually (fake XSLT layout).
- Import the helper stylesheet from the XSLT view.
- Use a helper Razor layout that uses the Razor layout and renders the XSLT view section by section.

First, we need a Razor view that uses the helper Razor layout:

```csharp
@layout ~/Views/Shared/_LayoutForXslt.cshtml
@{ 
   Page.ViewName = Path.GetFileNameWithoutExtension(VirtualPath);
}
```

_LayoutForXslt.cshtml uses the Razor layout and does the work of rendering the actual XSLT view section by section:

```csharp
@layout ~/Views/Shared/_Layout.cshtml
@{ 
   string viewName = "_" + Page.ViewName;
}
@section head {
   @{
      Html.RenderPartial(viewName, (object)Model, new ViewDataDictionary(ViewData) { 
         { "layout-section", "head" }
      });
   }
}
@{ 
   Html.RenderPartial(viewName, (object)Model, new ViewDataDictionary(ViewData) { 
      { "layout-section", "content" }
   });
}
@RenderBody()
```

This is the actual XSLT view:

```xslt
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:import href="../Shared/_RazorLayout.xsl"/>

   <xsl:template name="head">
      <title>XSLT / Razor</title>
   </xsl:template>

   <xsl:template name="content">
      <p>
         This is an XSLT view using a Razor layout.
      </p>
   </xsl:template>

</xsl:stylesheet>
```

It imports the helper stylesheet that does the job of rendering the appropriate section based on a parameter:

```xslt
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:param name="layout-section"/>

   <!-- Avoid xml declaration when sections are rendered individually -->
   <xsl:output omit-xml-declaration="yes"/>

   <xsl:template match="/" name="main">

      <xsl:choose>
         <xsl:when test="$layout-section = 'head'">
            <xsl:call-template name="head"/>
         </xsl:when>
         <xsl:when test="$layout-section = 'content'">
            <xsl:call-template name="content"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message terminate="yes">Invalid section.</xsl:message>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

   <xsl:template name="head"/>
   <xsl:template name="content"/>

</xsl:stylesheet>
```

Hope you like this.

[:emoji: Source code][2]

[1]: {{ site.url }}/2013/07/razor-vs-xslt.html
[2]: https://github.com/maxtoroq/2014-02-using-razor-and-xslt-in-same-project
