# issues

## syntax 

currently the syntax of adts does not really matchup with their background construct.
products are pretty good, but sums are not as good.

- product 

```
x = ..
y = ..
p = f => f x y      # tuple takes in a function and applies tupled values to it
f = x => y => x + y # a function to use the tuple
z = p f 
```

```
..
p = {x, y}
f = {x, y} => x + y
z = p f
```

- sum

```
x = ..
s = if x > 0
    then f => g => f x
    else f => g => g x
y = s (x => x) (x => x + 1)
```

```
..
t = {
    | f i32
    | g i32
}
s = if x > 0
    then {f x}
    else {g x}
y = s {
    | f = x => x
    | g = x => x + 1
}
```
hypothetically the sum functions could just be a struct, but this would allow for a catch all, and mapping multiple cases to the same function/value.


on a more fundamental level, function calls may still be a little to hard to read,
and also leave open questions of issues in parsing. 
that being said, it is very clean, and I havent seen a parsing concern yet.

```
f = x => y => x + y
z = f 1 2
```



## blocks

it could be that blocks are imperative, and in the case of wanting mutual recursion,
follow the ocaml precedent of using the and keyword, or something that opts into mutual recursion.

the one thing this will make worse if code organization, as everything will have to be in order.

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
