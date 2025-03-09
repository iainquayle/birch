from lex import Token, Lexer

src = "f: {a: u32} -> u32 = {a} => a + 1"
lexer = Lexer(src)
for token in lexer:
	print(token)
