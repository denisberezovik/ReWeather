//
//  WeatherCollectionViewCell.swift
//  ReWeather
//
//  Created by REEMOTTO on 29.11.21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "HourlyCollectionViewCell"
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        
        addSubview(temperatureLabel)
        addSubview(timeLabel)
        addSubview(iconImageView)
        
        layoutSubviews()
 }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var timeLabel = UILabel()
    var iconImageView = UIImageView()
    var temperatureLabel = UILabel()
    
    func configure(with model: Hourly, index: Int ) {
        self.timeLabel.textAlignment = .center
        self.temperatureLabel.textAlignment = .center
        self.temperatureLabel.textColor = .black
        self.timeLabel.textColor = .black
        self.temperatureLabel.text = "\(Int(model.temp))°"
    
        if index == 0 {
            timeLabel.text = "Now"
        } else {
            let hourForDate = Date(timeIntervalSince1970: Double(model.dt)).getHourForDate()
            timeLabel.text = hourForDate
        }
        
        self.iconImageView.contentMode = .scaleAspectFit
        
        let icon = model.weather[0].icon
        let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        iconImageView.downloaded(from: urlString ?? "")
        
    }
    
    override func layoutSubviews() {
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
     
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        iconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5).isActive = true
        temperatureLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      
    }
    
}



