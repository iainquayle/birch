use token::Token;


//while this is nice, it may be useful to start from the beginning with a graph based syntax representation


pub struct Assignment {
	pub assignee: Assignee,
	pub expression: Box<Expression>,
}

pub enum Assignee {
	Identifier(Token),
	Destructure(Vec<(Token, Option<Token>)>),
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
		assignments: Vec<Assignment>,
		return_expression: Box<Expression>,
	},
	Call {
		identifier: Token,
		argument: Box<Expression>,
	},

}


