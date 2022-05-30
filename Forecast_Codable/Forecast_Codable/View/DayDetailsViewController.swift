//
//  DayDetailsViewController.swift
//  Forecast_Codable
//
//  Created by Karl Pfister on 2/6/22.
//

import UIKit

class DayDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    //MARK: - Properties
    var days: [Day] = []
    var forecastData: TopLevelDictionary?
    
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        dayForcastTableView.dataSource = self
        WeatherNetworkService.fetchDays { forecastData in
            guard let forecastData = forecastData else {return}
            
            self.forecastData = forecastData
            self.days = forecastData.days
            DispatchQueue.main.async {
                self.updateViews()
                self.dayForcastTableView.reloadData()
            }
        }
    }
    
    func updateViews() {
        guard let day = days.first else {return}
        cityNameLabel.text = forecastData?.cityName
        currentTempLabel.text = "\(day.temp)"
        currentHighLabel.text = "\(day.highTemp)"
        currentLowLabel.text = "\(day.lowTemp)"
        currentDescriptionLabel.text = day.weather.description
    }
}

//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        let day = days[indexPath.row]
        cell.updateViews(day: day)
        return cell
    }
}


