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
    
    var weatherImageView = UIImageView()
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    let containerView = UIView()
    let weatherChartView = UIView()
    let additionalInfoView = UIView()
    
    // MARK: - Model
    
    var model = WeatherModel(temperature: nil, city: nil, weatherIconName: "Sunny")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .main
        
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
    
    func configureWeatherImageView() {
        
        weatherImageView.contentMode = .scaleAspectFit
        view.addSubview(weatherImageView)
        
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
        view.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureTemperatureLabel() {
        temperatureLabel.text = "\(model.temperature ?? "Loading...")°C"
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 48)
        view.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
 
    func configureContainerView() {
        containerView.backgroundColor = .main1
        containerView.layer.cornerRadius = 10
        
        addShadowToView(containerView)
        
        view.addSubview(containerView)
        
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
        
        view.addSubview(weatherChartView)
        
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
        let apiKey = "82b63b257fa6537513b6d200de7e71e4"
        let city = model.city ?? "Moscow"
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric&lang=ru"
        
        AF.request(url).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherData):
                print("✅ Город: \(weatherData.name)")
                print("🌡 Температура: \(weatherData.main.temp)°C")
                
                self.model.city = weatherData.name
                self.model.temperature = String(Int(weatherData.main.temp))
                
                let iconCode = weatherData.weather.first?.icon ?? "01d"
                self.loadWeatherIcon(named: iconCode)
                
                self.updateUI()
            case .failure(let error):
                print("❌ Ошибка Alamofire: \(error.localizedDescription)")
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
        
    }

