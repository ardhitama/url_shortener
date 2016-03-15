defmodule UrlShortener.PageControllerTest do
  use UrlShortener.ConnCase

  test "GET / - 404", %{conn: conn} do
    conn = get conn, "/"
    assert json_response(conn, 404) == %{"code" => -1000, "message" => "resource not found", "data" => [404]}
  end

  test "POST / - new url", %{conn: conn} do
    conn = post conn, "/", %{ :url => "https://www.example.com"}
    assert json_response(conn, 201) == %{"code" => 1, "message" => "created", "data" => ["https://www.short.net/1"]}
  end

  test "POST / - new url2", %{conn: conn} do
    conn = post conn, "/", %{ :url => "https://www.example.com"}
    conn = post conn, "/", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 201) == %{"code" => 1, "message" => "created", "data" => ["https://www.short.net/2"]}
  end

  test "POST / - same url", %{conn: conn} do
    conn = post conn, "/", %{ :url => "https://www.example2.com"}
    conn = post conn, "/", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 200) == %{"code" => 0, "message" => "existed", "data" => ["https://www.short.net/1"]}
  end

  test "POST / - 404", %{conn: conn} do
    conn = post conn, "/32", %{ :url => "https://www.example2.com"}
    assert json_response(conn, 404) == %{"code" => -1000, "message" => "resource not found", "data" => [404]}
  end

  test "POST / - 400", %{conn: conn} do
    conn = post conn, "/", %{ :url2 => "https://www.example2.com"}
    assert json_response(conn, 400) == %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
  end

  test "POST / - 400 no param", %{conn: conn} do
    conn = post conn, "/", %{}
    assert json_response(conn, 400) == %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
  end

  test "POST / - 400 empty body", %{conn: conn} do
    conn = post conn, "/"
    assert json_response(conn, 400) == %{"code" => -1002, "message" => "request criteria not met", "data" => [400]}
  end

  test "GET /1 - expand url", %{conn: conn} do
    conn = post conn, "/", %{ :url => "https://www.example.com"}
    conn = get conn, "/1"
    assert json_response(conn, 200) == %{"code" => 0, "message" => "success", "data" => ["https://www.example.com"]}
  end

  test "GET / - 404", %{conn: conn} do
    conn = get conn, "/"
    assert json_response(conn, 404) == %{"code" => -1000, "message" => "resource not found", "data" => [404]}
  end
end
