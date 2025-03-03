extern crate regex;
extern crate once_cell;
extern crate petgraph;

pub mod ast;
pub mod asg;
pub mod lexer;
pub mod token;
pub mod parser;

use lexer::Lexer;

fn main() {
    println!("Hello, world!");

	let src = "{some: i32} -> i32 = some -> (let x = 5 y = some x + y)".to_string();
	println!("{}", src);
	let lex = Lexer::new(src);
	println!("{}", lex);
}
