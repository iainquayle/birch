use token::Token;


pub struct AstNode {
	token: Token,
	node_type: NodeType,	
	children: Vec<AstNode>,
}
pub struct Ast {
	root: AstNode,
}

pub enum NodeType {
	Function,	
	
}

