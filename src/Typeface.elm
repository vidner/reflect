module Typeface exposing (..)

import Element.Font as Font


roboto =
    Font.family
        [ Font.external
            { name = "Roboto Mono"
            , url = "https://fonts.googleapis.com/css?family=Roboto+Mono"
            }
        , Font.monospace
        ]


fira =
    Font.family
        [ Font.external
            { name = "Fira Sans"
            , url = "https://fonts.googleapis.com/css?family=Fira+Sans"
            }
        ]


cantarell =
    Font.family
        [ Font.external
            { name = "Cantarell"
            , url = "https://fonts.googleapis.com/css?family=Cantarell"
            }
        ]
