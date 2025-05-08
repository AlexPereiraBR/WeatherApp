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
    var gradientColors: [CGColor]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let colors = gradientColors {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors
            gradientLayer.frame = view.bounds
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    var favoriteCities: [ViewedCity] {
        let favorites = UserDefaults.standard.stringArray(forKey: "FavoriteCities") ?? []
        return viewedCities.filter { favorites.contains($0.name) }
    }
    
    private let tableView = UITableView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewedCities()
        prioritizeCurrentCity()
        title = "History"
        view.backgroundColor = .clear
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.separatorColor = .main
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return favoriteCities.count
        case 1: return todayCities.count
        case 2: return allTimeCities.count
        default : return 0
        }
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
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.isOpaque = false
        cell.isOpaque = false
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(named: "main")
        cell.selectedBackgroundView = bgColorView
        
        let city: String
        switch indexPath.section {
        case 0: city = favoriteCities[indexPath.row].name
        case 1: city = todayCities[indexPath.row]
        case 2: city = allTimeCities[indexPath.row]
        default : city = ""
        }
        cell.textLabel?.text = city
        if city == currentCity {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Favorites"
        case 1: return "Today"
        case 2: return "All time"
        default: return nil
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity: String
        switch indexPath.section {
        case 0: selectedCity = favoriteCities[indexPath.row].name
        case 1: selectedCity = todayCities[indexPath.row]
        case 2: selectedCity = allTimeCities[indexPath.row]
        default: return
        }
        citySelectionHandler?(selectedCity)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                // Удаляем из избранных
                let city = favoriteCities[indexPath.row].name
                var favorites = UserDefaults.standard.stringArray(forKey: "FavoriteCities") ?? []
                favorites.removeAll { $0 == city }
                UserDefaults.standard.set(favorites, forKey: "FavoriteCities")
            case 1:
                todayCities.remove(at: indexPath.row)
            case 2:
                allTimeCities.remove(at: indexPath.row)
            default:
                break
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Обновляем сохранённую историю
            let updated = todayCities + allTimeCities
            let updatedObjects = updated.map { ViewedCity(name: $0, dateViewed: Date()) }
            if let encoded = try? JSONEncoder().encode(updatedObjects) {
                UserDefaults.standard.set(encoded, forKey: Constants.viewedCitiesKey)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let city: String
        switch indexPath.section {
        case 0: city = favoriteCities[indexPath.row].name
        case 1: city = todayCities[indexPath.row]
        case 2: city = allTimeCities[indexPath.row]
        default: return nil
        }
        
        var favorites = UserDefaults.standard.stringArray(forKey: "FavoriteCities") ?? []
        let isFavorite = favorites.contains(city)
        
        let title = isFavorite ? "Remove ⭐️" : "Add favorites ⭐️"
        let action = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completion in
            
            guard let self = self else { return }
            
            if isFavorite {
                favorites.removeAll { $0 == city }
            } else {
                favorites.append(city)
            }
            
            UserDefaults.standard.set(favorites, forKey: "FavoriteCities")
            self.tableView.reloadData()
            completion(true)
        }
        
        action.backgroundColor = isFavorite ? .systemRed : .systemYellow
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
}
