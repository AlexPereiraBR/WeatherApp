//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit
import Alamofire
import CoreLocation
import Network
import Reachability

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let scrollView = UIScrollView()
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var weatherImageView = UIImageView()
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    let containerView = UIView()
    let weatherChartView = UIView()
    let additionalInfoView = UIView()
    
    let locationManager = CLLocationManager()
    
    // MARK: - Model
    
    var model = WeatherModel()
    var reachability: Reachability?
    let userDefaults = UserDefaults.standard
    
    var viewedCities: [String] {
        get {
            userDefaults.stringArray(forKey: "viewedCities") ?? []
        }
        set {
            userDefaults.set(newValue, forKey: "viewedCities")
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .main
        
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {make in
            make.edges.equalToSuperview()
        }
        
        configureActivityIndicator()
        
        setupInitialAppearance()
        
        configureWeatherImageView()
        configureCityLabel()
        configureTemperatureLabel()
        configureContainerView()
        configureWeatherChartView()
        configureAdditionalInfoView()
        
        animateAppearance()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Reachability: handle denied location + offline + saved city
        // Это можнт быть в отдельную функцию надо вынести?
        do {
            reachability = try Reachability()
            reachability?.whenUnreachable = { _ in
                // Тут варнинг о том что метод устарел, в идеале желтых ошибок быть не должно никаких
                if CLLocationManager.authorizationStatus() == .denied,
                   let savedCity = self.userDefaults.string(forKey: "savedCity") {
                    DispatchQueue.main.async {
                        self.model.city = savedCity
                        self.fetchWeatherWithAlamofire()
                    }
                }
            }
            try reachability?.startNotifier()
        } catch {
            print("❌ Ошибка запуска Reachability: \(error)")
            // Отступ скобки
            }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "City", style: .plain, target: self, action: #selector(promptForCity))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(showHistory))
    }
    
    // MARK: - Setup Appearance
    
    func setupInitialAppearance() {
        let views = [
            weatherImageView,
            cityLabel,
            temperatureLabel,
            containerView,
            weatherChartView,
            additionalInfoView
        ]
        
        views.forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: 30)
        }
        
    }
    
    // MARK: - UI Configuration
    
    func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    func configureWeatherImageView() {
        // перед всем кодом внутри функции пустых отступов быть не должно
        weatherImageView.contentMode = .scaleAspectFit
        
        scrollView.addSubview(weatherImageView)
        
        weatherImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }
    }
    
    func configureCityLabel() {
        cityLabel.text = model.city ?? "Loading..."
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        scrollView.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureTemperatureLabel() {
        temperatureLabel.text = "\(model.temperature ?? "Loading...")°C"
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 48)
        
        scrollView.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureContainerView() {
        containerView.backgroundColor = .main1
        containerView.layer.cornerRadius = 10
        
        addShadowToView(containerView)
        
        scrollView.addSubview(containerView)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }
    }
    
    func configureWeatherChartView() {
        weatherChartView.backgroundColor = .main1
        weatherChartView.layer.cornerRadius = 10
        
        addShadowToView(weatherChartView)
        
        scrollView.addSubview(weatherChartView)
        
        weatherChartView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(400)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(220)
        }
    }
    
    func configureAdditionalInfoView() {
        additionalInfoView.backgroundColor = .main1
        additionalInfoView.layer.cornerRadius = 10
        
        addShadowToView(additionalInfoView)
        
        updateAdditionalInfoViewContent()
        
        scrollView.addSubview(additionalInfoView)
        additionalInfoView.snp.makeConstraints { make in
            make.top.equalTo(weatherChartView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(140)
        }
    }
    func updateAdditionalInfoViewContent() {
        additionalInfoView.subviews.forEach { $0.removeFromSuperview() }
        // Сделай отдельный класс для этого втю и размести в отдельном файле. А тут сделай вызов ит задавай данные
        let humidityLabel = UILabel()
        humidityLabel.text = "Влажность: \(model.humidity ?? "__")"
        humidityLabel.font = UIFont.systemFont(ofSize:16)
        
        let pressureLabel = UILabel()
        pressureLabel.text = "Давление: \(model.pressure ?? "__")"
        pressureLabel.font = UIFont.systemFont(ofSize:16)
        
        let windLabel = UILabel()
        windLabel.text = "Ветер: \(model.windSpeed ?? "__")"
        windLabel.font = UIFont.systemFont(ofSize:16)
        
        additionalInfoView.addSubview(humidityLabel)
        additionalInfoView.addSubview(pressureLabel)
        additionalInfoView.addSubview(windLabel)
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.right.equalToSuperview().inset(12)
        }
        
        pressureLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
        }
        
        windLabel.snp.makeConstraints { make in
            make.top.equalTo(pressureLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12)
        }
        
    }
    
    func animateAppearance() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
            let views = [self.weatherImageView, self.cityLabel, self.temperatureLabel, self.containerView, self.weatherChartView, self.additionalInfoView]
            
            views.forEach {
                $0.alpha = 1
                $0.transform = .identity
            }
            
        }, completion: nil)
        
    }
    
    func addShadowToView(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
    }
    
    //MARK: - Networking
    
    func fetchWeatherWithAlamofire() {
        activityIndicator.startAnimating()
        // Создай отдельную структуру в отдельном файле с названием Constants и вынеси ключевые константы туда, апи кей должен лежать 100% отдельно. Оброазайся к константам через static заодно изучи почему именно через него и что это такое
        let apiKey = "82b63b257fa6537513b6d200de7e71e4"
        guard let city = model.city else {
            return
        }
        // Адреса тоже заносят в константы, особенно первую неизменяемую часть адреса, подумай что здесь нужно вынести в константы
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=ru"
        
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let weatherData):
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    print("✅ Город: \(weatherData.name)")
                    
                    self.model.city = weatherData.name
                    self.model.temperature = String(Int(weatherData.main.temp))
                    
                    self.model.humidity = "\(weatherData.main.humidity)%"
                    self.model.pressure = "\(weatherData.main.pressure) hPa"
                    self.model.windSpeed = "\(weatherData.wind.speed) m/s"
                    
                    let iconCode = weatherData.weather.first?.icon ?? "01d"
                    self.loadWeatherIcon(named: iconCode)
                    
                    if !self.viewedCities.contains(weatherData.name) {
                        var updated = self.viewedCities
                        updated.append(weatherData.name)
                        self.viewedCities = updated
                        
                    }
                    
                    self.updateUI()
                // у фейлур есть ошибка с текстом, ть можешь ее показывать в своей функции на эррор алерт (failure(let error))
                case .failure:
                    //Check for 404/city not found
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data) as?
                        [String: Any],
                       let message = json["message"] as? String,
                       message.lowercased().contains("city not found") {
                        self.showErrorAlert(message: "Город не найден. Проверьте название города")
                        return
                    }
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.showErrorAlert(message: "Не удалось загрузить данные о погоде. Проверьте подключение к интернету и попробуйте снова")
                }
            }
            
        }
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double) {
        activityIndicator.startAnimating()
        let apiKey = "82b63b257fa6537513b6d200de7e71e4"
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=ru"
        
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherData):
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                
                self.model.city = weatherData.name
                self.model.temperature = String(Int(weatherData.main.temp))
                self.model.humidity = "\(weatherData.main.humidity)%"
                self.model.pressure = "\(weatherData.main.pressure) hPa"
                self.model.windSpeed = "\(weatherData.wind.speed) m/s"
                
                let iconCode = weatherData.weather.first?.icon ?? "01d"
                self.loadWeatherIcon(named: iconCode)
                
                self.updateUI()
            case .failure:
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.showErrorAlert(message: "Не удалось получить погоду по координатам. Проверьте разрешения в настройках")
            }
        }
    }
    
    func loadWeatherIcon(named iconCode: String) {
        let iconURL = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        
        AF.request(iconURL).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherImageView.image = image
                    }
                }
            case .failure:
                // Set local fallback weather icon
                DispatchQueue.main.async {
                    self.weatherImageView.image = UIImage(systemName: "cloud.slash")
                }
            }
        }
        
    }
    //MARK: - Update UI
    
    func updateUI() {
        // отступы
        updateAdditionalInfoViewContent()
        if let city = model.city {
            cityLabel.text = city
        } else {
            cityLabel.text = "Loading..."
        }
        
        if let temperature = model.temperature {
            temperatureLabel.text = "\(temperature)°C"
  
        }
        
    }
    
    func showErrorAlert(message: String) {
        // здесь тоже можно вынести в константы
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc private func refreshWeatherData() {
        fetchWeatherWithAlamofire()
    }
    
    @objc func promptForCity() {
        let alert = UIAlertController(title: "Введите город", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default)
        { [weak self, weak alert] _ in
            guard let city = alert?.textFields?.first?.text, !city.isEmpty else { return }
            self?.userDefaults.set(city, forKey: "savedCity")
            self?.model.city = city
            self?.fetchWeatherWithAlamofire()
            
        }
        alert.addAction(submitAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - History
    @objc func showHistory() {
        let historyVC = HistoryViewController()
        historyVC.viewedCities = self.viewedCities
        historyVC.citySelectionHandler = { [weak self] selectedCity in
            self?.model.city = selectedCity
            self?.fetchWeatherWithAlamofire()
        }
        navigationController?.pushViewController(historyVC, animated: true)
    }
}

//MARK: - Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            fetchWeatherByCoordinates(lat: lat, lon: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка геолокации: \(error.localizedDescription)")
    }
}





