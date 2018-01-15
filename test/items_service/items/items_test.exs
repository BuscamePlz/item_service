defmodule ItemsService.ItemsTest do
  use ItemsService.DataCase

  alias ItemsService.Items

  describe "items" do
    alias ItemsService.Items.Item
    test_photo_path = "test/support/test_photo.jpg"
    image_upload = %Plug.Upload{path: Path.relative_to_cwd(test_photo_path), filename: Path.basename(test_photo_path)}

    @valid_attrs %{lat: 120.5, long: 120.5, name: "some name", taken: true, image: image_upload}
    @update_attrs %{lat: 456.7, long: 456.7, name: "some updated name", taken: false, image: image_upload}
    @invalid_attrs %{lat: nil, long: nil, name: nil, taken: nil, image: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Items.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Items.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Items.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Items.create_item(@valid_attrs)
      assert item.lat == 120.5
      assert item.long == 120.5
      assert item.name == "some name"
      assert item.taken == true
      %{file_name: "test_photo.jpg", updated_at: _} = item.image
    end

    test "create_item/1 with duplicate data returns error changeset" do
      Items.create_item(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@valid_attrs)
    end


    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Items.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, item} = Items.update_item(item, @update_attrs)
      assert %Item{} = item
      assert item.lat == 456.7
      assert item.long == 456.7
      assert item.name == "some updated name"
      assert item.taken == false
      %{file_name: "test_photo.jpg", updated_at: _} = item.image

    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Items.update_item(item, @invalid_attrs)
      assert item == Items.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Items.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Items.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Items.change_item(item)
    end
  end
end
