//
//  WeatherSuccess.swift
//  OpenWeather
//
//  Created by Simbarashe Dombodzvuku on 4/19/25.
//

import Foundation
import SwiftUI

struct WeatherSuccess : View {
    @EnvironmentObject var weatherViewModel: WeatherViewModelImplementation
    @State private var showingSheet: Bool = false
    var forecast: Forecast
    
    init(forecast : Forecast) {
        self.forecast = forecast
    }
    
    var body: some View {
        if let weatherList = forecastResultStrip(forecast: forecast) {
            ZStack {
                VStack {
                    switch weatherList.first?.weather.first?.main {
                        case let name where name == "Clear" :
                            Image("sea_sunny")
                                .resizable()
                            //.aspectRatio(contentMode: .fill)
                                .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.4)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                        case let name where name == "Rain" :
                            Image("sea_rainy")
                                .resizable()
                            //.aspectRatio(3 / 2, contentMode: .fill)
                                .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.4)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                        default:
                            Image("sea_cloudy")
                                .resizable()
                            //.aspectRatio(3 / 2, contentMode: .fill)
                                .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.4)
                                .edgesIgnoringSafeArea([.top, .horizontal])
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: getRect().width, maxHeight: getRect().height)
                
                VStack {
                    Spacer ()
                    
                    VStack {
                        let minMax = forecastMinMax(forecast: forecast)
                        HStack {
                            //unexpected behaviour for min and max temperatures for the day. will look into purchasing license for 16 day forecast API
                            //minMax and weatherList.first.main produce the same values
                            iconView(weatherList.first!.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n min", minMax?.min ?? weatherList.first!.main.tempMin))
                            
                            Spacer()
                            
                            iconView(weatherList.first!.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n current", weatherList.first!.main.temp))
                            
                            Spacer()
                            
                            iconView(weatherList.first!.weather.first!.main, label: String.localizedStringWithFormat("%.0f° \n max", minMax?.max ?? weatherList.first!.main.tempMax))
                        }
                        .padding(.horizontal)
                        
                        LabelledDivider(label: "", horizontalPadding: -10, color: .white)
                            .glow(color: .white, radius: 1)
                            .frame(maxWidth : getRect().width)
                        
                        ForEach(weatherList) { list in
                            HStack(spacing: 0) {
                                CustomRow {
                                    Text(dayName(list.dt))
                                        .font(.caption)
                                        .padding(.leading)
                                        .frame(maxWidth: 150, alignment: .leading)
                                } center: {
                                    iconView(list.weather[0].main)
                                        .padding(.horizontal)
                                } right: {
                                    Text(String.localizedStringWithFormat("%.0f°", list.main.tempMax))
                                        .padding(.trailing)
                                }
                            }
                            .frame(maxWidth: getRect().width)  
                        }
                    }
                    .frame(maxWidth: getRect().width, maxHeight: getRect().height * 0.55, alignment: .top)
                    //background here
                    .background (
                        Group {
                            switch weatherList.first?.weather.first?.main {
                            case let name where name == "Clear" :
                                Color.blue
                            case let name where name == "Rain" :
                                Color("rainy")
                            default:
                                Color("cloudy")
                            }
                        }
                    )
                }
                .frame(maxWidth: getRect().width, maxHeight: getRect().height)
            }
            .frame(maxWidth: getRect().width, maxHeight: getRect().height)
            .background (
                Group {
                    switch weatherList.first?.weather.first?.main {
                    case let name where name == "Clear" :
                        Color.blue
                    case let name where name == "Rain" :
                        Color("rainy")
                    default:
                        Color("cloudy")
                    }
                }
            )
        } else {
            VStack {
                ErrorView(error: APIError.unknown){weatherViewModel.getForecast()}
                Image(systemName: "photo.fill")
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .frame(width: 100, height: 100)
            }
        }
        
    }
    
