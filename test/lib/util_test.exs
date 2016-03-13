defmodule UrlShortener.UtilTest do
  use ExUnit.Case, async: true

  test "safe url sanitized" do
    assert UrlShortener.Util.sanitize("https://www.ardhitama.com") == "https://www.ardhitama.com"
  end

  test "untrimmed url sanitized" do
    assert UrlShortener.Util.sanitize("    https://www.ardhitama.com  ") == "https://www.ardhitama.com"
  end

  test "whitespaced url sanitized" do
    assert UrlShortener.Util.sanitize("    https://w   ww.a  rdhi  tama.com  ") == "https://www.ardhitama.com"
  end

  test "gen url 1" do
    assert UrlShortener.Util.gen_url(143233) == "4BS1"
  end

  test "gen url 2" do
    assert UrlShortener.Util.gen_url(1) == "1"
  end

  test "gen url 3" do
    assert UrlShortener.Util.gen_url(99999999999999999999999999999999999) == "2D162SM79M12N1SFSVVVVVVV"
  end

  test "gen url 4" do
    assert UrlShortener.Util.gen_url(9999999) == "9H5JV"
  end
end
