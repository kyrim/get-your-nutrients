defmodule GetYourNutrients.PageController do
  use GetYourNutrients.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
