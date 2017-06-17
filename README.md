# Fettle Plug

Plug support for Fettle health-checks.

## Getting Started

### Installation

```elixir
def deps do
  [{:fettle_plug, github: "Financial-Times/fettle_plug"}]
end
```
`fettle_plug` has a transitive dependency on `fettle`.

### Setup

In your `Plug` pipeline (Phoenix Endpoint etc.), install
the `Fettle.Plug` module to serve your results:

```elixir

plug Fettle.Plug, schema: Fettle.Schema.