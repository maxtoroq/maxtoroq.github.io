---
title: ASP.NET Framework Changes
---
Breaking changes are in **bold**.

## HTML Helpers

- **Client validation and unobtrusive js enabled by default** [b62f94f](https://github.com/maxtoroq/XCST-a/commit/b62f94f7f117f835a33f4191f5a6fe840082238f)
- **Excluding member errors by default on `a:validation-summary`** [14a00b5](https://github.com/maxtoroq/XCST-a/commit/14a00b56381eed57d9cf9e098010ebb1264a327d)
- **Don't render date client validation metadata for DateTime** [36c3eb0](https://github.com/maxtoroq/XCST-a/commit/36c3eb0942da4904cb1149efc29278e41f327d33)
- **Switched DateTime editor rendering to Rfc3339 by default (consistent with ASP.NET Core)** [67a7425](https://github.com/maxtoroq/XCST-a/commit/67a7425623f9de3333073195804f8f83f04d38d3)
- **AntiForgery writes to XcstWriter instead of returning string** [284f3c9](https://github.com/maxtoroq/XCST-a/commit/284f3c96a214f6df02bcf3f5eebc653d81e6b09c)
- AntiForgery.TryValidate [f655872](https://github.com/maxtoroq/XCST-a/commit/f655872a5430feb5c8cd9aa954c25e6dd37458c7)
- Support for `a:member-template` on built-in Object display/editor template [09827ff](https://github.com/maxtoroq/XCST-a/commit/09827ff136998450f1b8c4e4aa96dd544caeb1b5#diff-d9e4a150ec2ec7025b8cfa3d93460c97)
- Built-in DropDownList editor template [aedab4e](https://github.com/maxtoroq/XCST-a/commit/aedab4e351a26f2b3e10c93b6793acb506d1ec6f)
- Built-in ListBox editor template [cf3d8a4](https://github.com/maxtoroq/XCST-a/commit/cf3d8a441d159cde2e25990d6b9b7cd12d81c9fc)
- Built-in Enum display/editor templates [9ca2539](https://github.com/maxtoroq/XCST-a/commit/9ca25398f221720565d65b4d30630f849c79d551)
- Built-in Upload editor template [9869018](https://github.com/maxtoroq/XCST-a/commit/9869018828224a5c0f0c8c0e7eb73b831cbc3ad0)
- Built-in ImageUrl display template [ffbaeed](https://github.com/maxtoroq/XCST-a/commit/ffbaeed858d8562a7f1bd06cc13cdb54721f30b5)

## Pages

- Support for null path part on Href() [86d1fdd](https://github.com/maxtoroq/XCST-a/commit/86d1fdd3fe7e41c636fb5499bd849625f983d26c)

## Other

- **Removed ViewContext.View (IView) property (circular dependency)** [AspNetLib/6684e6f](https://github.com/maxtoroq/AspNetLib/commit/6684e6fd0a627e42600fce2afb131f02854ebc88)
- **Removed System.Data.Linq.Binary dependency (model binder and hidden helpers)** [d3a7912](https://github.com/maxtoroq/XCST-a/commit/d3a7912d4a4959c50f538a59fbcf9ec9e75ac168)
- **Removed System.Data.EntityState dependency (built-in Object display/editor template)** [d3a7912](https://github.com/maxtoroq/XCST-a/commit/d3a7912d4a4959c50f538a59fbcf9ec9e75ac168)
- **Use built-in adapters for derived validation attributes** [AspNetLib/0168c4c](https://github.com/maxtoroq/AspNetLib/commit/0168c4cf7d390f14f0d043fb6811bffc8174245e)
- **ClientDataTypeModelValidatorProvider gets messages from config object instead of global resource** [e6053e1](https://github.com/maxtoroq/XCST-a/commit/e6053e1468f8597d375fa50d23932a698fe0b946)
- ModelMetadata.GroupName [184cf25](https://github.com/maxtoroq/XCST-a/commit/184cf25ba5850fb6efb482002b243d9fa35702f4)
- Replaced JavaScriptSerializer with Json.NET [9a1ac0d](https://github.com/maxtoroq/XCST-a/commit/9a1ac0db954d54ecc58977a9ffe70cd428185947)
