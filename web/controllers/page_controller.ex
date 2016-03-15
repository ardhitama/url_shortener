defmodule UrlShortener.PageController do
  use UrlShortener.Web, :controller

  def call(conn, opts) do
    try do
      super(conn, opts)
    rescue
      e in UndefinedFunctionError -> conn |> put_status(404) |> json %{"code" => -1000, "message" => "resource not found", "data" => [404]}
      e in Phoenix.MissingParamError -> conn |> put_status(400) |> json %{"code" => -1001, "message" => "request criteria not met", "data" => [400]}
      e in Phoenix.ActionClauseError -> conn |> put_status(400) |> json %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
      e in _ -> conn |> put_status(500) |> json %{"code" => -2000, "message" => "error", "data" => [500, e]}
    end
  end

  def get_real_url conn, %{"short_url" => short_url} do
    existing_url = Repo.get_by! UrlShortener.Url, short_url: short_url
    real_url = existing_url.real_url
    conn = put_status conn, 200
    json conn, %{"code" => 0, "message" => "success", "data" => ["#{real_url}"]}

  end

  def shorten_url conn, %{"url" => url} do
    base_url = "https://www.short.net/"
    sanitized_url = UrlShortener.Util.sanitize url

    try do
      existing_url = Repo.get_by! UrlShortener.Url, real_url: sanitized_url
    rescue
      Ecto.NoResultsError ->
      new_url = Repo.insert! %UrlShortener.Url{real_url: sanitized_url}
      short_url = UrlShortener.Util.gen_url new_url.id

      new_url = Ecto.Changeset.change new_url, short_url: short_url
      new_url = Repo.update! new_url

      conn = put_status conn, 201
      json conn, %{"code" => 1, "message" => "created", "data" => ["#{base_url <> short_url}"]}
    else
      ok ->
      existing_url = Repo.get_by! UrlShortener.Url, real_url: sanitized_url
      short_url = UrlShortener.Util.gen_url existing_url.id
      conn = put_status conn, 200
      json conn, %{"code" => 0, "message" => "existed", "data" => ["#{base_url <> short_url}"]}

    end

  end
end
