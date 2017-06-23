defmodule FettlePlugTest do
  use ExUnit.Case
  use Plug.Test

  doctest Fettle.Plug

  defmodule TestSchema do
    @behaviour Fettle.Schema
    def to_schema(_config, _checks) do
      %{status: "OK"}
    end
  end

  test "options accepts schema key" do
    config = Fettle.Plug.init(schema: Foo)

    assert config == {Foo}
  end

  test "options accepts empty options" do
    config = Fettle.Plug.init([])

    assert config == {nil}
  end

  test "reports (with custom schema)" do
    config = Fettle.Plug.init([schema: TestSchema])
    conn = conn("GET", "/__health")

    conn = Fettle.Plug.call(conn, config)
    assert conn.resp_body == ~s({"status":"OK"})
    assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers
    assert {"cache-control", "no-store"} in conn.resp_headers
  end
end
