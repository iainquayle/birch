use token::Token;
use ast::{Type, Value, Expression, Statement};



pub struct Parser {
	tokens: Vec<Token>,
	current: usize,
}

impl Parser {
	pub fn new(tokens: Vec<Token>) -> Parser {
		Parser {
			tokens,
			current: 0,
		}
	}
}
