# finalized


## types 

tuples arent a thing, only structs, enums, and anonymous structs/enums.

defined types may be pass for anonymous types of the same structure, but not vice versa.
this is not absolute yet, but will likely be the case to help with type enforcement.

### first class

types are first class, meaning they can be tossed around, though the usefulness of this will likely come with ctr and rtc.
if it is useful, great, if not, it wont effect anything.

### definitions

a type is any data, where all values within it are types.
type A = {
    a: u32, 
    e: 
        | f: u32
        | g: u32
}
enums under the hood, using such syntax, will create a new type and return it as a value.

as well, there will be a shorthand for the option type, which will be a ? after the type.
there may also be a shorthand for the result type, with a ! between the type and the error type, but this is not decided.

### generics

generics will be a thing, but the syntax and their construction in language is not yet decided.

there will be an opaque type of generic, which will take the place of traits and typeclasses.
these will allow for the passing of types, with some functions paired that can take in that type.
once these types are passed in, their members will only be accessible by the functions, as only the functions will know what the type is.

## data 

data from the programmers perspective is always immutable, and arent preceded by any keyword.

while types and functions are just data, it may be that the syntax requires a ketword denote them when they are being defined to help with readability.
this is not decided yet.

### instantiation

as shown above, structs can be defined anonymously, and infact those are what are used for types.

it would be nice though to have a way to instantiate a typed by binding positionally.
that being said, it really isnt necessary.

### access

access with be done through . operator.
it may also be destructured, with {a, b} = {a: 1, b: 2}, or somthing similar, perhaps brackets being optional.

## functions

### body

the body of a function will be denoted by parantheses.
all code will be evaluated implicitly, meaning that the order of eval is not tied to the order of the code.
the return value will be the last item in the function, and will be returned to the scope above it.
this means that 
x = 1 + (
    y = 2 + 5
    y + 1)
is valid
the optionality of paranthese is not decided, it could be that the single return value can be elsewhere, but that would likely be more messy.

### definitions

fn add: {a: u32, b: u32} -> u32 =
    x = a + b
    x

fn sum_and_prod: {a: u32, b: u32} -> {s: u32, p: u32} =
    {s: a + b, p: a * b}

for the moment, structs are the only top level type allowed to be passed in. thought this may change if a good solution is found.

fn sum_and_prod: {a: u32, b: u32} -> {s: u32, p: u32} = {a, b}
    {s: a + b, p: a * b}
may need something more like this? where the type is optional.
in the case of anon functions, the inputs would need to be able to be defined.

### calling

likely favour piping

{a: 1, b: 2} |> add
or
{1, 2} |> add 

but more traditional calling would likely be smart to support, especially for anonymous functions that take space.

add <| {1, 2}

it may be possible, in the case of anon functions being passed into

### currying

currying will be supported by passing in partially complete structs, this will return a new function that takes a struct with the remaining fields.

## scoping

all items are implicity declared, thus in a function, a variable can rely on anything declared before or after it in that scope.
this allows for the removal of modules.

scope does bleed into functions, but not the other way around.

x = 1
fn f = {y: u32} -> u32
    x + y

## control flow

if and match will be the only control flow structures.
values will be returned from them, into the next scope up, they will not return from the function they are in.
(syntax is not final)

if
| x == 1 -> 1
| _ -> 0

match x
| 1 -> 1
| _ -> 0

match obviously works best on arithmetic types, but can be used on any type that has equality.

loops while done through recursion, may have a special rec keyword to help with simple tail recursion situations to reduce boilerplate.
either that, or have an anon function that is called back to itself using perhaps self.

## organization 

scoping will be done entirely through functions, and there will be no need for modules.
likely will be that, files and folders are merely treated as functions that take no args, and return whatever is return from the file

## metaprogramming

ideally, both compile time, and run time programming, in the native language will be supported.

## side effects

anything that deals with side effects, including networking, file io, and multithreading, will likely have some special operator, or keyword or syntax to access it.
access to such things may look something like python futures, where they can be polled for completeness.
this would work well for essentially all of these operations, and would be a unified way to handle them.

### multithreading


## style guide

actual tabs for indentation, snake case for vars, camel case for functions, capital camel case for types, and screaming snake case for constants.
