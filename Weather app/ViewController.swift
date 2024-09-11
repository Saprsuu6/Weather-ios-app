import UIKit

class ViewController: UIViewController {
    @IBOutlet var weatherInfo: UILabel!
    @IBOutlet var getWeatherBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherBtn.addTarget(self, action: #selector(didTapedGetWeatherBtn), for: .touchUpInside)
    }
    
    @objc func didTapedGetWeatherBtn() {
        weatherInfo.text = "Fetching data..."
        
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        
        let url = URL(string: urlString)!;
        let request = URLRequest(url: url);
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data, let weather = try? JSONDecoder().decode(Welcome.self, from: data) {
                DispatchQueue.main.async {
                    let temperature = weather.current.temperature2M;
                    let windSpeed = weather.current.windSpeed10M;
                    
                    self.weatherInfo.text = """
                        Temperature: \(temperature)°C
                        Wind Speed: \(windSpeed) m/s
                    """
                    
                    switch temperature {
                        case ..<0: // Низкая температура
                            self.weatherInfo.textColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
                        case 0...20: // Средняя температура
                            self.weatherInfo.textColor =  UIColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1)
                        default: // Высокая температура
                            self.weatherInfo.textColor =  UIColor(red: 255/255, green: 69/255, blue: 0/255, alpha: 1) // 
                    }
                }

                print("Parsed");
            } else {
                print("Failed");
            }
        }
        
        task.resume()
    }
}

