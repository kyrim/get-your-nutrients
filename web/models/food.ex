defmodule GetYourNutrients.Food do
  use GetYourNutrients.Web, :model

  @primary_key {:food_id, :string, []}
  @derive {Phoenix.Param, key: :food_id}
  schema "foods" do
    # 200-character description of food item.
    field :long_description, :string

    # 60-character abbreviated description of food item. Generated from
    # the 200-character description using abbreviations in Appendix A.
    # If short description is longer than 60 characters,
    # additional abbreviations are made.
    field :short_description, :string

    # Other names commonly used to describe a food, including local or
    # regional names for various foods, for example,
    # “soda” or “pop” for “carbonated beverages.”
    field :common_name, :string
    
    # Indicates the company that manufactured the product, when appropriate.
    field :manufacturer_name, :string

    # Indicates if the food item is used in the USDA Food and Nutrient Database
    # for Dietary Studies (FNDDS) and thus has a complete nutrient profile
    # for the 65 FNDDS nutrients.
    field :survey, :string

    # Description of inedible parts of a food item (refuse), such as seeds or bone.
    field :refuse_description, :string

    # Percentage of refuse.
    field :refuse_percentage, :integer

    # Scientific name of the food item. Given for the least processed form
    # of the food (usually raw), if applicable.
    field :scientific_name, :string

    # Factor for converting nitrogen to protein
    field :nitrogen_factor, :float

    # Factor for calculating calories from protein
    field :protein_factor, :float

    # Factor for calculating calories from fat
    field :fat_factor, :float

    # Factor for calculating calories from carbohydrate
    field :carbohydrate_factor, :float

    has_one :food_group, FoodGroup    

    timestamps()
  end 

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:food_id, :long_description, :short_description, :common_name, :manufacturer_name, :survey, :refuse_description, :refuse_percentage, :scientific_name, :nitrogen_factor, :protein_factor, :fat_factor, :carbohydrate_factor])
    |> validate_required([:food_id, :long_description, :short_description, :common_name, :manufacturer_name, :survey, :refuse_description, :refuse_percentage, :scientific_name, :nitrogen_factor, :protein_factor, :fat_factor, :carbohydrate_factor])
  end
end
