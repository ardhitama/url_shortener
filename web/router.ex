defmodule UrlShortener.Router do
  use UrlShortener.Web, :router

  def call(conn, opts) do
    try do
      super(conn, opts)
    rescue
      e in Phoenix.Router.NoRouteError -> conn |> put_status(404) |> json %{"code" => -1000, "message" => "resource not found", "data" => [404]}
      e in _ -> conn |> put_status(500) |> json %{"code" => -2000, "message" => "error", "data" => [500, e]}
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UrlShortener do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", UrlShortener do
    pipe_through :api
    post "/shorten_url.json", PageController, :shorten_url
  end
end
