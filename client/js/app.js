import Elm from './Main';
import searchableFoods from './searchableFoods';
import nutrients from './nutrients';

// Using elastic lunr due to it being much faster
// at indexing than ElmSearchText. Also a good
// way to try out Elm ports.
var index = elasticlunr(function () {
  this.addField('name');
  this.setRef('id');
});

const elmDiv = document.querySelector('#elm-target');
if (elmDiv) {
  var app = Elm.Main.embed(elmDiv, {searchableFoods, nutrients});

// Doesn't seem to be a bulk add method. This is fast anyway.
searchableFoods.forEach(food => index.addDoc(food));

  app.ports.foodSearch.subscribe(
    searchText => {
      var searchResults = index.search(searchText);
      var foodIds = searchResults.map(result => result.ref);
      app.ports.foodSearchResults.send(foodIds);
    }
  );
}