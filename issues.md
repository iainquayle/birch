# issues

## order of evaluation

* procedural
    
    top to bottom, left to right. very natural.
    this would to be natural to use, require a module system, 

* functional/declaritive

    everything is implicitly declared, more along the lines of haskell, where you can have a where clause that is lazily evaluated.
    while this would be more foreign, it would consolidate the need for modules, vs just having functions which are used for scoping.
    and, people could write this in a procedural manner, it would change anything.
    then, there would just need to be a singular return point, which can be branching through ifs and matches.

## definition

### generics

how to implement opaque generics

where do generics come in, and would it perhaps be something that would just be covered by possible macros?
would be nice in any case to not need angle braces for generics... or perhaps there some other delimiter that wont cause trivial undecidability issues in the lexer...

## compiler

