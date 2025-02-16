import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=14ec7dbbcad5852ce7ff16ff444b8c3d&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequests(with: urlString)
    } //用城市名字获取天气信息
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequests(with: urlString)
    } //用经纬度获取天气信息
    
    func performRequests(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default) //创建默认配置
            let task = session.dataTask(with: url) { (data, respons, error) in
                if error != nil{ //解析失败调用
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{  //解析成功调用
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume() //启动任务
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{                                       //解码类型。   ⬅️         数据源头
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            
        } catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
