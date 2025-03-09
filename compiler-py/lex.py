from __future__ import annotations
from dataclasses import dataclass
from typing import Iterator
from copy import copy

class Lexer:
	def __init__(self, string: str):
		self.string = string
		self.string_iter = iter(string)
		self.position = TokenPosition(0, 0, 0)
	def __iter__(self):
		return Lexer(self.string)
	def __next__(self) -> Token:
		if (token := Token.eat(self.string_iter, self.position)) is None:
			raise StopIteration
		self.position = token[0].position
		self.string_iter = token[1]
		return token[0]
	def __copy__(self):
		lexer = Lexer(self.string)
		lexer.string_iter = copy(self.string_iter)
		lexer.position = copy(self.position)
		return lexer 

class Token:
	def __init__(self, token_type: TokenType, position: TokenPosition): 
		self.token_type: TokenType = token_type
		self.position: TokenPosition = position
	@staticmethod
	def eat(string_iter: Iterator[str], prev_position: TokenPosition | None = None) -> tuple[Token, Iterator[str]] | None:
		c = next(string_iter, None)
		if prev_position is None:
			prev_position = TokenPosition(0, 0, 0)
		out_string_iter = copy(string_iter)
		position = copy(prev_position)
		if c is None:
			return None
		cumulative = c
		position.add(c)
		match c:
			case ' ' | '\t' | '\n':
				while (c := next(string_iter, None)) in {' ', '\t', '\n'}:
					out_string_iter = copy(string_iter)
					position.add(c)
					cumulative += c
				return Token(Whitespace(), position), out_string_iter 
			case x if x.isdigit():
				while (c := next(string_iter, None)) is not None and c.isdigit():
					out_string_iter = copy(string_iter)
					position.add(c)
					cumulative += c
				if c == '.':
					cumulative += c
					position.add(c)
					while (c := next(string_iter, None)) is not None and c.isdigit():
						out_string_iter = copy(string_iter)
						position.add(c)
						cumulative += c
					return Token(LitFloat(float(cumulative)), position), out_string_iter
				else:
					return Token(LitInt(int(cumulative)), position), out_string_iter
			case x if ('a' <= x <= 'z' or 'A' <= x <= 'Z' or x == '_'):
				number_count = 0
				while (c := next(string_iter, None)) is not None and ('a' <= c <= 'z' or 'A' <= c <= 'Z' or c == '_' or c.isdigit()):
					out_string_iter = copy(string_iter)
					position.add(c)
					cumulative += c
					if c.isdigit():
						number_count += 1
				if len(cumulative) - number_count == 1 and number_count > 0:
					match cumulative[0]:
						case 'i':
							return Token(IntType(int(cumulative[1:])), position), out_string_iter
						case 'u':
							return Token(UIntType(int(cumulative[1:])), position), out_string_iter
						case 'f':
							return Token(FloatType(int(cumulative[1:])), position), out_string_iter
						case _:
							return Token(Ident(cumulative), position), out_string_iter
				else:
					match cumulative:
						case 'type':
							return Token(TypeType(), position), out_string_iter
						case 'fn':
							return Token(Fn(), position), out_string_iter
						case 'let':
							return Token(Let(), position), out_string_iter
						case 'if':
							return Token(If(), position), out_string_iter
						case 'match':
							return Token(Match(), position), out_string_iter
						case 'to':
							return Token(To(), position), out_string_iter
						case 'as':
							return Token(As(), position), out_string_iter
						case 'is':
							return Token(Is(), position), out_string_iter
						case 'tail':
							return Token(Tail(), position), out_string_iter
						case 'rec':
							return Token(Rec(), position), out_string_iter
						case 'bool':
							return Token(BoolType(), position), out_string_iter
						case 'true':
							return Token(LitBool(True), position), out_string_iter
						case 'false':
							return Token(LitBool(False), position), out_string_iter
						case '_':
							return Token(Underscore(), position), out_string_iter
						case _:
							return Token(Ident(cumulative), position), out_string_iter
			case '(':
				return Token(LParen(), position), out_string_iter
			case ')':
				return Token(RParen(), position), out_string_iter
			case '[':
				return Token(LSquare(), position), out_string_iter
			case ']':
				return Token(RSquare(), position), out_string_iter
			case '{':
				return Token(LCurly(), position), out_string_iter
			case '}':
				return Token(RCurly(), position), out_string_iter
			case ',':
				return Token(Comma(), position), out_string_iter
			case ':':
				return Token(Colon(), position), out_string_iter
			case ';':
				return Token(Semi(), position), out_string_iter
			case '.': #could move this to where numbers are parsed 
				if next(string_iter, None) == '.':
					return Token(Spread(), position), string_iter
				return Token(Dot(), position), out_string_iter
			case '+':
				return Token(Plus(), position), out_string_iter
			case '-':
				if next(string_iter, None) == '>':
					return Token(RArrow(), position), string_iter
				return Token(Minus(), position), out_string_iter
			case '*':
				return Token(Star(), position), out_string_iter	
			case '/':
				return Token(FSlash(), position), out_string_iter
			case '\\':
				return Token(BSlash(), position), out_string_iter
			case '|':
				next_char = next(string_iter, None)
				if next_char == '|':
					return Token(Or(), position), string_iter
				elif next_char == '>':
					return Token(RPoint(), position), string_iter
				return Token(Pipe(), position), out_string_iter
			case '&':
				if next(string_iter, None) == '&':
					return Token(And(), position), string_iter 
				return Token(Amp(), position), out_string_iter
			case '^':
				return Token(Caret(), position), out_string_iter
			case '=':
				next_char = next(string_iter, None)
				if next_char == '>':
					return Token(RFatArrow(), position), string_iter
				elif next_char == '=':
					return Token(Eq(), position), string_iter
				return Token(Eq(), position), out_string_iter
			case '!':
				if next(string_iter, None) == '=':
					return Token(Ne(), position), string_iter
				return Token(Bang(), position), out_string_iter
			case '<':
				next_char = next(string_iter, None)
				if next_char == '=':
					return Token(Le(), position), string_iter
				elif next_char == '-':
					return Token(LArrow(), position), string_iter
				elif next_char == '|':
					return Token(LPoint(), position), string_iter
				return Token(Lt(), position), out_string_iter
			case '>':
				if next(string_iter, None) == '=':
					return Token(Ge(), position), string_iter
				return Token(Gt(), position), out_string_iter
			case '%':
				return Token(Mod(), position), out_string_iter
			case '?':
				return Token(QMark(), position), out_string_iter
			case _:
				return Token(Unknown(), position), out_string_iter
	def __str__(self):
		return f"{self.token_type}"
	def __repr__(self):
		return f"{self.token_type} at {self.position.line}:{self.position.column}"

					


