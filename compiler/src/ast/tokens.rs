//this will all be scrapped


pub enum UniOp {
	Not,
	Neg,
}

pub enum Literal {
	Int(i64),
	Float(f64),
	String(String),
}

pub enum Type {
	Int(u8),
	Float(u8),
	Bool,
	String,
}

pub enum Delimiter {
	LParen,
	RParen,
	LBrace,
	RBrace,
	LBracket,
	RBracket,
	Comma,
	Semicolon,
	Colon,
}

pub enum CompareOp {
	Gt,
	Lt,
	Ge,
	Le,
	Eq,
	Ne,
}

pub enum BinOp {
	Add,
	Sub,
	Mul,
	Div,
	Mod,
	And,
	Or,
	Xor,
}



pub enum TokenKind {
	Delimiter(Delimiter),
	Compare(CompareOp),
	BinOp(BinOp),
	UniOp(UniOp),
	Type(Type),
	Ident(String),
}

pub struct Token {
	start: usize,
	kind: TokenKind,
}

impl Token {
	pub fn new(start: usize, kind: TokenKind) -> Self {
		Token {
			start,
			kind,
		}
	}
}
