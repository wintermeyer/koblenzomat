defmodule Koblenzomat.Repo.Migrations.CreateHashtags do
  use Ecto.Migration

  def change do
    create table(:hashtags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:hashtags, [:name])
  end
end
