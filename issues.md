# issues

## variable names as data

### pros

- unifies complex types
- forces thought out naming

### cons

- doesnt really fit with data as a whole, structs are just a way to address data, actual enumerated data is data itself.
- removes flexibility
- non industry standard
- presents more of a pain regarding restricting types for functions
- causes more ambiguity, in what would be a struct type vs a struct

### sketch

```
Option: type -> type = generic =>
    {Some: generic | None: _}

f: {x: u32} -> Option <| u32 = {x} => 
    a = 1
    if x == 1 then
        {Some = a}
    else
        {None = _}

match f <| {x = 1} with
| {Some} => Some * 2
| {None} => 0


Rect: type = {x: u32 , y: u32}
transpose: Rect -> Rect = {x, y} => {x = y, y = x}
t_rect = transpose <| {x = 1, y = 2}
{x, y} = t_rect

LockedShape: type = {x: ...}
OpenShape: type = {x: ...}
Shape: type = { LockedShape | OpenShape } 

or

LockedShape: type = {LockedShape: {x: ...}}
OpenShape: type = {OpenShape: {x: ...}}
Shape: type = { LockedShape | OpenShape } 

or

locked: type = {x: ...}
open: type = {x: ...}
Shape: type = { locked | open }
LockedShape: type = {locked}
OpenShape: type = {open}
```

really everything above works fine, except for the restricting of types for functions.
since it cant be chosen when to use the name/when not to, sometime it will end up layering in more names when not necessary, or not enough.

unless matches could match on type rather than name.

## typing

make structs just a collection of named data, and its type a collection of named types.
just restrict the syntax to not allow for declared types, as it would be ambigous as of now.
{a, b} could be a type or a struct otherwise.

## blocks

it could be that blocks are imperative, and in the case of wanting mutual recursion,
follow the ocaml precedent of using the and keyword, or something that opts into mutual recursion.

the one thing this will make worse if code organization, as everything will have to be in order.

another thing it would help with would be the ordering of io operations, as it would set a clear order of operations.

## functions

also will be good to add something like tail, or rec, or something to replace loops in a manner that doesnt require the user think of names for the function.
as well, something like tail forcing tail recursion would be nice for explicit optimization.

## types

### complex type syntax

### expression restrictions

only expressions that could be restricted from type defs would be bin ops, all others need to be allowed.
dont want to have to write comptime infront of everything, and making a func that takes in a func is ambiguous.
t -> t -> t will be parsed as t -> (t -> t), and not (t -> t) -> t, thus need to allow for expressions to define the latter.

## control flow

### match expressions ambiguity 

since there is no guarenteed default case to delimit the end, nested matches could be ambigous.
likely just use parens to solve this, but non the less.

### if/guard ambiguity

### misc

figure out binding, would be nice to in conditions and matches to be able to bind variables

## init

## expressions

## definition

## compiler

## metaprogramming

want to make both compile time and runtime metaprogramming natural if possible. 
all compiled code will be immutable unlike the reflection stupidity of other languages.
ast/asg of the code should be available at runtime, that can be used in new asg,
and a asg should be easily created at runtime.

on second thought, asg is likely the way to go, make it part of the std lib.
example of why is calling functions, or if statements, asg will be close enough to minimal,
but understable in the context of the language and calling already implemented functions that take structs etc.


need to decide how to denote compile time, and runtime compile.


## misc

remaining symbols are @, #, $ 


add tail keyword and specification, or rec keyword which would allow for recursing on anon functions.

## tokens

add :=, add tail, add rec 
