//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

    let blueView = UIView(frame: .zero)
    let yellowView = UIView(frame: .zero)
    let redView = UIView(frame: .zero)
    let brownView = UIView(frame: .zero)
    
    // MARK: - Системные функции
    
        //Экран БЫЛ загружен
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        
        blueView.backgroundColor = .blue
        view.addSubview(blueView)
        
        blueView.snp.makeConstraints { (make) in
            make.width.equalTo(152)
            make.height.equalTo(27)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        yellowView.backgroundColor = .yellow
            view.addSubview(yellowView)
            
        yellowView.snp.makeConstraints { (make) in
            make.width.equalTo(304)
            make.height.equalTo (123)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        redView.backgroundColor = .red
            view.addSubview(redView)
            
        redView.snp.makeConstraints { (make) in
            make.width.equalTo(338)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        brownView.backgroundColor = .brown
                view.addSubview(brownView)
                
        brownView.snp.makeConstraints { (make) in
                make.width.equalTo(338)
                make.height.equalTo(218)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        }
    //MARK: - Ползовательские функции

    
    
    
    
    
    
    
    
    
}

