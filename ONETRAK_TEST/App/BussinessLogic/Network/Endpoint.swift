//
//  Endpoint.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

/// Путь запроса
protocol Endpoint {
    var path: String { get }
}

/// Перечисляет различные виды активности
enum Activities {
    case steps
}

extension Activities: Endpoint {
    var path: String {
        switch self {
        case .steps: return "https://intern-f6251.firebaseio.com/intern/metric.json"
        }
    }
}
