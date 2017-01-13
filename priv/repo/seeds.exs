defmodule GetYourNutrients.DatabaseSeeder do
  alias GetYourNutrients.Repo
  alias GetYourNutrients.FoodGroup
  alias GetYourNutrients.Food
  alias GetYourNutrients.Nutrient
  alias GetYourNutrients.FoodNutrient
  alias GetYourNutrients.NutrientIntake

@file_list ["FD_GROUP.txt", "FOOD_DES.txt", "NUTR_DEF.txt", "NUT_DATA.txt"]

  def unzip_food_data_files do 
    files_char_list = 
      @file_list |> Enum.map(&String.to_char_list/1)

    :zip.unzip('./priv/repo/data/sr28asc.zip',
          [{
            :file_list, 
            files_char_list
          }]
      )
  end

  def delete_food_data_files do 
      out_file_list =  @file_list |> Enum.map(&("#{&1}.out"))

      (@file_list ++ out_file_list) |> Enum.each(&File.rm/1)
  end

  def stream_to_indexed_map (row) do
    row 
      |> Stream.with_index
      |> Enum.to_list
      |> Enum.map(fn {a, b} -> {b, a} end)
      |> Enum.into(%{})
  end

  def parse_csv_by_map(csv_file, map_function) do 
      parse_csv(csv_file) 
      |> Enum.map(fn row ->
        row 
          |> stream_to_indexed_map 
          |> map_function.()
      end)
  end

  def clean_file(filename) do 
    File.open!(filename, [:read, :read, {:encoding, :latin1}])
    |> IO.stream(:line)
    |> Stream.map(fn line -> 
      line
        # using Pipe delimter rather than comma due to 
        # use of commas in descriptions
        |> String.replace("^", "|") 
        # not using double quotes due to inches 
        # being displayed as double quotes
        |> String.replace(~s("), "") 
        |> String.replace("~", "") 
      end)
    |> Stream.into(File.stream!(filename <> ".out"))
    |> Stream.run

    File.open!(filename <> ".out", [:read, :read, {:encoding, :latin1}])
    |> IO.stream(:line)
  end

  def parse_csv(filename) do
      clean_file(filename)
      |> CSV.decode(separator: ?|)
  end 


  def parse_food_groups do
    parse_csv_by_map("FD_GROUP.txt", &(
        %{
          id: &1[0],
          description: &1[1]
        }
    ))
  end

  def parse_foods do
    parse_csv_by_map("FOOD_DES.txt", &(
        %{
          id: &1[0],
          food_group_id: &1[1],
          long_description: &1[2],
          short_description: &1[3],
          common_name: &1[4],
          manufacturer_name: &1[5],
          survey: &1[6],
          refuse_description: &1[7],
          refuse: &1[8],
          scientific_name: &1[9],
          nitrogen_factor: &1[10],
          protein_factor: &1[11],
          fat_factor: &1[12],
          carbohydrate_factor: &1[13]
        }
    ))
  end

  def parse_nutrient_descriptions do
    parse_csv_by_map("NUTR_DEF.txt", &(
        %{
          id: &1[0],
          unit_of_measure: &1[1],
          tag_name: &1[2],
          description: &1[3],
          precision: &1[4],
          sort_order: &1[5]
         }
    ))
  end

  def parse_nutrients do
    parse_csv_by_map("NUT_DATA.txt", &(
        %{
          food_id: &1[0],
          nutrient_description_id: &1[1],
          amount: &1[2],
          number_of_data_points: &1[3],
          standard_error: &1[4],
          source_code: &1[5],
          derivation_code: &1[6],
          reference_food_id: &1[7],
          added_nutritional_mark: &1[8],
          number_of_studies: &1[9],
          minimum: &1[10],
          maximum: &1[11],
          degree_of_freedom: &1[12],
          lower_error_bound: &1[13],
          upper_error_bound: &1[14],
          statistical_comments: &1[15],
          data_last_added: &1[16],
          confidence_code: &1[17]
        }
    ))
  end

  def parse_nutrient_intakes do
    csv = File.stream!("./priv/repo/data/nutrient-intake.csv")
     |> CSV.decode(headers: true)
     |> Enum.to_list

      csv
  end

  def create_nutrient_intakes(nutrient_intakes, nutrient_description_map) do
    nutrient_intakes
     |> Enum.map(fn nutrient_intake -> 
          Repo.insert!(
              %NutrientIntake{
                description: nutrient_intake["description"],
                daily_intake: nutrient_intake["daily_intake"] |> parse_string_float,
                low_intake_amount: nutrient_intake["low_intake_amount"] |> parse_string_float,
                low_intake_description: nutrient_intake["low_intake_description"],
                high_intake_amount: nutrient_intake["high_intake_amount"] |> parse_string_float,
                high_intake_description: nutrient_intake["high_intake_description"],
                type: nutrient_intake["type"],
                nutrient_id: nutrient_description_map[nutrient_intake["nutrient_id"]],
           })
       end)
  end

  def create_food_groups(food_groups) do
    food_groups 
      |> Enum.map(fn food_group -> 
        inserted =
                Repo.insert!(
                  %FoodGroup{
                    description: food_group.description
                })

        {food_group.id, inserted.id}

        end)
        |> Enum.into(%{})
  end

  def create_foods(foods, food_groups_map) do
    foods 
      |> Enum.map(fn food ->

        inserted = Repo.insert!(
                %Food{
                    name: food.long_description,
                    protein_factor: food.protein_factor |> parse_string_float,
                    fat_factor: food.fat_factor |> parse_string_float,
                    carbohydrate_factor: food.carbohydrate_factor |> parse_string_float,
                    food_group_id: food_groups_map[food.food_group_id]
                })
        
        {food.id, inserted.id}
        end)
        |> Enum.into(%{})
  end

  def create_nutrients(nutrient_descriptions) do
    nutrient_descriptions 
      |> Enum.map(fn nutrient_description -> 
        inserted =
                Repo.insert! %Nutrient{
                  name: nutrient_description.description,
                  unit_of_measure: nutrient_description.unit_of_measure,
                }
        {nutrient_description.id, inserted.id}
        end)
        |> Enum.into(%{})
  end

  def create_food_nutrients(nutrients, foods_map, nutrients_map) do
    max_parameter_size = 65535
    chunk_amount = round(max_parameter_size / 5)

     nutrients 
      |> Enum.map(fn nutrient -> 
            nutrient_amount = parse_string_float (nutrient.amount)

            [
              # Dividing by 100 because it is per 100 grams.
              # It's much easier to calculate per gram.
              amount: (if (nutrient_amount == nil), do: nil, else: (nutrient_amount / 100)),
              food_id: foods_map[nutrient.food_id],
              nutrient_id: nutrients_map[nutrient.nutrient_description_id],
              inserted_at: Ecto.DateTime.utc,
              updated_at: Ecto.DateTime.utc
            ]
      end)
      |> Enum.chunk(chunk_amount)
      |> Enum.each(&(Repo.insert_all(FoodNutrient, &1)))
  end

  def clear do
    Repo.delete_all(FoodNutrient)
    Repo.delete_all(NutrientIntake)
    Repo.delete_all(Nutrient)
    Repo.delete_all(Food)
    Repo.delete_all(FoodGroup)
  end

  def parse_string_float(float) when is_nil(float) do
     nil 
  end

  def parse_string_float("") do
     nil 
  end

  def parse_string_float(float) do 
    float |> Float.parse |> elem(0) 
  end

  def run do
    IO.puts "Starting to seed database"

    IO.puts "Clearing old databases"
    clear

    IO.puts "Deleting old food data files and unzipping new ones"
    delete_food_data_files
    unzip_food_data_files

    IO.puts "Creating nutrients"
    nutrients_map = parse_nutrient_descriptions |> create_nutrients

    IO.puts "Creating nutrient intakes"
    parse_nutrient_intakes |> create_nutrient_intakes(nutrients_map)

    IO.puts "Creating food groups"
    food_group_map = parse_food_groups |> create_food_groups

    IO.puts "Creating foods"
    foods_map = parse_foods |> create_foods(food_group_map)

    IO.puts "Creating food nutrients"
    parse_nutrients |> create_food_nutrients(foods_map, nutrients_map)

    IO.puts "deleting food data files"
    delete_food_data_files

    IO.puts "Done seeding database"
  end

end

GetYourNutrients.DatabaseSeeder.run

