# data structure 

## tokens

one flat namespace of token types, dont worry about how the tokens will interact with each other such as in the case of them all being data.

## ast 

nodes will be a single struct, accompanied by an enum type also from a flat namespace, and any number of children. 

# ast generation 

## parsing

the parser will be a simple recursive descent parser, that will generate the ast as it goes.

## semantic analysis

once initial ast is done, a walk will be done to check, types, and reduce the ast where possible.
