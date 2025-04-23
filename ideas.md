# with removal of | bitwise
    
now that the | bitwise operator is removed, it does open up some possibilities.
it would be possible i think possible tto remove the requirement for the {}
that being said, it wouldnt really be possible to do so in all cases without other syntax changes, 
such as the sum call, being just a function call, and it should remain in a syntax that is seperate to the regular function call.

# considerations on named data and pattern matching

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

# array syntax

perhaps both fixed size and dynamic arrays can use the same syntax,
obviously the fixed size ones will allow for compile time checks, and passing by value if optimal.

this will both allow for better optimization, but also unify the syntax of the two and allow easy conversion between the two.

## strings

would be nice to simplify/make strings more robust over issues in other langs.
rust, too damn many. 
elixir, graphemes vs this vs that.

# pattern matching

while pattern matching wont be in the frist version, would be smart to consider its syntax agead of time.

the issue is that it does matter whether sum types will be integrated with attern matching,
or the exact means of how pattern matching will be done.

an interesting idea for pattern matching is to have it set such that functions can be defined where the input is the pattern,
and for completeness, each case of a function pattern is seperated by a bar

```
f = 
| 2 => 1
| x => x
```

this would being two issues:
- how to nicely handle integrating this with sum types, or whether they are kept seperate
- how to handle curried functions, ie, can we match nested functions in a flat space.
    ie, what would happen in the case of returning a function from a branch.
    ie, inorder to match, would all of that need to be locked to be known at runtime what path the code will take?
 
```
f = 
| 2 => 1 => 0
| x => y => y + x
```

the one thing about moveing to this syntax where the functions themselves envode patterns, 
is that it would bring the syntax of products and sums closer together in a way.

a couple of issues, how would this work with the current currying syntax?
ie, if wanting a true catch all, would that then mean that it would be required to 
allow the calling of data like a function which is not decided on.
or would sum types now only take one item of data, or how would it be enforced that their call signature look a certain way?
