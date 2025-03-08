use std::{fmt, str::Chars};

pub enum TokenType {
	Whitespace,

	LitInt(i64), //maybe box i128? could also just string it to allow for future changes...
	LitFloat(f64),

	TypeType,	
	IntType(u8),
	UIntType(u8),
	FloatType(u8),
	BoolType,

	Ident(String),

	Type,
	Fn,
	Let,
	If,
	Match,
	To,
	As,
	Is,
	Tail,
	Rec,
	True,
	False,

	Assign,

	LParen,
	RParen,
	LSquare,
	RSquare,
	LCurly,
	RCurly,

	Comma,
	Colon,
	Semi,
	RArrow,
	LArrow,
	RPipe,
	LPipe,
	Dot,

	FSlash,
	BSlash,
	Bar,
	Amp,

	Lt, 
	Gt,
	Ge,
	Le,
	Eq,
	Ne,

	Bang,
	QMark,
	Plus,
	Minus,
	Star,

	Mod,

	And,
	Or,
	Xor,

	Unknown,

}
impl Token {

}
impl fmt::Display for TokenType {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		match self {
			Self::Whitespace => write!(f, "Whitespace"),
			Self::LitInt(i) => write!(f, "LitInt({})", i),
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
			Self::Semi => write!(f, "Semicolon"),
			Self::Colon => write!(f, "Colon"),
			Self::RArrow => write!(f, "RArrow"),
			Self::Ge => write!(f, "Ge"),
			Self::Le => write!(f, "Le"),
			Self::Eq => write!(f, "Eq"),
			Self::Ne => write!(f, "Ne"),
			Self::Lt => write!(f, "Lt"),
			Self::Gt => write!(f, "Gt"),
			Self::Bang => write!(f, "Not"),
			Self::Plus => write!(f, "Plus"),
			Self::Minus => write!(f, "Minus"),
			Self::Star => write!(f, "Star"),
			Self::FSlash => write!(f, "FSlash"),
			Self::BSlash => write!(f, "BSlash"),
			Self::Mod => write!(f, "Mod"),
			Self::And => write!(f, "And"),
			Self::Or => write!(f, "Or"),
			Self::Xor => write!(f, "Xor"),
			Self::Unknown => write!(f, "Unknown"),
			Self::LitFloat(n) => write!(f, "LitFloat({})", n),
			Self::TypeType => write!(f, "TypeType"),
			Self::IntType(n) => write!(f, "IntType({})", n),
			Self::UIntType(n) => write!(f, "UIntType({})", n),
			Self::FloatType(n) => write!(f, "FloatType({})", n),
			Self::Fn => write!(f, "Fn"),
			Self::QMark => write!(f, "QMark"),
			Self::To => write!(f, "To"),
			Self::As => write!(f, "As"),
			Self::Bar => write!(f, "Bar"),
			Self::Amp => write!(f, "Amp"),
			Self::RPipe => write!(f, "RPipe"),
			Self::LPipe => write!(f, "LPipe"),
			Self::LArrow => write!(f, "LArrow"),
			Self::If => write!(f, "If"),
			Self::Match => write!(f, "Match"),
			Self::Dot => write!(f, "Dot"),
			Self::Is => write!(f, "Is"),
			Self::Tail => write!(f, "Tail"),
			Self::Rec => write!(f, "Rec"),
			Self::True => write!(f, "True"),
			Self::False => write!(f, "False"),
			Self::BoolType => write!(f, "BoolType"),

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
	/* maybe do this later, or not
	pub fn eat(mut string_iter: Chars, previous_position: Position) -> (Self, Chars) {
		let mut current_position = previous_position.clone();
		let mut previous_iter = string_iter.clone();
		let mut next_char: Option<char> = string_iter.next();
		let mut current_string = String::new();
		match next_char {
			_ => {}
		}
		return (Self::new(TokenType::Unknown, Position::new(0, 0, 0)), previous_iter);
	}
	*/
}
impl fmt::Display for Token {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		write!(f, "{} {}", self.token_type, self.position)
	}
}

