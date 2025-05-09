//
//  ForecastDayCell.swift
//  WeatherApp
//
//  Created by Aleksandr Shchukin on 09/05/25.
//

import Foundation
import UIKit
import Alamofire

class ForecastDayCell: UITableViewCell {
    
    // MARK: - Properties
    private let dayLabel = UILabel()
    private let tempLabel = UILabel()
    private let iconView = UIImageView()
    static let reuseID = "ForecastDayCell"
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [iconView, dayLabel, tempLabel])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(equalToConstant: 30),
        ])
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
