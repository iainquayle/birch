# Birch

A very minimalistic functional language, with goals of supporting full CTR and RTC metaprogramming.

The overall goal of the language is to make a typed lambda calculus,
with syntactic sugar for common patterns such as booleans, Church products/tuples, Church sums/either-or types, and other common data types.
By following the lambda calculus and keeping the language as simple as possible,
the programmer does not need to spend time considering which language construct is best, but instead on how best to solve the problem at hand.

The main points of note are:

- Immutability all the time.
- Declaration order independence all the time.
- Strongly typed, with inference.
- Algebraic types.
- Anonymous types.
- No modules, only functions.
- Currying.
- Piping support.

While the general feel and syntax of the language has been mostly decided,
certain parts, such as always requiring curly braces for algebraic types, might be tweaked.

## Primitives

Primitives are the most basic data types and are currently limited to unsigned and signed integers of varying sizes, floats of varying sizes, and bools.
(First versions of the compiler will likely only support 32-bit integers and floats).

### Instantiation

Primitives are instantiated by their literal value.

```
1
1.0
true
```

### Typing

```
u32
i32
f32
bool
```

## Functions

Functions only take one argument and return one value.

### Instantiation

All functions are denoted by an assignee followed by a fat arrow (`=>`).

```
binding => expression
```

Curried functions are currently represented as a chain of function inputs and do not yet have special syntax.

```
x => y => x + y
```

### Typing

```
type -> type
```

### Calling

```
f . x
x |> f
```

Functions are first-class and are curried.
There might even be a way to curry functions that accept product types.

```
{x} => x + y
```

This returns a new function that accepts 'y'.

## Product Types/Tuples

Tuples are akin to structs in other languages.
They have named fields and represent a Church product.

Product types and data must have at least one field and at least one comma.
This differentiates them from sum types that take no arguments.

### Instantiation

Structs are instantiated with curly braces.

```
a = 2
x = { a, b = 3 }
y = { ..x, a = 1 }
```

The spread operator is shown, only one of which is allowed, and copies fields, although specified fields will override the copied ones.
Also, the syntax requires at least one comma for the moment.

### Typing

```
t = {a: u32, b: i32}
```

### Access

Single-element access right now uses double dot access, though this is likely to change.

```
s.a
```

Destructuring uses curly braces, and aliasing uses the `as` keyword.

```
{a, b} = s
{a, b as c} = s
```

This might be changed such that aliasing a field uses an `=` sign instead of the `as` keyword.
However, this might be confusing.

```
{a, c = b} = s
```

## Sum Types/Unions

Sums (Church sums) are akin to variants/tagged unions in other languages.

(These might not be implemented in the first version of the compiler.)

### Instantiation

The value returned is essentially a deferred function call.
The syntax for this is not yet fully decided.

```
if expression then {a . x . y} else {b . x}
```

### Typing

```
t = {a . types | b . types }
```

### Access

```
out = x.{
    | a = x => y => expression
    | b | c = y => expression
    | _ = expression
}
```

## Arrays

### Instantiation

Arrays are instantiated using square brackets and have a fixed size.

```
\[1, 2, 3\]
```

To get an updated array, the spread operator can be used.

```
\[..a, i = 0, j = 1\]
```

It would be nice to support this syntax for vectors; however, there is no operator overloading yet, nor is any planned, so it is undecided how that would work.

### Typing

```
t1 = \[u32; 3\]
```

### Access

Access is done using square brackets.

```
a\[0\]
```

## Named Data

It is not yet certain if this will be implemented.

The details are not decided, but it would be nice to have a way to name data and restrict it to only be used in certain functions.
Also, the syntax for this would be different.

### Instantiation

Data can be named or anonymous:

```
x = 1
y = A 1 // Not like this
x != y
```

This facilitates restricting function usage.

### Typing

```
t = A: u32
```

### Access

The access mechanism is undecided, but it would be convenient to syntactically avoid referencing the name part of the data.
This might be possible, but it could also pose an issue for type inference.


## Types

### Casting

Casting basic types will use the `to` keyword.
(How exactly this will work depends on decisions regarding function overloading).

Also, casting will be explicit.

### Reinterpretation

## Control Flow

### If

`if` is an expression and returns a value.
It follows the `if then else` pattern.

```
if x == 1 then x else y
```

### Match

There isn't a `match` expression yet, but there likely will be.

## Blocks

Blocks are a list of statements culminating in an expression.

```
_ =
    x = 1;
    y = 2;
    x + 1
;
```

Currently, statements are separated by semicolons; however, this will likely change to be less verbose.

## Scoping

