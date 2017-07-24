# Fettle Plug

Plug support for [Fettle](https://github.com/Financial-Times/fettle) health-checks.

[![Hex pm](http://img.shields.io/hexpm/v/fettle_plug.svg?style=flat)](https://hex.pm/packages/fettle_plug) [![Inline docs](http://inch-ci.org/github/Financial-Times/fettle_plug.svg)](http://inch-ci.org/github/Financial-Times/fettle_plug) [![Build Status](https://travis-ci.org/Financial-Times/fettle_plug.svg?branch=master)](https://travis-ci.org/Financial-Times/fettle_plug)

## Getting Started

### Installation

```elixir
def deps do
  [
    {:fettle_plug, "~> 0.1"}
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

In your `Plug` pipeline (`Phoenix.Endpoint` etc.), forward to
the `Fettle.Plug` module to serve your results from your desired URL:

Plug example:

```elixir
use Plug.Router
plug :match
plug :dispatch

forward "/__health", to: Fettle.Plug, init_opts: [schema: Fettle.Schema.FTHealthCheckV1]
```

In a Phoenix `Router`, it's pretty much the same:

```elixir
forward "/__health", Fettle.Plug, schema: Fettle.Schema.FTHealthCheckV1
```

> Note in both examples above, the specification of the `schema` is **optional**,
since `Fettle.Schema.FTHealthCheckV1` is the default.

