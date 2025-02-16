import Foundation

struct WeatherData: Decodable{
    let name: String
    let main: main
    let weather: [Weather]
}

struct main: Decodable{
    let temp: Double
}

struct Weather: Decodable{
    let id: Int
    let description: String
}
