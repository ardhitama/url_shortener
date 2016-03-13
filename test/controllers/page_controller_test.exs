defmodule UrlShortener.PageControllerTest do
  use UrlShortener.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "POST /api/shorten_url - new url", %{conn: conn} do
    conn = post conn, "/api/shorten_url", %{ :url => "https://www.example.com"}
    assert json_response(conn, 201) == ~s({code:1, message:"created", data:["https://www.short.net/1"]})
  end

  test "POST /api/shorten_url - new url2", %{conn: conn} do
    conn = post conn, "/api/shorten_url", %{ :url => "https://www.example.com"}
    conn = post conn, "/api/shorten_url", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 201) == ~s({code:1, message:"created", data:["https://www.short.net/2"]})
  end

  test "POST /api/shorten_url - same url", %{conn: conn} do
    conn = post conn, "/api/shorten_url", %{ :url => "https://www.example2.com"}
    conn = post conn, "/api/shorten_url", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 200) == ~s({code:0, message:"existed", data:["https://www.short.net/1"]})
  end

end
