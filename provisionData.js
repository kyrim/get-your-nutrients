const fs = require('fs');
const AdmZip = require('adm-zip');
const baby = require('babyparse');
const _ = require('lodash');

const fileList = ['FOOD_DES.txt', 'NUTR_DEF.txt', 'NUT_DATA.txt'];
const extraCsvFiles = ['nutrient-intake.csv'];
const temporaryFileExtension = '.out';
const usdaDatabaseZipName = 'sr28asc.zip';

module.exports = function (sourceDataFolder, outputJsonPath) {
    return unzipUsdaDatabaseAndGetContents(sourceDataFolder)
        .then(addExtraCsvFiles)
        .then(parseContents)
        .then(createJsonFile)
        .then(outputJsonFile(outputJsonPath))
};

// TODO: Make this not part of the string prototype, 
// could cause external library issues
String.prototype.replaceAll = function (find, replace) {
    var str = this;
    return str.replace(new RegExp(find.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'), 'g'), replace);
};

function unzipUsdaDatabaseAndGetContents(sourceDataFolder) {
    return new Promise((resolve, reject) => {

        if (!fs.existsSync(sourceDataFolder)) {
            reject("folder: " + sourceDataFolder + " does not exist");
        }

        var transformedEntries = [];

        var zip = new AdmZip(sourceDataFolder + usdaDatabaseZipName);

        zip.getEntries().forEach(zipEntry => {
            if (fileList.includes(zipEntry.entryName)) {
                // using Pipe delimter rather than comma due to 
                // use of commas in descriptions
                // not using double quotes due to inches 
                // being displayed as double quotes
                var fileContents = zipEntry.getData().toString('utf8').replaceAll('^', '|').replaceAll('"', '').replaceAll('~', '');

                transformedEntries.push({
                    name: zipEntry.entryName,
                    delimiter: '|',
                    header: false,
                    content: fileContents
                });
            }
        });

        resolve({ transformedEntries, sourceDataFolder });
    });
}

function addExtraCsvFiles({ transformedEntries, sourceDataFolder }) {
    return new Promise((resolve, reject) => {

        var count = 1;

        // Deep copy
        var newEntries = transformedEntries.map(x => Object.assign({}, x));

        extraCsvFiles.forEach(csvFile => {
            fs.readFile(sourceDataFolder + csvFile, 'utf8', function (err, data) {
                if (err) reject(err);
                newEntries.push({
                    name: csvFile,
                    delimiter: ',',
                    header: true,
                    content: data
                });
                if (extraCsvFiles.length === count++) resolve(newEntries);
            });
        });
    });
}

function parseContents(transformedEntries) {
    return new Promise((resolve, reject) => {
        var csvParsedEntries = transformedEntries.map(entry => ({
            name: entry.name,
            content: baby.parse(entry.content,
                {
                    delimiter: entry.delimiter,
                    header: entry.header
                }).data
        }));

        resolve(csvParsedEntries);
    });
}

function parseFoodNutrients(foodNutrientsContent) {
    var foodNutrients = {};
    // We want to group all food nutrients by their food id
    // so that itll be easier to access when constructing
    // the foods.
    foodNutrientsContent.forEach(foodNutrientContent => {
        var foodId = foodNutrientContent[0];

        if (!(foodId in foodNutrients)) foodNutrients[foodId] = [];

        var amountFromCsv = parseFloat(foodNutrientContent[2]) / 100;
        if (amountFromCsv === 0) return;

        foodNutrients[foodId].push({
            nutrientId: foodNutrientContent[1],
            // Dividing by 100 because amount is per 100 grams. 
            // It's much easier to calculate per gram.
            amount: amountFromCsv
        })
    });

    return foodNutrients;
}

function parseFoods(foodsContent, foodNutrientsContent) {

    var foodNutrients = parseFoodNutrients(foodNutrientsContent);
    var foods = [];

    foodsContent.forEach(foodContent => {

        if (!foodContent[2]) return;

        foods.push({
            id: foodContent[0],
            name: foodContent[2],
            foodNutrients: foodNutrients[foodContent[0]] || []
        });
    });

    return foods;
}

function parseNullableFloat(str) {
    if (!str) return null;
    return parseFloat(str);
}

function parseNutrients(nutrientsContent, nutrientIntakesContent) {
    let nutrientIntakes = nutrientIntakesContent.map(nutrientIntake => ({
        id: nutrientIntake['nutrient_id'],
        description: nutrientIntake['description'],
        dailyIntake: parseNullableFloat(nutrientIntake['daily_intake']),
        lowIntakeAmount: parseNullableFloat(nutrientIntake['low_intake_amount']),
        lowIntakeDescription: nutrientIntake['low_intake_description'],
        highIntakeAmount: parseNullableFloat(nutrientIntake['high_intake_amount']),
        highIntakeDescription: nutrientIntake['high_intake_description'],
        nutrientType: nutrientIntake['type']
    }));

    let nutrientsByNutrientId = _.keyBy(nutrientsContent, x => x[0]);

    nutrientIntakes.forEach(nutrientIntake => {
        let nutrient = nutrientsByNutrientId[nutrientIntake.id];
        if (!nutrient) return;

        nutrientIntake['unitOfMeasure'] = nutrient[1];
        nutrientIntake['name'] = nutrient[3];
    });

    return _.filter(nutrientIntakes, x => !!x.id);
}

function createJsonFile(csvParsedEntries) {
    return new Promise((resolve, reject) => {
        var jsonFile = {};

        var foodsContent = [];
        var foodNutrientsContent = []
        var nutrientsContent = [];
        var nutrientIntakesContent = [];

        // This seems a bit gross, should probably pass it in from the top as a
        // object dictionary.
        csvParsedEntries.forEach(entry => {
            if (entry.name === 'FOOD_DES.txt') foodsContent = entry.content;
            if (entry.name === 'NUT_DATA.txt') foodNutrientsContent = entry.content;
            if (entry.name === 'NUTR_DEF.txt') nutrientsContent = entry.content;
            if (entry.name === 'nutrient-intake.csv') nutrientIntakesContent = entry.content;
        });

        var jsonFile = {
            foods: parseFoods(foodsContent, foodNutrientsContent),
            nutrients: parseNutrients(nutrientsContent, nutrientIntakesContent),
        };

        resolve(jsonFile);
    });
};

function outputJsonFile(outputJsonPath) {
    return jsonFile => new Promise((resolve, reject) => {
        var json = JSON.stringify(jsonFile);
        fs.writeFile(outputJsonPath, json, 'utf8', 4);
    });
}