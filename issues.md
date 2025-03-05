# issues

## functions

also will be good to add something like tail, or rec, or something to replace loops in a manner that doesnt require the user think of names for the function.
as well, something like tail forcing tail recursion would be nice for explicit optimization.

## types

## definition

## compiler

## metaprogramming

want to make both compile time and runtime metaprogramming natural if possible. 
all compiled code will be immutable unlike the reflection stupidity of other languages.
ast/asg of the code should be available at runtime, that can be used in new asg,
and a asg should be easily created at runtime.

issues with this are that, asg when using a array is harder to merge than.
ast/asg is more specific to a written code syntax, and less to a runtime graph that generates code. 
so, perhaps, make a first class ir system, that can be generated from code or built.
this ir is opinionated in the fact that it still follows the functional no side effect rules of the language.

on second thought, asg is likely the way to go, make it part of the std lib.
example of why is calling functions, or if statements, asg will be close enough to minimal,
but understable in the context of the language and calling already implemented functions that take structs etc.

need to decide how to denote compile time, and runtime compile.


## misc

remaining symbols are @, #, $ 
