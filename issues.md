# issues

## products

currently products require multople fields, which is a little artificially limiting.
it could be that the instantiation of products adn product types require at least one comma,
in order to distinguish them from sum type calls with no arguments.

## parsing

as it stands, because of the current function calls, without delimiting the end of statements,
or making the function calls more explicit, the return value of a block is completely ambiguous.

```
x = f 1
2
```

while trying to return 2, it will parse as apply f to 1 and 2, and then assign that to x.

will likely use a semicolon to delimit statements

```
x = f 1;
2
```

or make function calls more explicit

```
x = f <| 1
2
```

HERE!!!!!
or use a single token to denote applying a function to an argument
this will make the syntax a little more apparent, and will allow for the removeal of the semicolon entirely.
this would need to be either moved to a different token from ., or move struct access to a different token.
, cannot be used and would be confusing,
and it should be a token that is easy to access, not backslash or tilde or tick.
could actuall use semicolon, though may be a little confusing,
could also move elemnt access to colon which would somewhat fall in line with other languages.
and wouldnt be too much of a pain if destructuring is mainly used...

could technically use the same token for both, they are booth in a sense.
and in some sense, a tuple can take in a function an return the associated value, which this would actually fit in line with.

```
x = f . 1 . z
2
```

or

```
x = f \ 1 \ z
2
```

one other option is to make statement blocks return the last expression using a symbol or keyword.
this would only be necessary in statement blocks.

```
x = f 1
<- 2
```

while this looks nice, it would make the sum type syntax substantially more verbose,
unless some other syntax was used for that.

one option for the sum type is to lean into requiring that it use product types for multiple arguments, instead of curried functions.
though this does not seem like a good idea.

other option is to bring in true tuples? but that does not seem necessary

## syntax 



currently there is an issue with ambiguity in the syntax of structs with single implicit field,
and sum type calls with no arguments.
options:
- require that sum types with no arguments are called with _
    likely the least consitent option
- have some other syntax for sum type calls
    this is likely the second best option, but not sure exactly how it would look.
- require that product fields are explicitly named.
    would be easy, but not follow the precident set by destructuring
- require that product types have multiple fields
    would follow the language precidents the best, but would make development more of a pain.
    likely the best option though so far.

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
x = ..
s = if x > 0
    then {f, g} => f x
    else {f, g} => g x
y = s {
    f = x => x, 
    g = x => x + 1,
}
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
