defmodule Koblenzomat.Thesis do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "theses" do
    field :name, :string
    field :position, :integer
    belongs_to :questionnaire, Koblenzomat.Questionnaire, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(thesis, attrs) do
    thesis
    |> cast(attrs, [:name, :position, :questionnaire_id])
    |> validate_required([:name, :position, :questionnaire_id])
    |> unique_constraint(:name)
    |> unique_constraint(:position, name: :theses_questionnaire_id_position_index)
  end
end
