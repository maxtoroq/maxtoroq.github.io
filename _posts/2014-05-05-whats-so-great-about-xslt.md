---
title: What's so great about XSLT
date: 2014-05-05 16:46:00 -0300
tags: [xslt]
---

I like technologies that empower me. In programming, high-level languages and libraries with declarative constructs. One such technology is XSLT. Either loved or hated, highly misunderstood, lot's of times misused, I just can't get over it. What makes XSLT so great?

Declarative programs
--------------------
In conventional languages, first you declare a function, then you call it by name[^1]. In XSLT, you don't need to name templates, templates are called for you, when the template's pattern matches. This tells us two very important things:

**1. XSLT is designed to process data**  
Aren't all languages designed to process data? I think most languages are designed to organize and expose behavior, rather than organize a program based on the data it takes as input[^2].

**2. XSLT has a default behavior**  
Which is to keep processing data until your template matches, then you can decide whether to stop or continue.

Being optimized for data makes XSLT **great for working with deep hierarchies and semi-structured content**.

XSLT is in this way similar to CSS, you simply say what you want (selectors in CSS; XPath-based patterns in XSLT) and what you want to do with it. I cannot think of a more straightforward way to program.

Composable programs
-------------------
XSLT programs are organized in modules. A module is a file with declarations (templates, functions, variables, etc.) that can import other modules.

Object-oriented languages like C# don't have modules. Instead, code is organized in classes (or types). Classes only see what the class (or base classes) define. To use other classes you have to create an instance, and optionally save it in a field or property. But this object you've just created won't see any members from the calling (or container) object. To share state and behavior you have to pass objects around using constructors or properties.

The closest thing to classes in XSLT are *modes*. Modes allow you to organize templates based on purpose, the same way classes should have a [single responsibility][1].

**Modules makes it easy to compose programs**. You don't have to worry about passing instances around to share state and behavior. The importing module can use the imported module, and vice versa. Unlike classes in most languages, you are not limited to single inheritance, you can import multiple modules.

### What about modules in VB and F#?
Modules in VB and F# are basically sealed classes with static members, which you can also do in C#. You could argue that, being a side-effect free language, modules in XSLT are also, in a way, static. The big difference is that XSLT modules are extensible, and in .NET anything static isn't.

Extensible programs
-------------------
In XSLT, **you don't have to design the extensibility of your program, you get it for free**. This is because all declarations are public and overridable by the importing module. In object-oriented languages, extensibility must be carefully and explicitly designed. Although this level of openess is sometimes not desired[^3], it's a powerful feature.

For example, take this very simple C# program:

```csharp
public class Salutator {

   public virtual string SayHello() {
      return "Hello";
   }
}
```

This is how you can use the `Salutator` class in an extensible way:

```csharp
public class SalutationProgram {

   readonly Salutator salutator;

   public SalutationProgram()
      : this(new InformalSalutator()) { }

   public SalutationProgram(Salutator salutator) {
      this.salutator = salutator;
   }

   public virtual string Main() { 
      return this.salutator.SayHello();
   }

   public class InformalSalutator : Salutator {

      public override string SayHello() {
         return "Hi";
      }
   }
}
```

`SalutationProgram` defines its own implementation of `Salutator` called `InformalSalutator`. It also defines two constructors, one for the default behavior and another that can be used to provide a different `Salutator` implementation.

Keep in mind this is the simplest example I could come up with, imagine larger more complex programs. In XSLT however:

```xslt
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:template name="say-hello">Hello</xsl:template>
   
</xsl:stylesheet>
```

The above is `salutator.xsl`, and this is how you can use it in an extensible way:

```xslt
<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:import href="salutator.xsl"/>
   
   <xsl:template name="main">
      <xsl:call-template name="say-hello"/>
   </xsl:template>

   <xsl:template name="say-hello">Hi</xsl:template>
   
</xsl:stylesheet>
```

You can see how simple it is to write XSLT code that is highly reusable, even if you didn't intend to.

**XSLT is a [structurally-typed][3] language**. You can override templates and functions by creating a new declaration with the same structure (name, type, parameters).

NULL friendly
-------------
In conventional languages, when something is null you have to work around it. For example, in Razor:

```aspx-cs
@if (Model.Message != null) {
   <div class="alert">@Model.Message</div>
}
```

In XSLT you declare a template, and if the data is absent it simply won't get called:

```xslt
<xsl:template match="message">
   <div class="alert">
      <xsl:value-of select="."/>
   </div>
</xsl:template>
```

This null-friendliness is not limited to templates. Most functions and operators won't fail if you use an empty value (XPath's equivalent to null) as argument. For example, let's say we want to remove the protocol part from a URL (take `http://example.com` and return `example.com`). In C#:

```csharp
url.Substring(url.IndexOf("://") + "://".Length)
```

If `url` is null, the above code will fail at runtime[^4]. In XSLT however:

```xslt
<xsl:value-of select="substring-after(url, '://')"/>
```

If the first argument to the `substring-after` function is empty, it returns an empty string. No runtime error and no need to work around empty values.

Conclusions
-----------
I've been thinking lately about how much of the C# I write is basically good once, and not reusable at all. This comes down to three aspects of the language: Object-oriented, stateful and nominally-typed. In constrast, XSLT is functional, stateless and structurally-typed. [Because...][4]

> The more pieces of your program are stateless, the more ways there are to put pieces together without having anything break. The power of the stateless paradigm lies not in statelessness (or purity) per se, but the ability it gives you to write powerful, reusable functions and combine them.

Add to the mix extensible modules and you get the most reusable code you could ever write.

This is by no means a complete list of everything that is great about XSLT, but is in my view what makes it such a powerful language. It's worth noting that I didn't mention XML; XSLT is great on its own, and not because of XML. In fact, I've been doing some experiments on [XSLT-style transformations in C#][5].

Maybe I'll end up writing classes so I don't have to write classes.

[^1]: Some languages have anonymous functions, but those are expressions not declarations.
[^2]: Only feature that comes to mind is overload resolution.
[^3]: Being addressed in XSLT 3.0 with the introduction of packages.
[^4]: Being addressed in C# 6 with the introduction of a [null-propagating operator][2].

[1]: http://en.wikipedia.org/wiki/Single_responsibility_principle
[2]: https://roslyn.codeplex.com/discussions/540883
[3]: http://en.wikipedia.org/wiki/Structural_type_system
[4]: http://stackoverflow.com/a/844569/39923
[5]: {{ site.url }}/NTransform/
