defmodule GetYourNutrients.DatabaseSeeder do
   alias GetYourNutrients.Repo
#   alias GetYourNutrients.FoodGroup
#   alias GetYourNutrients.Food
#   alias GetYourNutrients.NutrientDescription
#   alias GetYourNutrients.NutrientIntake
#   alias GetYourNutrients.Nutrient
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
          foodgroup_id: &1[1],
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
          units_of_measure: &1[1],
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

  # def insert_food_group(foodGroup) do
  #   # Repo.insert! %FoodGroup{
  #   #   title: (@titles_list |> Enum.take_random),
  #   #   url: (@urls_list |> Enum.take_random)
  #   # }
  # end

  def clear do
    Repo.delete_all
  end

end

defmodule Parallel do
  def map(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end

IO.puts "Starting to seed database"

IO.puts "Deleting old food data files"
GetYourNutrients.DatabaseSeeder.delete_food_data_files

IO.puts "Unziping food data files"
GetYourNutrients.DatabaseSeeder.unzip_food_data_files

IO.puts "Parsing food groups"
food_groups = GetYourNutrients.DatabaseSeeder.parse_food_groups

IO.puts "Parsing foods"
foods = GetYourNutrients.DatabaseSeeder.parse_foods

IO.puts "parsing nutrient descriptions"
nutrient_descriptions = GetYourNutrients.DatabaseSeeder.parse_nutrient_descriptions

IO.puts "parsing nutrients"
nutrients = GetYourNutrients.DatabaseSeeder.parse_nutrients

IO.puts "deleting old food data files"
GetYourNutrients.DatabaseSeeder.delete_food_data_files

IO.puts "Done seeding database"

# (1..100) |> Enum.each(fn _ -> <%= application_name %>.DatabaseSeeder.insert_link end)