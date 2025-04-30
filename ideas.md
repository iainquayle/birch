# plan

- pause current sum type work 
- get initial compilation working, or perhaps just interpretation fro the moment
- work on pattern matching syntax using function bindings, this will also include a new sum type syntax

# ideas

## with removal of | bitwise
    
now that the | bitwise operator is removed, it does open up some possibilities.
it would be possible i think possible tto remove the requirement for the {}
that being said, it wouldnt really be possible to do so in all cases without other syntax changes, 
such as the sum call, being just a function call, and it should remain in a syntax that is seperate to the regular function call.

## considerations on named data and pattern matching

while current sum type syntax is more genuine to actual sum types,
it is definitely less powerful than pattern matching in langs like elixir, haskell and ml.
so, learn from haskell and avoid purity for the sake of purity.

all functions will pattern match, but more consistent than haskell, allowing passing of pattern matching functions trivial.
```
f = 1 => ... | x => ...
```

there are two options:
- match on structure and type
    something like
    ```
    f = {ok} => ... | {err as {value, value}} => ... | {err} => ...
    ```
    - pros
        - very simple, along the lines of elixir simple
        - makes binding syntax simple
        - intuitive, except for perhaps no value fields.
    - cons
        - may get in the way of features such as struct currying, and or, struct over application
        - require some essentially hack to deal with variants that hold no data
        - will put pressure on language to adopt some strange constructs
            such as disjoint unions of structs, and units types/strange syntax for no value fields.
            though this isnt necessarily bad...
- special named data syntax
    something like 
    ```
    X::type | Y::type
    ```
    and then be able to match against them. 
    - pros
        - relitively standard
        - allow structs to simply stay as structs
    - cons
        - adds more syntax rules to the lang

## array syntax

perhaps both fixed size and dynamic arrays can use the same syntax,
obviously the fixed size ones will allow for compile time checks, and passing by value if optimal.

this will both allow for better optimization, but also unify the syntax of the two and allow easy conversion between the two.

### strings

would be nice to simplify/make strings more robust over issues in other langs.
rust, too damn many. 
elixir, graphemes vs this vs that.
