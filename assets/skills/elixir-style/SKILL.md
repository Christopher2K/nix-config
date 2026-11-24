---
name: Elixir Style
description: Use when writing, editing, or reviewing Elixir code according to the user's typespec-heavy, concisely documented, ok/error tuple style.
---

# Elixir Style

Apply these rules to code you create or edit. Do not rewrite unrelated code, generated files, or dependencies.

## Typespecs

- Add a `@spec` to every public function, and to private functions when the types are not obvious.
- Define a `@type t` for every struct, and add named `@type` aliases for shared or composite shapes.
- Prefer precise types (`String.t()`, `pos_integer()`, `Ecto.UUID.t()`, literal atoms) over `any()` or `term()`.
- Use `@typedoc` for public types whose meaning is not obvious from the name.
- Declare `@callback` specs for every behaviour callback.
- Keep specs correct; run `mix dialyzer` when it is available.

## Documentation

- Give every public module a `@moduledoc` and every public function a `@doc`.
- Keep each to one short sentence describing what it does.
- Explain semantics; do not repeat the function name or restate the spec.
- Never write doctests or `iex>` examples in docs; put tests in `test/`.
- Use `@moduledoc false` only for internal modules not meant to be used directly.
- Do not add `@doc` to private functions; use a short comment only when behavior is not obvious.

## Return values

- Return `{:ok, data}` or `{:error, reason}` from any function that can fail or has side effects.
- Prefer `{:ok, data}` even for operations that currently always succeed when they belong to a workflow, so they compose in `with` chains and saga steps.
- Return `{:ok, data}` instead of a bare `:ok` when there is a meaningful result to pass to the next step.
- Use structured error reasons (atoms, tagged tuples, or changesets), never raw strings.
- Offer bang (`!`) variants only as thin wrappers that raise on `{:error, _}`.
- Compose fallible steps with `with`; do not nest `case` statements.
- Keep pure, infallible helpers (formatting, calculations, predicates) returning plain values.

## Example

```elixir
defmodule Signet.Accounts.Account do
  @moduledoc "User account with its current status."

  use Ecto.Schema

  @typedoc "Current account state."
  @type status :: :active | :disabled

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          status: status(),
          expires_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "accounts" do
    field :status, Ecto.Enum, values: [:active, :disabled]
    field :expires_at, :utc_datetime
  end
end
```

```elixir
defmodule Signet.Accounts do
  @moduledoc "Account lifecycle operations."

  alias Signet.Accounts.Account
  alias Signet.Repo

  @type error :: {:error, :not_found | :already_disabled | Ecto.Changeset.t()}

  @doc "Fetches an account by id."
  @spec fetch_account(Ecto.UUID.t()) :: {:ok, Account.t()} | {:error, :not_found}
  def fetch_account(id) do
    case Repo.get(Account, id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  @doc "Disables an active account."
  @spec disable_account(Ecto.UUID.t()) :: {:ok, Account.t()} | error()
  def disable_account(id) do
    with {:ok, account} <- fetch_account(id),
         :ok <- ensure_active(account) do
      account
      |> Ecto.Changeset.change(status: :disabled)
      |> Repo.update()
    end
  end

  @spec ensure_active(Account.t()) :: :ok | {:error, :already_disabled}
  defp ensure_active(%Account{status: :active}), do: :ok
  defp ensure_active(%Account{}), do: {:error, :already_disabled}
end
```
