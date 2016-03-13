defmodule UrlShortener.Repo.Migrations.CreateUrl do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :real_url, :string
      add :short_url, :string

      timestamps
    end

  end
end
