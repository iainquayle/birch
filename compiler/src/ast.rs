use token::Token;
use petgraph::graph::{Graph, NodeIndex};

//while this is nice, it may be useful to start from the beginning with a graph based syntax representation

pub enum Assignee {
	Identifier(Token),
	Destructure(Vec<(Token, Option<Token>)>), // (name, alias)
}

pub enum Expression {
	If {
		conditions: Vec<(Expression, Expression)>,
		catch: Option<Box<Expression>>,
	},
	Match {
		match_on: Box<Expression>,
		cases: Vec<(Token, Expression)>,
		catch: Option<Box<Expression>>,
	},
	Block {
		assignments: Vec<(Assignee, Expression)>,
		return_expression: Box<Expression>,
	},
	Call {
		function: Box<Expression>,
		argument: Box<Expression>,
	},
	ArrayAccess {
		array: Box<Expression>,
		index: Box<Expression>,
	},
	StructAccess {
		structure: Box<Expression>,
		field: Token,
	},
	StructInit {
		fields: Vec<(Token, Expression)>,
	},
	EnumInit {
		variant: Token, 
		value: Option<Box<Expression>>,
	},
	FunctionInit {
		argument: Token, //needs to change to allow for destructuring
		expression: Box<Expression>,
	},
	ArrayInit {
		values: Vec<Expression>,
	},
	PrimitiveInit(Token),
	StructType{
		fields: Vec<(Token, Expression)>,
	},
	EnumType{
		variants: Vec<(Token, Option<Expression>)>,
	},
	ArrayType{
		elem_type: Box<Expression>,
		length: Option<usize>,
	},
	FunctionType{
		argument: Box<Expression>,
		return_type: Box<Expression>,
	},
	PrimitiveType(Token),
	TypeType,
	Identifier(Token),
}


