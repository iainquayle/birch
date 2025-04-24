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

while the current adt syntax is pretty nice, and it matches very well with what the actual underlying construct is,
the pattern matching syntax in langs such as elxir, haskel, and ml, are definitely more powerful.

so this raises the question of whether we should depart from the current adt syntax, 
or, continue with the current plan which would be to add in pattern matching later and have it more restricted to primitive types.
or, some third route where pattern matching is added, but it encompasses all, and the current sum block syntax is left as is.


DONT stray too far from internal consitency. 
perhaps along the lines of allowing booleans to be functions,
perhaps have the sum call be a function, but if proper pattern matching is added,
like with the if precedence, have some ducplicated functionality.
PROBABLY, best of all is just get the first version done, and then start thinking about fine tuning it.


options:
- add pattern matching that covers current adt syntax
    pros:
    - more powerful
    - more consistent with other langs
    - could integrate idea of named data once again with sum types
    cons:
    - more complex to implement
    - shifts away from true adts
- keep current adt syntax and add pattern matching later
    pros:
    - simpler to implement
    - more internally consistent
    - keeps adts as true adts
    cons:
    - less powerful
    - less consistent with other langs

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
