import Elm from './Main';

const elmDiv = document.querySelector('#elm-target');
if (elmDiv) {
  Elm.Main.embed(elmDiv);
}