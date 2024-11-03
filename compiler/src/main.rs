extern crate regex;
extern crate once_cell;

pub mod ast;
pub mod lexer;

use lexer::Lexer;

fn main() {
    println!("Hello, world!");

	let mut lex = Lexer::new("fn main() { let x = 5; }".to_string());
	lex.lex();
	println!("{}", lex);
}
