
## Data Types

These types are used to specify the allowed values of attributes.

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
`token`                  | An [`xsd:token`](https://www.w3.org/TR/xmlschema-2/#token)
`expression`             | A C# [`expression`]({{page.csharp_spec_url}}expressions.md#expression)
`identifier`             | A C# [`identifier`]({{page.csharp_spec_url}}lexical-structure.md#identifiers)
`type_name`              | A C# [`type_name`]({{page.csharp_spec_url}}basic-concepts.md#namespace-and-type-names)
`namespace_name`         | A C# [`namespace_name`]({{page.csharp_spec_url}}basic-concepts.md#namespace-and-type-names)
`boolean_expression`     | A C# [`boolean_expression`]({{page.csharp_spec_url}}expressions.md#boolean-expressions)
`lambda_expression`      | A C# [`lambda_expression`]({{page.csharp_spec_url}}expressions.md#anonymous-function-expressions)
`unary_expression`       | A C# [`unary_expression`]({{page.csharp_spec_url}}expressions.md#unary-operators)
`statement_expression`   | A C# [`statement_expression`]({{page.csharp_spec_url}}statements.md#expression-statements)

If a type is suffixed with an asterix (e.g. `cdata-section-elements = eqname*`) it indicates a whitespace separated list of values that conform to that particular type, e.g. `cdata-section-elements='script style'`.

## Reserved Namespaces

The XCST namespace `http://maxtoroq.github.io/XCST` and any other namespace that starts with `http://maxtoroq.github.io/XCST/` (note the trailing slash) are **reserved namespaces**. In general, reserved namespaces cannot be used to name [`c:template`](template.html), [`c:attribute-set`](attribute-set.html) and [`c:output`](output.html) declarations, see the documentation for these elements for more information.
