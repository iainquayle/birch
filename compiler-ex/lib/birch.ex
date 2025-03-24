defmodule Birch do
  @doc """
  Hello world.
  ## Examples

      iex> Compilerex.hello()
      :world

  """

  def test do
    #source = String.graphemes("f: {x: u32, y: u32} = {x, y} => x + y")
    source = String.graphemes("let ab + c 10")
    tokens = Birch.Lexer.tokenize(source, %Birch.Lexer.Position{})
    for token <- tokens do
      IO.puts("#{inspect(token.token)} at #{token.position.index}")
    end
  end
end
