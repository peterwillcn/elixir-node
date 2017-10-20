defmodule Aecore.Utils.Blockchain.BlockValidation do
  alias Aecore.Keys.Worker, as: KeyManager
  alias Aecore.Pow.Hashcash
  alias Aecore.Miner.Worker, as: Miner
  alias Aecore.Structures.Block
  alias Aecore.Chain.ChainState

  @spec validate_block!(Block.block(), Block.block(), map()) :: {:error, term()} | :ok
  def validate_block!(new_block, previous_block, chain_state) do
    prev_block_header_hash = block_header_hash(previous_block.header)
    is_genesis = new_block == Block.genesis_block() && previous_block == nil
    is_correct_prev_hash = new_block.header.prev_hash == prev_block_header_hash

    chain_state_hash = ChainState.calculate_chain_state_hash(chain_state)

    is_difficulty_target_met = Hashcash.verify(new_block.header)

    coinbase_transactions_sum = sum_coinbase_transactions(new_block)

    cond do
      # do not check previous block hash for genesis block, there is none
      !(is_genesis || is_correct_prev_hash) ->
        throw({:error, "Incorrect previous hash"})

      # do not check previous block height for genesis block, there is none
      !(is_genesis || previous_block.header.height + 1 == new_block.header.height) ->
        throw({:error, "Incorrect height"})

      !is_difficulty_target_met ->
        throw({:error, "Header hash doesnt meet the difficulty target"})

      new_block.header.txs_hash != calculate_root_hash(new_block.txs) ->
        throw({:error, "Root hash of transactions does not match the one in header"})

      !(new_block |> validate_block_transactions |> Enum.all?()) ->
        throw({:error, "One or more transactions not valid"})

      coinbase_transactions_sum > Miner.coinbase_transaction_value() ->
        throw({:error, "Sum of coinbase transactions values exceeds the maximum coinbase transactions value"})

      new_block.header.chain_state_hash != chain_state_hash ->
        throw({:error, "Chain state not valid"})

      new_block.header.version != Block.current_block_version() ->
        throw({:error, "Invalid block version"})

      true ->
        :ok
    end
  end

  @spec block_header_hash(Header.header()) :: binary()
  def block_header_hash(header) do
    block_header_bin = :erlang.term_to_binary(header)
    :crypto.hash(:sha256, block_header_bin)
  end

  @spec validate_block_transactions(Block.block()) :: list()
  def validate_block_transactions(block) do
    for transaction <- block.txs do
      if transaction.signature != nil && transaction.data.from_acc == nil do
        KeyManager.verify(transaction.data, transaction.signature, transaction.data.from_acc)
      else
        true
      end
    end
  end

  @spec filter_invalid_transactions(list()) :: list()
  def filter_invalid_transactions(txs) do
    Enum.filter(txs, fn transaction ->
      KeyManager.verify(transaction.data, transaction.signature, transaction.data.from_acc)
    end)
  end

  @spec calculate_root_hash(list()) :: binary()
  def calculate_root_hash(txs) do
    if length(txs) == 0 do
      <<0::256>>
    else
      merkle_tree =
        for transaction <- txs do
          transaction_data_bin = :erlang.term_to_binary(transaction.data)
          {:crypto.hash(:sha256, transaction_data_bin), transaction_data_bin}
        end

      merkle_tree =
        merkle_tree
        |> List.foldl(:gb_merkle_trees.empty(), fn node, merkle_tree ->
             :gb_merkle_trees.enter(elem(node, 0), elem(node, 1), merkle_tree)
           end)

      merkle_tree |> :gb_merkle_trees.root_hash()
    end
  end

  @spec calculate_root_hash(Block.block()) :: integer()
  defp sum_coinbase_transactions(block) do
    block.txs
    |> Enum.map(
         fn tx ->
           cond do
             tx.data.from_acc == nil && tx.signature == nil -> tx.data.value
             true -> 0
           end
         end
       )
    |> Enum.sum()
  end

end
