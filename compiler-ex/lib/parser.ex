alias Birch.Lexer, as: Lexer
alias Lexer.Position, as: Position

defmodule Birch.Parser do
  def parse(tokens) do
    
  end

  def parse_binding(tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"} 
      [token | rest] -> case token do
        {{:identifier, _}, _} -> {{:binding, token}, rest} 
        {:l_curly, _} -> parse_destructure_binding([], rest)
        _ -> {:error, "Invalid token for binding"} 
      end
    end
  end

  defp parse_destructure_binding(bindings, tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"} 
      [token | rest] -> result = case token do
        {:r_curly, _} -> {:ok, {:destructure_binding, bindings}, rest}
        _ -> 
          result = case token do 
            {:l_curly, _} -> parse_destructure_binding([], rest)
            {{:identifier, _}, _} -> case rest do
              [{:as, _} | rest] -> [alias_token | rest] = rest
                case alias_token do
                  {{:identifier, _}, _} -> {:ok, {:alias_binding, token, alias_token}, rest} 
                  _ -> {:error, "Invalid token for alias"} 
                end
              _ -> {:ok, {:binding, token}, rest} 
            end
            _ -> {:error, "Invalid token for destructure binding"} 
          end
          case result do
            {:error, _} -> result
            {:ok, binding, rest} -> case rest do
              [] -> {:error, "No tokens to parse"}
              [:comma | rest] -> parse_destructure_binding([binding | bindings], rest)
              [:r_curly | rest] -> {:ok, {:destructure_binding, [binding | bindings]}, rest}
              _ -> {:error, "Invalid token for destructure binding"}
            _ -> {:error, "Invalid result for destructure binding"}
            end
          end
      end
    end
  end

  def parse_function(tokens) do
    
  end
end
