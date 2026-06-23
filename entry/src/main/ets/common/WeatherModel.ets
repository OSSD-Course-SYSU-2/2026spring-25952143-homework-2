/**
 * 天气数据模型
 * 对应 wttr.in (?format=j1) 接口返回的 JSON 结构
 * 接口文档: https://github.com/chubin/wttr.in
 */

export interface WeatherDesc {
  value: string;
}

/** 当前实时天气状况 */
export interface CurrentCondition {
  temp_C: string;
  FeelsLikeC: string;
  humidity: string;
  windspeedKmph: string;
  weatherDesc: WeatherDesc[];
  observation_time: string;
}

/** 单日天气预报 */
export interface DailyWeather {
  date: string;
  maxtempC: string;
  mintempC: string;
  avgtempC: string;
}

export interface AreaValue {
  value: string;
}

/** 查询地区信息 */
export interface NearestArea {
  areaName: AreaValue[];
  country: AreaValue[];
  region: AreaValue[];
}

/** 接口完整响应结构 */
export interface WeatherResponse {
  current_condition: CurrentCondition[];
  weather: DailyWeather[];
  nearest_area: NearestArea[];
}
