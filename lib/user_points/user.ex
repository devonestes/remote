defmodule UserPoints.User do
  use Ecto.Schema

  import Ecto.Changeset, only: [cast: 3]

  schema "users" do
    field(:points, :integer)
    timestamps()
  end

  @doc false
  def changeset(), do: changeset(%__MODULE__{}, %{})

  @doc false
  def changeset(%__MODULE__{} = user), do: changeset(user, %{})

  def changeset(attrs), do: changeset(%__MODULE__{}, attrs)

  @doc false
  def changeset(user, attrs) do
    cast(user, attrs, [:points])
  end
end
