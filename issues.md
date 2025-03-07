# issues

## functions

also will be good to add something like tail, or rec, or something to replace loops in a manner that doesnt require the user think of names for the function.
as well, something like tail forcing tail recursion would be nice for explicit optimization.

## types

while duck typing will be most natural, pushing towards more restrictive definition based typing can help with restrictions.

defined types may only have one f their own types passed in, in the case of anon types, this will use the as keyword to cast it.
if the type definition has not been made available, then the user wont be able to make the type without using some other function that returns data of that type.

t: Type = { ... }
{ ... } as t |> f

all that being said, the more rigid system is still not very natural compared to how the rest has fit together.
duck typing is byfar the most natural.
becuase really the type system is just checks that two types are equal, and checking equality obviously is based on values, not definitions.

## init

add spread operator, and add the singular spread to ast nodes that can use it.

## expressions

make it apparent that expressions dont need parens, except for blocks

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

## control flow

figure out binding, would be nice to in conditions and matches to be able to bind variables

## misc

remaining symbols are @, #, $ 


add tail keyword and specification, or rec keyword which would allow for recursing on anon functions.

## tokens

add :=, add tail, add rec 
