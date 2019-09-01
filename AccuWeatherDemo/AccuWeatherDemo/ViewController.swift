//
//  ViewController.swift
//  AccuWeatherDemo
//
//  Created by ohlulu on 2019/9/1.
//  Copyright © 2019 ohlulu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var tmpLabel: UILabel!
    
    let apiKey = "Nx8fVetx3yB9xfvSAql3kICyQFTU1hHK"
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
    }
    
    private func callAPI() {
        // 根據網站的 Request tab info 我們拼出請求的網址
        let url = URL(string: "https://dataservice.accuweather.com/currentconditions/v1/315078?apikey=\(apiKey)&language=zh-Tw")!
        
        // 將網址組成一個 URLRequest
        var request = URLRequest(url: url)
        
        // 設置請求的方法為 GET
        request.httpMethod = "GET"
        
        // 建立 URLSession
        let session = URLSession.shared
        
        // 使用 sesstion + request 組成一個 task
        // 並設置好，當收到回應時，需要處理的動作
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // 這邊是收到回應時會執行的 code
            
            // 因為 data 是 optional，有可能請求失敗，導致 data 是空的
            // 如果是空的，我們直接 return，不做接下來的動作
            guard let data = data else {
                return
            }
            
            do {
                // 使用 JSONDecoder 去解開 data
                let weatherModel = try JSONDecoder().decode([WeatherModel].self, from: data)
                print(weatherModel)
                
                // 改變 UI 的動作必須在主線程完成，所以將下面的 code 包在 DispatchQueue.main.async 的大括號裡面
                DispatchQueue.main.async {
                    self.locationLabel.text = "台北市"
                    // 因為我們用 Array<WeatherModel> 去解析 data，所以在使用的時候我們先取出第一筆資料ㄝ
                    let tmp = weatherModel.first?.temperature.metric.value ?? -1
                    self.tmpLabel.text = "\(tmp)℃"
                }
                
            } catch {
                print(error)
            }
            
        })
        
        // 啟動 task
        dataTask.resume()

    }
}




