from __future__ import annotations

from abc import ABC as Abstract, abstractmethod
from dataclasses import dataclass

from lex import * 

def parse(tokens: Lexer) -> Expression: #returns the root
	pass


class Expression(Abstract):
	@abstractmethod
	def eat(tokens: Iterator[Token]) -> tuple[Expression, Iterator[Token]] | None:
		pass


@dataclass
class Identifier:
	ident: Token 
@dataclass
class Literal:
	value: Token
@dataclass
class Block:
	assignments: list[tuple[Token, Expression]]
	return_expression: Expression
@dataclass
class Conditional:
	conditions: list[tuple[Expression, Expression]]
	catch_all: Expression 
@dataclass
class PatternMatch:
	expression: Expression
	cases: list[tuple[Expression, Expression]] # need to figure out if the match shouldnt an expr?
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
