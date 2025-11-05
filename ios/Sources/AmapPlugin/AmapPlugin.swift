import Foundation
import Capacitor
import AMapFoundationKit
import AMapLocationKit
import AMapSearchKit
import MAMapKit
import CoreLocation

var locateCalls = [CAPPluginCall]()

@objc(AMapPlugin)
public class AMapPlugin: CAPPlugin, CAPBridgedPlugin, AMapLocationManagerDelegate, AMapSearchDelegate, CLLocationManagerDelegate {
    public let identifier = "AMapPlugin"
    public let jsName = "CapacitorAMap"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "load", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "init", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "locate", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "weather", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "calculate", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "checkPermissions", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "requestPermissions", returnType: CAPPluginReturnPromise)
    ]
    
    var aMapLocationManager: AMapLocationManager? = nil
    var weatherCall: CAPPluginCall? = nil
    var search: AMapSearchAPI? = nil
    var isInLocation = false
    
    // MARK: - 生命周期
    @objc public func load(_ call: CAPPluginCall) {
        // 插件加载时调用，可以在此预先初始化部分配置
        print("[AMapPlugin] load() called")
        if let iosKey = getConfigValue("iosKey") as? String {
            AMapServices.shared().apiKey = iosKey
            AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
            AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
            
            self.aMapLocationManager = AMapLocationManager()
            self.aMapLocationManager?.delegate = self
            self.aMapLocationManager?.pausesLocationUpdatesAutomatically = false
            self.aMapLocationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.aMapLocationManager?.locationTimeout = 3
            self.aMapLocationManager?.reGeocodeTimeout = 3
            
            call.resolve()
        } else {
            call.reject("未配置 iOS Key")
        }
    }

    @objc public override func checkPermissions(_ call: CAPPluginCall) {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            call.resolve(["status": "notDetermined"])
        case .restricted:
            call.resolve(["status": "restricted"])
        case .denied:
            call.resolve(["status": "denied"])
        case .authorizedAlways, .authorizedWhenInUse:
            call.resolve(["status": "granted"])
        @unknown default:
            call.resolve(["status": "unknown"])
        }
    }

    @objc public override func requestPermissions(_ call: CAPPluginCall) {
        guard CLLocationManager.locationServicesEnabled() else {
            call.reject("定位服务未启用")
            return
        }

        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // 请求权限
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()

        // 检查请求后的权限状态
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            call.resolve(["status": "granted"])
        } else {
            call.reject("定位权限请求失败")
        }
    }

    
    // MARK: - 初始化
    @objc func `init`(_ call: CAPPluginCall) {
        if let iosKey = getConfigValue("iosKey") as? String {
            AMapServices.shared().apiKey = iosKey
            AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
            AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
            
            self.aMapLocationManager = AMapLocationManager()
            self.aMapLocationManager?.delegate = self
            self.aMapLocationManager?.pausesLocationUpdatesAutomatically = false
            self.aMapLocationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.aMapLocationManager?.locationTimeout = 3
            self.aMapLocationManager?.reGeocodeTimeout = 3
            
            call.resolve()
        } else {
            call.reject("未配置 iOS Key")
        }
    }
    
    // MARK: - 定位
    @objc func locate(_ call: CAPPluginCall) {
        locateCalls.append(call)
        self.aMapLocationManager?.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            guard let self = self else { return }
            
            if let error = error as NSError? {
                NSLog("定位错误: {\(error.code) - \(error.localizedDescription)}")
                for item in locateCalls {
                    item.reject("定位错误:{\(error.code) - \(error.localizedDescription)}")
                }
                locateCalls.removeAll()
                return
            }
            
            guard let location = location else {
                for item in locateCalls {
                    item.reject("定位失败: 无位置信息")
                }
                locateCalls.removeAll()
                return
            }
            
            if let reGeocode = reGeocode {
                var result = [String: String]()
                result["latitude"] = "\(location.coordinate.latitude)"
                result["longitude"] = "\(location.coordinate.longitude)"
                result["address"] = reGeocode.formattedAddress ?? ""
                result["streetNum"] = reGeocode.number ?? ""
                result["country"] = reGeocode.country ?? ""
                result["district"] = reGeocode.district ?? ""
                result["adCode"] = reGeocode.adcode ?? ""
                result["province"] = reGeocode.province ?? ""
                result["street"] = reGeocode.street ?? ""
                result["city"] = reGeocode.city ?? ""
                result["cityCode"] = reGeocode.citycode ?? ""
                result["poiName"] = reGeocode.poiName ?? ""
                result["aoiName"] = reGeocode.aoiName ?? ""
                
                for item in locateCalls {
                    item.resolve(result)
                }
                locateCalls.removeAll()
                return
            }
            
            for item in locateCalls {
                item.reject("逆地理失败，无返回值")
            }
            locateCalls.removeAll()
        })
    }
    
    // MARK: - 天气查询
    @objc func weather(_ call: CAPPluginCall) {
        if self.weatherCall != nil {
            call.reject("已有正在执行中的天气查询任务")
            return
        }
        self.weatherCall = call
        self.search = AMapSearchAPI()
        self.search?.delegate = self
        
        let adCode = call.getString("adCode")
        let request = AMapWeatherSearchRequest()
        request.city = adCode
        request.type = AMapWeatherType.live
        
        self.search?.aMapWeatherSearch(request)
    }
    
    // MARK: - 距离计算
    @objc func calculate(_ call: CAPPluginCall) {
        let startLat = call.getDouble("startLatitude") ?? 0
        let startLng = call.getDouble("startLongitude") ?? 0
        let endLat = call.getDouble("endLatitude") ?? 0
        let endLng = call.getDouble("endLongitude") ?? 0
        
        let point1 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: startLat, longitude: startLng))
        let point2 = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: endLat, longitude: endLng))
        let distance = MAMetersBetweenMapPoints(point1, point2)
        
        var result = [String: Double]()
        result["distance"] = distance
        call.resolve(result)
    }
    
    // MARK: - AMapSearchDelegate 天气结果
    public func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        guard let call = self.weatherCall else { return }
        defer { self.weatherCall = nil }
        
        if response.lives.isEmpty {
            call.reject("获取天气失败")
            return
        }
        if let weather = response.lives.first {
            var result = [String: String]()
            result["weather"] = weather.weather ?? ""
            result["temperature"] = weather.temperature ?? ""
            result["windDirection"] = weather.windDirection ?? ""
            result["windPower"] = weather.windPower ?? ""
            result["humidity"] = weather.humidity ?? ""
            call.resolve(result)
            return
        }
        call.reject("获取天气失败")
    }
    
    public func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        self.weatherCall?.reject("获取天气失败: \(error.localizedDescription)")
        self.weatherCall = nil
    }
}
