alias Birch.Lexer, as: Lexer
alias Lexer.Position, as: Position

defmodule Birch.Parser do

# binary expressions
  def parse_expression(tokens) do
    parse_logical_expression(nil, tokens)
  end

  defp parse_logical_expression(left_result, tokens) do
    parse_binary([{:amp_amp, :logical_and}, {:pipe_pipe, :logical_or}], apply_nil(&parse_equality_expression/2), &parse_logical_expression/2, left_result, tokens)
  end

  #defp parse_bitwise_expression(left_result, tokens) do
  #  parse_binary([{:amp, :bitwise_and}, {:pipe, :bitwise_or}, {:caret, :bitwise_xor}], apply_nil(&parse_equality_expression/2), &parse_bitwise_expression/2, left_result, tokens)
  #end

  defp parse_equality_expression(left_result, tokens) do
    parse_binary([{:eq_eq, :eq}, {:tilde_eq, :neq}], apply_nil(&parse_relational_expression/2), &parse_equality_expression/2, left_result, tokens)
  end

  defp parse_relational_expression(left_result, tokens) do
    parse_binary([{:l_angle, :lt}, {:l_angle_eq, :leq}, {:r_angle, :gt}, {:r_angle_eq, :geq}], apply_nil(&parse_additive_expression/2), &parse_relational_expression/2, left_result, tokens)
  end

  #defp parse_bitwise_shift_expression(left_result, tokens) do
  #  parse_binary([{:l_shift, :l_shift}, {:r_shift, :r_shift}], apply_nil(&parse_additive_expression/2), &parse_bitwise_shift_expression/2, left_result, tokens)
  #end

  defp parse_additive_expression(left_result, tokens) do
    parse_binary([{:plus, :add}, {:dash, :sub}], apply_nil(&parse_multiplicative_expression/2), &parse_additive_expression/2, left_result, tokens)
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
            {:ok, {expr, position, rest}} -> {:ok, {{:negate, expr}, position, rest}}
          end
        {:tilde, _} -> expr_result = parse_unary_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, {expr, position, rest}} -> {:ok, {{:not, expr}, position, rest}}
          end
        _ -> parse_call_expression(nil, tokens)
      end
    end
  end

  defp parse_call_expression(left_result, tokens) do
    parse_binary([{:dot, :call}], &parse_primary_expression/1, &parse_call_expression/2, left_result, tokens)
  end

# primary expressions
  defp parse_primary_expression(tokens) do
    case tokens do
      [] -> {:error, "No more tokens"}
      [token | rest] -> case token do
        {{:int, _}, position} -> {:ok, {token, position, rest}}
        {{:int_type, _}, position} -> {:ok, {token, position, rest}}
        {{:uint_type, _}, position} -> {:ok, {token, position, rest}} 
        {{:float, _}, position} -> {:ok, {token, position, rest}}
        {{:float_type, _}, position} -> {:ok, {token, position, rest}}
        {:l_paren, _} -> result = parse_expression(rest)
          case result do
            {:error, _} -> result
              {:ok, {expr, position, rest}} -> case rest do
                [{:r_paren, _} | rest] -> {:ok, {expr, position, rest}}
              _ -> {:error, "No closing parenthesis"}
            end
          end
        {:if, position} -> {:error, "not implemented yet"} 
        _ -> longest_parse(tokens, [
          &parse_ident/1,
          #&parse_function/1,
          &parse_product/1,
          #&parse_block/1
        ])
      end
    end
  end


# datas

  def parse_ident(tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"}
      [token | rest] -> 
        case token do 
          {{:ident, _}, position} -> {:ok, {token, position, rest}}
          _ -> {:error, "Invalid token for identifier"}
        end
    end
  end

  def parse_function(tokens) do
    binding_result = parse_function_match(tokens)
    case binding_result do
      {:error, _} -> binding_result
      {:ok, {binding, _, rest}} -> case rest do
        [] -> {:error, "No tokens to parse"}
        [{:eq_r_angle, _} | rest] -> expr_result = parse_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, {expr, position, rest}} -> {:ok, {{:function, binding, expr}, position, rest}}
          end
        _ -> {:error, "Invalid token after binding"}
      end
    end
  end
  #perhaps just start by copying the block binding parser, and then start adding functionality to it
  defp parse_function_match(tokens) do
    {:error, "not impl yet"} 
  end


  def parse_adt(tokens) do #move this to product since it is now the only one.
    case tokens do
      [{:l_curly, _} | rest] -> 
        result = longest_parse(rest, [
          &parse_product/1,
        ]) 
        case result do
          {:error, _} -> result
          {:ok, {adt, position, rest}} -> 
            case rest do
              [{:r_curly, _} | rest] -> {:ok, {adt, position, rest}}
              _ -> {:error, "No closing curly brace"}
            end
        end
      _ -> {:error, "Invalid token for adt or no tokens"}
    end
  end

  def parse_adt_type(tokens) do
  end

  defp parse_product(tokens) do
    result = case tokens do
      [] -> {:error, "No tokens to parse"}
      _ -> parse_product_list(tokens)
    end 
    case result do
      {:error, _} -> result
      {:ok, {elements, position, rest}} -> case rest do
        [{:comma, _} | rest] -> 
          case rest do
            [{:dot_dot, _} | rest] -> result = parse_expression(rest) 
              case result do
                {:error, _} -> result
                {:ok, {expr, position, rest}} -> {:ok, {{:product, elements, expr}, position, rest}}
              end
            _ -> {:ok, {{:product, elements}, position, rest}}
          end
        _ ->  case elements do
          [_ | [_ | _]] -> {:ok, {{:product, elements}, position, rest}} #checking for at least two elements
          _ -> {:error, "Product must have at least one comma"}
        end
      end
    end
  end
  defp parse_product_list(tokens) do
    parse_list(tokens, fn tokens -> 
      case tokens do
        [] -> {:error, "No tokens to parse"}
        [token | rest] -> case token do
          {{:ident, _}, position} -> case rest do
            [{:eq, _} | rest] -> result = parse_expression(rest)
              case result do
                {:ok, {expr, position, rest}} -> {:ok, {{token, expr}, position, rest}}
                {:error, _} -> result 
              end
              _ -> {:ok, {token, position, rest}} 
          end
          _ -> {:error, "Invalid token for product element"}
        end    
      end
    end, :comma)
  end

  defp parse_product_type(tokens) do
  end

