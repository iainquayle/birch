extern crate regex;
extern crate once_cell;

pub mod ast;
pub mod lexer;
pub mod token;
pub mod parser;

use lexer::Lexer;

fn main() {
    println!("Hello, world!");

	let src = "fn do {some: i32} -> i32 (let x = 5 x = some x)".to_string();
	println!("{}", src);
	let lex = Lexer::new(src);
	println!("{}", lex);
}
