---
title: From Sandcastle HTML to Markdown
date: 2014-03-21 17:00:00 -0300
tags: [documentation, markdown, sandcastle]
---

Reference documentation is important. Whether it's a programming language, a framework, a library or a web API, you simply cannot remember or understand every detail before you start writing code. And you shouldn't, because your brain should be free working on the problem you are trying to solve instead of memorizing APIs.

So, the best kind of API documentation is the one that's right there at your fingertips. In Visual Studio it's called Intellisense. This is the most important reason to document your code, and release that documentation alongside your binaries.

Except, Intellisense can only show you so much. I bet you've clicked on 'Go to definition' to get a better sense of what you're dealing with, and to read that extra pieces of information that does not show up on Intellisense. But looking at documentation in source code form, having to expand and collapse comments, is far from ideal.

Visual Studio does offer a UI called Object Browser, which is not very good. It doesn't support all the tags that C# documentation supports. In fact, I don't think they've made any significant efforts to improve it.

Even if Object browser was good it has inherent limitations. First, you have to be at your development machine, with Visual Studio open, with the particular library you want to read about installed, to be able to use it, and that is not always the case.

For example, when your are reading more narrative documentation on the project's website, like guides or tutorials, and it talks about a particular type or method you should use to do something, you'd want to click to find more about it. Or maybe your are reading an answer on StackOverflow about how to solve a particular problem and the API to use to do it, you'd also want a link to learn about it. Not every time you are reasoning about coding you are actually coding. That's why Microsoft has MSDN.

Sandcastle
----------
The standard tool to generate an MSDN-like documentation website for your project is [Sandcastle][1]. While Sandcastle works, it's not very user friendly. Sandcastle hasn't evolved like MSDN has. Although its latest version includes the long-awaited feature of listing all of the type's members in the type's page, it still creates a lot of noise and duplicated information, like having special pages for the type's properties, methods and overloads.

Sandcastle is also not very machine friendly. It uses iframes, which makes it hard to share links, and if you navigate to a content page from Google you lose the menu. The generated HTML markup is very bad in terms of efficiency and semantics, and it puts all HTML in a single directory, you get no hierarchy.

Versioning documentation
------------------------
Maintaining documentation for a project gets harder as your project gets older and new major versions gets released. If your project gets backwards-incompatible changes then your documentation also needs such updating, yet you don't want to force users to upgrade just to have relevant documentation available. So for a while I've been thinking about versioning documentation alongside the source code. Looking for thoughts on the matter found a good answer on [Programmers][2]:

> The same way your code changes from release to release, the same way your documentation has to change. But if your docs are in a Wiki or a "Stack Exchange" like system, you cannot integrate this well into your version control system (VCS). So I strongly suggest not to separate the docs from the rest of the source tree - the docs should be versioned and tagged together with the corresponding code version.

This is exactly how I felt, so I did it. I moved all the documentation I had on the GitHub wiki to the source repository, but kept the Sandcastle-generated website for the API reference.

Markdown
--------
Markdown is one of those great features about code hosting services like GitHub and Bitbucket. Markdown is so easy to write and read, it makes it so much easier to write documentation. And you get a free UI! Both GitHub and Bitbucket transform your markdown files to HTML on the fly. You can use relative links to other markdown files, and optionally use the repository browser to navigate the documentation folder structure. And you get breadcrum navigation links so you know exactly where you stand.

And, since your documentation is versioned with your source code, you can simply use the branch/tag selector dropdown to change versions.

And if all of the above wasn't enough, GitHub has an extra feature: your documentation is now fully searchable! <span class="update"><strong>Update:</strong> You also get a mobile UI!</span>

From Sandcastle HTML to Markdown
--------------------------------
So, the next logical step was going all the way by moving my Sandcastle-generated API reference documentation to the source repository in Markdown format. Except, Sandcastle does not support Markdown.

Maybe there are Sandcastle alternatives out there that do support Markdown, and I'd love to hear about them, but I didn't go that way. Sandcastle does a lot of things right, like linking to MSDN, generating unique and descriptive file names, documenting namespaces, etc. It's a mature tool with lots of options. It's also very complex and hard to extend, at least that's my perception.

So, what I did was convert the HTML that Sandcastle produced to Markdown. This was a bit tricky, since the generated HTML is quite bad, but nothing that 600 lines of XSLT 2 couldn't solve.

So, [here it is][3]. You can find examples of the projects that use it at the end of the readme file.

[1]: https://shfb.codeplex.com/
[2]: http://programmers.stackexchange.com/a/231658/3552
[3]: {{ site.url }}/sandcastle-md/