# block

  defp parse_block(tokens) do
    {:error, "Not implemented"}
  end

  def parse_block_binding(tokens) do
    on_token(tokens, fn token, position, rest -> 
      case token do
        {:ident, _} -> {:ok, {{:binding, token}, position, rest}} 
        :l_curly -> 
          list_result = parse_list(rest, fn tokens -> on_token(tokens, fn token, position, rest -> 
            case token do
              {:ident, _} -> on_token(rest, fn as_token, _, as_rest -> 
                case as_token do
                  :colon -> alias_result = parse_block_binding(as_rest) 
                    case alias_result do
                      {:ok, {bindings, position, rest}} -> {:ok, {{:alias, token, bindings}, position, rest}}
                      {:error, _} -> alias_result
                    end
                  _ -> {:ok, {{:binding, token}, position, rest}}
                end 
              end) 
              _ -> {:error, "Unexpected token"}
            end
            end) end, :comma) 
          case list_result do
            {:ok, {list, _, rest}} -> 
              rest = case rest do 
                [{:comma, _} | rest] -> rest
                _ -> rest
              end
              on_token(rest, fn token, position, rest -> 
                case token do
                  :r_curly -> {:ok, {{:destructure_bindings, list}, position, rest}}
                  _ -> {:error, "Unexpected token"}
                end
              end)
            {:error, _} -> list_result  
          end
        _ -> {:error, "Invalid token to start binding"} 
      end
    end)
  end

#helpers

  defp longest_parse(tokens, parsers) do
    results = Enum.map(parsers, fn parser -> parser.(tokens) end)
    Enum.reduce(results, {:error, "No tokens to parse"}, fn result, acc -> 
      case result do
        {:error, _} -> acc
        {:ok, {_, position, _}} -> case acc do
          {:error, _} -> result
          {:ok, {_, acc_position, _}} -> if Position.compare(position, acc_position) == :gt do
              result
            else
              acc
            end
        end
      end
    end)
  end

  defp parse_binary(token_node_pairs, parse_next, parse_self, left_result, tokens) do
    left_result = case left_result do
      nil -> parse_next.(tokens)
      _ -> left_result
    end
    case left_result do
      {:error, _} -> left_result
      {:ok, {left_node, _, rest}} -> case rest do
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
                  {:ok, {right_node, position, rest}} -> node = {node_type, left_node, right_node}
                      result = {:ok, {node, position, rest}}
                    new_result = parse_self.(result, rest)
                    case new_result do
                      {:error, _} -> result
                        {:ok, {_, _, _}} -> new_result
                    end
                end
            end
        end
    end
  end
  defp apply_nil(func) do
    fn tokens -> func.(nil, tokens) end
  end

  #expects function that returns result
  defp on_token(tokens, func) do
    case tokens do
      [] -> {:error, "No tokens to parse"}
      [{token, position} | rest] -> func.(token, position, rest)
    end
  end 

  defp on_success(result, func) do
    case result do
      {:error, _} -> result 
      {:ok, {_, _, _}} -> func.(result)
    end
  end

  #expects parse element to return a result
  defp parse_list(tokens, parse_element, delim) do
    element_result = parse_element.(tokens)
    case element_result do
      {:error, _} -> on_token(tokens, fn _, position, _ -> 
        {:ok, {[], position, tokens}}
      end)
      {:ok, {element, position, rest}} -> on_token(rest, fn delim_token, _, delim_rest -> # should change to different behaviour on empty list
        if delim_token == delim do
          list_result = parse_list(delim_rest, parse_element, delim)
          case list_result do
            {:error, _} -> {:ok, {[element], position, rest}}
            {:ok, {elements, position, rest}} -> {:ok, {[element | elements], position, rest}} 
          end
        else 
          {:error, "invalid delimiter"} 
        end
      end)
    end
  end
end
