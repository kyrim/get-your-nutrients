var express = require('express');
var _ = require('lodash');
var foods = require('./data/foods.json');

var app = express();

var foodById = _.keyBy(foods, food => food.id);

app.use(express.static('dist'));

app.get('/api/food/:foodId', function (req, res) {
  res.send(foodById[req.params.foodId]);
});

app.listen(3000, function () {
    console.log("Listening on port 3000");
});