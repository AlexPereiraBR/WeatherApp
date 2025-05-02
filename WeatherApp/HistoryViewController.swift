//
//  HistoryViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 02/05/25.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewedCities: [String] = []
    var citySelectionHandler: ((String) -> Void)?
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "History"
        view.backgroundColor = .main
        view.isOpaque = false
        tableView.isOpaque = false
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        tableView.backgroundColor = UIColor(named: "main")
        tableView.separatorStyle = .none
        tableView.separatorColor = .main
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        cell.backgroundColor = .main
        cell.contentView.backgroundColor = .main
        cell.textLabel?.backgroundColor = .main
        cell.textLabel?.textColor = .black
        cell.textLabel?.isOpaque = false
        cell.isOpaque = false

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "main")
        cell.selectedBackgroundView = bgColorView
        
        cell.textLabel?.text = viewedCities[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = viewedCities[indexPath.row]
        citySelectionHandler?(selectedCity)
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
