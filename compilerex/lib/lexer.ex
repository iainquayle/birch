defmodule Birch.Lexer do
  defstruct tokens: [], input: ""

  defmodule Position do 
    defstruct index: 0, line: 0, column: 0
    def increment_position(position, char) do
      case char do
        c when c in [?\n, ?\r] -> %Position{index: position.index + 1, line: position.line + 1, column: 0}
        _ -> %Position{index: position.index + 1, line: position.line, column: position.column + 1}
      end
    end
  end

  defmodule Token do
    defstruct token: {:unknown}, position: %Position{}
  end

  @whitespace [?\s, ?\t, ?\r, ?\n]
  @numbers ?0..?9
  @alphabet [?a..?z, ?A..?Z]
  @alphanum_underscore [?0..?9, ?a..?z, ?A..?Z, ?_]
  def tokenize(chars, position) do
    case chars do
      [] -> []
      [char | rest] -> {token, new_position, rest} = case char do
          c when c in @whitespace -> {new_position, rest} = tokenize_whitespace(rest, Position.increment_position(position, char))
            {%Token{token: :whitespace, position: position}, new_position, rest}
          c when c in @numbers -> {num, new_position, rest} = tokenize_number(rest, <<c::utf8>>,  Position.increment_position(position, char))
            {%Token{token: {:number, num}, position: position}, new_position, rest}
          c when c in @alphabet -> {num, new_position, rest} = tokenize_number(rest, <<c::utf8>>, Position.increment_position(position, char))
            if new_position != position do
              case c do
                ?i -> {%Token{token: {:int_type, num}, position: position}, new_position, rest}
                ?u -> {%Token{token: {:uint_type, num}, position: position}, new_position, rest}
                ?f -> {%Token{token: {:float_type, num}, position: position}, new_position, rest}
                _ -> {%Token{token: {:unknown, char}, position: position}, Position.increment_position(position, char), rest}
              end
            else
              {identifier, new_position, rest} = tokenize_identifier(rest, <<c::utf8>>, Position.increment_position(position, char))
              full_identifier = <<c::utf8>> <> identifier
              case full_identifier do
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
                _ -> {%Token{token: {:identifier, full_identifier}, position: position}, new_position, rest}
              end

            end
            
            {identifier, new_position, rest} = tokenize_identifier(rest, <<c::utf8>>, Position.increment_position(position, char))
            
          _ -> {%Token{token: {:unknown, char}, position: position}, Position.increment_position(position, char), rest}
            
        end
        [token | tokenize(rest, Position.increment_position(new_position, char))]
    end
  end
  def tokenize_identifier(chars, identifier_str, position) do
    case chars do
      [] -> {"", position, []}
      [char | rest] -> case char do
        c when c in @alphanum_underscore -> tokenize_identifier(rest, identifier_str <> <<c::utf8>>, Position.increment_position(position, char))
        _ -> {"", position, chars}
      end
    end
  end
  def tokenize_number(chars, number_str, position) do
    case chars do
      [] -> {0, position, []}
      [char | rest] -> case char do
        c when c in @numbers -> tokenize_number(rest, number_str <> <<c::utf8>>, Position.increment_position(position, char))
        _ -> {String.to_integer(number_str), position, chars}
      end
    end
  end
  def tokenize_whitespace(chars, position) do
    case chars do
      [] -> {position, []}
      [char | rest] -> case char do
        c when c in @whitespace -> tokenize_whitespace(rest, Position.increment_position(position, char))
        _ -> {position, chars}
      end
    end
  end
end

