//this will all be scrapped


pub enum BinaryOperator {
	Add,
	Sub,
	Mul,
	Div,
	Mod,
	And,
	Or,
	Xor,
	Gt,
	Lt,
	Ge,
	Le,
	Eq,
	Ne,
}

pub enum UnaryOperator {
	Not,
	Neg,
}

pub enum Literal {
	Int(i64),
	Float(f64),
	String(String),
}

pub enum Type {
	Int(usize),
	Float(usize),
	Bool,
	String,
}

pub enum Identifier {

}


pub enum Token {

}
