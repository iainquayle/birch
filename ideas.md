# plan

- get initial compilation working, or perhaps just interpretation fro the moment
- implement pattern matching ideas into definition and update general guide
- implement pattern matching syntax into parser, consider how underlying system will work.

# ideas

## blocks

to deal with the type expressions issue, all that needs to be done is make the : necessary
var: type_expr = expr
or 
var: = expr
or
var: _ = expr
makes it so that block can now be a primary expr at the bottom again

## scoping struct members

perhaps members can be declared to only be visible based on blocks?
ie, if a member is somehow declared private, it can only be accessed by sibling expressions in a block.
ie, works based on assignments and blocks.

## considerations on named data and pattern matching

while current sum type syntax is more genuine to actual sum types,
it is definitely less powerful than pattern matching in langs like elixir, haskell and ml.
so, learn from haskell and avoid purity for the sake of purity.

all functions will pattern match, but more consistent than haskell, allowing passing of pattern matching functions trivial.
```
f = 1 => ... | x => ...
```

best guess, currying over structs with any option, is not generalizably possible,
but in certain cases is partially possible.

there are two options:
- match on structure and type
    something like
    ```
    f = {ok} => ... | {err as {value, value}} => ... | {err} => ...
    ```
    currying over structs may be partially possible, in the case where there is overlap between fields,
    and would work best when all cases have the same number of fields, ie a catch all case will just trigger.
    the other issue with over application, and currying,
    is that people could expect a certain behaviour, but then a clause that catches what they input is then added to an api.
    though there may be rules that could be enforced that would solve this issue.
    for set style structs, multiple spreads could be used where they are disjoint.
    this would also necessitate that the types allow spreads.
    also whether this would just start to make the language too complex is a fair assesment.
    - pros
        - very simple, along the lines of elixir simple
        - makes binding syntax simple
        - intuitive, except for perhaps no value fields.
    - cons
        - require some essentially hack to deal with variants that hold no data
        - will put pressure on language to adopt some strange constructs
            such as disjoint unions of structs, and units types/strange syntax for no value fields.
            though this isnt necessarily bad...

### structural matching notes

structural matching would likely be best extended to matching on types.
really types are a compile time enum of how to treat data, this could just carry over into runtime, and the overhead could be nothing.
the syntax could be reflective of this, and 

while the base syntax of matching on types would be verbose,
short cuts could be implemented when only the value should be matched on, 
or, the data inputted is a struct
or, the type doesnt matter.

```
a: type in value => ...
a => ...
a in value => ...
value => ...
{a, b} => ...
{a, b: {c, d}} => ...
```

matching multiple cases to one outcome may be a pain syntaxtically.

would need to add syntax for matching on arrays.
feels slightly awkward to match array in type, but if arrays are viewed as a list (with array benefits), then it is actually natural.
it just once again, has a short cut syntax as compared to what a proper list would look like.
```
[a, b, ..rest] => ...
[a: type, b: type, ..rest: type] => ...
```

may want to also allow for aliasing, which was the original idea for how the matching would be done.
while it makes sense when dealing with block binding, matching is not akin to aliasing? 

typeing shouldnt change much.
```
{a} | {b} -> c
```
only thing, if matching on types goes ahead, precendence will need to be considered.
likly the first but will want to consider if its inline with the rest of the lang.
```
a | (b -> c) | d
(a | b) -> (c | d)
```

it is also a somewhat interesting idea to allow for complex predicates regarding value matching, 
and allowing functions to return these predicates.
two options for this, make some specific syntax which is inlined at comptime, or, allow for a programatic means to do so.
probably dont allow full programatic solution, as that is stomping on general conditional system.

## array syntax

perhaps both fixed size and dynamic arrays can use the same syntax,
obviously the fixed size ones will allow for compile time checks, and passing by value if optimal.

this will both allow for better optimization, but also unify the syntax of the two and allow easy conversion between the two.

### strings

would be nice to simplify/make strings more robust over issues in other langs.
rust, too damn many. 
elixir, graphemes vs this vs that.
