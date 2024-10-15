


pub enum Literal {
	Int(i64), //probably want to make this something larger, then perhaps box it
}

pub enum Type {
	Int(u8),
}

pub enum TokenType {
	Whitespace,

	Ident(String),
	Let,
	Type,

	LParen,
	RParen,
	LBrace,
	RBrace,
	LBracket,
	RBracket,
	LAngle, //would be nice to not hace these
	RAngle,

	Comma,
	Semicolon,
	Colon,

	Ge,
	Le,
	Eq,
	Ne,

	Not,
	Neg,
	Add,
	Sub,
	Mul,
	Div,
	Mod,
	And,
	Or,
	Xor,
}

