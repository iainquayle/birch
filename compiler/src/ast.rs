use token::Token;
use petgraph::graph::{Graph, NodeIndex};

//while this is nice, it may be useful to start from the beginning with a graph based syntax representation

pub enum Assignee {
	Identifier(Token),
	Destructure(Vec<(Token, Option<Token>)>), // (name, alias)
}

pub enum Value {
	Type(Type),
	Expression(Expression),
	Function {
		argument: Token,
		expression: Box<Expression>,
	},
	Struct {
		fields: Vec<(Token, Value)>,
	},
	Enum {
		variant: Token,
		value: Option<Box<Value>>,
	},
	Array {
		values: Vec<Value>,
	},
	Primitive {

	}
}

/*
 * was a question as to whether this should be explicitly in the ast, or added on some how
 * that being said, runtime comp, when compiling a function it would be best to have it still
 * around.
 */
pub enum Type { 
	Struct {
		fields: Vec<(Token, Type)>,
	},
	Enum {
		variants: Vec<(Token, Option<Type>)>,
	},
	Array {
		elem_type: Box<Type>,
		length: Option<usize>,
	},
	Function {
		argument: Box<Type>,
		return_type: Box<Type>,
	},
	Primitive {
		kind: Token,
	},
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
		function: Box<Expression>, //can technically be an anon function called right away 
		argument: Box<Expression>,
	},
	Value(Box<Value>),
	Identifier(Token),
}


