defmodule Koblenzomat.Questionnaire do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "questionnaires" do
    field :name, :string
    has_many :theses, Koblenzomat.Thesis

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(questionnaire, attrs) do
    questionnaire
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
