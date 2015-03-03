---
title: Web Pages exception in ASP.NET MVC 3 application after installing MVC 4 Beta
date: 2012-02-19 15:00:00 -0300
tags: [asp.net mvc, asp.net web pages]
---

After installing [ASP.NET MVC 4 Beta][1] I tried to run one of my MVC 3 applications and got this error:

<blockquote>
System.InvalidCastException: [A]System.Web.WebPages.Razor.Configuration.HostSection cannot be cast to [B]System.Web.WebPages.Razor.Configuration.HostSection. Type A originates from 'System.Web.WebPages.Razor, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' in the context 'Default' at location 'C:\Windows\Microsoft.Net\assembly\GAC_MSIL\System.Web.WebPages.Razor\v4.0_1.0.0.0__31bf3856ad364e35\System.Web.WebPages.Razor.dll'. Type B originates from 'System.Web.WebPages.Razor, Version=2.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' in the context 'Default' at location 'C:\Windows\Microsoft.Net\assembly\GAC_MSIL\System.Web.WebPages.Razor\v4.0_2.0.0.0__31bf3856ad364e35\System.Web.WebPages.Razor.dll'.
</blockquote>

For some reason the framework was loading version 2.0 of System.Web.WebPages.Razor.dll instead of version 1.0. To fix it I just set `webpages:Version` to 1.0 in Web.config:

```xml
<appSettings>
   <add key="webpages:Version" value="1.0"/>
</appSettings>
```

[1]: http://www.asp.net/mvc/mvc4