defmodule GetYourNutrients.SearchFoodControllerTest do
  use GetYourNutrients.ConnCase

  alias GetYourNutrients.SearchFood
  @valid_attrs %{foodId: "some content", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, search_food_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    search_food = Repo.insert! %SearchFood{}
    conn = get conn, search_food_path(conn, :show, search_food)
    assert json_response(conn, 200)["data"] == %{"id" => search_food.id,
      "name" => search_food.name,
      "foodId" => search_food.foodId}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, search_food_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, search_food_path(conn, :create), search_food: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(SearchFood, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, search_food_path(conn, :create), search_food: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    search_food = Repo.insert! %SearchFood{}
    conn = put conn, search_food_path(conn, :update, search_food), search_food: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(SearchFood, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    search_food = Repo.insert! %SearchFood{}
    conn = put conn, search_food_path(conn, :update, search_food), search_food: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    search_food = Repo.insert! %SearchFood{}
    conn = delete conn, search_food_path(conn, :delete, search_food)
    assert response(conn, 204)
    refute Repo.get(SearchFood, search_food.id)
  end
end
