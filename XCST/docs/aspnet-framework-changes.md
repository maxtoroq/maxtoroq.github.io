---
title: ASP.NET Framework Changes
---
This page lists the changes made to existing features taken from ASP.NET MVC 5. It does not include completely new features. Breaking changes are in **bold**.

## HTML Helpers

- **Client validation and unobtrusive js enabled by default** [b62f94f](https://github.com/maxtoroq/XCST-a/commit/b62f94f7f117f835a33f4191f5a6fe840082238f)
- **Removed System.Data.Linq.Binary dependency (hidden helpers)** [d3a7912](https://github.com/maxtoroq/XCST-a/commit/d3a7912d4a4959c50f538a59fbcf9ec9e75ac168)
- **Merged `a:text-box` and `a:password` into `a:input`** [5bd091e](https://github.com/maxtoroq/XCST-a/commit/5bd091ead81a2e55b8f60af5d1b0656dcd1ab4bd)
- **Merged `a:drop-down-list` and `a:list-box` into `a:select`** [53e6c22](https://github.com/maxtoroq/XCST-a/commit/53e6c22b3f5e62876b4390128cab45548b75b7f2)
- **Removed `a:http-method-override`**
- **`a:select` gets selected value from metadata** [aa38519](https://github.com/maxtoroq/XCST-a/commit/aa38519525292c672093054d964e12eb39067bec)
- Auto-create IEnumerable&lt;SelectListItem> from various types [cf3d8a4](https://github.com/maxtoroq/XCST-a/commit/cf3d8a441d159cde2e25990d6b9b7cd12d81c9fc)
- `a:input`, `a:hidden`, `a:checkbox` and `a:radio` can now get value/checked from current model [30cc474](https://github.com/maxtoroq/XCST-a/commit/30cc4743e899a9325b054f4ecc15b6ee44ac39d7)
- **Excluding member errors by default on `a:validation-summary`** [14a00b5](https://github.com/maxtoroq/XCST-a/commit/14a00b56381eed57d9cf9e098010ebb1264a327d)
- **Validation helpers gets messages from config object instead of global resource** [63ec292](https://github.com/maxtoroq/XCST-a/commit/63ec2929636d16873b90aecb389bb787f26b8cb3)
- **Use built-in adapters for derived validation attributes** [AspNetLib/0168c4c](https://github.com/maxtoroq/AspNetLib/commit/0168c4cf7d390f14f0d043fb6811bffc8174245e)
- **ClientDataTypeModelValidatorProvider gets messages from config object instead of global resource** [e6053e1](https://github.com/maxtoroq/XCST-a/commit/e6053e1468f8597d375fa50d23932a698fe0b946)
- **Don't render date client validation metadata for DateTime** [36c3eb0](https://github.com/maxtoroq/XCST-a/commit/36c3eb0942da4904cb1149efc29278e41f327d33)
- Fixed [aspnet/AspNetWebStack#7](https://github.com/aspnet/AspNetWebStack/issues/7) [02e8172](https://github.com/maxtoroq/XCST-a/commit/02e8172da9f38201ba432ca5a26a6131cac1ef3f)
- **Value/ValueFor uses EditFormatString by default** [0738bbe](https://github.com/maxtoroq/XCST-a/commit/0738bbe7ff78e505f10ee28e2374953cf07b1a4a)
- **Omit `value` for `file` input** [017ad20](https://github.com/maxtoroq/XCST-a/commit/017ad20b559e73f2858e03c35740b11ada895337)
- **`a:display-text` shows display name for Enum**

### Built-in display/editor templates

- **Switched DateTime editor rendering to Rfc3339 by default (consistent with ASP.NET Core)** [67a7425](https://github.com/maxtoroq/XCST-a/commit/67a7425623f9de3333073195804f8f83f04d38d3)
- **Omit password value on Password editor template** [753fc53](https://github.com/maxtoroq/XCST-a/commit/753fc5330cba50547a818b35a44fb8fc15565334)
- EditorCssClass configuration function [dd95eb6](https://github.com/maxtoroq/XCST-a/commit/dd95eb67f0ee62c31c6385aa64b8f52de067e1fd)
- **Render `readonly` and `placeholder` attributes based on metadata** [8688489](https://github.com/maxtoroq/XCST-a/commit/868848929833254341ab1670e4dba9ea76ce7225)
- **Render display/editor label even when text is empty** [8688489](https://github.com/maxtoroq/XCST-a/commit/868848929833254341ab1670e4dba9ea76ce7225)
- Support for `a:member-template` on built-in Object display/editor template [09827ff](https://github.com/maxtoroq/XCST-a/commit/09827ff136998450f1b8c4e4aa96dd544caeb1b5#diff-d9e4a150ec2ec7025b8cfa3d93460c97)
- **Group properties on Object editor/display templates into fieldsets** [b4a90dd](https://github.com/maxtoroq/XCST-a/commit/b4a90dd6f23d7a953f95895a7396f00302db943e)
- **Removed System.Data.EntityState dependency** [d3a7912](https://github.com/maxtoroq/XCST-a/commit/d3a7912d4a4959c50f538a59fbcf9ec9e75ac168)
- **Removed Color editor template (System.Drawing dependency)** [99673eb](https://github.com/maxtoroq/XCST-a/commit/99673eb354f3f5d009a1a20b5c4f02e88546f84b)
- ModelMetadata's ShowForEdit and ShowForDisplay can now report different values [3bbf772](https://github.com/maxtoroq/XCST-a/commit/3bbf7723d26befb6e22acc2de402777d751573c1)
- Built-in DropDownList editor template [aedab4e](https://github.com/maxtoroq/XCST-a/commit/aedab4e351a26f2b3e10c93b6793acb506d1ec6f)
- Built-in ListBox editor template [cf3d8a4](https://github.com/maxtoroq/XCST-a/commit/cf3d8a441d159cde2e25990d6b9b7cd12d81c9fc)
- **Built-in Enum display/editor templates** [9ca2539](https://github.com/maxtoroq/XCST-a/commit/9ca25398f221720565d65b4d30630f849c79d551)
- **Built-in Upload editor template** [9869018](https://github.com/maxtoroq/XCST-a/commit/9869018828224a5c0f0c8c0e7eb73b831cbc3ad0)
- **Built-in ImageUrl display template** [ffbaeed](https://github.com/maxtoroq/XCST-a/commit/ffbaeed858d8562a7f1bd06cc13cdb54721f30b5)
- **Built-in HttpPostedFileBase editor template** [daaf809](https://github.com/maxtoroq/XCST-a/commit/daaf8096b888f33ac3b90db8d9df4a92cca35bd7)
 - **Show HttpPostedFileBase property on Object editor template** [66ad3bb](https://github.com/maxtoroq/XCST-a/commit/66ad3bb5fc9be45743c66cf9b8f7489208e1d7ff)
- `a:editor/a:with-options` and use DropDownList template when options are available [aedab4e](https://github.com/maxtoroq/XCST-a/commit/aedab4e351a26f2b3e10c93b6793acb506d1ec6f)
- **Stopped removing 'Model' first segment in expressions** [90de77b](https://github.com/maxtoroq/XCST-a/commit/90de77b858432520fa4a8aa9b7ffc3cd65d25e9f)

## Model binding

- **Removed System.Data.Linq.Binary dependency (model binder)** [d3a7912](https://github.com/maxtoroq/XCST-a/commit/d3a7912d4a4959c50f538a59fbcf9ec9e75ac168)
- **DefaultModelBinder gets messages from config object instead of global resource** [63ec292](https://github.com/maxtoroq/XCST-a/commit/63ec2929636d16873b90aecb389bb787f26b8cb3)
- Replaced JavaScriptSerializer with Json.NET [9a1ac0d](https://github.com/maxtoroq/XCST-a/commit/9a1ac0db954d54ecc58977a9ffe70cd428185947)
- **Removed CancellationTokenModelBinder** [29c215b](https://github.com/maxtoroq/XCST-a/commit/29c215bd3c3d013b3f0c7aaf353a85ffdbce4e56)

## Pages

- **Removed "default" as default page ("index" only)** [86a628c](https://github.com/maxtoroq/XCST-a/commit/86a628cd0717dfb912591a02cb945319c52710e5)
- **Removed display modes support** [86a628c](https://github.com/maxtoroq/XCST-a/commit/86a628cd0717dfb912591a02cb945319c52710e5)
- **Base page class references HtmlHelper instead of HtmlHelper&lt;object>**, and stopped copying ViewData on HtmlHelper&lt;TModel> [5679046](https://github.com/maxtoroq/XCST-a/commit/5679046141c0a9afe4e5028e7602cfa8e3e25435)
- Support for null path part on `Href()` [86d1fdd](https://github.com/maxtoroq/XCST-a/commit/86d1fdd3fe7e41c636fb5499bd849625f983d26c)

## Other

- **Removed everything about request validation** [b661a1f](https://github.com/maxtoroq/XCST-a/commit/b661a1fc638dfe4996c4154744d4bbdbddb41832)
- **Removed ViewContext.View (IView circular dependency)** [AspNetLib/6684e6f](https://github.com/maxtoroq/AspNetLib/commit/6684e6fd0a627e42600fce2afb131f02854ebc88)
- **Removed ViewContext.ViewBag** [d61872e](https://github.com/maxtoroq/XCST-a/commit/d61872e24e83bbf253d980bb7bce1e9112ac5926)
- **Removed static properties from HtmlHelper and moved defaults to ViewContext** [840220d](https://github.com/maxtoroq/XCST-a/commit/840220d3434b5a8269d448bc34b13002bcf277bf)
- **Removed ViewContext.Writer and constructor parameter** [840220d](https://github.com/maxtoroq/XCST-a/commit/840220d3434b5a8269d448bc34b13002bcf277bf)
- AntiForgery.TryValidate [f655872](https://github.com/maxtoroq/XCST-a/commit/f655872a5430feb5c8cd9aa954c25e6dd37458c7)
- ModelMetadata.GroupName [184cf25](https://github.com/maxtoroq/XCST-a/commit/184cf25ba5850fb6efb482002b243d9fa35702f4)
- **Merged AjaxRequestExtensions and RequestExtensions into HttpRequestExtensions** [2f5f3f4](https://github.com/maxtoroq/XCST-a/commit/2f5f3f498efa39f57fbd635e57b12751fd1f568a)
- **Simplified ControllerContext implementation**: Removed RouteData [035168a](https://github.com/maxtoroq/XCST-a/commit/035168ac1c51124583d81cd6bfd2ef4c0d8e56e5); Removed RequestContext [8cf48ac](https://github.com/maxtoroq/XCST-a/commit/8cf48acca3f6df9d8d18cb6cc6d11b087193189b)
- **Simplified ViewContext implementation**: Added constructor that accepts HttpContextBase only; Removed ViewData and TempData [a675d21](https://github.com/maxtoroq/XCST-a/commit/a675d2105a1b84c1ec8cad102068c5abbc508f77)
- **Removed HtmlHelper.RouteCollection** [166184c](https://github.com/maxtoroq/XCST-a/commit/166184c810e721683f40caba38f9c832b1eee94a)
- **Removed UrlHelper.RequestContext and UrlHelper.RouteCollection** [8e00919](https://github.com/maxtoroq/XCST-a/commit/8e009190ab7ce1c91944d151939ec058a1a1bc3c)
- **Removed FieldValidationMetadata**: Unobtrusive validation is the only client validation supported [8814ae3](https://github.com/maxtoroq/XCST-a/commit/8814ae3771f71e1cb61fc95171ca4d3565c0347c)
