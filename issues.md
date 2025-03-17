# issues

## blocks

it could be that blocks are imperative, and in the case of wanting mutual recursion,
follow the ocaml precedent of using the and keyword, or something that opts into mutual recursion.
this would also possibly if done correctly would prevent the issue of people trying to use mutual recursion on values. 

the one thing this will make worse if code organization, as everything will have to be in order.

another thing it would help with would be the ordering of io operations, as it would set a clear order of operations.

## functions

also will be good to add something like tail, or rec, or something to replace loops in a manner that doesnt require the user think of names for the function.
as well, something like tail forcing tail recursion would be nice for explicit optimization.

## types

### complex type syntax

move towards a type system with constructors and anon complex types
ie, Type {...} or _{...}
decide on whether enums will can use predefined types, or if they will need to have their own types and constructors defined.
ie, {PredefType | ...} or {Type {} | ...}
allowing predef types would require a blank type, to show the difference between a predef type, and an inline type.
ie { Type _ | ... } vs { Type | ... }

also all complex types will now be wrapped in curls, only possible issue may be with enum variant inits, but that may not be an issue.

### expression restrictions

only expressions that could be restricted from type defs would be bin ops, all others need to be allowed.
dont want to have to write comptime infront of everything, and making a func that takes in a func is ambiguous.
t -> t -> t will be parsed as t -> (t -> t), and not (t -> t) -> t, thus need to allow for expressions to define the latter.

## control flow

### match expressions ambiguity 

since there is no guarenteed default case to delimit the end, nested matches could be ambigous.
likely just use parens to solve this, but non the less.

### if/guard ambiguity

if using a | to denote each guard in an if statement, it could be ambigous with the preceding expression.
... 
expr
| expr => ... 
the bar could merely be a binary operator, and with other binary ops in there, parsing wouldnt be reliable.

either find some other way to denote guards, or switch to if else if else.

### misc

add regular if else expressions

figure out binding, would be nice to in conditions and matches to be able to bind variables

## init

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


## misc

remaining symbols are @, #, $ 


add tail keyword and specification, or rec keyword which would allow for recursing on anon functions.

## tokens

add :=, add tail, add rec 
