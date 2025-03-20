# essentially finalized language constructs

## overview

Very minimalistic functional language, with goals of supporting full ctr and rtc metaprogramming.
The main points of note are:

- Immutability all the time 
- Declaration order independence all the time
- Strongly typed, with inference 
- Algebraic types
- Anonymous types
- No modules, only functions
- Partial argument application 
- Piping support

The aim is for extreme simplicity, and massive maleability but safety with metaprogramming.


## scoping 

Everything is an expression except for assignments. 
Even blocks, which always culminate with an expression which is the return value.

```
_ = (
    x = 1
    x + 1
)
```

Variables in the same scope are declaration order independent, though style wise it is best to declare them in the order they are used unless.
This may still be changed to be imperative, and just not allow for mutual recursion.

```
_ = (
    x = 1 + y
    y = 2
    x + 1
)
```

Variables in nested scopes are not visible in outer scopes, and variables in outer scopes are shadowed by variables in inner scopes.

```
_ = (
    x = 1
    _ = (
        x = 2
        x
    )
    x
)
```

## control flow

### if

If is an expression, and will return a value.
They follow the if then else pattern.

```
if x == 1 then x else y
```

Haskell like guard blocks are planned, but syntax not yet decided.

As well, something akin to rusts if let, perhaps using 'is' is being considered.

### match

Match is an expression, and will return a value.
Match is exhaustive, and will return a value for every possible value of the input.

```
match x
| 1 -> 1
| 2 -> 2
| _ -> 0
```

Ranges and ors are planned, but not yet implemented.

## data and types 

Data is always immutable, and is defined by structs, arrays and algebraic types.

Everything is statically typed, however, types will be infered when possible.

### primitives

Primitives are the most basic types of data, and are currently limited to unsigned and signed integers of varying sizes,
and floats of varying sizes, and bool.
(first versions of the compiler will likely just support 32 bit ints and floats)

#### instantiation

Primitives are instantiated by their literal value.

```
1
1.0
true
```

#### typing

```
u32
i32
f32
```

### named data

#### instantiation

Data can be named, or anonymous:

```
x = 1
y = A 1
x != y
```

This facilitates algebraic types, and function use restriction.

#### typing

```
t = A: u32
```

#### access

Access is not fully decided yet, but it would be nice to syntaxtically skip needing to reference the name part of the data.
(obviously except for algebraics.)
Though this would possibly hinder the type inference system.

### structs

Structs are a collection of named data.

#### instantiation

Structs are instantiated with curly braces.

```
a = 2
x = { a, b 3 }
y = { ..x, a 1 }
```

Shown is the spread operator, which only one of is allowed, and which will copy fields but will be overridden by specified fields.

#### typing

```
t1 = {a: u32, b: i32}
```

#### access

Single element access is done by dot notation, destructuring is done by curly braces, and aliasing is done by the as keyword.

```
s.a
{a, b} = s
{a, b as c} = s
```

### algebraic types

Algebraic types are merely a union of named data, thus anonymous types cant be used in algebraic types.

#### instantiation

If two or more named datas are returned from a function, it is infered to be returning an algebraic type.

```
if x == 1 then A 1 else B 2
```

Empty named data is a thing in the language to allow for variants that hold no data.

```
A _
```

This is the only data where the data, and the type are the same.

#### typing


```
t1 = {A u32 | B i32}
```

#### access

access is done by pattern matching.

```
match x
| A y -> y
| B y -> y
```

or, for use in conditions, the is keyword will be used. (this isnt decided yet)

```
if
| a is b: x -> x
...
```

### arrays

#### instantiation

arrays are instantiated by square brackets, and are fixed. 

```
\[1, 2, 3\]
```

and to get an updated array, the spread operator can be used.

```
\[..a, i = 0, j = 1\]
```

it would be nice to support this syntax for vectors, however there is no operator overloading yet or planned, so how that would work is not yet decided.

#### typing

```
t1 = \[u32; 3\]
```

#### access

access is done by square brackets.

```
a\[0\]
```

## types 

Types are 

defined types may be pass for anonymous types of the same structure, but not vice versa.

### definitions

Types can be an alias of any type, including, primitives, structs, arrays, algebraic types, and functions.

```
Int = u32
A = {
    a: u32,
    b: \[u32; 3\]
    e: {
        f: u32 |
        g: u32
    },
    h: u32 -> u32
}
```

Short hand for an option algebraic will be supported with a ? after the type.

```
type OptionInt = u32?
```

Short hand for the result type will be supported with a ! between the return type and the error type. 

