alias Birch.Lexer, as: Lexer
alias Lexer.Position, as: Position

defmodule Birch.Parser do
  def parse(tokens) do
    
  end

  def parse_binding(tokens) do
    case tokens do
      [] -> nil
      [token | rest] -> case token do
        {{:identifier, _}, _} -> {{:binding, token}, rest} 
        {:l_curly, _} -> parse_destructure_binding([], rest)
        _ -> nil
      end
    end
  end

  defp parse_destructure_binding(bindings, tokens) do
    case tokens do
      [] -> nil
      [token | rest] -> case token do
        {:comma, _} -> parse_destructure_binding(bindings, rest)
        {{:identifier, _}, _} -> case rest do
          [{:as, _} | rest] -> [alias_token | rest] = rest
            case alias_token do
              {{:identifier, _}, _} -> parse_destructure_binding([{token, alias_token} | bindings], rest)
              _ -> nil
            end
          _ -> parse_destructure_binding([{token, nil} | bindings], rest)
        end
        {:r_curly, _} -> {{:destructure_binding, bindings}, rest}
        _ -> nil
      end
    end
  end

  def parse_function(tokens) do
    
  end
end
