defmodule Koblenzomat.HashtagsToTheses do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "hashtags_to_theses" do
    field :thesis_id, :binary_id
    field :hashtag_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(hashtags_to_theses, attrs) do
    hashtags_to_theses
    |> cast(attrs, [])
    |> validate_required([])
  end
end
