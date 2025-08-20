# issues

implement new syntax from ideas into syntax definition

## grammar
change short circuit to use or and and? as it is more of a set of actions rather than a pure data operation. 
need to figure out though how something like calls will be like with in toher types

figure out empty fields in sum types

need to:
- figure out function and sum types
- fully define lists, and their matching/binding grammar

when dealing with function matching, using an expression to match on a value or type, 
certain ones are currently ambiguous. any that are not delimited by some bracketing delimiters,
ie, ifs, calls, blocks. these may need to be bundled in aidfferent precedence level in the grammar.

also for matching on values, wouldnt that make it such that functions themselves could be part of the match?
not just the function type, would this ever be useful?.

## compiler

standardize the position of rest, position or vice versa.
move results to a {:ok, data}
make parsing errors more accurate, ie add positions, move to {:error, data}

make sure that tokens retain positional data, or ast nodes have good enough positional data added.

make list parse work on lists that dont have any elements, ie, always return a list


## metaprogramming

want to make both compile time and runtime metaprogramming natural if possible. 
all compiled code will be immutable unlike the reflection stupidity of other languages.
ast/asg of the code should be available at runtime, that can be used in new asg,
and a asg should be easily created at runtime.

on second thought, asg is likely the way to go, make it part of the std lib.
example of why is calling functions, or if statements, asg will be close enough to minimal,
but understable in the context of the language and calling already implemented functions that take structs etc.

need to decide how to denote compile time, and runtime compile.

## misc

remaining symbols are @, #, $, &, ^, ;, \\, `,

add tail keyword and specification, or rec keyword which would allow for recursing on anon functions.

## tokens
