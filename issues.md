# issues

## functions

## types

while first class types would be cool and the structs can be handled, enums prove and issue
if types were first class, they could merely be a struct, where all values are types, and the syntax stays the same.
however, enums, would break that syntax.
two options, either keep types in a seperate space and not usable at runtime which would be an issue for runtime comp
or, perhaps the | x: y | z: w syntax returns a whole new type, which can obvioudly be then a member of a struct.
second options best ^

## definition

### generics

## compiler

## metaprogramming

want to make both compile time and runtime metaprogramming natural if possible. 
all compiled code will be immutable unlike the reflection stupidity of other languages.
ast/asg of the code should be available at runtime, that can be used in new asg,
and a asg should be easily created at runtime.

issues with this are that, asg when using a array is harder to merge than.
ast/asg is more specific to a written code syntax, and less to a runtime graph that generates code. 
so, perhaps, make a first class ir system, that can be generated from code or built.
this ir is opinionated in the fact that it still follows the functional no side effect rules of the language.
