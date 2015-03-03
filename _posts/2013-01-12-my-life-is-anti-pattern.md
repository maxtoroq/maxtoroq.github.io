---
title: My life is an anti-pattern
date: 2013-01-12 13:50:00 -0300
tags: [culture, patterns]
---

For some reason people often look for THE solution to a particular problem, ignoring the fact that the best solution to any problem depends on its inputs. In other words, if someone asks you something there are two answers that are always correct: *I don't know* and *it depends*. These phrases probably won't help you much if you are a business man or a politician, but as programmers we should feel comfortable saying, specially the latter. Because, that IS what we do, right? Take some input, program some logic and return a result.

Yet, there are ideas some programmers put forward as THE right solution, ALWAYS. Meaning, if you're not doing it that way your code is inferior. Things like best practices, design principles, design patterns, and the worst of all, rules of thumb. The most important argument in favor of these ideas is that they are proven to work. Well, except for rules of thumb, which are just designed to work most of the time.

Proven
------
So, if something is proven it should be useful, right? It depends on your particular problem. Just because ORM, Repository, Unit of Work, LINQ to X are proven it doesn't mean they are good choices for a high traffic website, for example. So, it's the degree of utility, what you gain vs. what you lose. Proven means it works, it doesn't mean it's exactly what you need.

Anti-patterns
-------------
Not following a pattern, like fat models, thin controllers, session per request, means I'm following an anti-pattern? Of course not. It doesn't mean you are against (anti) that particular pattern, or that what you are doing instead is therefore wrong. This dualism is very common in our society: if you are not a capitalist you must be a communist, if you are not a republican you must be a democrat, and so on. It's a way for people to defend their beliefs by avoiding any reasoning. I'm not against patterns, all I'm saying is IT DEPENDS. Pattern advocates should not feel the need to defend their beliefs by calling the opposite or absence of their pattern an anti-pattern.

Endless *What if*s
------------------
What if some day you want to change ORM, or database server, or logging library? Don't use that static helper, what if you need to test that method? What if? What if?...

Well, when that day comes I'll worry about that. If it isn't a requirement today, [YAGNI][1]. Software development, specially application development, shouldn't be so focused on design decisions or making the code as politically correct as it can be. In fact, following too many patterns, specially abstraction patterns, can make your code perform worse, harder to understand, harder to maintain, etc. [Design patterns are a form of complexity][2].

All problems are unique
-----------------------
My advice to you, dear reader, is don't think about a *type* of problem, focus on what makes your problem unique, and you'll end up with the best solution.

[1]: http://en.wikipedia.org/wiki/You_ain%27t_gonna_need_it
[2]: http://www.codinghorror.com/blog/2007/07/rethinking-design-patterns.html