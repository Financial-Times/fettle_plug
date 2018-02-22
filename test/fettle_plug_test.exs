defmodule FettlePlugTest do
  use ExUnit.Case
  use Plug.Test

  setup do
    :ok = Application.ensure_started(:plug)
    Application.put_env(:plug, :validate_header_keys_during_test, true)

    {:ok, _pid} = start_supervised(Fettle.Supervisor)

    :ok
  end

  defmodule TestSchema do
    @behaviour Fettle.Schema
    def to_schema(_config, _checks) do
      %{status: "OK"}
    end
  end

  test "options accepts schema key" do
    config = Fettle.Plug.init(schema: Foo)

    assert {_, Foo} = config
  end

  test "invalid schema key" do
    assert_raise ArgumentError, fn -> Fettle.Plug.init(schema: "Foo") end
  end

  test "options accepts path_info key" do
    config = Fettle.Plug.init(path_info: ["__foo"])

    assert config == {["__foo"], nil}
  end

  test "invalid path_info key" do
    assert_raise ArgumentError, fn -> Fettle.Plug.init(path_info: "__foo") end
  end

  test "options accepts empty options" do
    config = Fettle.Plug.init([])

    assert config == {["__health"], nil}
  end

  test "reports (with default schema)" do
    config = Fettle.Plug.init([])
    conn = conn("GET", "/__health")

    conn = Fettle.Plug.call(conn, config)
    assert Regex.match?(~r/"systemCode":"fettle_plug"/, conn.resp_body), conn.resp_body
    assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers
    assert {"cache-control", "no-store"} in conn.resp_headers
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
