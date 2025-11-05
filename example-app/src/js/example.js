import { CapacitorAMap } from '@vaecebyz/capacitor-amap';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    console.log(inputValue)
    console.log(CapacitorAMap)
    CapacitorAMap.echo("1232132")
    CapacitorAMap.checkPermissions()
    CapacitorAMap.requestPermissions()
    CapacitorAMap.locate().then(async (result) => {
        // {result
        //     "accuracy": 30,
        //     "adCode": "500105",
        //     "address": "重庆市江北区福港大道靠近井池村",
        //     "city": "重庆市",
        //     "cityCode": "023",
        //     "altitude": 0,
        //     "latitude": 29.622122,
        //     "longitude": 106.802222,
        //     "aoiName": "",
        //     "country": "中国",
        //     "district": "江北区",
        //     "poiName": "井池村",
        //     "province": "重庆市",
        //     "street": "福港大道",
        //     "streetNum": "",
        //     "locationTime": "Wed Oct 15 15:42:26 GMT+08:00 2025"
        // }
        console.log('CapacitorAMap locate result:', result);
        // const geo = {
        //   coordinates: [String(result!.longitude), String(result!.latitude)].join(','),
        // };
        // const [err, res] = await Ptry(ApiLocation.updateLocation(geo));
        // if (err) return console.error('保存定位失败:', err);
        // const { data } = (res as any) || {}
        // const { content } = data || {}
        // {content
        //     "status": "1",
        //     "info": "OK",
        //     "regeocode": {
        //         "addressComponent": {
        //             "city": "",
        //             "province": "重庆市",
        //             "district": "江北区"
        //         },
        //         "formattedAddress": "重庆市江北区鱼嘴镇福港大道"
        //     }
        // }
        if (content && content.status === '1') {
          // const addrComp = content.regeocode?.addressComponent || {}
        //   userPosition.value = [result!.longitude, result!.latitude];
          return true
        } else {
          console.error('解析定位地址失败:', content);
          return false
        }
      }).catch((error) => {
        console.error('CapacitorAMap locate error:', error);
        return false
      });
}
