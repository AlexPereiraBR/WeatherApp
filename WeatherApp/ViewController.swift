//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    //    1. Это картинка
    //    2. Название города
    //    3. Температура
    //    4. Какие то данные о погоде
    //    5. График
    //    6. Еще какие то данные о погоде
    
    // 1
    var weatherImageView = UIImageView()
    
    // 2
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
        view.backgroundColor = .lightGray // Цвет для визуализации
        view.layer.cornerRadius = 10
        return view
    }()
    // 5. График
    
    
    // MARK: - Системные функции
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        // Настройка элементов
        weatherImageView.image = UIImage(named: "Sunny")
        weatherImageView.contentMode = .scaleAspectFit

        cityLabel.text = "Москва"
        cityLabel.textAlignment = .center
        cityLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)

        temperatureLabel.text = "25°"
        temperatureLabel.textAlignment = .center
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 48)

        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 10
        
        let secondInfoView = UIView()
        secondInfoView.backgroundColor = .lightGray
        secondInfoView.layer.cornerRadius = 10
        
        let thirdInfoView = UIView()
        thirdInfoView.backgroundColor = .lightGray
        thirdInfoView.layer.cornerRadius = 10
        
    

        // Добавление элементов на экран
        view.addSubview(weatherImageView)
        view.addSubview(cityLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(containerView)
        view.addSubview(secondInfoView)
        view.addSubview(thirdInfoView)
        
        // Расстановка с помощью SnapKit
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }

        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        secondInfoView.snp.makeConstraints { make in
                make.top.equalTo(containerView.snp.bottom).offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(200)
            }

            thirdInfoView.snp.makeConstraints { make in
                make.top.equalTo(secondInfoView.snp.bottom).offset(16)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(100)
            }
        
        
    }
}
