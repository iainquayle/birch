# Birch

A minimalistic typed functional language, that doesnt sacrifice usability.

The overall goal of the language is to make a typed lambda calculus++,
with syntactic sugar for common patterns such as Church products/tuples, Church sums/either-or types, and other common data types.
By following the lambda calculus and keeping the language as simple as possible,
the programmer does not need to spend time considering which language construct is best, but instead on how best to solve the problem at hand.

The main points of note are:

- Immutability all the time.
- Declaration order independence all the time (probably, maybe).
- Strongly typed, with inference.
- Algebraic types.
- Anonymous types.
- No modules, only functions.
- Currying.
- Piping support.

While the general feel and syntax of the language has been mostly decided,
certain parts, smaller tweaks are still being made. 

## Primitives

Primitives are the most basic data types and are currently limited to unsigned and signed integers of varying sizes,
floats of varying sizes, and bools.
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

## Strings

Not yet decided on, still lots of work here.

## Functions

Functions only take one argument and return one value.

### Instantiation

All functions are denoted by an assignee followed by a fat arrow (`=>`).
Later, pattern matching using functions will be shown as well.

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
There may be in the future be a way to curry functions that accept product types.

```
{x} |> {x, y} => x + y
```

This returns a new function that accepts 'y'.

## Product ADT 

Products are akin to structs in other languages, and are the only way of packing multiple values. 
Ie, there are no positional tuples.
Product and product types must have at least one value, there are no empty products. 
There will be however empty product fields, which will take the place of enums in most languages.

### Instantiation

Structs are instantiated with curly braces.

```
a = 2
x = { a, b = 3 }
y = { a = 1, ..x }
```

The spread operator is shown, only one of which is allowed, and copies fields, 
although specified fields will override the copied ones.

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

Sum types switch on the underlying types, such as int, float, bool, etc.
However, they can also switch on user created types, such as products,
even hypothetically functions though this would be discouraged.

### Instantiation

Return two different types

```
if foo then {bar = 1} else {baz = 1} 
```

### Typing

```
Foo = {bar: i32} | {baz: i32}
```

### Access

Using a sum value leans on functions, which by defualt allow for pattern matching on types and values.

```
x = y |>
    | {bar} => bar * 2
    | {baz} => baz * 3
```

The syntax of matching functions is still being work on.

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

### Pattern Match

Pattern matching also makes use of functions. The syntax for which is not fully set yet

## Blocks

Blocks are a list of statements culminating in an expression.
The syntax for assignment may change a little. 

```
_ =
    x := 1;
    y: i32 = 2;
    x * y + 1
```


## Scoping

Everything is an expression except for assignments.

```
_ = (
    x = 1;
    x + 1
);
```

Variables within the same scope are declaration-order independent, although stylistically, it's best to declare them in the order they are used.
This might still be changed to be imperative, potentially disallowing mutual recursion.
This also may change to only allow recursion on assignments preceded with type or fn.

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

This is not a true bnf specification, there are ambiguities due to me being lazy.
It is also a WIP, language is still evolving.

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
- relational_expression **<** additive_expression 
- relational_expression **<=** additive_expression  
- relational_expression **>** additive_expression  
- relational_expression **>=** additive_expression  
- additive_expression 

additive_expression:
- additive_expression **+** multiplicative_expression 
- additive_expression **-** multiplicative_expression 
- multiplicative_expression 

multiplicative_expression:
- multiplicative_expression ** * ** pipe_expression 
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
- if
- block
- **(** expression **)**

### Block

block:
- statement_list expression 

This is ambiguous, as a block could return a new block. assume parsing statements first.

statement_list:
- statement
- statement statement_list

statement: //this isnt in line with typing on functions, which is problematic
- block_assignee **:=** expression 
- block_assignee **:** expression **=** expression 

block_assignee:
- identifier
- **{** block_product_assignee_list **}**

block_product_assignee_list:
- identifier
- identifier **as** identifier
- identifier **,** block_binding_list 
- identifier **as** identifier **,** block_binding_list 

### If

if:
- **if** expression **then** expression **else** expression 

### Function

function:
- function_case_list

function_case_list:
- function_case
- function_case **|** function_case_list

function_case:
- function_match **=>** expression 

function_match:
- identifier **:** function_match_binding_type function_match_binding_value 
- function_product_match 
- function_list_match 
- literal
- **(** expression **)**

function_product_match:
- **{** function_product_match_list **}**
- **{** function_product_match_list **, }**

//this needs to change
function_match_binding_type:
- epsilon
- **:** function_product_match
- **:** function_list_match
- **:** identifier 
- **:** **(** expression **)**

function_product_match_list:
- identifier product_binding_alias function_match_binding_type function_match_binding_value 
- identifier product_binding_alias function_match_binding_type function_match_binding_value **,** function_product_match_list

function_match_binding_value:
- epsilon
- **in** expression

product_binding_alias:
- epsilon
- **as** identifier

function_list_match:

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
- identifier **=** _ 

### List

array:
- **\[** array_list **\]**
- **\[** array_list, **\]**
- **\[** array_list, **..** expression **\]**

array_list:
- expression
- expression **=** expression
- expression **,** array_list 
- expression **=** expression **,** array_list

### Function Type

fun_io_types:
- identifier
- easy_parse_types 
- **(** expression **)**


### Sum Type

sum_type:
- sum_type_list

sum_type_list:
- sum_variant_types
- sum_variant_types **|** sum_type_list

sum_variant_types:
- identifier
- easy_parse_types 
- **(** expression **)**

### Easy Parse Types

easy_parse_types:
- product_type
- list_type 
- builtin_types

### Product Type

product_type:
- **{** product_type_list **}**
- **{** product_type_list **, }**

product_type_list:
- product_type_element
- product_type_element **,** product_type_list

product_type_element:
- identifier **:** expression
- identifier **:** _ 

### List Type

list_type:
- **\[** expression **;** expression **\]**
- **\[** expression **; _ \]**

### not sure yet 

comptime:
- **comptime** expression

option_type:
- expression **?**

result_type:
- expression **!** expression
