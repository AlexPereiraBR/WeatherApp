//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 09/05/25.
//

import Foundation
import UIKit
import Alamofire

class ForecastViewController: UIViewController {
    
    // MARK: - Properties
    var iconCode: String?
    var city: String?
    private let tableView = UITableView()
    private var days: [ForecastDay] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Weekly Forecast"
        view.backgroundColor = .main
        
        setupTableView()
        guard let city = city else {
            return
        }
        fetchForecast(for: city)
    }
    
    // MARK: - Layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.sublayers?.removeAll(where: { $0.name == "weatherGradient" })
        
        if let code = iconCode {
            let gradient = WeatherBackgroundManager.gradientLayer(for: code, in: view.bounds)
            view.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    // MARK: - UI Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(ForecastDayCell.self, forCellReuseIdentifier: ForecastDayCell.reuseID)
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor.clear
        tableView.isOpaque = false
        view.addSubview(tableView)
    }
    
    // MARK: - Networking
    private func fetchForecast(for city: String) {
        let url = "\(Constants.forecastURL)?q=\(city)&appid=\(Constants.apiKey)&units=\(Constants.units)&lang=\(Constants.language)"
        
        AF.request(url).responseDecodable(of: ForecastResponse.self) { [weak self] resp in
            guard let self = self else { return }
            switch resp.result {
            case .success(let forecastData):
                let calendar = Calendar.current
                let grouped = Dictionary(grouping: forecastData.list) { item in
                    calendar.startOfDay(for: Date(timeIntervalSince1970: item.dt))
                }
                let sortedDates = grouped.keys.sorted().prefix(7)
                self.days = sortedDates.compactMap { date in
                    guard let first = grouped[date]?.first else { return nil }
                    return ForecastDay(
                        date: date,
                        temperature: Int(first.main.temp),
                        iconCode: first.weather.first?.icon ?? "01d"
                    )
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(_):
                break
            }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastDayCell.reuseID, for: indexPath) as! ForecastDayCell
        cell.configure(with: days[indexPath.row])
        cell.backgroundColor = .clear
        return cell
    }
}
