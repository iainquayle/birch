# data structure 



## tokens

make new eat function in token class, will take iterator, return next token and iterator.
just copy iterator before reading, return last iterator once done.

one flat namespace of token types, dont worry about how the tokens will interact with each other such as in the case of them all being data.

## ast 

nodes will be a single struct, accompanied by an enum type also from a flat namespace, and any number of children. 

data holds type (which will be value until semantic analysis?) and value,
value can be prim (including types), struct (including types), function, 

files will be a function node, as well as files.

## asg

does it make sense to turn the ast into a graph like with the lemnos ir?
likely quicker navigation and analysis, but whether it is worth it.

# ast generation 

## parsing

### statements 

if the final part of a statement expression could be a function,
then it will parse the start of the statement as an argument?

solutions:
- make it such that every statement is followed by a semicolon once again, instead of just the last statement
    this would be more consistent syntax wise, with others languages, and just in general
- make a state based function parsing system, where it will represent both states until a deciding token is found
    would be more complex, but allow for more flexibility

PERHAPS, function parse can first check for a statement, if it finds one, it will parse it and return the original ast and the optional new statement ast
this can then be passed back up somehow



## semantic analysis

once initial ast is done, a walk will be done to check, types, and reduce the ast where possible.
