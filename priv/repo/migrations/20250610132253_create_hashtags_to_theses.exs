defmodule Koblenzomat.Repo.Migrations.CreateHashtagsToTheses do
  use Ecto.Migration

  def change do
    create table(:hashtags_to_theses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :thesis_id, references(:theses, on_delete: :nothing, type: :binary_id)
      add :hashtag_id, references(:hashtags, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:hashtags_to_theses, [:thesis_id])
    create index(:hashtags_to_theses, [:hashtag_id])
    create unique_index(:hashtags_to_theses, [:thesis_id, :hashtag_id])
  end
end
