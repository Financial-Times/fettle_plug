defmodule Fettle.Plug do
  @moduledoc """
  Format and send the latest Fettle health status report.
  """
  import Plug.Conn

  @doc "`Plug.init/1`; takes a single keyword option, `:schema` which overrides Fettle's configured (or default) schema setting."
  def init(options) do
    schema = options[:schema]
    {schema}
  end

  @doc false
  def call(conn, {schema}) do
    report = Fettle.report(schema)

    conn
    |> put_resp_content_type("application/json")
    |> put_resp_header("cache-control", "no-store")
    |> send_resp(200, Poison.encode_to_iodata!(report))
    |> halt
  end

end
