use std::fmt;

pub enum TokenType {
	Whitespace,

	LitInt(i64),

	TypeInt(u8),

	Ident(String),
	Let,
	Type,

	Assign,

	LParen,
	RParen,
	LSquare,
	RSquare,
	LCurly,
	RCurly,

	Comma,
	Semicolon,
	Colon,

	Ge,
	Le,
	Eq,
	Ne,
	Lt, //would be nice to not hace these
	Gt,

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
impl fmt::Display for TokenType {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		match self {
			Self::Whitespace => write!(f, "Whitespace"),
			Self::LitInt(i) => write!(f, "LitInt({})", i),
			Self::TypeInt(i) => write!(f, "TypeInt({})", i),
			Self::Ident(s) => write!(f, "Ident({})", s),
			Self::Let => write!(f, "Let"),
			Self::Type => write!(f, "Type"),
			Self::Assign => write!(f, "Assign"),
			Self::LParen => write!(f, "LParen"),
			Self::RParen => write!(f, "RParen"),
			Self::LSquare => write!(f, "LSquare"),
			Self::RSquare => write!(f, "RSquare"),
			Self::LCurly => write!(f, "LCurly"),
			Self::RCurly => write!(f, "RCurly"),
			Self::Comma => write!(f, "Comma"),
			Self::Semicolon => write!(f, "Semicolon"),
			Self::Colon => write!(f, "Colon"),
			Self::Ge => write!(f, "Ge"),
			Self::Le => write!(f, "Le"),
			Self::Eq => write!(f, "Eq"),
			Self::Ne => write!(f, "Ne"),
			Self::Lt => write!(f, "Lt"),
			Self::Gt => write!(f, "Gt"),
			Self::Not => write!(f, "Not"),
			Self::Neg => write!(f, "Neg"),
			Self::Add => write!(f, "Add"),
			Self::Sub => write!(f, "Sub"),
			Self::Mul => write!(f, "Mul"),
			Self::Div => write!(f, "Div"),
			Self::Mod => write!(f, "Mod"),
			Self::And => write!(f, "And"),
			Self::Or => write!(f, "Or"),
			Self::Xor => write!(f, "Xor"),
		}
	}
}


pub struct Token {
	pub token_type: TokenType,
	pub location: usize,
}
impl fmt::Display for Token {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		write!(f, "{} {}", self.token_type, self.location)
	}
}

