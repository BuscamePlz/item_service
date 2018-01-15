defmodule ItemsService.Items.Item do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias ItemsService.Items.Item
  alias ItemsService.Items.Image
  schema "items" do
    field :lat, :float
    field :long, :float
    field :name, :string
    field :taken, :boolean, default: false
    field :image, Image.Type

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:name, :long, :lat, :taken])
    |> cast_attachments(attrs, [:image])
    |> unique_constraint(:identity, name: :item_identity_ix)
    |> validate_required([:name, :long, :lat, :image])
  end
end