Everything is an expression except for assignments.
Even blocks culminate with an expression, which serves as the return value.

```
_ = (
    x = 1;
    x + 1
);
```

Variables within the same scope are declaration-order independent, although stylistically, it's best to declare them in the order they are used.
This might still be changed to be imperative, potentially disallowing mutual recursion.

```
_ = (
    x = 1 + y;
    y = 2;
    x + 1
);
```

Variables in nested scopes are not visible in outer scopes, and variables in outer scopes are shadowed by variables in inner scopes.

```
_ = (
    x = 1;
    _ = (
        x = 2;
        x
    );
    x
);
```

## Metaprogramming

Compile-time run (CTR) and runtime compile (RTC) metaprogramming will be supported.

Compile-time metaprogramming will be the method of choice for generics.
Runtime metaprogramming will offer alternative avenues for interfaces, although partial application will likely be preferable for several reasons.
A significant benefit of runtime compilation will be JIT compilation targeting other compute devices, such as GPUs.

### First-Class AST

Ideally, the language should naturally support generating and operating on its own code.
The exact way in which this will be accomplished is not yet decided,
but one possibility is to make AST nodes built-in types, with specific syntax for accessing the AST associated with any symbol in the code.

This does not imply runtime reflection—all code is immutable—but an AST can be constructed at compile-time or runtime and used after compilation.

## Side Effects

Anything dealing with side effects (including networking, file I/O, and multithreading) will likely require a special operator, keyword, or syntax.
Accessing such features might resemble Python futures, where operations can be polled for completion.
This approach could work well for essentially all these operations, providing a unified handling mechanism.

### Multithreading


## Compiler Hints

The programmer will be able to provide hints to the compiler for possible optimizations, but likely primarily for ffi reasons such as enforcing C struct layout.
This will be a late thing if ever.

## Style Guide

Use actual tabs for indentation. Use snake_case for variables, camelCase for functions, CapitalCamelCase for types, and SCREAMING_SNAKE_CASE for constants.

For function inputs, use structs when argument order matters or ambiguity exists.
Otherwise, currying can be used.

Variable names should be descriptive and not heavily abbreviated unless the abbreviation is common.

## Specification

function:
- assignee **=>** expression

function_type:
- expression **->** expression

call:
- expression **|>** expression
- expression . expression

Call also includes accessing a field of a product type.
It will essentially be mimicking passing in a function, which retrieves a single field of a product type.

if:
- **if** expression **then** expression **else** expression

block:
- statement_list expression
- **(** expression **)**

statement_list:
- statement **;**
- statement **;** statement_list

statement:
- assignee **=** expression
- assignee **:** expression **=** expression

assignee:
- identifier
- **{** assignee_list **}**

assignee_list:
- identifier
- identifier **as** identifier
- identifier **,** assignee_list
- identifier **as** identifier **,** assignee_list

product:
- **{** product_list **}**
- **{** product_list **, }**
- **{** product_list **, ..** expression **}** 
- **{ ..** expression **}** 

product_list:
- product_element 
- product_element **,** product_list

product_element:
- identifier
- identifier **=** expression

product_type:
- **{** product_type_list **}**
- **{** product_type_list **, }**

product_type_list:
- identifier **:** expression
- identifier **:** expression **,** product_type_list

sum_call:
- { identifier }
- { identifier . expression }

Expression will be a chain of calls effectively,
and it will just be treated different than normal for code gen and analysis.

sum_functions:
- **{** sum_function_list **}**


//this absolutley requires a leading bar, so perhaps change that to optional like the trailing comma in products
sum_functions_list:
- **|** **_** **=** expression
- sum_function_identifier_list **=** expression sum_function_identifier_list  **=** expression
- sum_function_identifier_list **=** expression sum_functions_list

sum_function_identifier_list:
- **|** identifier
- **|** identifier sum_function_identifier_list

sum_type:
- **{** sum_type_list **}**

sum_type_list:
- sum_type_variant **|** sum_type_variant
- sum_type_variant **|** sum_type_list

sum_type_variant:
- identifier
- identifier **.** expression

array:
- **\[** array_list **\]**

array_list:
- expression
- expression **,** expression_list
- **..** expression
- identifier **=** expression
- **..** expression **,** array_list
- identifier **=** expression **,** array_list

array_type:
- **\[** expression **;** expression **\]**

comptime:
- **comptime** expression

option_type:
- expression **?**

result_type:
- expression **!** expression

expression:
- identifier
- primitive_literal
- primitive_type
- anything above that doesnt have to do with a list, or a statement

Too lazy to remove left recursion.
May still be some mistakes, or a couple ambiguities, and primary expressions are missing, but should be mostly correct.
