# essentially finalized language constructs

## overview

Very minimalistic functional language, with goals of supporting full ctr and rtc metaprogramming.

The overall goal of the language is to make a typed lambda calculus,
with syntaxtic sugar for the common patterns such as booleans, church products/tuples, and church sums/either or types and common data types.
By following the lambda calculus, and keeping the language as simple as possible, 
the programmer does not need to spend time considering what is the best language construct to use, but instead how best to solve the problem at hand.

The main points of note are:

- Immutability all the time 
- Declaration order independence all the time
- Strongly typed, with inference 
- Algebraic types
- Anonymous types
- No modules, only functions
- Currying
- Piping support

While the general feel and syntax of the language has been for the most part decided,
certain parts such as always requiring curly braces for algebraic types will likely be tweaked.

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
bool
```

### functions

Only take one argument and return one value.

#### instantiation

All functions are denoted by an assignee followed by a fat arrow.

```
x => expression
```

Curried functions are currently just a chain of function inputs, and do not yet have a special syntax.

```
x => y => x + y
```

May follow a haskell like syntax, which would be a litte more readable. 

```
x, y => x + y
```

#### typing

```
type -> type 
```

#### calling

Not yet decided.
There will be piping.

May do something like:

```
add 1 2
1, 2 \> add
```
Need to figure out what exactly to do with functions that dont take arguments, will they just ne treated as a value?
Will values even be treated as functions that can take in any number of arguments, but obviously only return a specific value?

All functions support currying, as well, currying over tuples will likely be supported, where a partially complete tuple can be passed in,
and a new function will be returned.

### product types/tuples

Tuples are more akin to structs in other languages,
they have named fields, and represent a church product.

#### instantiation

Structs are instantiated with curly braces.

```
a = 2
x = { a, b = 3 }
y = { ..x, a = 1 }
```

Shown is the spread operator, which only one of is allowed, and which will copy fields but will be overridden by specified fields.

#### typing

```
t = {a: u32, b: i32}
```

#### access

Single element access is done by dot notation, destructuring is done by curly braces, and aliasing is done by the as keyword.

```
s.a
{a, b} = s
{a, b as c} = s
```

### sum types/unions

Sums are more akin to algebraic types/variants/tagged unions in other languages.
They represent a church sum.

(These may not be implemented in the first version of the compiler.)

#### instantiation

The value returned is essentially a defered function call.
The syntax for this is not yet fully decided.

```
if expression then {a value} else {b value}
```

#### typing

```
t = {a: type | b: type | c: type}
```

#### access

```
out = { x 
    | a = y => expression 
    | b = y => expression 
    | _ = expression 
}
```

There will also be some syntax for conditions likely, but it is not yet decided.

```
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

### named data

This is not decided yet, but it would be nice to have a way to name data, and have it be restricted to only be used in certain functions.
Aswell the syntax for this would be different.

#### instantiation

Data can be named, or anonymous:

```
x = 1
y = A 1 //not like this
x != y
```

This facilitates function use restriction.

#### typing

```
t = A: u32
```

#### access

Access is not fully decided yet, but it would be nice to syntaxtically skip needing to reference the name part of the data.
This may be possible, but it may also be an issue for type inference.


## types 

### casting

casting of basic types will use the to keyword.
(how this will work exactly will be decided by decisions on function overloading)

as well, casting will be explicit.

### reinterpretation

## control flow

### if

If is an expression, and will return a value.
They follow the if then else pattern.

```
if x == 1 then x else y
```

Haskell like guard blocks are planned, but syntax not yet decided.

As well, something akin to rusts if let, perhaps using 'is' is being considered.

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
- assignee **=>** expression 

function_type:
- expression **->** expression 

call:
- expression_list **|>** expression 
- expression expression 

if:
- **if** expression **then** expression **else** expression 

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
- identifier
- identifier **as** identifier
- identifier **,** assignee_list
- identifier **as** identifier **,** assignee_list

product:
- **{** product_list **}**

product_list:
- identifier
- identifier **=** expression
- identifier **=** expression **,** product_list

product_type:
- **{** product_type_list **}**

product_type_list:
- identifier **:** expression
- identifier **:** expression **,** product_type_list

sum:
- { identifier sum_list }

sum_list:
- expression
- expression sum_list

sum_call:
- **{** expression sum_call_list **}**

sum_call_list:
- **|** **_** **=** expression
- **|** identifier **=** expression **|** identifier **=** expression  
- **|** identifier **=** expression sum_call_list

sum_type:
- **{** sum_type_list **}**

sum_type_list:
- identifier **:** expression **|** identifier **:** expression
- identifier **:** expression **|** sum_type_list 

array:
- **\[** array_list **\]**

array_list:
- expression
- expression **,** expression_list

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