    func forecastResultStrip(forecast: Forecast) -> [WeatherList]? {
        var times : [Int] = []
        
        var firstDay : [Int] = []
        var secondDay : [Int] = []
        var thirdDay : [Int] = []
        var fourthDay : [Int] = []
        var fifthDay : [Int] = []

        let currentWeatherTime = forecast.list.first {
            Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
        }
        
        guard currentWeatherTime != nil else {
            return nil
        }
        
        //MARK: first approach
        for i in stride(from: TimeInterval(currentWeatherTime!.dt), through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 432_000)).timeIntervalSince1970, by: 86_400) {
            times.append(Int(i))
        }
        
        //print("this is times now",times)
            
        let res = forecast.list.filter({ weatherList in
            times.contains(weatherList.dt)
        })
        
        /*let _ = print("this is result now", res.map({
            $0.dtTxt
        }))*/
        
        //return res
        
        //MARK: second approach
        for firstDayValue in stride(from: TimeInterval(currentWeatherTime!.dt), through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400)).timeIntervalSince1970, by: 10_800) {
            firstDay.append(Int(firstDayValue))
        }
        
        for secondDayValue in stride(from: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400)).timeIntervalSince1970, through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400 * 2)).timeIntervalSince1970, by: 10_800) {
            secondDay.append(Int(secondDayValue))
        }
        
        for thirdDayValue in stride(from: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400 * 2)).timeIntervalSince1970, through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400 * 3)).timeIntervalSince1970, by: 10_800) {
            thirdDay.append(Int(thirdDayValue))
        }
        
        for fourthDayValue in stride(from: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400 * 3)).timeIntervalSince1970, through: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400 * 4)).timeIntervalSince1970, by: 10_800) {
            fourthDay.append(Int(fourthDayValue))
        }
        
        for fifthDayValue in stride(from: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 86_400 * 4)).timeIntervalSince1970, to: Date(timeIntervalSince1970: TimeInterval(currentWeatherTime!.dt + 432_000)).timeIntervalSince1970, by: 10_800) {
            fifthDay.append(Int(fifthDayValue))
        }
        
        let firstDayMax = firstDay.max()
        let secondDayMax = secondDay.max()
        let thirdDayMax = thirdDay.max()
        let fourthDayMax = fourthDay.max()
        let fifthDayMax = fifthDay.max()
        
        guard firstDayMax != nil, secondDayMax != nil, thirdDayMax != nil, fourthDayMax != nil, fifthDayMax != nil else {
            showErrorAlertView("Error", "Unable to initialize max values", handler: {})
            return nil
        }
        
        let maxArray = [firstDayMax!, secondDayMax!, thirdDayMax!, fourthDayMax!, fifthDayMax!]
        
        let result = forecast.list.filter { weatherList in
            maxArray.contains(weatherList.dt)
        }
        
        return result
    }

    func forecastMinMax(forecast: Forecast) -> (min :Double, max: Double)? {
        var maxArray : [Double] = []
        var minArray : [Double] = []
        
        let index = forecast.list.firstIndex {
            Date(timeIntervalSince1970: TimeInterval($0.dt)) > Date.now
        }
        
        let finalIndex = forecast.list.firstIndex {
            //$0.dtTxt.contains("00:00:00") //not producing expected results
            Date(timeIntervalSince1970: TimeInterval($0.dt)) > Calendar.current.date(byAdding: DateComponents(hour: 24), to: Date.now) ?? Date.now //changed Boolean test from < to > and now it emits expected results
        }
        
        guard index != nil, finalIndex != nil else {
            return nil
        }
        
        for max in forecast.list[index!...finalIndex!] {
            maxArray.append(max.main.tempMax)
        }
        
        for min in forecast.list[index!...finalIndex!] {
            minArray.append(min.main.tempMin)
        }
        
        let max = maxArray.max()
        let min = minArray.min()
        
        //not producing expected results, have no choice but to iterate over the array slice
        /*
        let max = forecast.list[index!...finalIndex!].max { a, b in
            a.main.tempMax < b.main.tempMax
        }
        
        let min = forecast.list[index!...finalIndex!].max { a, b in
            a.main.tempMax > b.main.tempMax
        }
         */
        
        guard max != nil, min != nil else {
            return nil
        }

        return (min!, max!)
    }
    
    @ViewBuilder func iconView(_ weatherMainStringValue: String, label: String = "") -> some View {
        switch weatherMainStringValue {
            case let maindesc where maindesc == "Clear" :
                Label{
                    Text(label)
                        .font(.body)
                        .fontWeight(.ultraLight)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .glow(color: .white, radius: 1)
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                } icon: {
                    Image("clear")
                        .resizable()
                        .scaledToFit()
                }
                .labelStyle(CaptionLabelStyle())
                
            case let maindesc where maindesc == "Rain":
                Label{
                    Text(label)
                        .font(.body)
                        .fontWeight(.ultraLight)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                } icon: {
                    Image("rain")
                        .resizable()
                        .scaledToFit()
                }
                .labelStyle(CaptionLabelStyle())
                
            default:
                Label{
                    Text(label)
                        .font(.body)
                        .fontWeight(.ultraLight)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                } icon: {
                    Image("partlysunny")
                        .resizable()
                        .scaledToFit()
                }
                .labelStyle(CaptionLabelStyle())
        }
    }

}

func weatherImage(_ stringValueFromMain: String) -> Image {
    var imageName: String = ""
    
    switch stringValueFromMain {
        case let name where name == "Clear" :
            imageName = "clear"
        case let name where name == "Rain":
            imageName = "rain"
        default :
            imageName = "partlysunny"
    }
    
    return Image(imageName)
        .resizable()
        .scaledToFit() as! Image
}

struct CaptionLabelStyle : LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .scaleEffect(0.8, anchor: .center)
                .frame(width: 20, height: 20, alignment: .center)
            configuration.title
        }
        .font(.subheadline)
    }
}

struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

func dayName(_ unixValue: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let date = Date(timeIntervalSince1970: TimeInterval(unixValue))
    dateFormatter.timeZone = .current
    return dateFormatter.string(from: date)
}

struct ErrorView: View {
    @Environment(\.dismiss) var dismiss
    typealias ErrorViewActionHandler = () -> Void
    
    let error: Error
    let handler: ErrorViewActionHandler
    
    internal init(error: Error, handler: @escaping ErrorView.ErrorViewActionHandler) {
        self.error = error
        self.handler = handler
    }

    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud.fill")
                .foregroundColor(.gray)
                .font(.system(size: 50, weight: .black, design: .rounded))
                .padding(.bottom, 5)
            
            Text("Sorry, something went wrong here")
                .foregroundColor(.black)
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .multilineTextAlignment(.center)
            
            Text(error.localizedDescription)
                .foregroundColor(.gray)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .padding(.vertical, 5)
            
            Button {
                handler()
            } label: {
                Text("Retry")
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .heavy, design: .rounded))
            .cornerRadius(10)
            
            Button {
                dismiss()
            } label: {
                Text("OK")
            }

        }
    }
}
