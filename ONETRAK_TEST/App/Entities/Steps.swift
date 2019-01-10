//
//  Activity.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

/// Модель данных активности пользователя
struct Steps: Codable {
    
    let aerobic: Int
    let date: Int
    let run: Int
    let walk: Int
}
