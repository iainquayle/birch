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
