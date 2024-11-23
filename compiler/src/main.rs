extern crate regex;
extern crate once_cell;

pub mod ast;
pub mod lexer;
pub mod token;
pub mod parser;

use lexer::Lexer;

fn main() {
    println!("Hello, world!");

	let mut lex = Lexer::new("fn do {some: i32} -> i32 (let x = 5 x = some x) ".to_string());
	lex.lex();
	println!("{}", lex);
}
