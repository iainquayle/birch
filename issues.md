# issues

## compiler

## parsing

perhaps move the sum call to use perhaps the call list function,
then atleast it doesnt get wrapped in unecessary tuple.
also, in the case of function calls, perhaps move to using a list for arguments,
rather than the current proper repr.
just will be easier to work with

fix the parse errors in product parse,
currently it will just show no rcurly error if something isnt right in the list

## syntax 

HERE!
perhaps do infact go with typeing sum blocks as structs with functions
they need to have some type, or else them straying to far from internal consitency may cause issues
unless a move is made to matching on patterns as discussed in the ideas.

if wanting to try to elmininate the need for curly braces, few things needed:
- cant have trailing commas, or else the next expression can be confused with a block
pros:
- lighter syntax 
cons:
- above, also the braces are a good visual cue
aswell, extending this to sums, the sum call may need to be reworked?
it could be that with a sum call, if the function is not found, then it will merely be assumed as a sum call when typing.
though this itself could be problematic for good lsp experience. 
it could be that the sum call keeps the curly notation, and that since the block is moved to pattern matching, 
it gets to be freed.
the issue would then be bringing the typing syntax into line aswell.

would also be nice to allow for types for products to inlined in the binding, 
though that doesnt follow the precedent and would likely be more of a pain than really worth it.
there would then need to be two ways to define the types...

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

when it comes to assigning adts, consider allowing adts that are a sub or super set of the type to be passed in or stored.
ie 
```
foo: { a: int, b: int } = { a = 1, b = 2, c = 3 }
```
but just restrict the access to the fields that are in the type?
pros:
- allows for more flexible code
cons:
- mistakes are harder to catch

## control flow

## init

## expressions

## definition


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

remaining symbols are @, #, $, &, ^

add tail keyword and specification, or rec keyword which would allow for recursing on anon functions.

## tokens
