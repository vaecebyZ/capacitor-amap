# @vaecebyz/capacitor-amap

Amap for Capacitor

## Install

```bash
npm install @vaecebyz/capacitor-amap
npx cap sync
```

## API

<docgen-index>

* [`locate()`](#locate)
* [`weather(...)`](#weather)
* [`calculate(...)`](#calculate)
* [`checkPermissions()`](#checkpermissions)
* [`requestPermissions()`](#requestpermissions)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### locate()

```typescript
locate() => any
```

**Returns:** <code>any</code>

--------------------


### weather(...)

```typescript
weather(param: { adCode: string; }) => any
```

| Param       | Type                             |
| ----------- | -------------------------------- |
| **`param`** | <code>{ adCode: string; }</code> |

**Returns:** <code>any</code>

--------------------


### calculate(...)

```typescript
calculate(params: { startLatitude: number; startLongitude: number; endLatitude: number; endLongitude: number; }) => any
```

| Param        | Type                                                                                                       |
| ------------ | ---------------------------------------------------------------------------------------------------------- |
| **`params`** | <code>{ startLatitude: number; startLongitude: number; endLatitude: number; endLongitude: number; }</code> |

**Returns:** <code>any</code>

--------------------


### checkPermissions()

```typescript
checkPermissions() => any
```

**Returns:** <code>any</code>

--------------------


### requestPermissions()

```typescript
requestPermissions() => any
```

**Returns:** <code>any</code>

--------------------


### Interfaces


#### Location

| Prop               | Type                | Description |
| ------------------ | ------------------- | ----------- |
| **`accuracy`**     | <code>number</code> | 定位精度        |
| **`adCode`**       | <code>string</code> | 区域编码        |
| **`address`**      | <code>string</code> | 地址          |
| **`city`**         | <code>string</code> | 城市\|区       |
| **`cityCode`**     | <code>string</code> | 城市编码        |
| **`latitude`**     | <code>number</code> | 精度          |
| **`longitude`**    | <code>number</code> | 纬度          |
| **`aoiName`**      | <code>string</code> | 当前定位点的AOI信息 |
| **`country`**      | <code>string</code> | 国家          |
| **`district`**     | <code>string</code> | 城区信息        |
| **`poiName`**      | <code>string</code> | 当前定位点的POI信息 |
| **`province`**     | <code>string</code> | 省份          |
| **`street`**       | <code>string</code> | 街道          |
| **`streetNum`**    | <code>string</code> | 街道号         |
| **`locationTime`** | <code>Date</code>   | 定位时间        |


#### WeatherInfo

| Prop                | Type                              | Description |
| ------------------- | --------------------------------- | ----------- |
| **`type`**          | <code>'live' \| 'forecast'</code> |             |
| **`weather`**       | <code>string</code>               | 天气          |
| **`temperature`**   | <code>string</code>               | 温度          |
| **`city`**          | <code>string</code>               | 城市\|区       |
| **`province`**      | <code>string</code>               | 省份          |
| **`windDirection`** | <code>string</code>               | 风向          |
| **`windPower`**     | <code>string</code>               | 风力          |
| **`humidity`**      | <code>string</code>               | 湿度          |


#### PermissionStatus

| Prop           | Type                                                        |
| -------------- | ----------------------------------------------------------- |
| **`location`** | <code><a href="#permissionstate">PermissionState</a></code> |


### Type Aliases


#### PermissionState

<code>'prompt' | 'prompt-with-rationale' | 'granted' | 'denied'</code>

</docgen-api>
