defmodule UrlShortener.PageController do
  use UrlShortener.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
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
      json conn, ~s({code:1, message:"created", data:["#{base_url <> short_url}"]})
    else
      ok ->
      existing_url = Repo.get_by! UrlShortener.Url, real_url: sanitized_url
      short_url = UrlShortener.Util.gen_url existing_url.id
      conn = put_status conn, 200
      json conn, ~s({code:0, message:"existed", data:["#{base_url <> short_url}"]})

    end
    #
    # put_status conn, 500
    # json conn, ~s({code:-1, message:"error", data:[]})

  end
end
