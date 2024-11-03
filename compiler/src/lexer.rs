use std::fmt;

pub enum TokenType {
	Whitespace,

	LitInt(i64),

	TypeInt(u8),

	Ident(String),
	Let,
	Type,

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

pub struct Lexer {
	source: String,
	tokens: Vec<Token>,
}
impl Lexer {
	pub fn new(source: String) -> Lexer {
		Lexer {
			source,
			tokens: Vec::new(),
		}
	}

	pub fn lex(&mut self) {
		let mut char_iter = self.source.chars();
		let mut next_char: Option<char> = char_iter.next();
		let mut current_string = String::new();
		let mut location: usize = 0;

		//first check for identifier, check if identifier is a keyword or type, else identifier
		//or check for whitespace first, doens matter
		//check for literals 
		//check match on operators and what not

		while let Some(c) = next_char {
			match c { 
				' ' | '\t' | '\n' | '\r' => self.tokens.push(Token { token_type: TokenType::Whitespace, location }),
				'0'..='9' => {
					current_string.push(c);
					next_char = char_iter.next();
					while let Some(c @ '0'..='9') = next_char {
						current_string.push(c);
					} //will need to add . and possible other descriptors
					self.tokens.push(Token { token_type: TokenType::LitInt(current_string.parse().unwrap()), location });
					location += current_string.len();
					current_string.clear();	
				}
				'a'..='z' | 'A'..='Z' | '_' => {
					current_string.push(c);
					next_char = char_iter.next();
					while let Some(c @ ('a'..='z' | 'A'..='Z' | '_' | '0'..='9')) = next_char {
						current_string.push(c);
					}
					match current_string.as_str() {
						"let" => self.tokens.push(Token { token_type: TokenType::Let, location }),
						"type" => self.tokens.push(Token { token_type: TokenType::Type, location }),
						_ => self.tokens.push(Token { token_type: TokenType::Ident(current_string.clone()), location }),
					}
					location += current_string.len();
					current_string.clear();
				}
				'{' => self.tokens.push(Token { token_type: TokenType::LCurly, location }),
				'}' => self.tokens.push(Token { token_type: TokenType::RCurly, location }),
				'(' => self.tokens.push(Token { token_type: TokenType::LParen, location }),
				')' => self.tokens.push(Token { token_type: TokenType::RParen, location }),
				'[' => self.tokens.push(Token { token_type: TokenType::LSquare, location }),
				']' => self.tokens.push(Token { token_type: TokenType::RSquare, location }),
				',' => self.tokens.push(Token { token_type: TokenType::Comma, location }),
				';' => self.tokens.push(Token { token_type: TokenType::Semicolon, location }),
				':' => self.tokens.push(Token { token_type: TokenType::Colon, location }),
				'+' => self.tokens.push(Token { token_type: TokenType::Add, location }),
				'-' => self.tokens.push(Token { token_type: TokenType::Sub, location }),
				'*' => self.tokens.push(Token { token_type: TokenType::Mul, location }),
				'/' => self.tokens.push(Token { token_type: TokenType::Div, location }),
				'%' => self.tokens.push(Token { token_type: TokenType::Mod, location }),
				'&' => self.tokens.push(Token { token_type: TokenType::And, location }),
				'|' => self.tokens.push(Token { token_type: TokenType::Or, location }),
				'^' => self.tokens.push(Token { token_type: TokenType::Xor, location }),
				'!' => self.tokens.push(Token { token_type: TokenType::Not, location }),
				_ => {}
			}

			location += 1;
		}
	}
}
