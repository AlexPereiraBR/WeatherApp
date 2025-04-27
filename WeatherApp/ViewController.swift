//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    
    
    // MARK: - UI Elements
    
    var weatherImageView = UIImageView()
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    let containerView = UIView()
    let weatherChartView = UIView()
    let additionalInfoView = UIView()
    
    // MARK: - Model
    
    var model = WeatherModel(
        temperature: "25",
        city: "Москва",
        weatherIconName: "Sunny")
    
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
        
        //Активируем появление
        animateAppearance()
        }
    
    // MARK: - Setup Appearance
    
    func setupInitialAppearance() {
        let views = [weatherImageView, cityLabel, temperatureLabel, containerView, weatherChartView, additionalInfoView]
        
        views.forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: 0, y: 30)
        }
    }
    
    // MARK: - UI Configuration
    
    //Настройка изображкения погоды (Пункт 1)
    func configureWeatherImageView() {
        weatherImageView.image = UIImage(named: model.weatherIconName)
        weatherImageView.contentMode = .scaleAspectFit
        view.addSubview(weatherImageView)
        
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
    }
    
    //Настройка названия города (Пункт 2)
    func configureCityLabel() {
        cityLabel.text = model.city
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        view.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    //Настройка отображения температуры (Пункт 3)
    func configureTemperatureLabel() {
        temperatureLabel.text = "\(model.temperature)°C"
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 48)
        view.addSubview(temperatureLabel)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    //Настройка контейнера с дополнительной погодной информацией (пункт 4)
    func configureContainerView() {
        containerView.backgroundColor = .main1
        containerView.layer.cornerRadius = 10
        
        //Добавили тень
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 8
        
        view.addSubview(containerView)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }
    }
   // Настройка контейнера с дополнительной погодной инфолрмацией (Пункт 5)
    func configureWeatherChartView() {
        weatherChartView.backgroundColor = .main1
        weatherChartView.layer.cornerRadius = 10
        
        //Добавили тень
        weatherChartView.layer.shadowColor = UIColor.black.cgColor
        weatherChartView.layer.shadowOpacity = 0.5
        weatherChartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        weatherChartView.layer.shadowRadius = 8
        
        view.addSubview(weatherChartView)
        
        weatherChartView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(400)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(220)
        }
    }
    // Настройка блока с дополнительной информацией (пункт 6)
    func configureAdditionalInfoView() {
        additionalInfoView.backgroundColor = .main1
        additionalInfoView.layer.cornerRadius = 10
        
        //Добавили тень
        additionalInfoView.layer.shadowColor = UIColor.black.cgColor
        additionalInfoView.layer.shadowOpacity = 0.5
        additionalInfoView.layer.shadowOffset = CGSize(width: 0, height: 2)
        additionalInfoView.layer.shadowRadius = 8
        
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
}
    
