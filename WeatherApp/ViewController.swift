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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .main
        //Изначальная прозрачность
        weatherImageView.alpha = 0
        cityLabel.alpha = 0
        temperatureLabel.alpha = 0
        containerView.alpha = 0
        weatherChartView.alpha = 0
        additionalInfoView.alpha = 0
        //Добавлен вертикальный сдвиг
        weatherImageView.transform = CGAffineTransform(translationX: 0, y: 30)
        cityLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        temperatureLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        containerView.transform = CGAffineTransform(translationX: 0, y: 30)
        weatherChartView.transform = CGAffineTransform(translationX: 0, y: 30)
        additionalInfoView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        configureWeatherImageView()
        configureCityLabel()
        configureTemperatureLabel()
        configureContainerView()
        configureWeatherChartView()
        configureAdditionalInfoView()
        
        //Активируем появление
        animateAppearance()
        
    }
    
    // MARK: - UI Configuration
    
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
        
        containerView.snp.makeConstraints { make in
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
        
        containerView.snp.makeConstraints { make in
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
    //Добавили функию анимации
    func animateAppearance() {
        UIView.animate(withDuration: 1.0, delay: 0.2, options: [.curveEaseOut], animations: {
            //Прозрачность элементов
            self.weatherImageView.alpha = 1
            self.cityLabel.alpha = 1
            self.temperatureLabel.alpha = 1
            self.containerView.alpha = 1
            self.weatherChartView.alpha = 1
            self.additionalInfoView.alpha = 1
            
            //Возвращение в исходное положение
            self.weatherImageView.transform = .identity
            self.cityLabel.transform = .identity
            self.temperatureLabel.transform = .identity
            self.containerView.transform = .identity
            self.weatherChartView.transform = .identity
            self.additionalInfoView.transform = .identity
            
        }, completion: nil)
                       
        
                    
    }
}
    
