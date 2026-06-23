import { WeatherService } from '../common/WeatherService';
import type { CurrentCondition, DailyWeather } from '../common/WeatherModel';

@Entry
@Component
struct Index {
  @State cityName: string = 'Beijing';
  @State isLoading: boolean = false;
  @State errorMsg: string = '';
  @State hasResult: boolean = false;
  @State areaLabel: string = '';
  @State currentTemp: string = '';
  @State feelsLike: string = '';
  @State humidity: string = '';
  @State windSpeed: string = '';
  @State weatherDesc: string = '';
  @State forecastList: DailyWeather[] = [];

  private weatherService: WeatherService = new WeatherService();

  async queryWeather(): Promise<void> {
    const city = this.cityName.trim();
    if (city.length === 0) {
      this.errorMsg = '请输入城市名称，例如 Beijing、Shanghai、Guangzhou';
      this.hasResult = false;
      return;
    }

    this.isLoading = true;
    this.errorMsg = '';

    try {
      const result = await this.weatherService.fetchWeather(city);
      const current: CurrentCondition = result.current_condition[0];
      const area = result.nearest_area[0];

      this.areaLabel = `${area.areaName[0].value}, ${area.country[0].value}`;
      this.currentTemp = current.temp_C;
      this.feelsLike = current.FeelsLikeC;
      this.humidity = current.humidity;
      this.windSpeed = current.windspeedKmph;
      this.weatherDesc = current.weatherDesc[0].value;
      this.forecastList = result.weather;
      this.hasResult = true;
    } catch (err) {
      this.errorMsg = '查询失败，请检查网络连接或确认城市名称后重试';
      this.hasResult = false;
      console.error(`WeatherApp queryWeather error: ${JSON.stringify(err)}`);
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('天气查询')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 32, bottom: 8 })

        Row({ space: 12 }) {
          TextInput({ placeholder: '请输入城市名称，如 Beijing', text: this.cityName })
            .layoutWeight(1)
            .height(44)
            .onChange((value: string) => {
              this.cityName = value;
            })

          Button('查询')
            .height(44)
            .onClick(() => {
              this.queryWeather();
            })
        }
        .width('90%')

        if (this.isLoading) {
          LoadingProgress()
            .width(40)
            .height(40)
            .color('#4A90E2')
        }

        if (this.errorMsg.length > 0) {
          Text(this.errorMsg)
            .fontColor('#E14B4B')
            .fontSize(14)
            .width('90%')
        }

        if (this.hasResult) {
          Column({ space: 8 }) {
            Text(this.areaLabel)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')

            Text(`${this.currentTemp}°C`)
              .fontSize(56)
              .fontWeight(FontWeight.Bold)
              .fontColor('#4A90E2')

            Text(this.weatherDesc)
              .fontSize(18)
              .fontColor('#666666')

            Row({ space: 20 }) {
              Text(`体感 ${this.feelsLike}°C`)
                .fontSize(14)
                .fontColor('#888888')
              Text(`湿度 ${this.humidity}%`)
                .fontSize(14)
                .fontColor('#888888')
              Text(`风速 ${this.windSpeed}km/h`)
                .fontSize(14)
                .fontColor('#888888')
            }
            .margin({ top: 4 })
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#F0F4F8')
          .borderRadius(16)
          .alignItems(HorizontalAlign.Center)

          Column({ space: 4 }) {
            Text('未来天气预报')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .alignSelf(ItemAlign.Start)
              .margin({ bottom: 4 })

            ForEach(this.forecastList, (day: DailyWeather) => {
              Row() {
                Text(day.date)
                  .fontSize(14)
                  .layoutWeight(1)
                Text(`${day.mintempC}° / ${day.maxtempC}°C`)
                  .fontSize(14)
                  .fontColor('#4A90E2')
              }
              .width('100%')
              .padding({ top: 10, bottom: 10 })
            }, (day: DailyWeather) => day.date)
          }
          .width('90%')
          .padding(16)
          .backgroundColor('#FAFAFA')
          .borderRadius(16)
        }
      }
      .width('100%')
      .constraintSize({ minHeight: '100%' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
