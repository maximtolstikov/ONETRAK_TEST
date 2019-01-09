//
//  ActivityScreen.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class ActivityScreen: UIViewController {
    
    var fetcher: Fetcher?
    var steps = [Steps]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    private func loadData() {
        
        fetcher?.fetch(response: { [weak self] (activities) in
            guard let activities = activities else { return }
            self?.steps = activities
        })
    }

}
