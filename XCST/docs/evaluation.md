---
title: Evaluation
---

## API

The evaluation API starts with the `Xcst.XcstEvaluator` class, which provides a fluent interface. See the following example and the comments for guidance:

```csharp
// pass new instance of compiled package
XcstEvaluator.Using(new FooPackage())
   
   // optionally set a global parameter
   .WithParam("a", 5)
   
   // call initial template (or CallTemplate("bar"))
   .CallInitialTemplate()
   
   // optionally set a template parameter
   .WithParam("b", 10)
   
   // specify the output destination (overloads available)
   .OutputTo(Console.Out) 
   
   // optionally override serialization parameters
   .WithParams(new OutputParameters { Indent = true }) 
   
   // execute
   .Run();
```

## Evaluating from XCST

If you are evaluating from XCST, instead of using the API you can use the [`c:evaluate-package`](../c/evaluate-package.html) instruction.
