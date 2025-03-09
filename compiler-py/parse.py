from __future__ import annotations

from abc import ABC as Abstract, abstractmethod
from dataclasses import dataclass

from lex import * 

class Expression(Abstract):
	@staticmethod
	@abstractmethod
	def eat(tokens: Iterator[Token]) -> tuple[Expression, Iterator[Token]] | None:
		pass

#perhaps break stuff up into comptime, and runtime expressions, better typing then

@dataclass
class Identifier(Expression):
	ident: Token 
	@staticmethod
	def eat(tokens: Iterator[Token]) -> tuple[Expression, Iterator[Token]] | None:
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, Ident):
			return Identifier(token), tokens
		return None
@dataclass
class Literal(Expression):
	value: Token
	@staticmethod
	def eat(tokens: Iterator[Token]) -> tuple[Expression, Iterator[Token]] | None:
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, LitBool) or isinstance(token, LitFloat) or isinstance(token, LitInt):
			return Literal(token), tokens
		return None
@dataclass
class Block(Expression):
	assignments: list[tuple[Token, Expression | None, Expression]] # assignee, type, value
	return_expression: Expression
	@staticmethod
	def eat(tokens: Iterator[Token]) -> tuple[Expression, Iterator[Token]] | None:
		if (token := next(tokens, None)) is None:
			return None
		pass
@dataclass
class Conditional:
	conditions: list[tuple[Expression, Expression]]
	catch_all: Expression 
@dataclass
class PatternMatch:
	expression: Expression
	cases: list[tuple[Expression, Expression]]
	catch_all: Expression
@dataclass
class Call:
	function: Expression
	arguement: Expression
@dataclass
class StructAccess:
	struct: Expression
	field: Token
@dataclass
class ArrayAccess:
	array: Expression
	index: Expression
@dataclass
class StructInit:
	spread: Expression
	fields: list[tuple[Token, Expression]]
@dataclass
class ArrayInit:
	spread: Expression
	values: list[Expression]
@dataclass
class FunctionInit:
	arguement: Token
	return_expression: Expression
@dataclass
class AsType:
	expression: Expression
	reinterpret_type: Expression
@dataclass
class ToType:
	expression: Expression
	target_type: Expression
@dataclass
class StructType:
	fields: list[tuple[Token, Expression]]
@dataclass
class ArrayType:
	element_type: Expression
	length: Expression
@dataclass
class EnumType:
	variants: list[tuple[Token, Expression | None]]
@dataclass
class FunctionType:
	arguement_type: Expression
	return_type: Expression
@dataclass
class PrimitiveType:
	prim_type: Token
@dataclass
class MulExpression:
	left: Expression
	right: Expression
@dataclass
class AddExpression:
	left: Expression
	right: Expression
@dataclass
class LogicalExpression:
	left: Expression
	right: Expression
@dataclass
class CompareExpression:
	left: Expression
	right: Expression
