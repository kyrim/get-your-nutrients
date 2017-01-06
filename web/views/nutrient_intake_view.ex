defmodule GetYourNutrients.NutrientIntakeView do
  use GetYourNutrients.Web, :view

  def render("index.json", %{nutrient_intakes: nutrient_intakes}) do

    IO.inspect nutrient_intakes

    render_many(nutrient_intakes, GetYourNutrients.NutrientIntakeView, "nutrientIntake.json")
  end

  def render("nutrientIntake.json", %{nutrient_intake: nutrient_intake}) do
    %{
      id: nutrient_intake.id,
      name: nutrient_intake.name |> String.split("(") |> Enum.at(0) |> String.split(",") |> Enum.at(0),
      description: nutrient_intake.description,
      dailyIntake: nutrient_intake.daily_intake,
      lowIntakeAmount: nutrient_intake.low_intake_amount,
      lowIntakeDescription: nutrient_intake.low_intake_description,
      highIntakeAmount: nutrient_intake.high_intake_amount,
      highIntakeDescription: nutrient_intake.high_intake_description,
      unitOfMeasure: nutrient_intake.unit_of_measure,
      nutrientType: nutrient_intake.type
    }
  end
end