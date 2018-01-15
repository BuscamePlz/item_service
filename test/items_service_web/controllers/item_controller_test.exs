defmodule ItemsServiceWeb.ItemControllerTest do
  use ItemsServiceWeb.ConnCase

  alias ItemsService.Items
  alias ItemsService.Items.Item
  test_photo_path = "test/support/test_photo.jpg"
  image_upload = %Plug.Upload{path: Path.relative_to_cwd(test_photo_path), filename: Path.basename(test_photo_path)}

  @create_attrs %{lat: 120.5, long: 120.5, name: "some name", taken: true, image: image_upload}
  @update_attrs %{lat: 456.7, long: 456.7, name: "some updated name", taken: false, image: image_upload}
  @invalid_attrs %{lat: nil, long: nil, name: nil, taken: nil, image: nil}

  def fixture(:item) do
    {:ok, item} = Items.create_item(@create_attrs)
    item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all items", %{conn: conn} do
      conn = get conn, item_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create item" do
    test "renders item when data is valid", %{conn: conn} do
      conn = put_req_header(conn, "content-type", "multipart/form-data")
      conn = post conn, item_path(conn, :create), item: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, item_path(conn, :show, id)
      resp = json_response(conn, 200)
      assert resp["data"]["name"] == "some name"
      assert resp["data"]["taken"] == true
      assert resp["data"]["image_url"] =~ ~r"/uploads/test_photo.jpg"
      assert resp["data"]["long"] == 120.5
      assert resp["data"]["lat"] == 120.5
      assert resp["data"]["id"] == id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when duplicate is POSTed", %{conn: conn} do
      post conn, item_path(conn, :create), item: @create_attrs
      conn = post conn, item_path(conn, :create), item: @create_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

  end

  describe "update item" do
    setup [:create_item]

    test "renders item when data is valid", %{conn: conn, item: %Item{id: id} = item} do
      conn = put_req_header(conn, "content-type", "multipart/form-data")
      conn = put conn, item_path(conn, :update, item), item: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, item_path(conn, :show, id)
      resp = json_response(conn, 200)
      assert resp["data"]["name"] == "some updated name"
      assert resp["data"]["taken"] == false
      assert resp["data"]["image_url"] =~ ~r"/uploads/test_photo.jpg"
      assert resp["data"]["long"] == 456.7
      assert resp["data"]["lat"] == 456.7
      assert resp["data"]["id"] == id
    end

    test "renders errors when data is invalid", %{conn: conn, item: item} do
      conn = put conn, item_path(conn, :update, item), item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete conn, item_path(conn, :delete, item)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, item_path(conn, :show, item)
      end
    end
  end

  defp create_item(_) do
    item = fixture(:item)
    {:ok, item: item}
  end
end
