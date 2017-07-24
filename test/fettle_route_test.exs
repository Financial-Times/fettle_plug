defmodule FettleRouteTest do

  use ExUnit.Case
  use Plug.Test

  setup do
    Application.ensure_started(:fettle)

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

  defmodule RouterCustom do
    use Plug.Router
    plug :match
    plug :dispatch

    forward "/__health", to: Fettle.Plug, init_opts: [schema: FettleRouteTest.Schema]
  end

  test "routes to plug, custom settings" do
    conn = conn("GET", "/__health")
    conn = RouterCustom.call(conn, RouterCustom.init([]))
    {200, _headers, body} = sent_resp(conn)
    assert body == Poison.encode!(%{"schema" => "FettleRouteTest.Schema", "count" => 1})
  end

end
