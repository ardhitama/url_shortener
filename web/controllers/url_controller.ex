defmodule UrlShortener.UrlController do
  use UrlShortener.Web, :controller

  alias UrlShortener.Url
  alias UrlShortener.ErrorView

  plug :scrub_params, "url" when action in [:create, :update]
  plug :put_view, UrlShortener.UrlView

  defimpl Plug.Exception, for: Ecto.CastError do
    def status(_exception), do: 404
  end

  defimpl Plug.Exception, for: ArgumentError do
    def status(_exception), do: 400
  end

  def index(conn, _params) do
    urls = Repo.all(Url)
    render(conn, "index.html", urls: urls)
  end

  def new(conn, _params) do
    changeset = Url.changeset(%Url{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    changeset = Url.changeset(%Url{}, url_params)

    case Repo.insert(changeset) do
      {:ok, _url} ->
        conn
        |> put_flash(:info, "Url created successfully.")
        |> redirect(to: url_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Repo.get!(Url, id)
    render(conn, "show.html", url: url)
  end

  def edit(conn, %{"id" => id}) do
    url = Repo.get!(Url, id)
    changeset = Url.changeset(url)
    render(conn, "edit.html", url: url, changeset: changeset)
  end

  def update(conn, %{"id" => id, "url" => url_params}) do
    url = Repo.get!(Url, id)
    changeset = Url.changeset(url, url_params)

    case Repo.update(changeset) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "Url updated successfully.")
        |> redirect(to: url_path(conn, :show, url))
      {:error, changeset} ->
        render(conn, "edit.html", url: url, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    url = Repo.get!(Url, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(url)

    conn
    |> put_flash(:info, "Url deleted successfully.")
    |> redirect(to: url_path(conn, :index))
  end
end
