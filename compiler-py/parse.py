from __future__ import annotations

from abc import ABC as Abstract, abstractmethod
from dataclasses import dataclass
from functools import reduce

from lex import * 

from typing import TypeVar, Generic

class AstNode(Abstract):
	@staticmethod
	@abstractmethod
	def eat(tokens: TokenIter) -> Result: 
		pass

type Result = Parsed | None
@dataclass
class Parsed:
	node: AstNode
	tokens: TokenIter


@dataclass
class Identifier(AstNode):
	ident: Token 
	@staticmethod
	def eat(tokens: TokenIter) -> Result: 
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, Ident):
			return Parsed(Identifier(token), tokens) 
		return None
@dataclass
class Literal(AstNode):
	value: Token
	@staticmethod
	def eat(tokens: TokenIter) -> Result: 
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, LitBool) or isinstance(token, LitFloat) or isinstance(token, LitInt):
			return Parsed(Literal(token), tokens)
		return None

class Assignee(AstNode):
	@staticmethod
	@abstractmethod
	def eat(tokens: TokenIter) -> Result:
		pass
@dataclass
class SingleAssignee(Assignee):
	assignee: Token
	@staticmethod
	def eat(tokens: TokenIter) -> Result:
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, Ident):
			return Parsed(SingleAssignee(token), tokens)
		return None
@dataclass
class DestructureAssignee(Assignee):
	assignees: list[tuple[Token, Token | None]] #ident, optional alias
	@staticmethod
	def eat(tokens: TokenIter) -> Result:
		if (token := next(tokens, None)) is None:
			return None
		if not isinstance(token, LCurly):
			return None
		assignees = []
		while (token := next(tokens, None)) is not None:
			if isinstance(token, RCurly):
				return Parsed(DestructureAssignee(assignees), tokens)
			assignee = None
			alias = None
			if isinstance(token, Ident):
				assignee = token
			else:
				return None
			if isinstance((token := next(tokens, None)), As):
				if isinstance((token := next(tokens, None)), Ident):
					alias = token
			if not isinstance((token := next(tokens, None)), Comma):
				return None
			assignees.append((assignee, alias))
		return None
		

#if the only time where parens are needed are already in a block, then it can be parsed such that if one is found, a new block is parsed
#rather than looking for it at the beginning of the expression
@dataclass
class Block(AstNode): 
	statements: list[Statement] # assignee, type, value
	return_expression: AstNode
	@staticmethod
	def eat(tokens: TokenIter) -> Result:
		while (token := next(tokens, None)) is not None:
			pass
@dataclass
class Function(AstNode):
	argument: Token
	return_expression: AstNode
# statements with types may be nearly ambigous to parse with the current instantiation syntax of enums
# as it is currently "assign_ident: type", and "variant_ident: expression"
# the one saving fact is that a full statement is "ident: type = expression", and the equal should differentiate it.
# the other option is to instantiate enum variants in a syntax like "ident expression"
@dataclass
class Struct(AstNode):
	spread: AstNode
	fields: list[tuple[Token, AstNode]]
@dataclass
class Array(AstNode):
	spread: AstNode
	values: list[AstNode]
@dataclass
class Conditional(AstNode):
	conditions: list[tuple[AstNode, AstNode]]
	catch_all: AstNode 
@dataclass
class PatternMatch(AstNode):
	expression: AstNode
	cases: list[tuple[AstNode, AstNode]]
	catch_all: AstNode
@dataclass
class Call(AstNode):
	function: AstNode
	argument: AstNode
@dataclass
class StructAccess(AstNode):
	struct: AstNode
	field: Token
@dataclass
class ArrayAccess(AstNode):
	array: AstNode
	index: AstNode
@dataclass
class AsType(AstNode):
	expression: AstNode
	reinterpret_type: AstNode
@dataclass
class ToType(AstNode):
	expression: AstNode
	target_type: AstNode
@dataclass
class StructType(AstNode):
	fields: list[tuple[Token, AstNode]]
@dataclass
class ArrayType(AstNode):
	element_type: AstNode
	length: AstNode
@dataclass
class EnumType(AstNode):
	variants: list[tuple[Token, AstNode | None]]
@dataclass
class FunctionType(AstNode):
	argument_type: AstNode
	return_type: AstNode
@dataclass
class PrimitiveType(AstNode):
	prim_type: Token
@dataclass
class Mul(AstNode):
	left: AstNode
	right: AstNode
@dataclass
class Add(AstNode):
	left: AstNode
	right: AstNode
@dataclass
class Logical(AstNode):
	left: AstNode
	right: AstNode
@dataclass
class Compare(AstNode):
	left: AstNode
	right: AstNode


@dataclass
class Statement:
	assignee: Assignee
	value_type: AstNode | None
	value: AstNode
	@staticmethod
	def eat(tokens: TokenIter) -> Result:
		if (assignee := Identifier.eat(tokens)) is None:
			return None
		if (type := ToType.eat(tokens)) is None:
			type = None
		if (value := longest_parse(tokens)) is None:
			return None
		#return Parsed(Statement(assignee.expression, type, value.expression), value.tokens)
	


def longest_parse(tokens: TokenIter, possible_expressions: list[type[AstNode]] | None = None) -> Result:
	if possible_expressions is None:
		possible_expressions = [
			Identifier,
			Literal,
			Block,
		]
	results: list[Result] = [expression.eat(tokens) for expression in possible_expressions]
	return reduce(lambda x, y: x if x is not None and (y is None or len(x.tokens) > len(y.tokens)) else y, results, None)

