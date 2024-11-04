use token::Token;


pub enum Type {
	Primitive(Token),
	Array(Box<(Type, usize)>), 
	Enum(Vec<(String, Option<Type>)>),	
	Struct(Vec<(String, Type)>),
}

pub enum Expression {

}

pub enum Statement {
	Let {
		name: String,
		value: Expression,
	},
	Return(Expression),
	Expression(Expression),
}

pub struct Function {
	pub input_type: Type,
	pub output_type: Type,
	pub body: Vec<Statement>,
}

pub struct Module {

}
