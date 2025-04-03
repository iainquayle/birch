# issues

## products

currently products require multople fields, which is a little artificially limiting.
it could be that the instantiation of products adn product types require at least one comma,
in order to distinguish them from sum type calls with no arguments.

## parsing

## syntax 

HERE!, consider moving back to just single dot for adt access
as well, make .? and .! available for all function calls not just adt access

need to add the requirement for a comma a product to the specification.
also need to add the binary operators to the specification.

fix the parse errors in product parse,
currently it will just show no rcurly error if something isnt right in the list

add spread operator to products, could even hypothetically add them to sum blocks, ..spread | ident .....

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
