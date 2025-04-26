//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    
    
    // 1. Картина погоды
    var weatherImageView = UIImageView()
    
    // 2. Название города
    let cityLabel = UILabel()
    
    // 3 - Температура
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.text = "25"
        return label
    }()
    
    // 4 - Другие данные UIView
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    // 5. График
    let weatherChartView = UIView()
    
    // 6. Дополнительная информация
    let additionalInfoView = UIView()
    
    // MARK: - Системные функции
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureWeatherImageView()
        configureCityLabel()
        configureTemperatureLabel()
        configureContainerView()
        configureWeatherChartView()
        configureAdditionalInfoView()
        
    }
    
    //Настройка изображкения погоды (Пункт 1)
    func configureWeatherImageView() {
        weatherImageView.image = UIImage(named: "Sunny")
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
        cityLabel.text = "Москва"
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
        temperatureLabel.text = "25°C"
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
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(120)
        }
    }
   // Настройка контейнера с дополнительной погодной инфолрмацией (Пункт 5)
    func configureWeatherChartView() {
        weatherChartView.backgroundColor = .lightGray
        weatherChartView.layer.cornerRadius = 10
        view.addSubview(weatherChartView)
        
        weatherChartView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(400)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(220)
        }
    }
    // Настройка блока с дополнительной информацией (пункт 6)
    func configureAdditionalInfoView() {
        additionalInfoView.backgroundColor = .lightGray
        additionalInfoView.layer.cornerRadius = 10
        view.addSubview(additionalInfoView)
        
        additionalInfoView.snp.makeConstraints { make in
            make.top.equalTo(weatherChartView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(140)
        }
    }
    
}
    
