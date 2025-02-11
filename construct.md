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
- Currying support
- Piping support
- Opaque generics for interface like functionality

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

Variables can be overwritten in nested scopes, but they will not leak back out.
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

### generics

generics will be a thing, but the syntax and their construction in language is not yet decided.

there will be an opaque type of generic, which will take the place of traits and typeclasses.
these will allow for the passing of types, with some functions paired that can take in that type.
once these types are passed in, their members will only be accessible by the functions, as only the functions will know what the type is.


## functions

Functions only take one argument, and return one value.
Both the use of anonymous struct typing, and haskell type currying is supported.
Typeing will be optional where inference is possible.

### overloading

not sure yet, maybe?
they are not as confusing as in other languages due to the use of structs for arguments.

### definitions

fn add: {a: u32, b: u32} -> u32 = in ->
    x = in.a + in.b
    x
or
fn add: {a: u32, b: u32} -> u32 = {a, b} ->
    x = a + b
    x
or
fn add: u32 -> u32 -> u32 = a, b ->
    x = a + b
    x

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

ideally, both compile time, and run time programming, in the native language will be supported.

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
