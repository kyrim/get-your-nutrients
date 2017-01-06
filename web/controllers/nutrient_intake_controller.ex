defmodule GetYourNutrients.NutrientIntakeController do
  use GetYourNutrients.Web, :controller
  alias GetYourNutrients.NutrientIntake
  alias GetYourNutrients.Nutrient

    def index(conn, params) do

        nutrient_intakes = 
          Repo.all from ni in NutrientIntake,
            join: n in Nutrient,
                 on: ni.nutrient_id == n.id,
            select: %{
                id: n.id, 
                name: n.name, 
                description: ni.description, 
                daily_intake: ni.daily_intake, 
                low_intake_amount: ni.low_intake_amount,
                low_intake_description: ni.low_intake_description,
                high_intake_amount: ni.high_intake_amount,
                high_intake_description: ni.high_intake_description,
                unit_of_measure: n.unit_of_measure,
                type: ni.type }

    render(conn, "index.json", nutrient_intakes: nutrient_intakes)
  end
end