use token::Token;


pub enum Type {
	Primitive(Token),
	Pointer(Box<Type>), 
	//not sure how these will be utilized in the syntax, have some kind of escape hatch? or defer all unsafe stuff to using c?
	//just how will items that use dynamic allocation be created?
	Array(Box<(Type, usize)>), 
	Enum(Vec<(String, Option<Type>)>),	
	Struct(Vec<(String, Type)>),
	Function {
		input: Box<Type>,
		//issue, would work fine for only doing destructuring, but what if the function is given a single primitive type
		//either, give the inputs a default accessor, ie, in.0, or only allow for the case of complex types
		//one is more like react, the other more like every other language
		output: Box<Type>,
	},
}

pub enum Expression {
	Value(Token),
	Variable(String),
	Call { //treat operators as calls for the moment
		name: Token,
		args: Vec<Expression>, 
	},
}

pub enum Statement { 
	Declare {
		//mutability
		name: String,
		value: Expression,
	},
	Assign {
		name: String,
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
