//
//  WeatherTableViewCell.swift
//  ReWeather
//
//  Created by REEMOTTO on 18.11.21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    var dayLabel = UILabel()
    var highTempLabel = UILabel()
    var lowTempLabel = UILabel()
    var iconImageView = UIImageView()
    
    static var identifier = "WeatherTableViewCell"
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(dayLabel)
        addSubview(highTempLabel)
        addSubview(lowTempLabel)
        addSubview(iconImageView)
        
        self.tintColor = .clear
        
        setLabelConstraints()
        setImageConstraints()
        configureLabel()        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Daily) {
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textColor = .black
        self.lowTempLabel.textColor = .black
        self.dayLabel.textColor = .black
        self.dayLabel.font = .systemFont(ofSize: 18)
        self.lowTempLabel.font = .systemFont(ofSize: 18)
        self.highTempLabel.font = .systemFont(ofSize: 18)
        self.lowTempLabel.text = "\(Int(model.temp.min))°"
        self.highTempLabel.text = "\(Int(model.temp.max))°"
        
        let icon = model.weather[0].icon
        let urlString = "http://openweathermap.org/img/wn/\(icon)@2x.png"
        iconImageView.downloaded(from: urlString ?? "")
        
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        self.iconImageView.contentMode = .scaleAspectFit
        
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            iconImageView.image = nil
        }
    
    func configureLabel() {
        highTempLabel.numberOfLines = 0
        lowTempLabel.numberOfLines = 0
        dayLabel.numberOfLines = 0
        
        highTempLabel.adjustsFontSizeToFitWidth = true
        lowTempLabel.adjustsFontSizeToFitWidth = true
        dayLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.masksToBounds = true
    }
    
    func setLabelConstraints() {
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        lowTempLabel.translatesAutoresizingMaskIntoConstraints = false
        lowTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        lowTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        lowTempLabel.widthAnchor.constraint(equalToConstant: 66).isActive = true
        
        highTempLabel.translatesAutoresizingMaskIntoConstraints = false
        highTempLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        highTempLabel.leadingAnchor.constraint(equalTo: lowTempLabel.trailingAnchor, constant: 5).isActive = true
        highTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        highTempLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        highTempLabel.widthAnchor.constraint(equalToConstant: 66).isActive = true
    }
    
}
