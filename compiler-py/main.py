from lex import Token, Lexer

tokens_src = "f: {a: u32} -> u32 = {a} => a + 1"
lexer = Lexer(tokens_src)
print("Tokens test:")
for token in lexer:
	print('\t', token)

parse_src = ""
print("\nParse test:")

