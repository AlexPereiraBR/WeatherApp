//
//  ForecastDayCell.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 09/05/25.
//

import Foundation
import UIKit
import SnapKit

class ForecastDayCell: UITableViewCell {
    
    // MARK: - Properties
    private let dayLabel = UILabel()
    private let tempLabel = UILabel()
    private let iconView = UIImageView()
    static let reuseID = "ForecastDayCell"
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [iconView, dayLabel, tempLabel].forEach {
            contentView.addSubview($0)
        }
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Configuration
    func configure(with day: ForecastDay) {
        let df = DateFormatter()
        df.dateFormat = "EEE"   // Mon, Tue, …
        dayLabel.text = df.string(from: day.date)
        tempLabel.text = "\(day.temperature)°C"
        // Для иконки можно загрузить через ImageCacheManager, либо напрямую:
        let url = URL(string: "https://openweathermap.org/img/wn/\(day.iconCode)@2x.png")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async { self.iconView.image = img }
        }.resume()
    }
}
