defmodule Fettle.Plug do
  @moduledoc """
  Format and send the latest Fettle health status report, by default
  serving on `/__health` path.

  ## Example usage
  Match on `/priv/health` and send report in custom schema:
  ```
  plug Fettle.Plug, path_info: ["priv","health"], schema: MySchema
  ```

  NB when the path matches, `Plug.Conn.halt/1` is called.

  ## Options
  * `path_info` (optional) - set path segments to match, default `["__health"]`.
  * `schema` (optional) - override Fettle configured schema module for report generation.
  """
  import Plug.Conn

  @doc "`Plug.init/1`: see `Fettle.Plug` module documentation for options."
  def init(options) do
    path_info = options[:path_info] || ["__health"]
    is_list(path_info) || raise ArgumentError, "path_info option must be a list of path segments"
    schema = options[:schema]
    is_atom(schema) || raise ArgumentError, "schema option must be nil or a module implementing Fettle.Schema"
    {path_info, schema}
  end

  @doc false
  def call(%{path_info: path_info} = conn, {path_info, schema}) do
    report = Fettle.report(schema)

    conn
    |> put_resp_content_type("application/json")
    |> put_resp_header("cache-control", "no-store")
    |> send_resp(200, Poison.encode_to_iodata!(report))
    |> halt
  end

  def call(conn, _), do: conn

end
