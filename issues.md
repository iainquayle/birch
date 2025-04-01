# issues

need to set out an actual order of of ops in the language spec
logic > binary logical > cmp > add > mul > unary > call > binding/value/parens/control flow

it is likely best tto continue following this, however,
having the second expression in the call be capture more may be a nicer syntax.

this would have issues, it would cause parsing issues with product types,
which would either need to be wrapped in parens, or have a different syntax.

for the moment stick with ml style, look at other syntax options as well.

## products

currently products require multople fields, which is a little artificially limiting.
it could be that the instantiation of products adn product types require at least one comma,
in order to distinguish them from sum type calls with no arguments.

## parsing

## syntax 

## blocks

it could be that blocks are imperative, and in the case of wanting mutual recursion,
follow the ocaml precedent of using the and keyword, or something that opts into mutual recursion.

the one thing this will make worse is code organization, as everything will have to be in order.

another thing it would help with would be the ordering of io operations, as it would set a clear order of operations.

## functions

also will be good to add something like tail, or rec, or something to replace loops in a manner that doesnt require the user think of names for the function.
as well, something like tail forcing tail recursion would be nice for explicit optimization.

for polling loops, or recursions that interatct with the outside world, these would be a necessity.

## types

## control flow

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
