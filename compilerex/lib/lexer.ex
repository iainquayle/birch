defmodule Birch.Lexer do
  defstruct tokens: [], input: ""

  defmodule Position do 
    defstruct index: 0, line: 0, column: 0
    def increment(position, char) do
      case char do
        c when c in [?\n, ?\r] -> %Position{index: position.index + 1, line: position.line + 1, column: 0}
        _ -> %Position{index: position.index + 1, line: position.line, column: position.column + 1}
      end
    end
  end

  defmodule Token do
    defstruct token: {:unknown}, position: %Position{}
  end

  defmacro is_alphabet(char) do
    quote do
      unquote(char) in ?a..?z or unquote(char) in ?A..?Z
    end
  end
  defmacro is_alphanum_underscore(char) do
    quote do
      unquote(char) in ?0..?9 or unquote(char) in ?a..?z or unquote(char) in ?A..?Z or unquote(char) == ?_
    end
  end
  @whitespace [?\s, ?\t, ?\r, ?\n]
  @numbers ?0..?9

  def tokenize(chars, position) do
    case chars do
      [] -> []
      [char | rest] -> <<char::utf8>> = char
        start_position = Position.increment(position, char)
          {token, final_position, rest} = case char do
            c when c in @whitespace -> {new_position, rest} = tokenize_whitespace(rest, start_position)
              {%Token{token: :whitespace, position: position}, new_position, rest}
            c when c in @numbers  -> {num, new_position, rest} = tokenize_number(rest, <<c::utf8>>,  start_position)
              {%Token{token: {:int, num}, position: position}, new_position, rest}
              #add more options, as well as perhaps the size
            c when is_alphabet(c) -> {size, new_position, rest} = tokenize_number(rest, <<c::utf8>>, start_position)
              if new_position != start_position do
                case c do
                  ?i -> {%Token{token: {:int_type, size}, position: position}, new_position, rest}
                  ?u -> {%Token{token: {:uint_type, size}, position: position}, new_position, rest}
                  ?f -> {%Token{token: {:float_type, size}, position: position}, new_position, rest}
                  _ -> {%Token{token: {:identifier, <<c::utf8>> <> size}, position: position}, new_position, rest}
                end
              else
                {identifier, new_position, rest} = tokenize_identifier(rest, <<c::utf8>>, start_position)
                case identifier do
                  "true" -> {%Token{token: :true, position: position}, new_position, rest}
                  "false" -> {%Token{token: :false, position: position}, new_position, rest}
                  "if" -> {%Token{token: :if, position: position}, new_position, rest}
                  "then" -> {%Token{token: :then, position: position}, new_position, rest}
                  "else" -> {%Token{token: :else, position: position}, new_position, rest}
                  "bool" -> {%Token{token: :bool_type, position: position}, new_position, rest}
                  "fn" -> {%Token{token: :fn, position: position}, new_position, rest}
                  "let" -> {%Token{token: :let, position: position}, new_position, rest}
                  "to" -> {%Token{token: :to, position: position}, new_position, rest}
                  "as" -> {%Token{token: :as, position: position}, new_position, rest}
                  "in" -> {%Token{token: :in, position: position}, new_position, rest}
                  "match" -> {%Token{token: :match, position: position}, new_position, rest}
                  "tail" -> {%Token{token: :tail, position: position}, new_position, rest}
                  "rec" -> {%Token{token: :rec, position: position}, new_position, rest}
                  "type" -> {%Token{token: :type, position: position}, new_position, rest}
                  "self" -> {%Token{token: :self, position: position}, new_position, rest}
                  _ -> {%Token{token: {:identifier, identifier}, position: position}, new_position, rest}
                end
              end
            ?* -> {%Token{token: :star, position: position}, start_position, rest}
            ?/ -> {%Token{token: :f_slash, position: position}, start_position, rest}
            ?+ -> {%Token{token: :plus, position: position}, start_position, rest}
            ?- -> new_position = Position.increment(start_position, ?-)
              case rest do
                [?> | rest] -> {%Token{token: :r_arrow, position: position}, new_position, rest}
                _ -> {%Token{token: :minus, position: position}, start_position, rest}
            end
            ?= -> new_position = Position.increment(start_position, ?=)
              case rest do
                [?> | rest] -> {%Token{token: :r_fat_arrow, position: position}, new_position, rest}
                [?= | rest] -> {%Token{token: :eq, position: position}, new_position, rest}
                _ -> {%Token{token: :eq, position: position}, start_position, rest}
              end
            ?| -> new_position = Position.increment(start_position, ?|)
              case rest do
                [?> | rest] -> {%Token{token: :r_point, position: position}, new_position, rest}
                [?| | rest] -> {%Token{token: :or, position: position}, new_position, rest}
                _ -> {%Token{token: :pipe, position: position}, start_position, rest}
              end
            ?& -> new_position = Position.increment(start_position, ?&)
              case rest do
                [?& | rest] -> {%Token{token: :and, position: position}, new_position, rest}
                _ -> {%Token{token: :amp, position: position}, start_position, rest}
              end
            ?! -> new_position = Position.increment(start_position, ?!)
              case rest do
                [?= | rest] -> {%Token{token: :neq, position: position}, new_position, rest}
                _ -> {%Token{token: :bang, position: position}, start_position, rest}
              end 
            ?< -> new_position = Position.increment(start_position, ?<)
              case rest do
                [?- | rest] -> {%Token{token: :l_arrow, position: position}, new_position, rest}
                [?| | rest] -> {%Token{token: :l_point, position: position}, new_position, rest}
                [?= | rest] -> {%Token{token: :leq, position: position}, new_position, rest}
                _ -> {%Token{token: :lt, position: position}, start_position, rest}
              end
            ?( -> {%Token{token: :l_paren, position: position}, start_position, rest}
            ?) -> {%Token{token: :r_paren, position: position}, start_position, rest}
            ?{ -> {%Token{token: :l_brace, position: position}, start_position, rest}
            ?} -> {%Token{token: :r_brace, position: position}, start_position, rest}
            ?[ -> {%Token{token: :l_square, position: position}, start_position, rest}
            ?] -> {%Token{token: :r_square, position: position}, start_position, rest}
            ?; -> {%Token{token: :semicolon, position: position}, start_position, rest}
            ?: -> {%Token{token: :colon, position: position}, start_position, rest}
            ?? -> {%Token{token: :q_mark, position: position}, start_position, rest}
            ?\\ -> {%Token{token: :b_slash, position: position}, start_position, rest}
            _ -> {%Token{token: {:unknown, char}, position: position}, start_position, rest}
          end
          [token | tokenize(rest, final_position)]
    end
  end
  def tokenize_identifier(chars, identifier_str, position) do
    case chars do
      [] -> {identifier_str, position, []}
      [char | rest] -> <<char::utf8>> = char
        case char do
          c when is_alphanum_underscore(c) -> tokenize_identifier(rest, identifier_str <> <<c::utf8>>, Position.increment(position, char))
          _ -> {identifier_str, position, chars}
        end
    end
  end
  def tokenize_number(chars, number_str, position) do
    case chars do
      [] -> {number_str, position, []}
      [char | rest] -> <<char::utf8>> = char
        case char do
          c when c in @numbers -> tokenize_number(rest, number_str <> <<c::utf8>>, Position.increment(position, char))
          _ -> {number_str, position, chars}
        end
    end
  end
  def tokenize_whitespace(chars, position) do
    case chars do
      [] -> {position, []}
      [char | rest] -> case char do
        c when c in @whitespace -> tokenize_whitespace(rest, Position.increment(position, char))
        _ -> {position, chars}
      end
    end
  end

end

