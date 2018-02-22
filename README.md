# Fettle Plug

Plug support for [Fettle](https://github.com/Financial-Times/fettle) health-checks.

[![Hex pm](http://img.shields.io/hexpm/v/fettle_plug.svg?style=flat)](https://hex.pm/packages/fettle_plug) [![Inline docs](http://inch-ci.org/github/Financial-Times/fettle_plug.svg)](http://inch-ci.org/github/Financial-Times/fettle_plug) [![Build Status](https://travis-ci.org/Financial-Times/fettle_plug.svg?branch=master)](https://travis-ci.org/Financial-Times/fettle_plug)

## Getting Started

### Installation

```elixir
def deps do
  [
    {:fettle_plug, "~> 1.0"}
  ]
end
```

For the latest (and most unstable) version:

```elixir
def deps do
  [
    {:fettle_plug, github: "Financial-Times/fettle_plug"}
  ]
end
```

`fettle_plug` has a transitive dependency on [`fettle`](https://github.com/Financial-Times/fettle).

### Setup

In your `Plug` pipeline (`Phoenix.Endpoint` etc.), use `Fettle.Plug` to serve your results from your desired URL:

Plug example:

```elixir
use Plug.Router

plug :match

# serve health check results under /__meta/health
plug Fettle.Plug, path_info: ["__meta", "health"]

# other routes
match _, do: send_resp(conn, 404, "Route Not Found\n")

plug :dispatch
```

* `path_info` defaults to `["__health"]`; it may be given as `[]` for use under `forward` etc.
* A `schema` option uses a custom `Fettle.Schema` implementation; `Fettle.Schema.FTHealthCheckV1` is the default.
