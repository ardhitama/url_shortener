defmodule UrlShortener.PageControllerTest do
  use UrlShortener.ConnCase

  test "POST /api/v1/url/shorten - new url", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example.com"}
    assert json_response(conn, 201) == %{"code" => 1, "message" => "created", "data" => ["https://www.short.net/1"]}
  end

  test "POST /api/v1/url/shorten - new url2", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example.com"}
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 201) == %{"code" => 1, "message" => "created", "data" => ["https://www.short.net/2"]}
  end

  test "POST /api/v1/url/shorten - same url", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example2.com"}
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 200) == %{"code" => 0, "message" => "existed", "data" => ["https://www.short.net/1"]}
  end

  test "POST /api/v1/url/shorten - 404", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten/32", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 404) == %{"code" => -1000, "message" => "resource not found", "data" => [404]}
  end

  test "POST /api/v1/url/shorten - 400", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{ :url2 => "https://www.example2.com"}
    assert json_response(conn, 400) == %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
  end

  test "POST /api/v1/url/shorten - 400 no param", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{}
    assert json_response(conn, 400) == %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
  end

  test "POST /api/v1/url/shorten - 400 empty body", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten"
    assert json_response(conn, 400) == %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
  end

  test "GET /api/v1/url/unshort/0 - 404 expand url not found", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example.com"}
    conn = get conn, "/api/v1/url/unshort/0"
    assert json_response(conn, 404) == %{"code" => -1000, "message" => "resource not found", "data" => [404]}
  end

  test "GET /api/v1/url/unshort/1 - expand url", %{conn: conn} do
    conn = post conn, "/api/v1/url/shorten", %{ :url => "https://www.example.com"}
    conn = get conn, "/api/v1/url/unshort/1"
    assert json_response(conn, 200) == %{"code" => 0, "message" => "success", "data" => ["https://www.example.com"]}
  end

  test "GET /api/v1/url/unshort/ - 404", %{conn: conn} do
    conn = get conn, "/api/v1/url/unshort/"
    assert json_response(conn, 404) == %{"code" => -1000, "message" => "resource not found", "data" => [404]}
  end
end
