---
title: Microsoft frameworks deprecation
date: 2015-05-12 01:46:00 -0300
tags: [.net]
---

One thing I liked about .NET was its stability. Breaking API changes were not allowed. Breaking changes in behaviour were rare. I talk in past tense because today Microsoft doesn't include new libraries and frameworks in the .NET BCL. New stuff is distributed as NuGet packages. And in .NET Core, all of the BCL will become NuGet packages.

With the introduction of NuGet as a distribution mechanism, Microsoft is adopting [Semantic Versioning][1]. This means breaking changes [are allowed][2]:

> Per semantic versioning, breaking API changes and removal of features is a permissible (and inevitable) part of major releases.

So, not only breaking changes in API or behaviour, but removal of features.

## Removal of big features

In Entity Framework 7, [DbContext completely replaces ObjectContext][3]:

> EF4.1 introduced the DbContext API, which was much more focused on typical EF usage. Underneath, it still relied on the original ObjectContext that provides database interaction, manages transactions and tracks the state of objects. Since then, DbContext has become the default class to use and you’d dip down to the lower-level APIs if you wanted to do a rare interaction with the ObjectContext. EF7 will shed the obese ObjectContext; only the DbContext will remain. But some of those tasks you’ve relied on the ObjectContext for will still be accessible.

Removal of big features represent a change in direction or philosophy of a framework:

> When Entity Framework began life, it’s charter was more to do with the Entity Data Model vision rather than being a best-of-breed O/RM. As a result, there are many seldom used features and capabilities in the code base that hamper performance and complicate development, but are not feasible to remove due to the monolithic nature of the implementation.

## Removal of small features

Sometimes small features are removed for no good reason. Take this [bug report][4]:

> `@layout "....."` is equivalent to doing:
>
> ```text
> @{
>     Layout = "...."
> }
> ```
>
> And is for the most part not used in Razor. We should remove it due to its limited capability.

It does too little, rarely anyone uses it. Good reasons to remove a feature? I use it.

**Update:** Here's [another one][6]:

> We no longer support `[Authorize(Users="")]`.
>
> You should migrate to role based authorization, or implement your own authorization policy which authorizes based on user names.

Roles is an overkill for small businesses.

## Deprecation of complete products

When Microsoft announced project *Astoria* I was very interested. I thought it was innovative, and mixed various technologies I was interested in, such as HTTP and Atom. But sometimes when you innovate you don't know if you have the correct direction or focus. A specification was born from this project, called *OData*, which gave the project more credibility and acceptance. Then Microsoft decided to [abandon WCF Data Services in favor of WebApi][5]:

> Microsoft last week announced it will shift its OData-related development tool efforts from WCF Data Services to ASP.NET Web API, moving WCF Data Services to open source for further development. That angered many frontline developers whose teams or companies have invested a lot of work in WCF Data Services and now feel abandoned.

## Complete rewrites

Microsoft also adopted a new kind of deprecation, which is to create a new library/framework/package and deprecate the old one. A good thing about the NuGet gallery is its data preservation policy, the old package will always be there if you need it. But new features will only go into the new packages, and new tooling will most likely drop support for old packages, practically forcing you to upgrade at some point.

An example is ASP.NET MVC. There are now three different codebases for this framework: *System.Web.Mvc* (for sites), *System.Web.Http* (for services) and *Microsoft.AspNet.Mvc* (for sites and services). The first version of System.Web.Mvc was released 6 years ago (March 2009) and the first version of System.Web.Http less than 3 years ago (August 2012).

Complete rewrites are sometimes necessary, but a three year old deprecated framework is too short-lived for anyone to depend on.

## Naming and versioning

Should a new codebase be version 1 or +1? If you are removing features and rewriting the API, is it really the same product? If you stick with the same name and use +1 version you could create a naming hell. This is what I think it's happening with ASP.NET 5.

In the beginning, *ASP.NET* was a runtime and an application framework based on server controls and view state. Later, extensions to ASP.NET were released, such as *ASP.NET AJAX* and *ASP.NET Dynamic Data*.

When MVC was released ASP.NET was now the runtime only and the frameworks were *ASP.NET WebForms* and *ASP.NET MVC*. Later, *ASP.NET Web Pages* was added, which is too generic of a name. After all, what are .aspx pages if not web pages?

When WebApi was released, ASP.NET became was just a brand, because *ASP.NET Web API* did not depend on the old runtime, so it was necesary to make a distinction between old runtime, now refered to simply as *System.Web*, and the new frameworks.

Now we have *ASP.NET 5*, which includes MVC 6 and runs on .NET 4.6. ASP.NET versions no longer match the .NET version, so even though ASP.NET 5 contains the characters ".NET 5", it has nothing to do with .NET 5. I wonder what we'll call WebForms on .NET 5, maybe *ASP.NET WebForms 5*? (not to be confused with ASP.NET 5).

This is why I don't like to call myself an ASP.NET developer anymore, it has lost all meaning. Maybe for some people an ASP.NET developer is someone who adopts anything that Microsoft puts out under the ASP.NET name, but that's not me.

## Conclusions

There's a common trend to the cases presented in this post: Microsoft has shifted .NET's focus from Windows to " the cloud" (code for *Azure*). If you don't care about Azure then there's nothing really exciting in all these changes.

In the end it's your responsibility to choose frameworks wisely. If Microsoft frameworks are unstable is because Microsoft itself is unstable. If they're not making money from these frameworks, or depending heavily on them, then nothing stops Microsoft from making breaking changes, even if that affects you.

If you ask me, frameworks don't need to be perfect, support every use case, or please everyone. Frameworks can be boring but useful. **Frameworks need stability**. Being a .NET developer has taught me not to depend on frameworks too much.

[1]: http://semver.org/
[2]: http://blogs.msdn.com/b/adonet/archive/2014/10/27/ef7-v1-or-v7.aspx
[3]: https://msdn.microsoft.com/en-us/magazine/dn890367.aspx
[4]: https://github.com/aspnet/Razor/issues/359
[5]: https://visualstudiomagazine.com/blogs/data-driver/2014/04/wcf-data-services-and-odata.aspx
[6]: https://github.com/aspnet/Announcements/issues/21
