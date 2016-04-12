defmodule UrlShortener.Router do
  use UrlShortener.Web, :router
  require Logger

  def call(conn, opts) do
    if Enum.at(conn.path_info, 0) == "api" do
      try do
        super(conn, opts)
      rescue
          _ in Phoenix.Router.NoRouteError -> conn |> put_status(404) |> json %{"code" => -1000, "message" => "resource not found", "data" => [404]}
          _ in UndefinedFunctionError -> conn |> put_status(404) |> json %{"code" => -1000, "message" => "resource not found", "data" => [404]}
          _ in Phoenix.MissingParamError -> conn |> put_status(400) |> json %{"code" => -1001, "message" => "request criteria not met", "data" => [400]}
          _ in Phoenix.ActionClauseError -> conn |> put_status(400) |> json %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
          _ in Sqlite.Ecto.Error -> conn |> put_status(500) |> json %{"code" => -2001, "message" => "db error", "data" => [500]}
          _ in Ecto.NoResultsError -> conn |> put_status(404) |> json %{"code" => -1001, "message" => "resource not found", "data" => [404]}
          e in _ -> conn |> put_status(500) |> json %{"code" => -2000, "message" => "error", "data" => [500, e.reason]}
      end
    else
      super(conn, opts)
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

    resources "/", UrlController
  end

  # Other scopes may use custom stacks.
  scope "/api/v1/url", UrlShortener do
    pipe_through :api
    post "/shorten", PageController, :shorten_url
    get "/unshort/:short_url", PageController, :get_real_url
  end
end
