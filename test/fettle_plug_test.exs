defmodule FettlePlugTest do
  use ExUnit.Case
  use Plug.Test

  setup do
    :ok = Application.ensure_started(:plug)
    {:ok, _pid} = start_supervised(Fettle.Supervisor)
    Application.put_env(:plug, :validate_header_keys_during_test, true)
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

    assert config == {[], Foo}
  end

  test "options accepts path_info key" do
    config = Fettle.Plug.init(path_info: ["__foo"])

    assert config == {["__foo"], nil}
  end

  test "options accepts empty options" do
    config = Fettle.Plug.init([])

    assert config == {[], nil}
  end

    test "reports (with default schema)" do
    config = Fettle.Plug.init([])
    conn = conn("GET", "/")

    conn = Fettle.Plug.call(conn, config)
    assert Regex.match?(~r/"systemCode":"fettle_plug"/, conn.resp_body), conn.resp_body
    assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers
    assert {"cache-control", "no-store"} in conn.resp_headers
  end

  test "reports (with custom schema)" do
    config = Fettle.Plug.init([schema: TestSchema])
    conn = conn("GET", "/")

    conn = Fettle.Plug.call(conn, config)
    assert conn.resp_body == ~s({"status":"OK"})
    assert {"content-type", "application/json; charset=utf-8"} in conn.resp_headers
    assert {"cache-control", "no-store"} in conn.resp_headers
  end
end
