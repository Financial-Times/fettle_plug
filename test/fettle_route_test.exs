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

  defmodule Router do
    use Plug.Router
    plug :match
    plug :dispatch

    forward "/__health", to: Fettle.Plug, init_opts: [schema: FettleRouteTest.Schema]
  end

  test "routes to plug" do
    conn = conn("GET", "/__health")
    conn = Router.call(conn, Router.init([]))
    {status, headers, body} = sent_resp(conn)
    assert body == Poison.encode!(%{"schema" => "FettleRouteTest.Schema", "count" => 1})
  end

end
