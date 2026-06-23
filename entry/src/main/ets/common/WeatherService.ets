import http from '@ohos.net.http';
import type { WeatherResponse } from './WeatherModel';

/**
 * 天气数据服务
 * 使用 wttr.in 公共接口，无需申请 API Key
 * 接口示例: https://wttr.in/Beijing?format=j1
 */
export class WeatherService {
  private readonly baseUrl: string = 'https://wttr.in';

  /**
   * 根据城市名称查询天气
   * @param city 城市名（支持中英文，建议使用英文/拼音以提高命中率）
   */
  async fetchWeather(city: string): Promise<WeatherResponse> {
    const httpRequest = http.createHttp();
    const url = `${this.baseUrl}/${encodeURIComponent(city)}?format=j1`;

    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: {
          'Accept': 'application/json'
        },
        connectTimeout: 10000,
        readTimeout: 10000
      });

      if (response.responseCode === http.ResponseCode.OK) {
        const raw: string = response.result as string;
        const data: WeatherResponse = JSON.parse(raw) as WeatherResponse;
        return data;
      } else {
        throw new Error(`接口请求失败，HTTP状态码: ${response.responseCode}`);
      }
    } finally {
      httpRequest.destroy();
    }
  }
}
