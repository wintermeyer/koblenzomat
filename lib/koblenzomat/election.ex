defmodule Koblenzomat.Election do
  @moduledoc """
  The Election schema represents a single election event in the system.

  Each election can have many associated theses (questions/statements) that users interact with.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "elections" do
    field :name, :string
    has_many :theses, Koblenzomat.Thesis

    timestamps(type: :utc_datetime)
  end

  @doc """
  Returns a changeset for creating or updating an election.

  ## Parameters
    - election: the %Election{} struct
    - attrs: a map of attributes to update

  ## Returns
    - %Ecto.Changeset{}
  """
  def changeset(election, attrs) do
    election
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
