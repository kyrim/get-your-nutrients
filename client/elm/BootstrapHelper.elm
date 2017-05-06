module BootstrapHelper exposing (..)

import Bootstrap.Grid.Row as Row
import AppCss
import Html.CssHelpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


rowBuffer =
    Row.attrs [ class [ AppCss.RowBuffer ] ]
