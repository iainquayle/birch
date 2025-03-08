use std::fmt;

use token::{Token, TokenType, Position};


pub struct Lexer {
	source: String,
	tokens: Vec<Token>,
}
impl Lexer {
	pub fn new(source: String) -> Lexer {
		let mut tokens = Vec::new();

		let mut char_iter = source.chars();
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
			next_char = char_iter.next(); //cut this, perhaps make some helper to eat / not?
			let mut token_type = TokenType::Unknown;
			match c { 
				' ' | '\t' | '\n' | '\r' => {
					//while let Some(c @ (' ' | '\t' | '\n' | '\r')) = next_char { position.add(c); }
					token_type = TokenType::Whitespace;
				},
				'0'..='9' => {
					current_string.push(c);
					while let Some(c @ '0'..='9') | Some(c @ '.') = next_char { push_c!(c); } //will need to add . and possible other descriptors
					if current_string.contains('.') {
						token_type = TokenType::LitFloat(current_string.parse().unwrap());
					} else {
						token_type = TokenType::LitInt(current_string.parse().unwrap());
					}
				}
				'a'..='z' | 'A'..='Z' | '_' => {
					current_string.push(c);
					let first_char = c;
					let mut number_count = 0;
					while let Some(c @ ('a'..='z' | 'A'..='Z' | '_' | '0'..='9')) = next_char {
						if c.is_digit(10) {
							number_count += 1;
						}
						push_c!(c);
					}
					if current_string.len() - number_count == 1 && number_count != 0  {
						match first_char {
							'u' => token_type = TokenType::UIntType(current_string[1..].parse().unwrap()),
							'i' => token_type = TokenType::IntType(current_string[1..].parse().unwrap()),
							'f' => token_type = TokenType::FloatType(current_string[1..].parse().unwrap()),
							_ => token_type = TokenType::Ident(current_string.clone()),
						}
					} else {
						match current_string.as_str() {
							"type" => token_type = TokenType::Type, 
							"fn" => token_type = TokenType::Fn,
							"let" => token_type = TokenType::Let,
							"if" => token_type = TokenType::If,
							"match" => token_type = TokenType::Match,
							"as" => token_type = TokenType::As,
							"to" => token_type = TokenType::To,
							"is" => token_type = TokenType::Is,
							"true" => token_type = TokenType::True,
							"false" => token_type = TokenType::False,
							"tail" => token_type = TokenType::Tail,
							"rec" => token_type = TokenType::Rec,
							"bool" => token_type = TokenType::BoolType,
							_ => token_type = TokenType::Ident(current_string.clone()), 
						}
					}
				}
				'.' => {
					current_string.push(c);
					while let Some(c @ '0'..='9') = next_char { push_c!(c); }
					if current_string.len() == 1 {
						token_type = TokenType::Dot;
					} else {
						token_type = TokenType::LitFloat(current_string.parse().unwrap());
					}
				}
				'!' => token_type = TokenType::Bang,
				'/' => token_type = TokenType::FSlash,
				'\\' => token_type = TokenType::BSlash,
				'*' => token_type = TokenType::Star,
				'%' => token_type = TokenType::Mod,
				'&' => {
					next_char = char_iter.next();
					match next_char {
						Some('&') => {
							token_type = TokenType::And;
							position.add('&');
						},
						_ => token_type = TokenType::Amp,
					}
				},
				'{' => token_type = TokenType::LCurly, 
				'}' => token_type = TokenType::RCurly,
				'(' => token_type = TokenType::LParen,
				')' => token_type = TokenType::RParen,
				'[' => token_type = TokenType::LSquare,
				']' => token_type = TokenType::RSquare,
				'<' => {
					next_char = char_iter.next();
					match next_char {
						Some('=') => {
							token_type = TokenType::Le;
							position.add('=');
						},
						/*Some('>') => {
							token_type = TokenType::Ne;
							position.add('>');
						},*/
						Some('|') => {
							token_type = TokenType::LPipe;
							position.add('|');
						},
						Some('-') => {
							token_type = TokenType::LArrow;
							position.add('-');
						},
						_ => token_type = TokenType::Lt,
					}
				},
				'>' => {
					next_char = char_iter.next();
					match next_char {
						Some('=') => {
							token_type = TokenType::Ge;
							position.add('=');
						},
						/*Some('>') => {
							token_type = TokenType::Ne;
							position.add('>');
						},*/
						_ => token_type = TokenType::Gt,
					}
				},
				'|' => {
					next_char = char_iter.next();
					match next_char {
						Some('|') => {
							token_type = TokenType::Or;
							position.add('|');
						},
						Some('>') => {
							token_type = TokenType::RPipe;
							position.add('>');
						},
						_ => token_type = TokenType::Bar,
					}
				},
				'^' => token_type = TokenType::Xor,
				'+' => token_type = TokenType::Plus,
				'-' => {
					next_char = char_iter.next();
					match next_char {
						Some('>') => {
							token_type = TokenType::RArrow;
							position.add('>');
						},
						_ => token_type = TokenType::Minus,
					}
				},
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
				':' => token_type = TokenType::Colon,
				';' => token_type = TokenType::Semi,
				_ => { }
			}
			tokens.push(Token::new(token_type, previous_position.clone()));
			previous_position = position.clone();
			current_string.clear();
		}
		Lexer {
			source,
			tokens,
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
impl Lexer {
	pub fn tokens(&self) -> &Vec<Token> {
		&self.tokens
	}
	pub fn source(&self) -> &String {
		&self.source
	}
}
