## Remarks

A **package** consists of one or more modules. Modules are linked together by means of [`c:import`](import.html) declarations. There are two elements that can be used to represent modules: [`c:module`](module.html) and `c:package`. But only [`c:module`](module.html) can be imported into another module. `c:package` can only be used as **principal module**.

A `c:package` that uses the `name` attribute is a **named package**. Named packages can be used by other packages by means of a [`c:use-package`](use-package.html) declaration.

## See Also

- [`c:module`](module.html)
