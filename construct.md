# finalized

## vars

variables are immutable always, cant be reassigned, and arent preceded by any keyword.

## types 

tuples arent a thing, only structs, and anonymous structs.
will make use of arithmetic types, which will be the method of error handling.

defined types may be pass for anonymous types of the same structure, but not vice versa.
this is not absolute yet, but will likely be the case to help with type enforcement.

### definitions

types will take after typescript, with the addition of arithmetic types.
ie, they will not be restricted to being flat, and anonymous types will be a large part.
it may be the case that the braces are optional, but not decided yet,
this would take more complicated tokenization, and not sure it would be more readable.

type A = {
    a: u32, 
    b: {
        c: u32,
        d: u32
    },
    e: {
        f: u32
        | g: u32
    }
}

### generics

while not tuned, generics will be supported, and either some or all will be opaque.
these opaque types will allow for a certain level of polymorphism, along the lines of rusts traits, but not globally scoped and a little more limited.

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

and precidience will be done through parantheses.

while 

### calling

likely favour piping

{a: 1, b: 2} |> add
or
{1, 2} |> add 

but more traditional calling would likely be smart to support, especially for anonymous functions that take space.

add <| {1, 2}

it may be possible, in the case of anon functions being passed into

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

