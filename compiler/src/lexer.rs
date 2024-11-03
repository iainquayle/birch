use std::fmt;

use token::{Token, TokenType};

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

		while let Some(c) = next_char {
			match c { 
				' ' | '\t' | '\n' | '\r' => {
					self.tokens.push(Token { token_type: TokenType::Whitespace, location });
					next_char = char_iter.next();
				},
				'0'..='9' => {
					current_string.push(c);
					next_char = char_iter.next();
					while let Some(c @ '0'..='9') = next_char {
						current_string.push(c);
						next_char = char_iter.next();
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
						next_char = char_iter.next();
					}
					match current_string.as_str() {
						"let" => self.tokens.push(Token { token_type: TokenType::Let, location }),
						"type" => self.tokens.push(Token { token_type: TokenType::Type, location }),
						_ => self.tokens.push(Token { token_type: TokenType::Ident(current_string.clone()), location }),
					}
					location += current_string.len();
					current_string.clear();
				}
				'{' => {
					self.tokens.push(Token { token_type: TokenType::LCurly, location });
					next_char = char_iter.next();
				}, 
				'}' => {self.tokens.push(Token { token_type: TokenType::RCurly, location }); next_char = char_iter.next();},
				'(' => {self.tokens.push(Token { token_type: TokenType::LParen, location }); next_char = char_iter.next();},
				')' => {self.tokens.push(Token { token_type: TokenType::RParen, location }); next_char = char_iter.next();},
				'[' => {self.tokens.push(Token { token_type: TokenType::LSquare, location }); next_char = char_iter.next();},
				']' => {self.tokens.push(Token { token_type: TokenType::RSquare, location }); next_char = char_iter.next();},
				',' => {self.tokens.push(Token { token_type: TokenType::Comma, location }); next_char = char_iter.next();},
				';' => {self.tokens.push(Token { token_type: TokenType::Semicolon, location }); next_char = char_iter.next();},
				':' => {self.tokens.push(Token { token_type: TokenType::Colon, location }); next_char = char_iter.next();},
				'=' => {
					next_char = char_iter.next();
					match next_char {
						Some('=') => {self.tokens.push(Token { token_type: TokenType::Eq, location }); next_char = char_iter.next();},
						_ => {self.tokens.push(Token { token_type: TokenType::Assign, location });},
					}
				},
				_ => {}
			}

			//location += 1;
			//make this easier
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
