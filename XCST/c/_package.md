## Remarks

<span id="dt-package"></span>An XCST program is called a **package**. <span id="dt-explicit-package"></span>The `c:package` element is used to create an **explicit package**. <span id="dt-implicit-package"></span>However, it's often more convenient to use [`c:module`](module.html) as an **implicit package**.

The main difference between implicit and explicit packages is the default visibility of components. Implicit packages make named templates and modes public by default. On explicit packages all components are private by default.

A package consists of one or more modules. Modules are linked together by means of [`c:import`](import.html) declarations. <span id="dt-principal-module"></span>The **principal module** is the module that all other modules are directly or indirectly referenced from. You can use both [`c:module`](module.html) and `c:package` as principal module, but only [`c:module`](module.html) can be imported into another module.

<span id="dt-named-package"></span>A `c:package` that uses the `name` attribute is a **named package**. Named packages can be used by other packages by means of a [`c:use-package`](use-package.html) declaration.

## Scope of Package Parameters

<span id="dt-package-parameter"></span>A `c:param` whose parent is [`c:module`](module.html), `c:package` or [`c:override`](override.html) is a **package parameter**. A package parameter is also a [global variable](variable.html#dt-global-variable).

Package parameters are visible to all other components in the containing package. Package parameters have an implicit `public` visibility, which also makes them visible to components in using packages.

## Initialization of Package Parameters

Package parameters that are not required follow the same rules as global variables. See [Initialization of Variables](variable.html#initialization-of-variables).

Package parameters that use `required='yes'` are initialized before the invocation of the initial component (usually the `c:initial-template` template).

## See Also

- [`c:module`](module.html)
