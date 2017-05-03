import Elm from './Main';
import data from './data';
import elasticlunr from 'elasticlunr';

// Using elastic lunr due to it being much faster
// at indexing than ElmSearchText. Also a good
// way to try out Elm ports.
var index = elasticlunr(function () {
  this.addField('name');
  this.setRef('id');
});

// Doesn't seem to be a bulk add method. This is fast anyway.
data.foods.forEach(food => index.addDoc(food));

const elmDiv = document.querySelector('#elm-target');
if (elmDiv) {
  var app = Elm.Main.embed(elmDiv, data);

  app.ports.foodSearch.subscribe(
    searchText => {
      var searchResults = index.search(searchText);
      var foodIds = searchResults.map(result => result.ref);
      app.ports.foodSearchResults.send(foodIds);
    }
  );
}