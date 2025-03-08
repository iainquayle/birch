from __future__ import annotations
from dataclasses import dataclass
from typing import Iterator
from copy import copy

class Token:
	def __init__(self, token_type: TokenType, position: TokenPosition): 
		self.token_type: TokenType = token_type
		self.position: TokenPosition = position
	@staticmethod
	def eat(string_iter: Iterator[str], prev_position: TokenPosition) -> tuple[Token, Iterator[str]] | None:
		c = next(string_iter, None)
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
			case x if ('a' <= x <= 'z' or 'A' <= x <= 'Z' or x == '_'):
				while (c := next(string_iter, None)) is not None and ('a' <= c <= 'z' or 'A' <= c <= 'Z' or c == '_' or c.isdigit()):
					out_string_iter = copy(string_iter)
					position.add(c)
					cumulative += c
			case _:
				pass
					


type TokenType = (
	Whitespace |
	LitInt | LitFloat | LitBool |
	TypeType | IntType | UIntType | FloatType | BoolType |
	Ident | Type | Fn | Let | If | Match | To | As | Is | Tail | Rec |
	Assign |
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
class Assign:
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
