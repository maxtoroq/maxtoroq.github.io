---
title: XCST Elements Reference
---

### Namespace Bindings

- c = `http://maxtoroq.github.io/XCST`
- a = `http://maxtoroq.github.io/XCST/application`

## XCST Elements

{% include_relative _ref-list-c.md %}

## Application Extension Elements

{% include_relative _ref-list-a.md %}
         
## Data Types

name                     | description
------------------------ | -----------
`string`                 | Any string
`boolean`                | One of the values `"yes"`, `"no"`, `"true"`, `"false"`, `"1"` or `"0"`.
`integer`                | An [`xsd:int`](https://www.w3.org/TR/xmlschema-2/#int)
`decimal`                | An [`xsd:decimal`](https://www.w3.org/TR/xmlschema-2/#decimal)
`qname`                  | An [`xsd:QName`](https://www.w3.org/TR/xmlschema-2/#QName)
`eqname`                 | An [`EQName`](https://www.w3.org/TR/xpath-30/#prod-xpath30-EQName)
`ncname`                 | An [`xsd:NCName`](https://www.w3.org/TR/xmlschema-2/#NCName)
`uri`                    | An [`xsd:anyURI`](https://www.w3.org/TR/xmlschema-2/#anyURI)
`nmtoken`                | An [`xsd:NMTOKEN`](https://www.w3.org/TR/xmlschema-2/#NMTOKEN)
`expression`             | A C# [`expression`]({{page.csharp_spec_url}}expressions.md#expression)
`identifier`             | A C# [`identifier`]({{page.csharp_spec_url}}lexical-structure.md#identifiers)
`type_name`              | A C# [`type_name`]({{page.csharp_spec_url}}basic-concepts.md#namespace-and-type-names)
`namespace_or_type_name` | A C# [`namespace_or_type_name`]({{page.csharp_spec_url}}basic-concepts.md#namespace-and-type-names)
`boolean_expression`     | A C# [`boolean_expression`]({{page.csharp_spec_url}}expressions.md#boolean-expressions)
`argument_list`          | A C# [`argument_list`]({{page.csharp_spec_url}}expressions.md#argument-lists)
`@T`                     | A C# expression that is implicitly castable to `T`, e.g. `@IDictionary<String, Object>`.

If a type is suffixed with an asterix (`*`) it indicates a white-space separated list of values that conform to that particular type, e.g. `cdata-section-elements='script style'`.

## Schemas

- [`http://maxtoroq.github.io/XCST`](https://github.com/maxtoroq/XCST/tree/master/schemas)
- [`http://maxtoroq.github.io/XCST/application`](https://github.com/maxtoroq/XCST-a/tree/master/schemas)
