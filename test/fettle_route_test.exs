defmodule FettleRouteTest do

  use ExUnit.Case
  use Plug.Test

  setup do
    :ok = Application.ensure_started(:plug)
    Application.put_env(:plug, :validate_header_keys_during_test, true)

    {:ok, _pid} = start_supervised({Fettle.Supervisor, []})

    Fettle.add(%Fettle.Spec{
            name: "test-1",
            panic_guide_url: "panic",
            business_impact: "impact",
            technical_summary: "impact"
        },
        Fettle.AlwaysHealthyCheck
    )

    :ok
  end

  defmodule Schema do
    @behaviour Fettle.Schema

    def to_schema(_config, checks) do
      %{
        "schema" => "FettleRouteTest.Schema",
        "count" => length(checks)
      }
    end
  end

  defmodule RouterDefault do
    use Plug.Router
    plug :match
    plug :dispatch

    forward "/__health", to: Fettle.Plug
  end

  test "routes to plug, default settings" do
    conn = conn("GET", "/__health")
    conn = RouterDefault.call(conn, RouterDefault.init([]))
    {200, _headers, body} = sent_resp(conn)
    assert Poison.decode!(body)["systemCode"] == "fettle_plug"
  end


  test "routes to plug, custom schema" do

    defmodule RouterCustomSchema do
      use Plug.Router
      plug :match
      plug :dispatch

      forward "/__health", to: Fettle.Plug, schema: FettleRouteTest.Schema
    end

    conn = conn("GET", "/__health")
    conn = RouterCustomSchema.call(conn, RouterCustomSchema.init([]))
    {200, _headers, body} = sent_resp(conn)
    assert body == Poison.encode!(%{"schema" => "FettleRouteTest.Schema", "count" => 1})
  end

  test "routing to plug, custom path_info" do

    defmodule RouterCustomPathInfo do
      use Plug.Router
      plug :match

      plug Fettle.Plug, path_info: ["__foo"]
      match _, do: send_resp(conn, 404, "Route Not Found\n")

      plug :dispatch
    end


    conn = conn("GET", "/__foo")
    conn = RouterCustomPathInfo.call(conn, RouterCustomPathInfo.init([]))
    {200, _headers, body} = sent_resp(conn)
    assert  %{"schemaVersion" => 1, "systemCode" => "fettle_plug"} = Poison.decode!(body)
  end

end
