alias Birch.Lexer, as: Lexer
alias Lexer.Position, as: Position

defmodule Birch.Parser do
  def parse(tokens) do
    
  end

  defp longest_parse(tokens, parsers) do
    results = Enum.map(parsers, fn parser -> parser.(tokens) end)
    Enum.reduce(results, {:error, "No tokens to parse"}, fn result, acc -> 
      case result do
        {:error, _} -> acc
        {:ok, _, _, position} -> case acc do
          {:error, _} -> result
          {:ok, _, _, acc_position} -> if Position.compare(position, acc_position) == :gt do
            result
          else
            acc
          end
        end
      end
    end)
  end

  defp parse_expression(tokens) do
    #consolidate all expressions into this
  end

# binary expressions

  defp parse_binary(token_node_pairs, parse_next, parse_self, left_side, tokens) do
    left_side = case left_side do
      nil -> parse_next.(nil, tokens)
      _ -> left_side
    end
    case left_side do
      {:error, _} -> left_side
      {:ok, left_side, rest, position} -> 
        
        nil
    end
  end

  defp parse_logical_expression(left_side, tokens) do
    left_side = case left_side do
      nil -> parse_bitwise_expression(nil, tokens)
      _ -> left_side
    end
    case left_side do
      {:error, _} -> left_side
      {:ok, left_side, rest, position} -> case rest do
        _ -> left_side
        [{:logical_and, _} | rest] -> right_side = parse_bitwise_expression(nil, rest)
          case right_side do
            {:error, _} -> right_side
            {:ok, right_side, rest, position} -> result = {:ok, {:logical_and, left_side, right_side}, rest, position}
              new_result = parse_logical_expression(result, rest)
              case new_result do
                {:error, _} -> result
                {:ok, _, _, _} -> new_result
              end
          end
        [{:logical_or, _} | rest] -> right_side = parse_logical_expression(nil, rest)
          case right_side do
            {:error, _} -> right_side
            {:ok, right_side, rest, position} -> {:ok, {:logical_or, left_side, right_side}, rest, position}
          end
        end
    end
  end

  defp parse_bitwise_expression(left_side, tokens) do
    
  end

  defp parse_equality_expression(left_side, tokens) do
    
  end

  defp parse_relational_expression(left_side, tokens) do
    
  end

  defp parse_bitwise_shift_expression(left_side, tokens) do
    
  end

  defp parse_additive_expression(left_side, tokens) do
    
  end

  defp parse_multiplicative_expression(left_side, tokens) do
    
  end

  defp parse_unary_expression(tokens) do
    
  end

  defp parse_call_expression(left_side, tokens) do
    
  end

  #lits, idents, parens, adts, control flow, could do blocks maybe
  defp parse_primary_expression(tokens) do
    
  end


# unary expressions



# datas

  def parse_function(tokens) do
    binding_result = parse_binding(tokens)
    case binding_result do
      {:error, _} -> binding_result
      {:ok, binding, rest, _} -> case rest do
        [] -> {:error, "No tokens to parse"}
        [{:r_fat_arrow, _} | rest] -> expr_result = parse_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest, position} -> {:ok, {:function, binding, expr}, rest, position}
          end
        _ -> {:error, "Invalid token after binding"}
      end
    end
  end


  def parse_adt(tokens) do
    #just attempt parse of adts below
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
