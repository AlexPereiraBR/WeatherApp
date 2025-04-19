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
    
    //...
    
    // MARK: - Системные функции
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(weatherImageView)
        weatherImageView.image = UIImage(named: "тут название изображения")
        weatherImageView.backgroundColor = . red
        
        weatherImageView.snp.makeConstraints { make in
            make.left.equalTo(50)
            make.width.height.equalTo(100)
            make.top.equalTo(100)
        }
        
        
    }
    
}

