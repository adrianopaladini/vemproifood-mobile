//
//  DataStruct.swift
//  vemproiFood
//
//  Created by Adriano Paladini on 21/11/18.
//  Copyright © 2018 Adriano Paladini. All rights reserved.
//

import Foundation


struct weather: Decodable {
    let list: [dayHour]

    struct dayHour: Decodable {
        let weather: [singleWeather]

        struct singleWeather: Decodable {
            let main: String
        }
    }
}

