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
    let city: String
    
    private let tableView = UITableView()
    private var days: [ForecastDay] = []
    private let screenTitle = "Weekly Forecast"
    private let defaultIconCode = "01d"
    
    //MARK: - Init
    
    init(city: String, iconCode: String?) {
        self.city = city
        self.iconCode = iconCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = screenTitle
        view.backgroundColor = .main
        setupTableView()
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
        
        AF.request(url).responseDecodable(of: ForecastResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let forecastData):
                
                let calendar = Calendar.current
                
                let grouped = Dictionary(grouping: forecastData.list) { item in
                    calendar.startOfDay(for: Date(timeIntervalSince1970: item.dt))
                }
                
                let sortedDates = grouped.keys.sorted().prefix(7)
                
                self.days = sortedDates.compactMap { date in
                    self.makeForecastDay(from: grouped, for: date)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    private func makeForecastDay(from grouped: [Date: [ForecastResponse.ForecastItem]], for date: Date) -> ForecastDay? {
        guard let first = grouped[date]?.first else { return nil }

        return ForecastDay(
            date: date,
            temperature: Int(first.main.temp),
            iconCode: first.weather.first?.icon ?? defaultIconCode
        )
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
