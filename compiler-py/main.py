from lex import Token, Lexer
from parse import Assignee

tokens_src = "f: {a: u32} -> u32 = {a} => a + 1"
lexer = Lexer(tokens_src)
print("Tokens test:")
for token in lexer:
	print('\t', token)

parse_src = "{a, {b, c}}"
parse_src = "a"
print("\nParse test:")
parsed_assignee = Assignee.eat(iter(Lexer(parse_src)))
if parsed_assignee is not None:
	print(parsed_assignee.node)
else:
	print("Failed to parse")