Struct type syntax may also be changed to {a: u32 & b: u32} to show that it is specifically a type.
Or struct initialization may be changed to {a = 1, b = 2} to show that it is specifically a struct.

### casting

casting of basic types will use the to keyword.
(how this will work exactly will be decided by decisions on function overloading)

as well, casting will be explicit.

### reinterpretation

reinterpretation will be used in the case of passing anonymous types to defined types, and will be done with the as keyword.
for it to work, the underlying types must be compatible, and the type being interpretted as must be in scope.
thus by the underlying compatibility, it cannot be used to interpret a i32 as a f32, but:

```
X = {a: u32}
```

```
c = {a: 1} as X
```

is

```
c: X = {a: 1}
```

## functions

Functions only take one argument, and return one value.
Both the use of anonymous struct typing, and haskell type currying is supported.
Typeing will be optional where inference is possible.

### overloading

No overloading, wont work with partial application of arguments.
This includes no overloading of operators.

### definitions

```
add: {a: u32, b: u32} -> u32 = in => in.a + in.b
```

or

```
add: {a: u32, b: u32} -> u32 = {a, b} => a + b
```

or

```
add: u32 -> u32 -> u32 = a, b => a + b 
```

The syntax for currying may change to the haskell type of all arguments seperated by commas.

### calling

pipe operator with a struct,

```
{a: 1, b: 2} |> add
```

and with curried functions

```
1, 2 |> add
```

as for a more common syntax, it may be somthing like a reverse pipe instead of parens.

```
add <| {1, 2}
add <| 1, 2
```

or, like haskell where a function is just applied to the following expressions.

### partial application

partial application is done by passing a struct with the fields that are to be partially applied.
this will return a function that takes the remaining fields.

obviously curried functions will work just like in haskell. 

this mechanic along with the regular currying will allow for interface mimicking.

## organization 

scoping will be done entirely through functions, and there will be no need for modules.
likely will be that, files and folders are merely treated as functions that take no args, and return whatever is return from the file

## metaprogramming

compile time run and runtime compile metaprogramming will be supported.

compile time will be the method of choice for generics.
runtime will offer alternate avenues for interfaces though partial application will be best for a number of reasons,
and a massive benefit of runtime compile will be jit compilation targeting other compute devices such as gpus.

### first class ast

I would like the language moving forward to be able to neturally be able to generate and work on its own code.
The exact way in which this will be accomplished is not yet decided,
but a possibility is to make ast nodes built in types, and have syntax specific to accessing the ast at any symbol in the code.

This does not mean that there will be runtime reflection, all code is immutable, but an ast can be constructed at compile time, or runtime,
and used after it has been compiled.

## side effects

anything that deals with side effects, including networking, file io, and multithreading, will likely have some special operator, or keyword or syntax to access it.
access to such things may look something like python futures, where they can be polled for completeness.
this would work well for essentially all of these operations, and would be a unified way to handle them.

### multithreading


## style guide

actual tabs for indentation, snake case for vars, camel case for functions, capital camel case for types, and screaming snake case for constants.

for function inputs, structs should be used when the order matters, or there is any ambiguity as to what an argument is.
otherwise, currying may be used.

variable names are preferred to be descriptive, and not heavily abbreviated unless the abbreviation is common.

## specification

function:
- assignee_list **=>** expression 

call:
- expression **<|** expression_list 
- expression_list **|>** expression 

if:
- **if** condition_list **| _ =>** expression

condition_list:
- **|** condition **=>** expression
- **|** condition **=>** expression condition_list

match:
- **match** expression match_list

match_list:
- **|** pattern **=>** expression
- **| _ =>** expression
- **|** pattern **=>** expression match_list

block:
- statement_list expression
- **(** expression **)**

statement_list:
- statement  
- statement statement_list

statement:
- assignee **=** expression
- assignee **:** expression **=** expression

assignee:
- identifier
- **{** assignee_list **}** 

assignee_list:
- assignee
- assignee **,** assignee_list

struct_init:
- **{** struct_list **}**

struct_init_list:
- identifier
- identifier **=** expression
- identifier **=** expression struct_list

enum_init:
- identifier **:** expression 

array_init:
- **\[** expression_list **\]**

expression_list:
- expression
- expression **,** expression_list

comptime:
- **comptime** expression

function_type:
- expression **->** expression 

struct_type:
- **{** struct_type_list **}**

struct_type_list:
- identifier **:** expression
- identifier **:** expression struct_type_list

enum_type:
- enum_type_variant **|** enum_type_variant 
- enum_type_variant **|** enum_type

enum_type_variant:
- identifier: expression
- identifier

array_type:
- **\[** expression **;** expression **\]**

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
