use token::Token;


pub enum Type {
	None,
	Primitive(Token),
	Pointer(Box<Type>), 
	//not sure how these will be utilized in the syntax, have some kind of escape hatch? or defer all unsafe stuff to using c?
	//just how will items that use dynamic allocation be created?
	Array(Box<(Type, usize)>), 
	Function {
		input: Box<Type>,
		//issue, would work fine for only doing destructuring, but what if the function is given a single primitive type
		//either, give the inputs a default accessor, ie, in.0, or only allow for the case of complex types
		//one is more like react, the other more like every other language
		output: Box<Type>,
	},
	Enum(Vec<(Token, Option<Type>)>),
	Struct(Vec<(Token, Type)>),
}


pub enum Value {
	Primitive(Type, Token),
	//not sure how these will be utilized in the syntax, have some kind of escape hatch? or defer all unsafe stuff to using c?
	//just how will items that use dynamic allocation be created?
	Array(Box<(Type, usize)>), 
	Function {
		input: Box<Type>,
		//issue, would work fine for only doing destructuring, but what if the function is given a single primitive type
		//either, give the inputs a default accessor, ie, in.0, or only allow for the case of complex types
		//one is more like react, the other more like every other language
		output: Box<Type>,
		body: Vec<Statement>,
	},
	Struct(Vec<(Token, Value)>),
}

pub enum Expression {
	Value(Value), //change this
	Identifier(Token),
	Call{
		
		callee: Box<Expression>, //either a variable, or inlined function
	},
}


//statement block, includes env capture
//function is a block, with a env that hasnt been fully resolved




pub enum Statement { 
	Declare {
		//mutability //this may be less necessary as the fact that mutations dont escape their scope
		name: Token,
		generics: Vec<Token>,
		value: Expression,
	},
	Assign {
		name: Token,
		value: Expression,
	},
	Return(Expression),
}

//pub 
//
//need a block, but since all blocks are just functions, the expression will be able to hold blocks?

//need to also extract function, as it needs to not be limited to just the top level
//also need to allow for it in types...
//in which case it may just become a constant in the module hierarchy

//also is naming in the correct spot?

//with the move of generics to declarations, can modules somehow become functions?
//they can return functions that are used, no need for specific import statements
//only thing would be how to deal with types, and maybe type classes
//thing about type classes, technically, same thing can be accomplished by passing in functions rather than having global functions essentially.

pub enum Module {
	//need to allow for generic bounding, which will need a new module type for type classes/traits
	TypeClass, //todo
	Type {
		name: String,
		generics: Vec<String>,
		kind: Type,
	},
	Constant {
		name: String,
		kind: Type,
		value: Expression,
	},
	Module{
		name: String,
		content: Vec<Module>,
	},
} 
