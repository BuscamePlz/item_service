defmodule ItemsService.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :long, :float, null: false
      add :lat, :float, null: false
      add :taken, :boolean, default: false
      add :image, :string, null: false

      timestamps()
    end

  end
end
