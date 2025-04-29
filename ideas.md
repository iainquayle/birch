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

## pattern matching

while pattern matching wont be in the frist version, would be smart to consider its syntax agead of time.

would be best to follow somewhat in the precedence of other langs, such as haskell and ml,
where function bindings are used for pattern matching.
the only difference, definitely dont go with the multiple function definitions.

```
f = 
| 2 => 1
| x => x
```

or 

```
f = 2 => 1 | x => x
```

there a few things to consider here though:
- syntax for sum types, especially for keeping the ability to not have to destructure the data everytime.
    ie, is ident => ... a sum match with no parameters, or is it a value. how is that decided.
- can curried functions be matched in a flat space, and if so how would that work with catch all.
    ```
    f = 
    | 2 => 1 => 0
    | x => y => y + x
    ```

In the case of haskell, supposedly, constructors/variants and bindings are ambiguous in the parse,
but will be resolved during the semantic analysis phase.
it would definitely be nice to have a syntax where that desticion can be made during the parse.
could follow something like elixir, with atoms.
while probably not exactly the same where the atom is a value, definitely follow in the sense 
of having a clearly defined syntax, just need to figure out what that would look like.
there are now a few tokens that are going unused...

perhaps for variants something like:
```
`VariantA | `VariantB: type 
```
and then the instantiation
```
`VariantB: value 
```
and then matching, idk
