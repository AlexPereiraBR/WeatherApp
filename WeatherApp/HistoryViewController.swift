//
//  HistoryViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 02/05/25.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewedCities: [ViewedCity] = []
    var citySelectionHandler: ((String) -> Void)?
    var currentCity: String?
    var todayCities: [String] = []
    var allTimeCities: [String] = []
    
    
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewedCities()
        prioritizeCurrentCity()
        title = "History"
        view.backgroundColor = .main
        view.isOpaque = false
        configureTableView()
    }

    // MARK: - Table View Configuration
    private func configureTableView() {
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
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? todayCities.count : allTimeCities.count
    }
    
    // MARK: - Data Preparation
    private func splitViewedCities() {
        let calendar = Calendar.current
        let now = Date()

        todayCities = viewedCities
            .filter { calendar.isDate($0.dateViewed, inSameDayAs: now) }
            .sorted(by: { $0.dateViewed > $1.dateViewed })
            .map { $0.name }

        allTimeCities = viewedCities
            .filter { !calendar.isDate($0.dateViewed, inSameDayAs: now) }
            .sorted(by: { $0.dateViewed > $1.dateViewed })
            .map { $0.name }
    }

    // MARK: - Helpers
    private func prioritizeCurrentCity() {
        guard let current = currentCity else { return }
        if let index = todayCities.firstIndex(of: current) {
            todayCities.remove(at: index)
            todayCities.insert(current, at: 0) } else
                if let index = allTimeCities.firstIndex(of: current) {
                    allTimeCities.remove(at: index)
                    allTimeCities.insert(current, at: 0)
                }
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
        
        let city = indexPath.section == 0 ? todayCities[indexPath.row] : allTimeCities[indexPath.row]
        cell.textLabel?.text = city
        if city == currentCity {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Today" : "All Time"
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = indexPath.section == 0 ? todayCities[indexPath.row] :
        allTimeCities[indexPath.row]
        citySelectionHandler?(selectedCity)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                todayCities.remove(at: indexPath.row)
            } else {
                allTimeCities.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            let updated = todayCities + allTimeCities
            let updatedObjects = updated.map { ViewedCity(name: $0, dateViewed: Date()) }
            if let encoded = try? JSONEncoder().encode(updatedObjects) {
                UserDefaults.standard.set(encoded, forKey: Constants.viewedCitiesKey)
            }
        }
    }
}
