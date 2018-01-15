defmodule ItemsServiceWeb.Router do
  use ItemsServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json", "form-data"]
  end

  pipe_through :api
  resources "/items", ItemsServiceWeb.ItemController, except: [:new, :edit]
end
