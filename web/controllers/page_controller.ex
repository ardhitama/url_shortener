defmodule UrlShortener.PageController do
  use UrlShortener.Web, :controller

  def call(conn, opts) do
    try do
      super(conn, opts)
    rescue
      _ in UndefinedFunctionError -> conn |> put_status(404) |> json %{"code" => -1000, "message" => "resource not found", "data" => [404]}
      _ in Phoenix.MissingParamError -> conn |> put_status(400) |> json %{"code" => -1001, "message" => "request criteria not met", "data" => [400]}
      _ in Phoenix.ActionClauseError -> conn |> put_status(400) |> json %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
      _ in Ecto.NoResultsError -> conn |> put_status(404) |> json %{"code" => -1001, "message" => "resource not found", "data" => [404]}
      _ in _ -> conn |> put_status(500) |> json %{"code" => -2000, "message" => "error", "data" => [500]}
    end
  end

  def get_real_url conn, %{"short_url" => short_url} do

    existing_url = Repo.get_by UrlShortener.Url, short_url: short_url
    if is_nil(existing_url) do
      conn = put_status conn, 404
      json conn, %{"code" => -1000, "message" => "resource not found", "data" => [404]}
    else
      real_url = existing_url.real_url
      conn = put_status conn, 200
      json conn, %{"code" => 0, "message" => "success", "data" => ["#{real_url}"]}
    end
  end

  def shorten_url conn, %{"url" => url} do
    base_url = "https://www.short.net/"
    sanitized_url = UrlShortener.Util.sanitize url

    existing_url = Repo.get_by UrlShortener.Url, real_url: sanitized_url
    if is_nil(existing_url) do
      new_url = Repo.insert! %UrlShortener.Url{real_url: sanitized_url}
      short_url = UrlShortener.Util.gen_url new_url.id

      new_url = Ecto.Changeset.change new_url, short_url: short_url
      new_url = Repo.update! new_url

      conn = put_status conn, 201
      json conn, %{"code" => 1, "message" => "created", "data" => ["#{base_url <> short_url}"]}
    else
      existing_url = Repo.get_by! UrlShortener.Url, real_url: sanitized_url
      short_url = UrlShortener.Util.gen_url existing_url.id
      conn = put_status conn, 200
      json conn, %{"code" => 0, "message" => "existed", "data" => ["#{base_url <> short_url}"]}
    end

  end
end
