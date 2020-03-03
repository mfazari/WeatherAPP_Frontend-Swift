import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var Humidity_text: UILabel!
    @IBOutlet weak var Pressure_text: UILabel!
    
    var activityIndicator: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        start()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDayBackground()
    }
    
    // "here" is the default location which is determined by API based on IP
    func start() {
        display_weather(location: "here")
    }
    
    /*
    // Terminal print for searchBar input
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("\(searchText)")
    }
    */
    
    // searchBar Button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var search = searchBar.text!
        if search.contains(" ") {
            search = search.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        }
        display_weather(location: search)
        print(search)
    }
    
    
    // Main function
    func display_weather(location: String) {
        Alamofire.request("http://localhost:8080/forecast/" + location).responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                // statuscode
                let statusCode = response.response?.statusCode
                if (statusCode != 200){
                    self.show_alert()
                }
                else if(statusCode == 200){
                    let jsonResponse = JSON(responseStr)
                    
                    // Round our temperature to int
                    let temperature = "\(Int(round(jsonResponse["temperature"].doubleValue)))"
                    
                    let location_name = jsonResponse["location"].stringValue
                    let iconName = jsonResponse["icon"].stringValue
                    let pressure = jsonResponse["pressure"].stringValue
                    let humidity = jsonResponse["humidity"].stringValue
                    let condition = jsonResponse["condition"].stringValue
                    
                    self.locationLabel.text = location_name
                    self.conditionLabel.text = condition
                    self.temperatureLabel.text = temperature
                    self.humidityLabel.text = humidity
                    self.pressureLabel.text = pressure
                    
                    // Set icon
                    self.conditionImageView.image = UIImage(named: iconName)
                    
                    // Set icon according to day or night
                    let suffix = iconName.suffix(1)
                    if(suffix == "n"){
                        self.setNightBackground()
                    }else{
                        self.setDayBackground()
                    }}
            }
        }
    }
    
    // Show Alert
    func show_alert(){
        let alert = UIAlertController(title: "Error", message: "Sorry, location doesn't exist", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Set Background Functions
    func setDayBackground(){
        backgroundView.backgroundColor = UIColor(red: 231.0/255.0, green: 227.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        locationLabel.textColor = UIColor.black
        conditionLabel.textColor = UIColor.black
        temperatureLabel.textColor = UIColor.black
        celsiusLabel.textColor = UIColor.black
        Humidity_text.textColor = UIColor.black
        humidityLabel.textColor = UIColor.black
        Pressure_text.textColor = UIColor.black
        pressureLabel.textColor = UIColor.black
    }
    
    func setNightBackground(){
        backgroundView.backgroundColor = UIColor(red: 24.0/255.0, green: 28.0/255.0, blue: 29.0/255.0, alpha: 1.0)
        locationLabel.textColor = UIColor.white
        conditionLabel.textColor = UIColor.white
        temperatureLabel.textColor = UIColor.white
        celsiusLabel.textColor = UIColor.white
        Humidity_text.textColor = UIColor.white
        humidityLabel.textColor = UIColor.white
        Pressure_text.textColor = UIColor.white
        pressureLabel.textColor = UIColor.white
    }
    
}

