# lambda move

Moving the language to something that is more of the lambda calculus, with syntaxtic sugar for common but verbose patterns.

## church products

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
x = struct.field1
```

## church sums

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
option = { 
    some: type -> type, 
    none: _ -> type 
} => type
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
or
out = data select { 
    | some = x => x 
    | none = _ => default
}
```

# data use restrictions

would still be nice to be able to somehow restrict the use of data, so not sure what would be best for that.
can do something like named data, underlying data type is wrapped in something custom, however that is the only use for those. 
the other being, relying on structs to make some specific pattern, that atleast makes it harder to misuse the data.
an interesting idea regarding the wrapping would be some special syntax for the constructor, and the constructor must be imported to get that wrapping for use with the data.
^ this may be the best idea yet for them
but then getting the data out, it could be transparent

