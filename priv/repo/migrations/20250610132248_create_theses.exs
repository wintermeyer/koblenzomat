defmodule Koblenzomat.Repo.Migrations.CreateTheses do
  use Ecto.Migration

  def change do
    create table(:theses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :position, :integer, null: false

      add :election_id,
          references(:elections, type: :binary_id, on_delete: :delete_all),
          null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:theses, [:name])
    create index(:theses, [:election_id])

    create unique_index(:theses, [:election_id, :position],
             name: :theses_election_id_position_index
           )
  end
end
