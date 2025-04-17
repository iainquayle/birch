# issues

## compiler

## parsing

make sure that anything that is a syntax constraint, such as only a single spread per product, be enforced in the parser.
not have it be a type checker issue.
another example, is keep the sum type call such that it seperates the ident from the rest of the call.
the one thing to keep in mind here is that as it stands, the arguments are currently defined as their own expression,
which doesnt really make sense. this needs to probably be changed in the syntax specification first and formost.

## syntax 

fix the parse errors in product parse,
currently it will just show no rcurly error if something isnt right in the list

HERE!!!
there is an option to make sum blocks more like product blocks, where you can just pass in a binding named the same as a field
this would be cool, though it would lead to an ambiguity with the product blocks
that being said, making the leading | optional would actually make this completely ambiguous.
if blocks can be entered into without using parens, then it could be that the bar seperating bindings, 
is just a bitwise or that then has a the second argument being a block expression.
three options here:
- make the leading | mandatory
- move the bitwise operators to some other syntax, perhaps look for other precedences
    this is actually backed by a few langs, haskell and ml based doesnt, older python, older lua
    haskell and ml support with specific functions
- cant remember the third option lol


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
