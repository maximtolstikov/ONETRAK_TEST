//
//  ActivityScreenBilder.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

// Cборщик вынес в фабрику на случай если понадобится для iPad например.
protocol ViewControllerFactory {
    func controller() -> UIViewController
}

class ActivityScreenFactory: ViewControllerFactory {
    
    func controller() -> UIViewController {
        let networkService = HTTPNetworking()
        let fetcher = StepsFetcher(networkService)
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let controller = storybord
            .instantiateViewController(withIdentifier: "ActivityScreen") as! ActivityScreen
        controller.fetcher = fetcher
        
        return controller        
    }
}
