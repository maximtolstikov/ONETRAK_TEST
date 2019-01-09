//
//  StepsFetcher.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import Foundation

/// Парсер даных в модель
protocol Fetcher {
    func fetch(response: @escaping ([Steps]?) -> Void)
}

/// Модуль мапинга данных в коллекцию Шагов
struct StepsFetcher: Fetcher {
    let networking: Networking
    
    init(_ networking: Networking) {
        self.networking = networking
    }
    
    func fetch(response: @escaping ([Steps]?) -> Void) {
        networking.request(from: Activities.steps) { (data, error) in
            
            if let error = error {
                print("Error received requesting Steps: \(error.localizedDescription)")
                return
            }
            
            guard let decoded = self.decodeJSON(type: [Steps].self, from: data) else {
                assertionFailure()
                return
            }
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        
        return response
    }
}
