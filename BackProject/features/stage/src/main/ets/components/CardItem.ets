import { ResManager } from '@hm/basic/Index'
import { promptAction } from '@kit.ArkUI';
import { StageTaskItemClass } from '../models';

@Component
export struct CardItem {
  @ObjectLink
  cardData: StageTaskItemClass;

  // 选中日期
  selectedDate: Date = new Date();

  // 改期
  handleChangeDate() {
    DatePickerDialog.show({
      start: new Date("2000-1-1"),
      end: new Date("2100-12-31"),
      selected: this.selectedDate,
      showTime: true,
      useMilitaryTime: true,
      selectedTextStyle: {
        color: ResManager.EC_MAIN_COLOR,
        font: { size: ResManager.EC_MODULE_TITLE_FS, weight: FontWeight.Regular }
      },
      onDateAccept: (value: Date) => {
        const now: Date = new Date()
        if (value.getTime() < now.getTime()) {
          setTimeout(() => {
            promptAction.showToast({
              message: '选择日期时间必须大于当前时间！'
            })
            this.selectedDate = now
          })
        }
        this.selectedDate = value
      },
    })
  }

  build() {
    Column({ space: 14 }) {
      Row() {
        Text(this.cardData.elderName)
          .fontColor(ResManager.EC_MID_BLACK)
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)
          .margin({ bottom: 5 })
        Button(this.cardData.taskType === 1 ? '护理计划内' : '护理计划外')
          .height(20)
          .borderRadius(10)// 计划外 bg：#FFF0D9
          .backgroundColor(this.cardData.taskType === 1 ? '#DBF0FF' : '#FFF0D9')
          .fontColor(this.cardData.taskType === 1 ? ResManager.EC_SUB_BLUE : ResManager.EC_SUB_YELLOW)
          .fontSize(ResManager.EC_SMALL_FS)
          .padding({ left: 6, right: 6 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Text(`期望服务时间：${this.cardData.estimatedServerTime}`)
        .fontColor(ResManager.EC_MID_59)
        .fontSize(13)

      if (this.cardData.mark) {
        Row() {
          Text(this.cardData.mark)
            .fontSize(ResManager.EC_SMALL_FS)
            .fontColor('#50A0D8')
            .lineHeight(20)
        }
        .width('100%')
        .backgroundColor('#E9F6FF')
        .borderRadius(5)
        .padding({ left: 10, right: 10, top: 5, bottom: 8 })
      }

      Row() {
        Button('取消')
          .height(28)
          .fontSize(ResManager.EC_SMALL_FS)
          .fontColor(ResManager.EC_MAIN_COLOR)
          .backgroundColor('#fff')
        Button('改期')
          .height(28)
          .fontSize(ResManager.EC_SMALL_FS)
          .fontColor(ResManager.EC_MAIN_COLOR)
          .backgroundColor('#fff')
          .onClick(() => {
            this.handleChangeDate()
          })
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