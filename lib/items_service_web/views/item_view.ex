defmodule ItemsServiceWeb.ItemView do
  use ItemsServiceWeb, :view
  alias ItemsServiceWeb.ItemView
  alias ItemsService.Items.Image
  def render("pong.json", _items) do
    %{data: "pong"}
  end

  def render("index.json", %{items: items}) do
    %{data: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{data: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name,
      long: item.long,
      lat: item.lat,
      taken: item.taken,
      image_url: Image.url({item.image, item}, :signed)
    }
  end
end
