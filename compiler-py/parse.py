from __future__ import annotations

from abc import ABC as Abstract, abstractmethod
from dataclasses import dataclass
from functools import reduce

from lex import * 



class Expression(Abstract):
	@staticmethod
	@abstractmethod
	def eat(tokens: TokenIter) -> Result: 
		pass

type Result = Parsed | None
@dataclass
class Parsed:
	expression: Expression
	tokens: TokenIter



@dataclass
class Identifier(Expression):
	ident: Token 
	@staticmethod
	def eat(tokens: TokenIter) -> Result: 
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, Ident):
			return Parsed(Identifier(token), tokens) 
		return None
@dataclass
class Literal(Expression):
	value: Token
	@staticmethod
	def eat(tokens: TokenIter) -> Result: 
		if (token := next(tokens, None)) is None:
			return None
		if isinstance(token, LitBool) or isinstance(token, LitFloat) or isinstance(token, LitInt):
			return Parsed(Literal(token), tokens)
		return None
#if the only time where parens are needed are already in a block, then it can be parsed such that if one is found, a new block is parsed
#rather than looking for it at the beginning of the expression
@dataclass
class Block(Expression): 
	statements: list[Statement] # assignee, type, value
	return_expression: Expression
	@staticmethod
	def eat(tokens: TokenIter) -> Result:
		while (token := next(tokens, None)) is not None:
			pass
# statements with types may be nearly ambigous to parse with the current instantiation syntax of enums
# as it is currently "assign_ident: type", and "variant_ident: expression"
# the one saving fact is that a full statement is "ident: type = expression", and the equal should differentiate it.
# the other option is to instantiate enum variants in a syntax like "ident expression"
@dataclass
class Conditional(Expression):
	conditions: list[tuple[Expression, Expression]]
	catch_all: Expression 
@dataclass
class PatternMatch(Expression):
	expression: Expression
	cases: list[tuple[Expression, Expression]]
	catch_all: Expression
@dataclass
class Call(Expression):
	function: Expression
	arguement: Expression
@dataclass
class StructAccess(Expression):
	struct: Expression
	field: Token
@dataclass
class ArrayAccess(Expression):
	array: Expression
	index: Expression
@dataclass
class StructInit(Expression):
	spread: Expression
	fields: list[tuple[Token, Expression]]
@dataclass
class ArrayInit(Expression):
	spread: Expression
	values: list[Expression]
@dataclass
class FunctionInit(Expression):
	arguement: Token
	return_expression: Expression
@dataclass
class AsType(Expression):
	expression: Expression
	reinterpret_type: Expression
@dataclass
class ToType(Expression):
	expression: Expression
	target_type: Expression
@dataclass
class StructType(Expression):
	fields: list[tuple[Token, Expression]]
@dataclass
class ArrayType(Expression):
	element_type: Expression
	length: Expression
@dataclass
class EnumType(Expression):
	variants: list[tuple[Token, Expression | None]]
@dataclass
class FunctionType(Expression):
	arguement_type: Expression
	return_type: Expression
@dataclass
class PrimitiveType(Expression):
	prim_type: Token
@dataclass
class Mul(Expression):
	left: Expression
	right: Expression
@dataclass
class Add(Expression):
	left: Expression
	right: Expression
@dataclass
class Logical(Expression):
	left: Expression
	right: Expression
@dataclass
class Compare(Expression):
	left: Expression
	right: Expression

type Assignee = SingleAssign | DestructureAssign
@dataclass
class SingleAssign:
	assignee: Token
@dataclass
class DestructureAssign:
	assignees: list[Assignee]

@dataclass
class Statement:
	assignee: Assignee
	value_type: Expression | None
	value: Expression
	@staticmethod
	def eat(tokens: TokenIter) -> Result:
		if (assignee := Identifier.eat(tokens)) is None:
			return None
		if (type := ToType.eat(tokens)) is None:
			type = None
		if (value := longest_parse(tokens)) is None:
			return None
		#return Parsed(Statement(assignee.expression, type, value.expression), value.tokens)
	


def longest_parse(tokens: TokenIter, possible_expressions: list[type[Expression]] | None = None) -> Result:
	if possible_expressions is None:
		possible_expressions = [
			Identifier,
			Literal,
			Block,
		]
	results: list[Result] = [expression.eat(tokens) for expression in possible_expressions]
	return reduce(lambda x, y: x if x is not None and (y is None or len(x.tokens) > len(y.tokens)) else y, results, None)

