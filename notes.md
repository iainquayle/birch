# lambda move

Moving the language to something that is more of the lambda calculus, with syntaxtic sugar for common but verbose patterns.

## church encoding products

Products are akin to tuples and structs in other languages.
They are called products for the fact that they are the cartesian product of values.

They are encoded as functions that take in a function that takes in multiple arguments.

### sugar in lang

Will only use struct style syntax, not tuples.
Syntax will be following:

```
type = { field1: type1, field2: type2 }
struct = { field1 = value1, field2 = value2 }
{ field, field2 } = struct
```

## church encoding sums

Sums are similair to tagged unions.
They are an either or type of data, a disjoint union of values.

In the lambda calculus, how this effect is achieved is by passing in a function for each case which takes in the corresponding values.
While this is undoubtedly more elegant, it is also more verbose.

### without sugar

Without sugar, the syntax could get extremely verbose for more complex types, as well as being harder to read.
The one thing that could help with this may be comptime functions, however that is a longer term goal,
as well to truly make it smoother it would likely need to delve into the realm of ast manipulation/generation which is even further away.

```
x = 1
option = { some: type -> type, none: _ -> type } => type
data: option = {some, none} =>
    some <| x
out = data <| { 
    some = x => x, 
    none = _ => 0 
}
```

### sugar in lang

Will need to somehow convey that the algebraic type is more along the lines of choosing a function to call,
and not that it is some tagged data being passed out.

```
x = 1
option: type = { some: type | none: _ }
data: option = { some = x }
out = data <| { 
    | some = x => x 
    | none = _ => default
}
```

