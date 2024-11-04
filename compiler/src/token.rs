use std::fmt;

pub enum TokenType {
	Whitespace,

	LitInt(i64), //maybe box i128? could also just string it to allow for future changes...

	TypeInt(u8), //same here with string?

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

	Unknown,
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
			Self::Unknown => write!(f, "Unknown"),
		}
	}
}


pub struct Position {
	pub location: u32,
	pub line: u32,
	pub column: u16,
}
impl Position {
	pub fn new(location: u32, line: u32, column: u16) -> Self {
		Self { location, line, column }
	}
	pub fn add(&mut self, c: char) {
		self.location += 1;
		if c == '\n' {
			self.line += 1;
			self.column = 0;
		} else {
			self.column += 1;
		}
	}
}
impl Clone for Position {
	fn clone(&self) -> Self {
		Self { location: self.location, line: self.line, column: self.column }
	}
}
impl fmt::Display for Position {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		write!(f, "L{}:C{}:P{}", self.line, self.column, self.location)
	}
}



pub struct Token {
	pub token_type: TokenType,
	pub position: Position,
}
impl Token {
	pub fn new(token_type: TokenType, position: Position) -> Self {
		Self { token_type, position}
	}
}
impl fmt::Display for Token {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		write!(f, "{} {}", self.token_type, self.position)
	}
}