type TokenType = (
	Whitespace |
	LitInt | LitFloat | LitBool |
	TypeType | IntType | UIntType | FloatType | BoolType |
	Ident | Type | Fn | Let | If | Match | To | As | Is | Tail | Rec | Underscore |
	Assign | Spread |
	LParen | RParen | LSquare | RSquare | LCurly | RCurly |
	Comma | Colon | Semi | RArrow | LArrow | RPoint | LPoint | RFatArrow | Dot |
	FSlash | BSlash | Pipe | Amp | Caret |
	Eq | Ne | Lt | Gt | Le | Ge |
	Bang | QMark | Plus | Minus | Star | Mod |
	And | Or |
	Unknown
)

@dataclass
class Whitespace:
	pass

@dataclass
class LitInt:
	value: int
@dataclass
class LitFloat:
	value: float
@dataclass
class LitBool:
	value: bool

@dataclass
class TypeType:
	pass
@dataclass
class IntType:
	size: int
@dataclass
class UIntType:
	size: int
@dataclass
class FloatType:
	size: int
@dataclass
class BoolType:
	pass

@dataclass
class Ident:
	ident: str
@dataclass
class Type:
	pass
@dataclass
class Fn:
	pass
@dataclass
class Let:
	pass
@dataclass
class If:
	pass
@dataclass
class Match:
	pass
@dataclass
class To:
	pass
@dataclass
class As:
	pass
@dataclass
class Is:
	pass
@dataclass
class Tail:
	pass
@dataclass
class Rec:
	pass
@dataclass
class Underscore:
	pass

@dataclass
class Assign:
	pass
@dataclass
class Spread:
	pass

@dataclass
class LParen:
	pass
@dataclass
class RParen:
	pass
@dataclass
class LSquare:
	pass
@dataclass
class RSquare:
	pass
@dataclass
class LCurly:
	pass
@dataclass
class RCurly:
	pass

@dataclass
class Comma:
	pass
@dataclass
class Colon:
	pass
@dataclass
class Semi:
	pass
@dataclass
class RArrow:
	pass
@dataclass
class LArrow:
	pass
@dataclass
class RPoint:
	pass
@dataclass
class LPoint:
	pass
@dataclass
class RFatArrow:
	pass
@dataclass
class Dot:
	pass

@dataclass
class FSlash:
	pass
@dataclass
class BSlash:
	pass
@dataclass
class Pipe:
	pass
@dataclass
class Amp:
	pass
@dataclass
class Caret:
	pass

@dataclass
class Eq:
	pass
@dataclass
class Ne:
	pass
@dataclass
class Lt:
	pass
@dataclass
class Gt:
	pass
@dataclass
class Le:
	pass
@dataclass
class Ge:
	pass

@dataclass
class Bang:
	pass
@dataclass
class QMark:
	pass
@dataclass
class Plus:
	pass
@dataclass
class Minus:
	pass
@dataclass
class Star:
	pass
@dataclass
class Mod:
	pass

@dataclass
class And:
	pass
@dataclass
class Or:
	pass

@dataclass
class Unknown:
	pass

class TokenPosition:
	def __init__(self, index: int, line: int, column: int):
		self.index: int = index
		self.line: int = line
		self.column: int = column
	def __copy__(self):
		return TokenPosition(self.index, self.line, self.column)
	def add(self, c: str):
		if c == '\n':
			self.line += 1
			self.column = 0
		else:
			self.column += 1
