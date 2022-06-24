//
//  AuthResponse.swift
//  SpotifyClone
//
//  Created by Lama Albadri on 24/06/2022.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
/*{
 "access_token" = "BQDtWNEZAjNDqjKGGFu7ogs8p4icBa3fdnRwvSXUx9Web3jXO1F8g9o4YkVOJrDVvcH70ej1xBQVsmqcMRv4mzMOWiYLpQKI4OW4s8SvjXpdEHxprwB1W2-TyeR16YN7L_O1B84PqJ0vnwZ0-AyU9WVzl3R-8l-1KHD9u4Hek2mU9tnXyhHsQgZrB_35OwVdXCjZudrK1yp8WmA";
 "expires_in" = 3600;
 "refresh_token" = "AQAngyFJZuZiyV3YYwbvG1WwR7-XyA8RuhtIrfuExEuUwiq3BxdE4zHhjs8-kW10Z_-W63nSTX2PiOO_S55fmJFaRZM3lknlM1COA8lFrfMaZvK0CVUn8cH_XEPT-s9tMjg";
 scope = "user-read-private";
 "token_type" = Bearer;
}*/
