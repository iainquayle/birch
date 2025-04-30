alias Birch.Lexer, as: Lexer
alias Lexer.Position, as: Position

defmodule Birch.Parser do
  def parse(tokens) do
    
  end

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
            {:ok, expr, rest, position} -> {:ok, {:negate, expr}, rest, position}
          end
#        {:bang, _} -> expr_result = parse_unary_expression(rest)
#          case expr_result do
#            {:error, _} -> expr_result
#            {:ok, expr, rest, position} -> {:ok, {:not, expr}, rest, position}
#          end
        {:tilde, _} -> expr_result = parse_unary_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest, position} -> {:ok, {:not, expr}, rest, position}
          end
        _ -> parse_call_expression(nil, tokens)
      end
    end
  end

  defp parse_call_expression(left_result, tokens) do
    parse_binary([{:dot, :call}], apply_nil(&parse_adt_call_expression/2), &parse_call_expression/2, left_result, tokens)
  end

  #still not sure about using this, while there should be some short cut for adt calls, it seems to be out of line
  #especially with the inctroduction of dot qmark and dot bang, since they can be used with func calls, there would need to be another operator for adts for those...
  defp parse_adt_call_expression(left_result, tokens) do
    #parse_binary([{:dot_dot, :adt_call}], &parse_primary_expression/1, &parse_adt_call_expression/2, left_result, tokens)
    parse_primary_expression(tokens)
  end

  #lits, idents, parens, adts, control flow, could do blocks maybe
  defp parse_primary_expression(tokens) do
    case tokens do
      [] -> {:error, "No more tokens"}
      [token | rest] -> case token do
        {{:int, _}, position} -> {:ok, token, rest, position}
        {{:int_type, _}, position} -> {:ok, token, rest, position}
        {{:uint_type, _}, position} -> {:ok, token, rest, position} 
        {{:float, _}, position} -> {:ok, token, rest, position}
        {{:float_type, _}, position} -> {:ok, token, rest, position}
        {:l_paren, _} -> result = parse_expression(rest)
          case result do
            {:error, _} -> result
            {:ok, expr, rest, position} -> case rest do
              [{:r_paren, _} | rest] -> {:ok, expr, rest, position}
              _ -> {:error, "No closing parenthesis"}
            end
          end
        {:l_square, position} -> nil
        {:if, position} -> nil
        _ -> longest_parse(tokens, [
          &parse_ident/1,
          &parse_function/1,
          &parse_adt/1,
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
        {{:ident, _}, position} -> {:ok, token, rest, position}
        _ -> {:error, "Invalid token for identifier"}
      end
    end
  end

  def parse_function(tokens) do
    binding_result = parse_function_match(tokens)
    case binding_result do
      {:error, _} -> binding_result
      {:ok, binding, rest, _} -> case rest do
        [] -> {:error, "No tokens to parse"}
        [{:eq_r_angle, _} | rest] -> expr_result = parse_expression(rest)
          case expr_result do
            {:error, _} -> expr_result
            {:ok, expr, rest, position} -> {:ok, {:function, binding, expr}, rest, position}
          end
        _ -> {:error, "Invalid token after binding"}
      end
    end
  end
  #perhaps just start by copying the block binding parser, and then start adding functionality to it
  defp parse_function_match(tokens) do
    {:error, "not impl yet"} 
  end


  def parse_adt(tokens) do
    case tokens do
      [{:l_curly, _} | rest] -> 
        result = longest_parse(rest, [
          &parse_product/1,
          #&parse_sum_call/1,
          #&parse_sum_block/1
        ]) 
        case result do
          {:error, _} -> result
          {:ok, adt, rest, position} -> 
            case rest do
              [{:r_curly, _} | rest] -> {:ok, adt, rest, position}
              _ -> {:error, "No closing curly brace"}
            end
        end
      _ -> {:error, "Invalid token for adt or no tokens"}
    end
  end

  def parse_adt_type(tokens) do
    case tokens do
      [{:l_curly, _} | rest] -> 
        result = longest_parse(rest, [
          &parse_product_type/1,
        ]) 
        case result do
          {:error, _} -> result
          {:ok, adt, rest, position} -> 
            case rest do
              [{:r_curly, _} | rest] -> {:ok, adt, rest, position}
              _ -> {:error, "No closing curly brace"}
            end
        end
      _ -> {:error, "Invalid token for adt or no tokens"}
    end
  end

  defp parse_product(tokens) do
    result = case tokens do
      [] -> {:error, "No tokens to parse"}
      _ -> parse_product_list(tokens)
    end 
    case result do
      {:error, _} -> result
      {:ok, elements, rest, position} -> case rest do
        [{:comma, _} | rest] -> 
          case rest do
            [{:dot_dot, _} | rest] -> result = parse_expression(rest) 
              case result do
                {:error, _} -> result
                {:ok, expr, rest, position} -> {:ok, {:product, elements, expr}, rest, position}
              end
            _ -> {:ok, {:product, elements}, rest, position}
          end
        _ ->  case elements do
            [_ | [_ | _]] -> {:ok, {:product, elements}, rest, position} #checking for at least two elements
            _ -> {:error, "Product must have at least one comma"}
          end
      end
    end
  end
  defp parse_product_list(tokens) do
    element_result = case tokens do
      [] -> {:error, "No tokens to parse"}
      [token | rest] -> case token do
        {{:ident, _}, position} -> case rest do
          [{:eq, _} | rest] -> result = parse_expression(rest)
            case result do
              {:error, _} -> result
              {:ok, expr, rest, position} -> {:ok, {token, expr}, rest, position}
            end
          _ -> {:ok, token, rest, position} 
        end
        _ -> {:error, "Invalid token for product element"}
      end    
    end
    case element_result do
      {:error, _} -> element_result 
      {:ok, element, rest, position} -> case rest do
        [{:comma, _} | comma_rest] -> list_result = parse_product_list(comma_rest)
          case list_result do
            {:error, _} -> {:ok, [element], rest, position}
            {:ok, list, rest, position} -> {:ok, [element | list], rest, position} 
          end
        _ -> {:ok, [element], rest, position}
      end
    end
  end

  defp parse_product_type(tokens) do
  end

  #could just make this parse expression, and check later that the bottom is an ident
  defp parse_sum_call(tokens) do 
    case tokens do
      [] -> {:error, "No tokens to parse"}
      [token | rest] -> 
        case token do
          {{:ident, _}, position} -> 
            case rest do
              [{:dot, _} | rest] -> result = parse_expression(rest)
                case result do
                  {:error, _} -> result
                  {:ok, expr, rest, position} -> {:ok, {:sum_call, token, expr}, rest, position}
                end
              _ -> {:ok, {:sum_call, token}, rest, position}
            end
            _ -> {:error, "Invalid token for sum call"}
        end
    end
  end

  defp parse_sum_block(tokens) do
    list_result = on_token(tokens, fn token, _, rest ->
      case token do
        {:bar, _} -> parse_sum_block_list(rest)
        _ -> result = parse_sum_block_list(tokens)
          #issue here, need to add flag tto deal with checking for atleast one bar
          #perhaps move the check for the catch all into its own function
          result
      end
    end)
  end
  defp parse_sum_block_catch(tokens) do
    case tokens do
      [{:bar, _} | [{:under, _} | [{:eq, _} | rest]]] -> result = parse_expression(rest)
        case result do
          {:error, _} -> result
          {:ok, expr, rest, position} -> {:ok, {:sum_block_catch, expr}, rest, position}
        end
      _ -> {:error, "Invalid token for sum block catch"}
    end
  end
  defp parse_sum_block_list(tokens) do
    variant_idents_result = parse_sum_block_variant_idents(tokens)
    variants_result = case variant_idents_result do
      {:error, _} -> variant_idents_result
      {:ok, variant_idents, rest, _} -> expr_result = case rest do
          [{:eq, _} | rest] -> parse_expression(rest)
            _ -> {:error, "Invalid token for sum block variant"}
        end
        case expr_result do 
          {:error, _} -> expr_result
          {:ok, expr, rest, position} -> {:ok, {variant_idents, expr}, rest, position}
        end
    end
    case variants_result do
      {:error, _} -> variants_result
      {:ok, variants, rest, position} -> case rest do
        [{:bar, _} | rest] -> result = parse_sum_block_list(rest)
          case result do
            {:error, _} -> {:ok, [variants], rest, position}
            {:ok, new_variants, rest, position} -> {:ok, [variants | new_variants], rest, position}
          end
      end
    end
  end
  defp parse_sum_block_variant_idents(tokens) do # could techincially use parse ident here, but think that could be used for exprs
    parse_list(tokens, fn tokens -> 
      case tokens do
        [] -> {:error, "No tokens to parse"}
        [token | rest] -> case token do
          {{:ident, _}, position} -> {:ok, token, rest, position}
          _ -> {:error, "Invalid token for sum block variant ident"}
        end
      end
    end, :bar)
  end

# block

  defp parse_block(tokens) do
    {:error, "Not implemented"}
  end

  def parse_block_binding(tokens) do
    case tokens do
      [] -> {:error, "No tokens to parse"} 
      [token | rest] -> case token do
        {{:ident, _}, position} -> {:ok, {:binding, token}, rest, position} 
        {:l_curly, _} -> 
          list_result = parse_list(tokens, fn tokens -> on_token(tokens, fn token, rest -> 
            case token do
              {{:ident, _}, position} -> on_token(tokens, fn token, rest -> case token do
                {:as, position} -> parse_block_binding(rest) #check that failing this will fail the whole thing, not just the element.
              end end) 
            end
          end) end, :comma) 
        _ -> {:error, "Invalid token for binding"} 
      end
    end
  end

#helpers

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

  #expects function that returns result
  defp on_token(tokens, func) do
    case tokens do
      [] -> {:error, "No tokens to parse"}
      [{token, position} | rest] -> func.(token, position, rest)
    end
  end 

  #may be too restrictive, in the case of products requiring atleast one comma to seperate them from sum calls
  defp parse_list(tokens, parse_element, delim) do
    element_result = parse_element.(tokens)
    case element_result do
      {:error, _} -> element_result 
      {:ok, element, rest, position} -> on_token(rest, fn token, _, rest ->
        case token do
          {token_data, _} -> if token_data == delim do
              list_result = parse_list(rest, parse_element, delim)
              case list_result do
                {:error, _} -> {:ok, [element], rest, position}
                {:ok, _, _, _} -> list_result
              end
            else
              {:error, "Invalid token for list element"}
            end
          _ -> {:error, "Invalid token for list element"}
        end
      end)
    end
  end
end
