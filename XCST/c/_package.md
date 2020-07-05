## Remarks

<span id="dt-package"></span>An XCST program is called a **package**. <span id="dt-explicit-package"></span>The `c:package` element is used to create an **explicit package**. <span id="dt-implicit-package"></span>However, it's often more convenient to use [`c:module`](module.html) as an **implicit package**.

A package consists of one or more modules. Modules are linked together by means of [`c:import`](import.html) declarations. <span id="dt-principal-module"></span>The **principal module** is the module that all other modules are directly or indirectly referenced from. You can use both [`c:module`](module.html) and `c:package` as principal module, but only [`c:module`](module.html) can be imported into another module.

<span id="dt-named-package"></span>A `c:package` that uses the `name` attribute is a **named package**. Named packages can be used by other packages by means of a [`c:use-package`](use-package.html) declaration. In all other respects, [`c:module`](module.html) has the same capabilities as `c:package`.

## See Also

- [`c:module`](module.html)
