defmodule ItemsService.Repo.Migrations.AddUniqueConstraintOnItems do
  use Ecto.Migration

  def change do
    create unique_index(:items, [:lat, :long, :name], name: :item_identity_ix)
  end
end
