//
//  AdditionalInfoView.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 05/05/25.
//

import Foundation
import UIKit
import SnapKit

final class AdditionalInfoView: UIView {
    private let humidityLabel = UILabel()
    private let pressureLabel = UILabel()
    private let windLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .main
        layer.cornerRadius = 10
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [humidityLabel, pressureLabel, windLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 16)
            addSubview($0)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(12)
        }
        
        pressureLabel.snp.makeConstraints {
            $0.top.equalTo(humidityLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
        
        windLabel.snp.makeConstraints {
            $0.top.equalTo(pressureLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(12)
        }
    }
    
    func configure(humidity: String?, pressure: String?, windSpeed: String?) {
        humidityLabel.text = "Humidity: \(humidity ?? "__")"
        pressureLabel.text = "Pressure: \(pressure ?? "__")"
        windLabel.text = "Wind: \(windSpeed ?? "__")"
    }
    
}
