//
//  ActivityScreen.swift
//  ONETRAK_TEST
//
//  Created by Maxim Tolstikov on 09/01/2019.
//  Copyright © 2019 Maxim Tolstikov. All rights reserved.
//

import UIKit

class ActivityScreen: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetcher: Fetcher?
    var activities = [Steps]() {
        didSet {
            tableView.reloadData()
        }
    }
    let dateFormater: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }()
    let userDefaults = UserDefaults.standard
    let aimKey = "ONETRAK-TEST-AIM-KEY"
    let aimDefaults = 2000
    var aim: Int {
        get {
            return userDefaults.integer(forKey: aimKey)
        }
        set {
            userDefaults.set(newValue, forKey: aimKey)
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func loadData() {
        
        fetcher?.fetch(response: { [weak self] (activities) in
            guard let activities = activities else { return }
            self?.activities = activities
        })
    }
    
    @IBAction func aimButtonTapped(_ sender: UIBarButtonItem) {
        aimSetup()
    }
}

// MARK: - UITableViewDataSource
extension ActivityScreen: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        
        let steps = activities[indexPath.section]        
        cell.configure(steps: steps, dateFormater: dateFormater, target: aim)
        
        return cell
    }
}

// MARK: - Aim Setup
extension ActivityScreen {
    
    private func aimSetup() {
        
        let alertController = UIAlertController(title: "Установка цели",
                                                message: "Текущее колличество шагов",
                                                preferredStyle: .alert)
        alertController.addTextField { [unowned self] (textField) in
            textField.font = UIFont.systemFont(ofSize: 16.0)
            textField.textAlignment = .center
            textField.text = String(self.aim)
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        let save = UIAlertAction(title: "Сохранить", style: .default) { [unowned self] _ in
            
            guard let textField = alertController.textFields?.first,
                  let text = textField.text,
                  let numberSteps = Int(text) else { return }
            
            self.aim = numberSteps
        }
        alertController.addAction(cancel)
        alertController.addAction(save)
        present(alertController, animated: true)
    }
}
