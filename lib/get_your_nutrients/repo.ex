defmodule GetYourNutrients.Repo do
  use Ecto.Repo, otp_app: :get_your_nutrients

    def set_limit(conn, limit) do
    {:ok, _result} = Postgrex.query(conn, "SELECT set_limit(0.2);", [])
  end
end
