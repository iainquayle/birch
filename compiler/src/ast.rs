use token::Token;


pub struct AstNode {
	pub token: Token,
	pub children: Vec<AstNode>,
}
pub struct Ast {
	pub root: AstNode,
}

