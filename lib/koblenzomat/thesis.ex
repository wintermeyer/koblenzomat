defmodule Koblenzomat.Thesis do
  @moduledoc """
  The Thesis schema represents a single statement or question within an election.

  Each thesis belongs to an election and can be associated with multiple hashtags for categorization.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "theses" do
    field :name, :string
    field :position, :integer
    belongs_to :election, Koblenzomat.Election, type: :binary_id
    many_to_many :hashtags, Koblenzomat.Hashtag, join_through: "hashtags_to_theses"
    timestamps(type: :utc_datetime)
  end

  @doc """
  Returns a changeset for creating or updating a thesis.

  ## Parameters
    - thesis: the %Thesis{} struct
    - attrs: a map of attributes to update (must include :name, :position, :election_id)

  ## Returns
    - %Ecto.Changeset{}
  """
  def changeset(thesis, attrs) do
    thesis
    |> cast(attrs, [:name, :position, :election_id])
    |> validate_required([:name, :position, :election_id])
    |> unique_constraint(:name)
    |> unique_constraint(:position, name: :theses_election_id_position_index)
  end
end
