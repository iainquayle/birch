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


# binary expressions

  defp parse_binary(token_node_pairs, parse_next, parse_self, left_result, tokens) do
    left_result = case left_result do
      nil -> parse_next.(tokens)
      _ -> left_result
    end
    case left_result do
      {:error, _} -> left_result
      {:ok, left_node, rest, _} -> case rest do
          [] -> left_result
          [token | rest] -> token_pair = Enum.find(token_node_pairs, fn {token_pair_type, _} -> 
              {token_type, _} = token
              token_type == token_pair_type 
            end)
            case token_pair do
              nil -> left_result
              {_, node_type} -> right_result = parse_next.(rest)
                case right_result do
                  {:error, _} -> right_result
                  {:ok, right_node, rest, position} -> node = {node_type, left_node, right_node}
                    result = {:ok, node, rest, position}
                    new_result = parse_self.(result, rest)
                    case new_result do
                      {:error, _} -> result
                      {:ok, _, _, _} -> new_result
                    end
                end
            end
        end
    end
  end
  defp apply_nil(func) do
    fn tokens -> func.(nil, tokens) end
  end

  def parse_expression(tokens) do
    parse_logical_expression(nil, tokens)
  end

  defp parse_logical_expression(left_result, tokens) do
    parse_binary([{:amp_amp, :logical_and}, {:pipe_pipe, :logical_or}], apply_nil(&parse_bitwise_expression/2), &parse_logical_expression/2, left_result, tokens)
  end

  defp parse_bitwise_expression(left_result, tokens) do
    parse_binary([{:amp, :bitwise_and}, {:pipe, :bitwise_or}, {:caret, :bitwise_xor}], apply_nil(&parse_equality_expression/2), &parse_bitwise_expression/2, left_result, tokens)
  end

  defp parse_equality_expression(left_result, tokens) do
    parse_binary([{:eq_eq, :eq}, {:bang_eq, :neq}], apply_nil(&parse_relational_expression/2), &parse_equality_expression/2, left_result, tokens)
  end

  defp parse_relational_expression(left_result, tokens) do
    parse_binary([{:lt, :lt}, {:leq, :leq}, {:gt, :gt}, {:geq, :geq}], apply_nil(&parse_bitwise_shift_expression/2), &parse_relational_expression/2, left_result, tokens)
  end

  defp parse_bitwise_shift_expression(left_result, tokens) do
    parse_binary([{:l_shift, :l_shift}, {:r_shift, :r_shift}], apply_nil(&parse_additive_expression/2), &parse_bitwise_shift_expression/2, left_result, tokens)
  end

  defp parse_additive_expression(left_result, tokens) do
    parse_binary([{:plus, :add}, {:minus, :sub}], apply_nil(&parse_multiplicative_expression/2), &parse_additive_expression/2, left_result, tokens)
  end

  defp parse_multiplicative_expression(left_result, tokens) do
    parse_binary([{:star, :mul}, {:f_slash, :div}, {:mod, :mod}], &parse_unary_expression/1, &parse_multiplicative_expression/2, left_result, tokens)
  end

  defp parse_unary_expression(tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"}
      [token | rest] -> case token do
        {:minus, _} -> expr_result = parse_unary_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest, position} -> {:ok, {:negate, expr}, rest, position}
          end
        {:bang, _} -> expr_result = parse_unary_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest, position} -> {:ok, {:not, expr}, rest, position}
          end
        {:tilde, _} -> expr_result = parse_unary_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest, position} -> {:ok, {:bitwise_not, expr}, rest, position}
          end
        _ -> parse_call_expression(nil, tokens)
      end
    end
  end

  defp parse_call_expression(left_result, tokens) do
    parse_binary([{:dot, :call}], &parse_primary_expression/1, &parse_call_expression/2, left_result, tokens)
  end

  #lits, idents, parens, adts, control flow, could do blocks maybe
  defp parse_primary_expression(tokens) do
    case tokens do
      [] -> {:error, "No more tokens"}
      [token | rest] -> case token do
        {{:identifier, _}, position} -> {:ok, token, rest, position}
      end
    end
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
