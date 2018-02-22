## v1.0.0

* Added `path_info` parameter for simple path matching in `Fettle.Plug`.
* Breaking changes:
    * Matches by default on `/__health`, use `path_info` to override.
    * Requires Elixir 1.5+, Fettle 1.x
