---
title: "CSS design patterns: Helper classes"
date: 2008-08-17 03:38:21 -0400
tags: [css]
originally_published_at: http://maxtoroq.wordpress.com/2008/08/17/css-design-patterns-helper-classes/
comments: off
---

CSS can be one of the most frustrating technologies in web development. Things like browser inconsistencies/hacks, quirks/standards modes, conditional comments, etc. are things I wish I didn't have to worry about. To make things even worse, CSS lacks of one of the most fundamental features in any language: variables. Is it possible to write reusable CSS?

Helper classes are reusable rules that use class selectors (sometimes combined with type/ID selectors). Helper classes are designed to let you:

1. **Apply style to an element without having to create a special rule for that element**: This means you can write less CSS. You can apply multiple helper classes to an element, as opposed to creating a special class and declare multiple properties in it.
2. **Abstract away browser inconsistencies**: One helper class can declare multiple properties that have the same effect, but target different browsers.
3. **Make documents more style readable**: In server-side programming we are concerned to write readable programs, so by reading the code we can easily understand the program's behaviour. When using helper classes in a document, by reading the code you should easily visualise it's appearance. The class name should describe the effect of the rule, in other words, by knowing the class name we should have a solid idea of what the element will look like when that rule is applied.

### Example 1: Combining rules
Given the following rules:

```css
.underline { text-decoration: underline; }
.highlight { background-color: #ffc; }
```

...here is an example of how you can combine multiple rules by applying multiple classes to an element. As you can see it's very easy to visualise how the element will render by reading the classes names.

```html
<span class="underline highlight">very important text</a>
```

### Example 2: Abstracting away browser inconsistencies

```css
.block { display: block; }
.inline-block { display: -moz-inline-box; display: inline-block; }
```

The `.block` class is useful when you need an inline element to behave like a block element, can be applied to `<span>`, `<a>`, `<label>`, etc. The `.inline-block` class shows how we can use helper classes to handle different browsers.

### Example 3: Powerful selectors

```css
.float_r { float: right; }
p img.float_r { margin-left: 0.5em; }
```

I like the second rule very much, because it shows how helper classes can help us write more powerful CSS. This rule is not a helper class, but takes advantage of helper classes, it says: for all images that are inside paragraphs and that are floating to the right, apply a 0.5em margin on the left, so there is a space between the image and the paragraph's  text.

By using helper classes we are basically tagging the elements with style information that, as opposed with inline styling, it's not actually implemented. The last example looks very similar to an attribute selector, like `input[type="text"]`, which is almost the same as an XPath query with a predicate. In essence all selectors are queries against the document's structure and/or user-defined class names. If you use class names that describe a particular style then you can query against the document's style.

### Further reading

- [CSS Reusable Classes][1]
- [Multiple CSS Classes][2]
- [CSS Continued… Part 2:Reduce, Reuse, Recycle][3]

[1]: http://www.mattvarone.com/2008/07/css-reusable-classes/
[2]: http://www.realmacsoftware.com/webshed/index_files/multiple-css-classes.php
[3]: http://www.aprilholle.com/technology-reviews/css-continued-part-2reduce-reuse-recycle/
