---
title: "ASP.NET Routing: Regex Constraints are inneficient"
date: 2013-05-18 22:59:00 -0400
tags: [asp.net, asp.net mvc, routing]
---

There are cases where using Regex constraints makes sense and does the job. For example, for action and controller parameters. If you have a constraint like `action = "Index|About|Contact"`, that will prevent the handling, and URL generation, of non-existing actions. The framework only needs a string, from a list of valid values.

But, if the route parameter will eventually map to a type different than string, like an enum or a numeric type, then you are effectively parsing twice. For example, let's say we have a route parameter `foo`, with a constraint `\d+` that maps to an action parameter `foo` of type `Int32`:

1. If the route matches the constraints are processed (Regex parsing).
2. If the constraint passes the string value of `foo` is added to `RouteData`.
3. Before action invocation, the string value of `foo` is converted to `Int32` using `System.Convert`, which calls `Int32.Parse` (Type parsing).

Apart from the unnecessary double parsing, Regex parsing might not be 100% accurate and could match values that Type parsing will later reject.

The process makes even less sense on URL generation:

1. You pass an `Int32` value for the `foo` parameter.
2. Routing converts it to a string, to execute Regex parsing.
3. If Regex matches the URL is generated.

There's no need for Regex or any kind of parsing when I already have a value of the correct type. The problem is that the route doesn't know which type a route parameter maps to. To solve this, I came up with this `IRouteConstraint`:

```csharp
using System;
using System.Globalization;
using System.Web;
using System.Web.Routing;

public abstract class ParsingRouteConstraint : IRouteConstraint {
 
   readonly Type type;
 
   protected ParsingRouteConstraint(Type type) {
 
      if (type == null) throw new ArgumentNullException("type");
 
      this.type = type;
   }
 
   protected abstract bool TryParse(string value, IFormatProvider provider, out object result);
 
   public bool Match(HttpContextBase httpContext, Route route, string parameterName, RouteValueDictionary values, RouteDirection routeDirection) {
 
      object originalVal = values[parameterName];
 
      if (originalVal == null) {
         return true;
      }
 
      if (this.type.IsInstanceOfType(originalVal)) {
         return true;
      }
 
      string stringVal = Convert.ToString(originalVal, CultureInfo.InvariantCulture);
 
      if (stringVal.Length == 0) {
         return true;
      }
 
      object parsedVal;
 
      if (!TryParse(stringVal, CultureInfo.InvariantCulture, out parsedVal)) {
         return false;
      }
 
      if (routeDirection == RouteDirection.IncomingRequest) {
         values[parameterName] = parsedVal;
      }
 
      return true;
   }
}
```

What the above code does is:

1. If the value is null or converts to an empty string then return true, which basically says ignore this constraint. If a route parameter is not optional then routing takes care of it by rejecting null or empty values.
2. If the value is an instance of the type then return true, no need for further processing. This is usually true on URL generation and when using default values.
3. If Type parsing is successful then return true, otherwise false. Also, for incoming requests, replace the string value with the parsed value. Because the `values` parameter is an original dictionary and not a copy, this means that when `RouteDataValueProvider` is asked for a `foo` parameter of type `Int32` it will already have a value of that type and won't need to call `Int32.Parse` again.

Hope you like it.