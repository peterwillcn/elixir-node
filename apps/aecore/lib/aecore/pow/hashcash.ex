defmodule Aecore.Pow.Hashcash do
  @moduledoc """
  Hashcash proof of work
  """

  @doc """
  Verify a nonce, returns :true | :false
  """

  alias Aecore.Utils.Bits
  alias Aecore.Utils.Blockchain.BlockValidation

  @spec verify(map()) :: boolean()
  def verify(%Aecore.Structures.Header{}=block_header) do
    block_header_hash = BlockValidation.block_header_hash(block_header)
    verify(block_header_hash, block_header.difficulty_target)
  end

  @spec verify(charlist() :: integer()) :: boolean()
  def verify(block_header_hash, difficulty) do
    block_header_hash
    |> Bits.extract
    |> Enum.take_while(fn(bit) -> bit == 0 end)
    |> Enum.count >= difficulty
  end

  @doc """
  Find a nonce
  """
  @spec generate(map()) :: {:ok, %Aecore.Structures.Header{} } | {:error, term()}
  def generate(%Aecore.Structures.Header{nonce: nonce}=block_header) do
    block_header_hash = BlockValidation.block_header_hash(block_header)
    case verify(block_header_hash, block_header.difficulty_target) do
      true  -> {:ok, block_header}
      false -> generate(%{block_header | nonce: nonce + 1})
    end
  end

end