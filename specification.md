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
{x, y} => x + y . {x}
```

This returns a new function that accepts 'y'.

## Product ADT 

Products are akin to structs in other languages, and are the only way of packing multiple values. 
Ie, there are no positional tuples.

### Instantiation

Structs are instantiated with curly braces.

```
a = 2
x = { a, b = 3 }
y = { a = 1, ..x }
```

The spread operator is shown, only one of which is allowed, and copies fields, although specified fields will override the copied ones.

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

## Sum ADT 

### Instantiation

### Typing

### Access

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

This is not a formal specification, there are ambiguities due to me being lazy.

### Block

block:
- statement_list expression 

// Technically ambiguous, but otherwise wont have possibility for order agnostic declarations if done properly.
// May fix this in the future, but compiler parsing left to right will get this correct.

statement_list:
- statement
- statement statement_list

statement:
- assignee **=** expression 
- assignee **:** pipe **=** expression 

block_binding:
- identifier
- **{** assignee_list **}**

block_binding_list:
- identifier
- identifier **:** identifier
- identifier **,** block_binding_list 
- identifier **:** identifier **,** block_binding_list 

### If

if:
- **if** expression **then** expression **else** expression 

### Operations 

expression:
- logic_expression

logical_expression:
- logic_expression **&&** equality_expression 
- logic_expression **||** equality_expression 
- equality_expression

equality_expression:
- equality_expression **==** relational_expression 
- equality_expression **~=** relational_expression 
- relational_expression

relational_expression:
- relational_expression **<** multiplicative_expression 
- relational_expression **<=** multiplicative_expression 
- relational_expression **>** multiplicative_expression 
- relational_expression **>=** multiplicative_expression 
- additive_expression 

additive_expression:
- additive_expression **+** multiplicative_expression 
- additive_expression **-** multiplicative_expression 
- multiplicative_expression 

multiplicative_expression:
- multiplicative_expression ***** pipe_expression 
- multiplicative_expression **/** pipe_expression 
- pipe_expression 

pipe_expression:
- pipe_expression **|>** call_expression 
- call_expression

call_expression:
- call_expression **.** primary_expression 
- primary_expression

### Primary

primary_expression:
- identifier
- literal
- function
- block
- if
- **(** expression **)**

### Function

function:
- function_case_list
- **|** function_case_list

function_case_list:
- function_case
- function_case **|** function_case_list

function_case:
- function_match **=>** expression 

function_match:
- identifier function_match_binding_type function_match_binding_value 
- function_product_match
- function_list_match
- literal 
- **(** expression **)**

function_product_match:
- **{** function_product_match_list **}**
- **{** function_product_match_list **, }**

function_match_binding_type:
- epsilon
- **:** function_product_match
- **:** function_list_match
- **:** primary_expression 

function_product_match_list:
- identifier product_binding_alias function_match_binding_type function_match_binding_value 
- identifier product_binding_alias function_match_binding_type function_match_binding_value **,** function_product_match_list

function_match_binding_value:
- epsilon
- **in** expression

product_binding_alias:
- epsilon
- **as** identifier

### Products

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

### Sums

sum_type:
- sum_type_list
- **|** sum_type_list

sum_variant_types:
- primitive_type
- identifier
- block 
- if 
- call
- product_type
- list_type

Have to define this to make sure function precedence is honoured.

sum_type_list:
- sum_variant_types
- sum_variant_types **|** sum_type_list

### List

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

### hold 

comptime:
- **comptime** expression

option_type:
- expression **?**

result_type:
- expression **!** expression
