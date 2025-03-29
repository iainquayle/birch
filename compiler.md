# data structure 

## tokens

make new eat function in token class, will take iterator, return next token and iterator.
just copy iterator before reading, return last iterator once done.

one flat namespace of token types, dont worry about how the tokens will interact with each other such as in the case of them all being data.

## ast 

### blocks

dealing with function calls, it would be best to essentially have the parsing check back every time
for the function call, you give it the current parsed chain, it will only give back the chain incremented by one.
then the next statement can be checked for, it nothing, continue with the current chain.

would be cool to allow this for most constructs in the language.

### misc

nodes will be a single struct, accompanied by an enum type also from a flat namespace, and any number of children. 

data holds type (which will be value until semantic analysis?) and value,
value can be prim (including types), struct (including types), function, 

files will be a function node, as well as files.

## asg

does it make sense to turn the ast into a graph like with the lemnos ir?
likely quicker navigation and analysis, but whether it is worth it.

# ast generation 

## parsing

the parser will be a simple recursive descent parser, that will generate the ast as it goes.

## semantic analysis

once initial ast is done, a walk will be done to check, types, and reduce the ast where possible.
