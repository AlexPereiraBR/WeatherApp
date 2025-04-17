//
//  ViewController.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 16/04/25.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

    
    var blueView = UIView(frame: CGRect(x: 34, y: 58, width: 152, height: 28))
    var yellowView = UIView(frame: CGRect(x: 54, y: 180, width: 304, height: 124))
    var redView = UIView(frame: CGRect(x: 32, y: 380, width: 338, height: 48))
    var brownView = UIView(frame: CGRect(x: 32, y: 512, width: 338, height: 218))
    
    // MARK: - Системные функции
    
        //Экран БЫЛ загружен
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    
        blueView.backgroundColor = .blue
        yellowView.backgroundColor = .yellow
        redView.backgroundColor = .red
        brownView.backgroundColor = .brown
        
        view.addSubview(blueView)
        view.addSubview(yellowView)
        view.addSubview(redView)
        view.addSubview(brownView)
        
        
        
//        blueView.backgroundColor = .blue
//        view.addSubview(blueView)
//        
//        blueView.snp.makeConstraints { (make) in
//            make.width.equalTo(152)
//            make.height.equalTo(28)
//            
//        }
//        
//        yellowView.backgroundColor = .yellow
//            view.addSubview(yellowView)
//            
//        yellowView.snp.makeConstraints { (make) in
//            make.width.equalTo(304)
//            make.height.equalTo (124)
//            
//        }
//        
//        redView.backgroundColor = .red
//            view.addSubview(redView)
//            
//        redView.snp.makeConstraints { (make) in
//            make.width.equalTo(338)
//            make.height.equalTo(48)
//            
//        }
//        
//        brownView.backgroundColor = .brown
//                view.addSubview(brownView)
//                
//        brownView.snp.makeConstraints { (make) in
//                make.width.equalTo(312)
//                make.height.equalTo(148)
//                
//            
//        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        }
    //MARK: - Ползовательские функции

    
    
    
    
    
    
    
    
    
}

