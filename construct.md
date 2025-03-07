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

### first class ast

I would like the language moving forward to be able to neturally be able to generate and work on its own code.
The exact way in which this will be accomplished is not yet decided,
but a possibility is to make ast nodes built in types, and have syntax specific to accessing the ast at any symbol in the code.

## expressions and scope

Expressions form the base of the language, they are any chunk of code in the same scope, and can be denoted by parantheses.
Values can be declared in the expression, in any order, and there must be one return value at the end of the expression. 
( 
    x = 1
    x
)

Variables can be shadowed in nested scopes, but they will not leak back out.
(
    x = 1
    (
        x = 2
        x
    )
    x
)

## data 

Data is always immutable, and is defined by structs and algebraic types.

### structs

#### typing 

{ a: u32, b: u32 }

#### instantiation

structs are instantiated by curly braces.
b = 2
y = { b: 10, c: 3 }
s = {
    ..y,
    a: 0,
    b 
}
Shown is the spread operator, which only one of is allowed, and which will copy fields but will be overridden by specified fields.
b takes both the value and name of b.
and a is a simple field.

#### access

single element access is done by dot notation.
s.a
and destructuring is done by curly braces.
{a, b} = s

aliasing for destructuring will be done using the as keyword.
{a, b as c} = s

### algebraic types

#### typing

{ a: u32 | b: u32 }

#### instantiation

(exact syntax is not yet decided)

a = b: 1
c = d: 2

if returned from a branching expression such as if or match, the type will be inferred, as follows

if
| x == 1 -> b: 1
| _ -> d: 2

this will result in a type of 
{ b: i32 | d: i32 }

#### access

access is done by pattern matching.

match a
| b: x -> x
| d: x -> x

### arrays

#### instantiation

arrays are instantiated by square brackets, and are fixed length for the moment.
not sure whether vectors will be the mutable version, or if arrays will allow for resizing.
\[1, 2, 3\]
or
\[\]

and to get an updated array, the spread operator can be used.
\[..a, i: 0, j: 1\]
or (not sure yet, would like to diffeerniate between arrays and structs, but also the same is nice)
\[..a, i = 0, j = 1\]
Not yet sure if attempting to 

And as to whether the syntax will be supported for vectors is also not yet decided.

#### access

access is done by square brackets.
a\[0\]

### casting

casting of basic types will use the to keyword.
(how this will work exactly will be decided by decisions on function overloading)

as well, casting will be explicit.

### reinterpretation

reinterpretation will be used in the case of passing anonymous types to defined types, and will be done with the as keyword.
for it to work, the underlying types must be compatible, and the type being interpretted as must be in scope.
thus by the underlying compatibility, it cannot be used to interpret a i32 as a f32, but:
X = {a: u32}

c = {a: 1} as X
is
c: X = {a: 1}

## types 

Types are 

defined types may be pass for anonymous types of the same structure, but not vice versa.

### definitions

Types can be an alias of any type, including, primitives, structs, arrays, algebraic types, and functions.
type Int = u32
type A = {
    a: u32, 
    b: \[u32; 3\]
    e: {
        f: u32 |
        g: u32
    },
    h: u32 -> u32
}

Short hand for an option algebraic will be supported with a ? after the type.
type OptionInt = u32?
Short hand for the result type will be supported with a ! between the return type and the error type. 

## functions

Functions only take one argument, and return one value.
Both the use of anonymous struct typing, and haskell type currying is supported.
Typeing will be optional where inference is possible.

### overloading

no overloading, wont work with partial application of arguments.
this includes no overloading of operators.

### definitions

fn add: {a: u32, b: u32} -> u32 = in => in.a + in.b
or
fn add: {a: u32, b: u32} -> u32 = {a, b} => a + b
or
fn add: u32 -> u32 -> u32 = a => b => a + b 

fn sum_and_prod: {a: u32, b: u32} -> {s: u32, p: u32} = {a, b} ->
    {s: a + b, p: a * b}

### calling

not sure yet...

pipe operator with a struct,
{a: 1, b: 2} |> add
and with curried functions
1, 2 |> add

as for a more common syntax, it may be somthing like a reverse pipe instead of parens.
add <| {1, 2}
add <| 1, 2

As shown, currying in the haskell sense is supported, but as well, partial struct currying will be supported.
add_1 = add <| {a: 1}

### partial application

partial application is done by passing a struct with the fields that are to be partially applied.
this will return a function that takes the remaining fields.

obviously curried functions will work just like in haskell. 

this mechanic will allow for interface mimicking.

## control flow

if and match will be the only branching control structures. 
values will be returned from them, into the next scope up, they will not return from the function they are in.

(syntax is not final)

if
| x == 1 -> 1
| _ -> 0

match x
| 1 -> 1
| _ -> 0

match can be used as an exhastive switch and pattern matching system.
if will be specifically for boolean expressions, and will be evaluated in order.

loops while done through recursion, may have a special rec keyword to help with simple tail recursion situations to reduce boilerplate.
either that, or have an anon function that is called back to itself using perhaps self.

## organization 

scoping will be done entirely through functions, and there will be no need for modules.
likely will be that, files and folders are merely treated as functions that take no args, and return whatever is return from the file

## metaprogramming

compile time run and runtime compile metaprogramming will be supported.

compile time will be the method of choice for generics.
runtime will offer alternate avenues for interfaces though partial application will be best for a number of reasons,
and a massive benefit of runtime compile will be jit compilation targeting other compute devices such as gpus.


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
