//
//  ViewController.swift
//  ReWeather
//
//  Created by REEMOTTO on 18.11.21.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private var dailyModels = [Daily]()
    private var hourlyModels = [Hourly]()
    private var icon = String()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    lazy var safeArea = view.safeAreaLayoutGuide
    private var layout = UICollectionViewFlowLayout()
    
    // MARK: - Subviews
    
    private let gifImageView = UIImageView()
    private let currentView = UIView()
    private let locationLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let highTemperatureLabel = UILabel()
    private let lowTemperatureLabel = UILabel()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let weatherTableView = UITableView()
    private let customColor: UIColor = #colorLiteral(red: 0.9867113233, green: 0.7987712622, blue: 0.0005572578521, alpha: 1)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Methods
    
    private func setup() {
        buildHierarchy()
        configureSubviews()
        layoutSubviews()
        setIcons()
    }
    
    private func configureSubviews() {
        
        gifImageView.contentMode = .scaleAspectFill
        
        view.backgroundColor = customColor
        currentView.backgroundColor = .clear
        locationLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        currentTemperatureLabel.textAlignment = .center
        highTemperatureLabel.textAlignment = . center
        lowTemperatureLabel.textAlignment = .center
        locationLabel.textColor = .black
        descriptionLabel.textColor = .black
        currentTemperatureLabel.textColor = .black
        highTemperatureLabel.textColor = .black
        lowTemperatureLabel.textColor = .black
        
        locationLabel.font = .boldSystemFont(ofSize: 30)
        currentTemperatureLabel.font = .systemFont(ofSize: 50)
        highTemperatureLabel.font = .systemFont(ofSize: 20)
        lowTemperatureLabel.font = .systemFont(ofSize: 20)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.cornerRadius = 15
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.tableFooterView = UIView()
        weatherTableView.rowHeight = 80
        weatherTableView.backgroundColor = customColor
        weatherTableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        weatherTableView.showsVerticalScrollIndicator = false
        weatherTableView.layer.cornerRadius = 15
        weatherTableView.contentInset = UIEdgeInsets(top: -24, left: 0, bottom: 0, right: 0)
    }
    
    private func buildHierarchy() {
        view.addSubview(gifImageView)
        view.addSubview(currentView)
        currentView.addSubview(locationLabel)
        currentView.addSubview(currentTemperatureLabel)
        currentView.addSubview(descriptionLabel)
        currentView.addSubview(highTemperatureLabel)
        currentView.addSubview(lowTemperatureLabel)
        view.addSubview(collectionView)
        view.addSubview(weatherTableView)
    }
    
    private func layoutSubviews() {
        
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.topAnchor.constraint(equalTo: currentView.topAnchor).isActive = true
        gifImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        gifImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        
        currentView.translatesAutoresizingMaskIntoConstraints = false
        currentView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        currentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        currentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        currentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 15).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 35).isActive = true
        
        currentTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTemperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15).isActive = true
        currentTemperatureLabel.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 35).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 35).isActive = true
        
        highTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        highTemperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        highTemperatureLabel.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 35).isActive = true
        
        lowTemperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        lowTemperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        lowTemperatureLabel.leadingAnchor.constraint(equalTo: highTemperatureLabel.leadingAnchor, constant: 100).isActive = true
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: currentView.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        weatherTableView.translatesAutoresizingMaskIntoConstraints = false
        weatherTableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8).isActive = true
        weatherTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        weatherTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        weatherTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    private func setIcons() {
        switch icon {
            
        case "01n", "01d" :
            gifImageView.loadGif(name: "sunny")
        case "02n", "02d" :
            gifImageView.loadGif(name: "partly cloudy")
        case "03n", "03d" :
            gifImageView.loadGif(name: "cloudy")
        case "04n", "04d" :
            gifImageView.loadGif(name: "cloudy")
        case "09n", "09d" :
            gifImageView.loadGif(name: "rainy")
        case "10n", "10d" :
            gifImageView.loadGif(name: "rainy")
        case "11n", "11d" :
            gifImageView.loadGif(name: "stormy")
        case "13n", "13d" :
            gifImageView.loadGif(name: "snowy")
        case "50n", "50d" :
            gifImageView.loadGif(name: "foggy")
        default:
            print("")
        }
    }
    
    
    
    private func requestWeatherForLocation(completion: @escaping (WeatherStruct?)-> Void) {
        guard let latitude = currentLocation?.coordinate.latitude,
              let longitude = currentLocation?.coordinate.longitude else { return }
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely&appid=ce06563b332a34ab69440e44c319ef3e"
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(WeatherStruct.self, from: data)
                DispatchQueue.main.async {
                    completion(response)
                    
                }
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
            }
            
        }
        
        .resume()
        
    }
    
    
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation { weather in
                guard let daily = weather?.daily,
                      let weather = weather else { return }
                self.dailyModels = daily
                if let weather = weather.current.weather.first {
                    self.icon = weather.icon
                    DispatchQueue.main.async {
                        self.setIcons()
                    }
                }
                
                self.hourlyModels = weather.hourly
                self.locationLabel.text = weather.timezone.deletingPrefix()
                self.currentTemperatureLabel.text = "\(String(Int(weather.current.temp)))°"
                self.descriptionLabel.text = weather.current.weather.first?.descriptionWeather.capitalized
                self.highTemperatureLabel.text = "High: \(String(Int(weather.daily.first?.temp.max ?? 0)))°"
                self.lowTemperatureLabel.text = "Low: \(String(Int(weather.daily.first?.temp.min ?? 0)))°"
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.weatherTableView.reloadData()
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Can't get location", error)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: dailyModels[indexPath.row])
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "8-Day Forecast"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = (view as? UITableViewHeaderFooterView)
        header?.textLabel?.textColor = UIColor.black
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        header?.tintColor = customColor
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}


// MARK: - UUICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: hourlyModels[indexPath.row], index: indexPath.row)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}








