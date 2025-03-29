alias Birch.Lexer, as: Lexer
alias Lexer.Position, as: Position

defmodule Birch.Parser do
  def parse(tokens) do
    
  end

  def parse_expression(tokens) do
    #consolidate all expressions into this
  end

  def parse_prim_op(tokens) do
    #attempt ident, literal(prim, func, adt), parens, unops, call, 
    #then match what is left with +, - ...
    #then recurse right side
    case tokens do
      [] -> {:error, "No tokens to parse"}
      [token | rest] -> case token do
        {{:identifier, _}, _} -> nil 
        _ -> {:error, "Invalid token for add"}
      end
    end
  end

  def parse_function(tokens) do
    binding_result = parse_binding(tokens)
    case binding_result do
      {:error, _} -> binding_result
      {:ok, binding, rest, _} -> case rest do
        [] -> {:error, "No tokens to parse"}
        [{:r_fat_arrow, _} | rest] -> expr_result = parse_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest} -> {:ok, {:function, binding, expr}, rest}
          end
        _ -> {:error, "Invalid token after binding"}
      end
    end
  end


  def parse_adt(tokens) do
    
  end

  def parse_product(tokens) do
  end

  def parse_sum(tokens) do
  end

  def parse_sum_block(tokens) do
  end
    

  def parse_binding(tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"} 
      [token | rest] -> case token do
        {{:identifier, _}, position} -> {:ok, {:binding, token}, rest, position} 
        {:l_curly, _} -> parse_destructure_binding([], rest)
        _ -> {:error, "Invalid token for binding"} 
      end
    end
  end
  #dont really need tco here...
  defp parse_destructure_binding(bindings, tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"} 
      [token | rest] -> case token do
        {:r_curly, position} -> {:ok, {:destructure_binding, bindings}, rest, position}
        _ -> 
          result = case token do 
            {:l_curly, _} -> parse_destructure_binding([], rest)
            {{:identifier, _}, position} -> case rest do
              [{:as, _} | rest] -> [alias_token | rest] = rest
                case alias_token do
                  {{:identifier, _}, position} -> {:ok, {:alias_binding, token, alias_token}, rest, position} 
                  _ -> {:error, {"Invalid token for alias", alias_token}} 
                end
              _ -> {:ok, {:binding, token}, rest, position} 
            end
            _ -> {:error, {"Invalid token for destructure binding", token}} 
          end
          case result do
            {:error, _} -> result
            {:ok, binding, rest, position} -> case rest do
              [] -> {:error, "No tokens to parse"}
              [{:comma, _} | rest] -> parse_destructure_binding([binding | bindings], rest)
              [{:r_curly, _} | rest] -> {:ok, {:destructure_binding, [binding | bindings]}, rest, position}
              [token | _] -> {:error, {"Invalid delimiter token", token}}
            end
          end
      end
    end
  end
end
