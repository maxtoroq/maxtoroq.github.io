---
title: About me
---

<img src="{{ site.github.owner_gravatar_url }}" style="clear: right; float: right; margin-bottom: 1em; margin-left: 1em;" width="200" height="200"/>

<h2 markdown="1">

**15+ years** programmer, architect.  
**XSLT** expert; **C#** proficient.

</h2>

Dropped out of **design school** to work at my father's IT startup <small>(remember Microsoft FrontPage?)</small>. Taught myself HTML, CSS and **XSLT** <small>(my first lang)</small>. Learned **VBScript** to do XSLT on the server <small>(remember MSXML?)</small>. Then **JScript** and eventually **C#** <small>(Visual Web Developer 2005)</small>. Used **WebForms** for a couple of years until I realized **how horrible it is** beneath its shiny appearance.

<div class="note" markdown="1">

Because VWD only supported Web Sites, I learned how to invoke `csc.exe` to create class libraries.

</div>

**C# 3** was an exciting release, it made me stick with the language. Add to that **MVC 1**, and there was hope again.  

Created **[DbExtensions](https://maxtoroq.github.io/DbExtensions/)** to simplify DB programming, still using it.  

Created **[MvcCodeRouting](https://maxtoroq.github.io/2012/09/5-reasons-why-you-should-use-mvccoderouting.html)** to simplify working with large codebases, for [improved modularity](https://maxtoroq.github.io/2013/02/aspnet-mvc-workflow-per-controller.html) and [avoid common routing issues](https://maxtoroq.github.io/2014/02/why-aspnet-mvc-routing-sucks.html).  

<div class="note" markdown="1">

I strongly believed I was on to something with MvcCodeRouting. Still found its niche of passionate users: it's a core component in [Eleflex](https://github.com/ProductionReady/Eleflex/blob/9e285d9/V3.0/Documentation/Eleflex%20V3%20Design.pdf); also mentioned in Joshua Gough's [Implementing DDD](https://docs.google.com/presentation/d/1dNRuDwVIOApuLVrdjy0cKCSL7F5gHa2ecUsnnm3cZFo/edit#slide=id.gbbed5dc7_056) talk.

</div>

After many years I decided **[I was done with MVC](https://maxtoroq.github.io/2015/06/nomvc.html)** and all its **inherent complexity**. At the same time, MVC was full of useful features, so I created **[MvcPages](https://maxtoroq.github.io/2012/11/mvcpages-aspnet-mvc-without-routes-and-controllers.html)** using Razor <small>(similar to Razor Pages in ASP.NET Core, but 5 years earlier)</small>.

Using MvcPages for a couple of years was very enjoyable and productive, but **Razor started to show its limitations**. Razor is great for what it was designed to do, but it wasn't designed to do much. **If I was to fully embrace the *pages* model I needed more than a simple template engine**. Inspired by XSLT 2 and 3, I created **[XCST](https://maxtoroq.github.io/XCST/)**.

<div class="note" markdown="1">

Packages in XCST are based on packages in XSLT 3, which was not complete at the time. Reported several bugs/suggestions to W3C, e.g. when using a package, accepted components are private by default, [thanks to me](https://lists.w3.org/Archives/Public/public-qt-comments/2016Apr/0067.html) :)

</div>

XCST is the **culmination of a decade-long search** for a sane, sensible, enjoyable and healthy language for application development, optimized for extensibility, composibility, reusability and markup.

Programming is hard because **we don't have the right tools**. Even new technologies are based on old ideas. Code is not the answer, it's the workaround. Classes is where code goes to die, where knowledge goes to waste. We spend too much time dealing with tools, writing code that gets rewritten after a couple of years. ***Declarative* is the answer**.

Get in touch
------------
Feel free to [email me](mailto:maxtoroq@gmail.com), or start a public conversation [here]({{ site.github.issues_url }}/new). You can also find me on [GitHub](https://github.com/maxtoroq) and [Stack Overflow](http://stackoverflow.com/users/39923).

If you'd like to show your appreciation you can [donate](donate.html).

Hire me
-------
[Need an XSLT expert?](/p/XSLT-Expert-for-hire.html)
