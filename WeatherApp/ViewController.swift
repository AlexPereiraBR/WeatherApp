//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    
    
    // MARK: - Системные функции
    
    //Экран БЫЛ загружен
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Main")
        setSquare()
    }
    
    //Функия которая создает квадраты view в заданных нами координатах что бы не создавать каждый индивидуально
    private func setSquare() {
        let square1 = createSquare(frame: CGRect(x: 34, y: 58, width: 152, height: 28))
        let square2 = createSquare(frame: CGRect(x: 54, y: 180, width: 304, height: 124))
        let square3 = createSquare(frame: CGRect(x: 32, y: 380, width: 338, height: 48))
        let square4 = createSquare(frame: CGRect(x: 32, y: 512, width: 338, height: 218))
        
        //Затем прогоняем все обекты для инициализации через массив
        [square1,square2,square3,square4].forEach { item in view.addSubview(item)
        }
        
    }
    // Функция инициализации квадратов с заданными параметрами
    private func createSquare(frame: CGRect) -> UIView {
            let square = UIView()
            square.backgroundColor = UIColor(named: "Main1")
            square.frame = frame
            square.layer.cornerRadius = 20
            return square
            }
        

        
    
    //MARK: - Ползовательские функции
    
    
}

