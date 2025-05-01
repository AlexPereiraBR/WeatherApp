//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit
import Alamofire

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
    
    // MARK: - Model
    
    var model = WeatherModel(temperature: nil, city: nil, weatherIconName: "Sunny", humidity: nil, pressure: nil, windSpeed: nil)
    
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
        
        fetchWeatherWithAlamofire()
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
        
        weatherImageView.contentMode = .scaleAspectFit
//        view.addSubview(weatherImageView)
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
        
        view.addSubview(additionalInfoView)
        
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
    
    func fetchWeatherData() {
        
        let apiKey = "82b63b257fa6537513b6d200de7e71e4"
        let city = model.city ?? "Moscow"
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=ru") else {
            print ("Ошибка создание URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Нет данных от сервера")
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Ответ сервера:")
                print(jsonString)
            }
        }
        
        task.resume()
    }
    
    func fetchWeatherWithAlamofire() {
        activityIndicator.startAnimating()
        let apiKey = "82b63b257fa6537513b6d200de7e71e4"
        let city = model.city ?? "Moscow"
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=ru"
        
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherData):
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                print("✅ Город: \(weatherData.name)")
                print("🌡 Температура: \(weatherData.main.temp)°C")
                
                self.model.city = weatherData.name
                self.model.temperature = String(Int(weatherData.main.temp))
                
                self.model.humidity = "\(weatherData.main.humidity)%"
                self.model.pressure = "\(weatherData.main.pressure) hPa"
                self.model.windSpeed = "\(weatherData.wind.speed) м/с"
                
                let iconCode = weatherData.weather.first?.icon ?? "01d"
                self.loadWeatherIcon(named: iconCode)
                
                self.updateUI()
            case .failure:
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                self.showErrorAlert(message: "Не удалось загрузить данные о погоде. Проверьте подключение к интернету и попробуйте снова")
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
            case .failure(let error):
                print("❌ Ошибка загрузки иконки: \(error.localizedDescription)")
            }
        }
        
    }
    
        func updateUI() {
            
            updateAdditionalInfoViewContent()
            if let city = model.city {
                cityLabel.text = city
            } else {
                cityLabel.text = "Loading..."
            }
            
            if let temperature = model.temperature {
                temperatureLabel.text = "\(temperature)°C"
            } else { temperatureLabel.text = "Loading...°C"
                
            }
            
        }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    @objc private func refreshWeatherData() {
        fetchWeatherWithAlamofire()
    }
    
}

