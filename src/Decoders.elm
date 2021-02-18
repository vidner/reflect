module Decoders exposing (..)

import Json.Decode as Json exposing (..)


type alias Profile =
    { name : String, bio : String }


type alias Blog =
    { title : String, url : String, date : String }


type alias Project =
    { name : String, url : String, description : String }


type alias Achievement =
    { title : String, description : String }


type alias Response =
    { profile : Profile, blogs : List Blog, projects : List Project, achivements : List Achievement }


responseDecoder =
    map4 Response
        (field "profile"
            (map2 Profile
                (field "name" string)
                (field "bio" string)
            )
        )
        (field "blogs"
            (list
                (map3 Blog
                    (field "title" string)
                    (field "url" string)
                    (field "date" string)
                )
            )
        )
        (field "projects"
            (list
                (map3 Project
                    (field "name" string)
                    (field "url" string)
                    (field "description" string)
                )
            )
        )
        (field "achievements"
            (list
                (map2 Achievement
                    (field "title" string)
                    (field "description" string)
                )
            )
        )
