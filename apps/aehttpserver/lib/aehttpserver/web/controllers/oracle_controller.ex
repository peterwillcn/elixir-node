defmodule Aehttpserver.Web.OracleController do
  use Aehttpserver.Web, :controller

  alias Aecore.Oracle.Oracle
  alias Aecore.Account.Account
  alias Aeutil.Bits

  require Logger

  def oracle_response(conn, _params) do
    body = conn.body_params
    binary_query_id = Bits.decode58(body["query_id"])

    case Oracle.respond(binary_query_id, body["response"], body["fee"]) do
      :ok ->
        json(conn, %{:status => :ok})

      :error ->
        json(conn, %{:status => :error})
    end
  end

  def registered_oracles(conn, _params) do
    registered_oracles = Oracle.get_registered_oracles()

    serialized_oracle_list =
      if Enum.empty?(registered_oracles) do
        %{}
      else
        Enum.reduce(registered_oracles, %{}, fn {address,
                                                 %{owner: owner} = registered_oracle_state},
                                                acc ->
          Map.put(
            acc,
            Account.base58c_encode(address),
            Map.put(registered_oracle_state, :owner, Account.base58c_encode(owner.value))
          )
        end)
      end
    json(conn, serialized_oracle_list)
  end

  def oracle_query(conn, _params) do
    deserialized_oracle = Oracle.deserialize(conn.body_params)

    case Oracle.query(
           deserialized_oracle.data.payload.oracle_address,
           deserialized_oracle.data.payload.query_data,
           deserialized_oracle.data.payload.query_fee,
           deserialized_oracle.data.fee,
           deserialized_oracle.data.payload.query_ttl,
           deserialized_oracle.data.payload.response_ttl
         ) do
      :ok ->
        json(conn, %{:status => :ok})

      :error ->
        json(conn, %{:status => :error})
    end
  end
end
