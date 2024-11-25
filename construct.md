# finalized

## type definitions

types will take after typescript, with the addition of arithmetic types.
ie, they will not be restricted to being flat, and anonymous types will be a large part.

type A = {
    a: u32, 
    b: {
        c: u32,
        d: u32
    },
    e: {
        f: u32
        |
    }
}

## functions
