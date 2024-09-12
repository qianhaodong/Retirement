import { ResManager } from '@hm/basic/Index'

@Component
export struct CardItem {
  @Prop
  cardData: string = ''

  build() {
    Column({ space: 14 }) {
      Row() {
        Text('李玉虎')
          .fontColor(ResManager.EC_MID_BLACK)
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)
          .margin({ bottom: 5 })
        Button('护理计划内')
          .height(20)
          .borderRadius(10)// 计划外 bg：#FFF0D9
          .backgroundColor('#DBF0FF')
          .fontColor(ResManager.EC_SUB_BLUE)
          .fontSize(ResManager.EC_SMALL_FS)
          .padding({ left: 6, right: 6 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Text('期望服务时间：2024年9月12日 16:00')
        .fontColor(ResManager.EC_MID_59)
        .fontSize(13)

      Row() {
        Text('喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具，喂饭的时候用老人自己的餐具')
          .fontSize(ResManager.EC_SMALL_FS)
          .fontColor('#50A0D8')
          .lineHeight(20)
      }
      .width('100%')
      .backgroundColor('#E9F6FF')
      .borderRadius(5)
      .padding({ left: 10, right: 10, top: 5, bottom: 8 })

      Row() {
        Button('取消')
          .height(28)
          .fontSize(ResManager.EC_SMALL_FS)
          .fontColor(ResManager.EC_MAIN_COLOR)
          .backgroundColor('#fff')
        Button('改造')
          .height(28)
          .fontSize(ResManager.EC_SMALL_FS)
          .fontColor(ResManager.EC_MAIN_COLOR)
          .backgroundColor('#fff')
        Button('执行')
          .height(28)
          .fontSize(ResManager.EC_SMALL_FS)
          .fontColor('#fff')
          .backgroundColor(ResManager.EC_MAIN_COLOR)
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .borderRadius(8)
    .backgroundColor(ResManager.EC_MID_WHITE)
    .padding({ left: 14, right: 14, top: 10, bottom: 10 })
    .alignItems(HorizontalAlign.Start)
  }
}