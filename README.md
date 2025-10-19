# capacitor-amap
高德地图 Capacitor 插件（定位、天气、距离计算等）。

> 本包基于原 `capacitor-plugin-getui` 演进，原作者已不再维护；现由 `vaecebyZ` 继续维护。保留原 MIT 许可归属。

> 注意：从 1.0.2 起包名改为 `@vaecebyz/capacitor-amap` 并附带两个 podspec (`CapacitorAmap.podspec` 与 `VaecebyzCapacitorAmap.podspec`) 以兼容 Capacitor CLI 在不同版本下的命名解析。支持 Capacitor 3 - 7。

## 特性
- 单次定位（含逆地理信息）
- 天气实时查询（按城市/行政区编码）
- 经纬度距离计算（Haversine，纯数学实现无地图视图依赖）

## 支持环境
- Capacitor 3.x
- iOS 12+ (AMapFoundation / AMapLocation / AMapSearch)
- Android API 21+ (使用高德定位/搜索/3D 地图 SDK)
- JDK 11（构建插件时建议使用；旧版 AGP 4.2.1 与 JDK 17/21 不兼容）

> 本仓库已固定使用 JDK 11。进入目录后可运行 `sdk env`（或开启 SDKMAN 的 auto-env）自动切换到 `.sdkmanrc` 指定的版本。
> 若你的全局默认是 JDK 21，请务必在构建本插件或运行验证脚本前切换到 11，以避免 AGP 4.2.x 的兼容性问题。

## 安装
```bash
npm install @vaecebyz/capacitor-amap
npx cap sync
```
## 配置
### iOS
在 `capacitor.config.ts` / `capacitor.config.json` 中配置 `iosKey`：
```typescript
const config: CapacitorConfig = {
    plugins: {
        CapacitorAMap: {
            iosKey: "your key",
        },
    }
};
```

在 Xcode 的 `Info.plist` 中添加定位权限文案：
```
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>此应用需要定位权限才能正常使用</string>
```
<img width="1026" alt="image" src="https://user-images.githubusercontent.com/23025255/161018082-6904e5b1-e5e8-4621-bed1-772c7f1d5fbf.png">

### Android
在你的应用模块 `AndroidManifest.xml` 中加入高德 Android API Key：

```xml
<application>
        <!-- 你的其它配置 -->
        <meta-data
                android:name="com.amap.api.v2.apikey"
                android:value="YOUR_ANDROID_API_KEY" />
</application>
```

并确保已有定位相关权限（如果只做单次定位，可按需裁剪）：

```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### 构建注意事项
1. 使用 JDK 11：若使用 sdkman，可 `sdk env` 或 `sdk use java 11.*` 后再执行 `npm run verify`。
2. 若你升级 Android Gradle Plugin 到 7+/8+，需要同步升级 Capacitor 依赖并添加 `namespace`，本插件当前以稳定回退（AGP 4.2.1）为主。
3. iOS 初次构建需要安装对应 iOS 平台 SDK（Xcode Preferences -> Components）。

#### 使用 SDKMAN 自动切换 JDK
仓库根目录包含 `.sdkmanrc`：

```properties
java=11.0.23-tem
```

执行：

```bash
sdk env   # 切换到 .sdkmanrc 指定的 JDK 11
```

或启用自动：

```bash
sdk config set auto_env=true
```

验证：

```bash
./android/gradlew -version
```

输出中应显示 "Java 11"。

### iOS Pods
本插件在 Pod 安装时会引入：
- `AMapFoundation`
- `AMapLocation`
- `AMapSearch`

无需引入 `AMap3DMap` 以实现定位与天气。

## 使用示例

```typescript
import { Plugins } from '@capacitor/core';
const { CapacitorAMap } = Plugins as any;

// 定位
CapacitorAMap.locate().then(res => {
    console.log('定位结果', res);
}).catch(err => console.error('定位失败', err));

// 天气查询 (adCode 可为城市/区县行政区编码)
CapacitorAMap.weather({ adCode: '310000' }).then(res => {
    console.log('天气', res);
});

// 距离计算
const distanceRes = await CapacitorAMap.calculate({
    startLatitude: 31.2304,
    startLongitude: 121.4737,
    endLatitude: 39.9042,
    endLongitude: 116.4074,
});
console.log('两点距离(米):', distanceRes.distance);
```

## API

| 方法 | 参数 | 返回 | 说明 |
|------|------|------|------|
| `locate()` | 无 | 定位 + 逆地理对象 | 单次定位，返回经纬度和地址字段 |
| `weather({ adCode })` | `adCode: string` | 天气对象 | 查询实时天气 |
| `calculate({ startLatitude, startLongitude, endLatitude, endLongitude })` | 数值 | `{ distance: number }` | 计算两点球面距离 (米) |

## 发布/构建脚本
执行自检：
```bash
npm run verify   # iOS / Android / Web 快速构建
npm run build    # 生成 dist 与文档
```

## 许可证
Apache-2.0

<img width="1384" alt="image" src="https://user-images.githubusercontent.com/23025255/161021530-eb2ba6d6-e4ed-41e9-b042-67f03f538933.png">
