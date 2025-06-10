defmodule Koblenzomat.Repo.Migrations.CreateQuestionnaires do
  use Ecto.Migration

  def change do
    create table(:questionnaires, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:questionnaires, [:name])
  end
end
