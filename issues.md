# issues

## compiler

standardize the position of rest, position or vice versa.
move results to a {:ok, data}
make parsing errors more accurate, ie add positions, move to {:error, data}

make sure that tokens retain positional data, or ast nodes have good enough positional data added.

make list parse work on lists that dont have any elements, ie, always return a list


## parsing


## syntax 

fix bindings lol, sub destructures will need to be field as {...}

## blocks

could make it that normal bindings imperative,
and then preface functions and types that should allow for mutual recursion with a keyword.
either use something like rec, or type and fn?

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
- kind of more in line with the allowance of currying over tuples
cons:
- could make mistakes harder to catch 

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

remaining symbols are @, #, $, &, ^, ;, \\, `,

add tail keyword and specification, or rec keyword which would allow for recursing on anon functions.

## tokens
