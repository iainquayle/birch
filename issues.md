# issues

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
