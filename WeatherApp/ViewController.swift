//
//  ViewController.swift
//  HistoryViewController
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
    // MARK: - Properties
    var currentIconCode: String?
    
    //MARK: - Initializers
        required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    // MARK: - UI Elements
    let scrollView = UIScrollView()
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var weatherImageView = UIImageView()
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    let containerView = UIView()
    let weatherChartView = UIView()
    let additionalInfoView = AdditionalInfoView()
    let locationManager = CLLocationManager()

    // MARK: - Model
    var model = WeatherModel()
    var reachability: Reachability?
    let userDefaults = UserDefaults.standard

    var viewedCities: [ViewedCity] {
        get {
            if let data = userDefaults.data(forKey: "viewedCities"),
               let decoded = try? JSONDecoder().decode([ViewedCity].self, from: data) {
                return decoded
            }
            return []
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                userDefaults.set(encoded, forKey: "viewedCities")
            }
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
        // Create bar button items
        let historyButton = UIBarButtonItem(title: "History", style: .plain, target: self, action: #selector(showHistory))
        let cityButton = UIBarButtonItem(title: "City", style: .plain, target: self, action: #selector(promptForCity))
        let forecastButton = UIBarButtonItem(title: "7-day", style: .plain, target: self, action: #selector(showForecast))
        navigationItem.leftBarButtonItem = historyButton
        navigationItem.rightBarButtonItems = [cityButton, forecastButton]
        
        trimViewedCitiesSections()
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
        setupReachabilityFallback()
        
    }
    
    // MARK: - UI Setup
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
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.30)
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
        weatherChartView.backgroundColor = UIColor.white.withAlphaComponent(0.30)
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
        additionalInfoView.backgroundColor = UIColor.white.withAlphaComponent(0.30)
        additionalInfoView.layer.cornerRadius = 10
        addShadowToView(additionalInfoView)
        scrollView.addSubview(additionalInfoView)
        additionalInfoView.snp.makeConstraints { make in
            make.top.equalTo(weatherChartView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(140)
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
    
    // MARK: - Networking
    func fetchWeatherWithAlamofire() {
        activityIndicator.startAnimating()
        guard let city = model.city else {
            return
        }
        
        let url = "\(Constants.baseURL)?q=\(city)&appid=\(Constants.apiKey)&units=\(Constants.units)&lang=\(Constants.language)"
        
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let weatherData):
                    // Update viewedCities with new dateViewed before updating model
                    var updated = self.viewedCities.filter { $0.name != weatherData.name }
                    updated.append(ViewedCity(name: weatherData.name, dateViewed: Date()))
                    self.viewedCities = updated
                    self.activityIndicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.updateModel(from: weatherData)
                    let iconCode = weatherData.weather.first?.icon ?? "01d"
                    self.updateBackgroundAndIcon(using: iconCode)
                    self.updateUI()
                    
                case .failure(let error):
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
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
            
        }
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double) {
        activityIndicator.startAnimating()
        let url = "\(Constants.baseURL)?lat=\(lat)&lon=\(lon)&appid=\(Constants.apiKey)&units=\(Constants.units)&lang=\(Constants.language)"
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherData):
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.updateModel(from: weatherData)
                let iconCode = weatherData.weather.first?.icon ?? "01d"
                self.updateBackgroundAndIcon(using: iconCode)
                self.updateUI()
            case .failure:
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.showErrorAlert(message: "Не удалось получить погоду по координатам. Проверьте разрешения в настройках")
            }
        }
    }
    
    func updateBackgroundAndIcon(using iconCode: String) {
        self.currentIconCode = iconCode
        self.applyGradientBackground(for: iconCode)
        self.loadWeatherIcon(named: iconCode)
    }
    
    func updateModel(from weatherData: WeatherResponse) {
        self.model.city = weatherData.name
        self.model.temperature = String(Int(weatherData.main.temp))
        self.model.humidity = "\(weatherData.main.humidity)%"
        self.model.pressure = "\(weatherData.main.pressure) hPa"
        self.model.windSpeed = "\(weatherData.wind.speed) m/s"
    }
    
    func loadWeatherIcon(named iconCode: String) {
        if let cachedImage = ImageCacheManager.shared.image(forKey: iconCode) {
            self.weatherImageView.image = cachedImage
            return
        }

        let iconURL = "https://openweathermap.org/img/wn/\(iconCode)@2x.png"
        
        AF.request(iconURL).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    ImageCacheManager.shared.set(image, forKey: iconCode)
                    DispatchQueue.main.async {
                        self.weatherImageView.image = image
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    self.weatherImageView.image = UIImage(systemName: Constants.fallbackWeatherIcon)
                }
            }
        }
    }
    
    //MARK: - Update UI
    func updateUI() {
        additionalInfoView.configure(humidity: model.humidity, pressure: model.pressure, windSpeed: model.windSpeed)
        if let city = model.city {
            cityLabel.text = city
        } else {
            cityLabel.text = "Loading..."
        }
        
        if let temperature = model.temperature {
            temperatureLabel.text = "\(temperature)°C"
            
        }
        
    }
    
    // MARK: - Alerts
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: Constants.alertTitleError, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonOK, style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    // MARK: - Gradient
    func applyGradientBackground(for iconCode: String) {
        view.layer.sublayers?.removeAll(where: { $0.name == "weatherGradient" })
        let gradient = WeatherBackgroundManager.gradientLayer(for: iconCode, in: view.bounds)
        view.layer.insertSublayer(gradient, at: 0)
    }

    @objc private func refreshWeatherData() {
        fetchWeatherWithAlamofire()
    }

    // MARK: - Navigation / City Input
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

    // MARK: - Navigation / Forecast
    @objc func showForecast() {
        let vc = ForecastViewController(city: model.city ?? "Unknown", iconCode: currentIconCode)
      
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Trim viewed cities sections
    private func trimViewedCitiesSections() {
        let calendar = Calendar.current
        let now = Date()
        
        var today = viewedCities.filter {
            calendar.isDate($0.dateViewed, inSameDayAs: now)
        }.sorted(by: { $0.dateViewed > $1.dateViewed})
        
        var allTime = viewedCities.filter {
            !calendar.isDate($0.dateViewed, inSameDayAs: now)
        }.sorted(by: { $0.dateViewed > $1.dateViewed})
        
        if today.count > 10 {
            today = Array(today.prefix(10))
        }
        
        if allTime.count > 10 {
            allTime = Array(allTime.prefix(10))
        }
        
        viewedCities = today + allTime
    }
    
    // MARK: - Navigation / History
    @objc func showHistory() {
        trimViewedCitiesSections()
        let historyVC = HistoryViewController()
        historyVC.viewedCities = self.viewedCities
        historyVC.currentCity = self.model.city
        if let iconCode = currentIconCode {
            historyVC.gradientColors = WeatherBackgroundManager.colors(for: iconCode).map { $0.cgColor }
        }
        historyVC.citySelectionHandler = { [weak self] selectedCity in
            self?.model.city = selectedCity
            self?.fetchWeatherWithAlamofire()
        }
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    // MARK: - Reachability
    private func setupReachabilityFallback() {
        do {
            reachability = try Reachability()
            reachability?.whenUnreachable = { _ in
            }
            try reachability?.startNotifier()
        } catch {
            print("❌ Ошибка запуска Reachability: \(error)")
            
        }
        
    }
    
    // MARK: - Location Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            break
        case .restricted, .denied:
            if let savedCity = userDefaults.string(forKey: "savedCity") {
                DispatchQueue.main.async {
                    self.model.city = savedCity
                    self.fetchWeatherWithAlamofire()
                }
            }
        case .authorizedWhenInUse, .authorizedAlways:
            break
        @unknown default:
            break
        }
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
        debugPrint("Ошибка геолокации: \(error.localizedDescription)")
    }
}

// MARK: - Favorite Cities Helper
extension ViewController {
    func isFavorite(city: String) -> Bool {
        let favorites = UserDefaults.standard.stringArray(forKey: "FavoriteCities") ?? []
        return favorites.contains(city)
    }
}
