# issues

## functions

while likely going towards the {} -> {} syntax, this does leave the issue of it wont be able to handle all types as inputes
ie, cant do i32 -> ..., as there is no name to address it by
two options are, actually address the input no matter what type by something like 'in' or 'self'
or, just dont allow types that cant be destructured. <- lilely this

## types

while first class types would be cool and the structs can be handled, enums prove and issue
if types were first class, they could merely be a struct, where all values are types, and the syntax stays the same.
however, enums, would break that syntax.
two options, either keep types in a seperate space and not usable at runtime which would be an issue for runtime comp
or, perhaps the | x: y | z: w syntax returns a whole new type, which can obvioudly be then a member of a struct.
second options best ^

## definition

### generics

how to implement opaque generics

where do generics come in, and would it perhaps be something that would just be covered by possible macros?
would be nice in any case to not need angle braces for generics... or perhaps there some other delimiter that wont cause trivial undecidability issues in the lexer...

## compiler

