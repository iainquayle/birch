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
    def to_string(position) do
      "Line: #{position.line}, Column: #{position.column}, Index: #{position.index}"
    end
  end

  defmacrop is_alphabet(char) do
    quote do
      unquote(char) in ?a..?z or unquote(char) in ?A..?Z
    end
  end
  defmacrop is_alphanum_underscore(char) do
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
        result = case char do
          c when c in @whitespace -> {new_position, rest} = tokenize_whitespace(rest, start_position)
            {:whitespace, new_position, rest}
          c when c in @numbers  -> {num, new_position, rest} = tokenize_number(rest, <<c::utf8>>,  start_position)
            {{:int, num}, new_position, rest}
            #add more options, as well as perhaps the size 
          c when is_alphabet(c) -> {size, new_position, rest} = tokenize_number(rest, <<c::utf8>>, start_position)
            if new_position != start_position do
              token = case c do
                ?i -> {:int_type, size}
                ?u -> {:uint_type, size}
                ?f -> {:float_type, size}
                _ -> {:identifier, <<c::utf8>> <> size}
              end
              {token, new_position, rest}
            else
              {identifier, new_position, rest} = tokenize_identifier(rest, <<c::utf8>>, start_position)
              token = case identifier do
                "true" -> :true
                "false" -> :false
                "if" -> :if
                "then" -> :then
                "else" -> :else
                "bool" -> :bool_type
                "fn" -> :fn
                "let" -> :let
                "to" -> :to
                "as" -> :as
                "in" -> :in
                "match" -> :match
                "tail" -> :tail
                "rec" -> :rec
                "type" -> :type
                "self" -> :self
                _ -> {:identifier, identifier}
              end
              {token, new_position, rest}
            end
          ?* -> {:star, rest}
          ?/ -> {:f_slash, rest}
          ?+ -> {:plus, rest}
          ?% -> {:mod, rest}
          ?- -> case rest do
              [?> | rest] -> {:r_arrow, Position.increment(start_position, ?>), rest}
              _ -> {:minus, rest}
            end
          ?= -> case rest do
              [?> | rest] -> {:r_fat_arrow, Position.increment(start_position, ?>), rest}
              [?= | rest] -> {:eq_eq, Position.increment(start_position, ?=), rest}
              _ -> {:eq, rest}
            end
          ?| ->  case rest do
              [?> | rest] -> {:r_point, Position.increment(start_position, ?>), rest}
              [?| | rest] -> {:pipe_pipe, Position.increment(start_position, ?|), rest}
              _ -> {:pipe, rest}
            end
          ?& -> case rest do
              [?& | rest] -> {:amp_amp, Position.increment(start_position, ?&), rest}
              _ -> {:amp, rest}
            end
          ?! -> case rest do
              [?= | rest] -> {:bang_ep, Position.increment(start_position, ?=), rest}
              _ -> {:bang, rest}
            end 
          ?~ -> case rest do
              [?= | rest] -> {:tilde_ep, Position.increment(start_position, ?=), rest}
              _ -> {:tilde, rest}
            end
          ?< -> case rest do
              [?- | rest] -> {:l_arrow, Position.increment(start_position, ?-), rest}
              [?| | rest] -> {:l_point,  Position.increment(start_position, ?|), rest}
              [?= | rest] -> {:leq, Position.increment(start_position, ?=), rest}
              [?< | rest] -> {:l_shift, Position.increment(start_position, ?<), rest}
              _ -> {:lt, rest}
            end
          ?> -> case rest do
              [?= | rest] -> {:geq, Position.increment(start_position, ?=), rest}
              [?> | rest] -> {:r_shift,Position.increment(start_position, ?>), rest}
              _ -> {:gt, rest}
            end
          ?( -> {:l_paren, rest}
          ?) -> {:r_paren, rest}
          ?{ -> {:l_curly, rest}
          ?} -> {:r_curly, rest}
          ?[ -> {:l_square, rest}
          ?] -> {:r_square, rest}
          ?; -> {:semicolon, rest}
          ?: -> {:colon, rest}
          ?? -> {:q_mark, rest}
          ?\\ -> {:b_slash, rest}
          ?' -> {:s_quote, rest}
          ?" -> {:d_quote, rest}
          ?` -> {:b_quote, rest}
          ?@ -> {:at, rest}
          ?$ -> {:dollar, rest}
          ?# -> {:hash, rest}
          ?^ -> {:caret, rest}
          ?_ -> {:underscore, rest}
          ?. -> {:dot, rest}
          ?, -> {:comma, rest}
          _ -> {{:unknown, char}, rest}
        end
        case result do
          {:whitespace, final_position, rest} -> tokenize(rest, final_position)
          {token, final_position, rest} -> [{token, position} | tokenize(rest, final_position)]
          {token, rest} -> [{token, position} | tokenize(rest, start_position)]
        end
    end
  end
  defp tokenize_identifier(chars, identifier_str, position) do
    case chars do
      [] -> {identifier_str, position, []}
      [char | rest] -> <<char::utf8>> = char
        case char do
          c when is_alphanum_underscore(c) -> tokenize_identifier(rest, identifier_str <> <<c::utf8>>, Position.increment(position, char))
          _ -> {identifier_str, position, chars}
        end
    end
  end
  defp tokenize_number(chars, number_str, position) do
    case chars do
      [] -> {number_str, position, []}
      [char | rest] -> <<char::utf8>> = char
        case char do
          c when c in @numbers -> tokenize_number(rest, number_str <> <<c::utf8>>, Position.increment(position, char))
          _ -> {number_str, position, chars}
        end
    end
  end
  defp tokenize_whitespace(chars, position) do
    case chars do
      [] -> {position, []}
      [char | rest] -> case char do
        c when c in @whitespace -> tokenize_whitespace(rest, Position.increment(position, char))
        _ -> {position, chars}
      end
    end
  end
end

