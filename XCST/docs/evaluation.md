---
title: Evaluation
---

The evaluation API starts with the `Xcst.XcstEvaluator` class, which provides a fluent interface. See the following example and the comments for guidance:

```csharp
XcstEvaluator.Using(new FooPackage()) // pass new instance of compiled package
   .WithParam("a", 5) // optionally set a global parameter
   .CallInitialTemplate() // or call a template by name
   .WithParam("b", 10) // optionally set a template parameter
   .OutputTo(Console.Out) // specify the output destination (overloads available)
   .WithParams(new OutputParameters { Indent = true }) // optionally override serialization parameters
   .Run(); // execute
```

## Evaluating from XCST

If you are evaluating from XCST, instead of using the API you can use the [`c:evaluate-package`](../c/evaluate-package.html) instruction.
