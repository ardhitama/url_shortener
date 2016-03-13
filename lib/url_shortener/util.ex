defmodule UrlShortener.Util do

  @spec gen_url(integer) :: String.t
  def gen_url(num) do
    Integer.to_string num, 32
  end

  @spec sanitize(String.t) :: String.t
  def sanitize(url) do
    url = String.replace(url, ~r/\s/, "")
  end

end
