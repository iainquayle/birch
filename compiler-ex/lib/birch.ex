defmodule Birch do
  @doc """
  Hello world.
  ## Examples

      iex> Compilerex.hello()
      :world

  """

  def test_lexer do
    #source = String.graphemes("f: {x: u32, y: u32} = {x, y} => x + y")
    source = String.graphemes("let ab + c 10")
    tokens = Birch.Lexer.tokenize(source, %Birch.Lexer.Position{})
    for {token, position} <- tokens do
      IO.puts("#{inspect(token)} at #{position.index}")
    end
  end

  def test_binding_parser do
    source = String.graphemes("{x, {y, z}}")
    tokens = Birch.Lexer.tokenize(source, %Birch.Lexer.Position{})
    for {token, position} <- tokens do
      IO.puts("#{inspect(token)} at #{position.index}")
    end
    parsed = Birch.Parser.parse_binding(tokens)
    IO.inspect(parsed)
  end
end
