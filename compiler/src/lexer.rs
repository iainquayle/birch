use std::fmt;

use token::{Token, TokenType, Position};

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

		let mut position = Position::new(0, 1, 1);
		let mut previous_position = Position::new(0, 1, 1);

		macro_rules! push_c {
			($c:expr) => (
				current_string.push($c);
				position.add($c);
				next_char = char_iter.next();
			)
		}

		while let Some(c) = next_char {
			position.add(c);
			next_char = char_iter.next();
			let mut token_type = TokenType::Unknown;
			match c { 
				' ' | '\t' | '\n' | '\r' => {
					//removed the whitespace token
				},
				'0'..='9' => {
					current_string.push(c);
					while let Some(c @ '0'..='9') = next_char { push_c!(c); } //will need to add . and possible other descriptors
					token_type = TokenType::LitInt(current_string.parse().unwrap());
				}
				'a'..='z' | 'A'..='Z' | '_' => {
					current_string.push(c);
					while let Some(c @ ('a'..='z' | 'A'..='Z' | '_' | '0'..='9')) = next_char {
						push_c!(c);
					}
					match current_string.as_str() {
						"let" => token_type = TokenType::Let, 
						"type" => token_type = TokenType::Type, 
						_ => token_type = TokenType::Ident(current_string.clone()), 
					}
				}
				'{' => token_type = TokenType::LCurly, 
				'}' => token_type = TokenType::RCurly,
				'(' => token_type = TokenType::LParen,
				')' => token_type = TokenType::RParen,
				'[' => token_type = TokenType::LSquare,
				']' => token_type = TokenType::RSquare,
				'<' => token_type = TokenType::Lt,
				'>' => token_type = TokenType::Gt,
				'+' => token_type = TokenType::Add,
				'-' => token_type = TokenType::Sub,
				'=' => {
					next_char = char_iter.next();
					match next_char {
						Some('=') => {
							token_type = TokenType::Eq;
							position.add('=');
						},
						_ => token_type = TokenType::Assign,
					}
				},
				_ => { }
			}
			self.tokens.push(Token::new(token_type, previous_position.clone()));
			previous_position = position.clone();
			current_string.clear();
		}
	}
}
impl fmt::Display for Lexer {
	fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
		for token in &self.tokens {
			write!(f, "{}\n", token)?;
		}
		Ok(())
	}	
}
