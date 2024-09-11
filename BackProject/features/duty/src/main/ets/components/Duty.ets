import { ResManager } from '@hm/basic/Index';
import { Log } from '@abner/log';
import { promptAction } from '@kit.ArkUI';

@Component
export struct Duty {
  @StorageProp('topHeight')
  topHeight: number = 0;
  @StorageProp('bottomHeight')
  bottomHeight: number = 0;
  @State
  refreshing: boolean = false;
  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive;

  @Builder
  CardItem(item: number) {
    Row({ space: 14 }) {
      Image('https://img1.baidu.com/it/u=1944934302,3144710326&fm=253&fmt=auto&app=138&f=JPEG?w=190&h=190')
        .width(80)
        .height(80)
        .borderRadius(8)

      Column({ space: 6 }) {
        Row({ space:15 }) {
          Text('李玉虎')
            .fontColor(ResManager.EC_MID_BLACK)
            .fontSize(ResManager.EC_PAGE_TITLE_FS)
            .fontWeight(500)
            .margin({ bottom: 5 })
          Text('64岁')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(13)
          Text('男')
            .width(36)
            .height(20)
            .borderRadius(10)// 女bg：#FFF0D9
            .backgroundColor('#DBF0FF')
            .textAlign(TextAlign.Center)
            .fontColor(ResManager.EC_SUB_BLUE)
            .fontSize(ResManager.EC_SMALL_FS)
        }

        Text('床位：四人间-1012床')
          .fontColor(ResManager.EC_MID_59)
          .fontSize(13)
        Text('护理等级：特级护理')
          .fontColor(ResManager.EC_MID_59)
          .fontSize(13)

        Row() {
          Button('健康数据')
            .height(28)
            .backgroundColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_NORMAL_FS)
            .margin({ right: 13 })
          Button('护理任务')
            .height(28)
            .backgroundColor(ResManager.EC_MAIN_COLOR)
            .fontSize(ResManager.EC_NORMAL_FS)
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .margin({ top: 17 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .borderRadius(8)
    .backgroundColor(ResManager.EC_MID_WHITE)
    .padding({ left: 14, right: 14, top: 16, bottom: 16 })
  }

  @Builder
  RefreshBuilder() {
    Row({ space: 10 }) {
      Progress({
        value: 0,
        total: 100,
        type: ProgressType.Ring
      })
        .width(20)
        .color('#00C4B3')
        .style({
          strokeWidth: 20,
          status: this.refreshStatus === RefreshStatus.Refresh ? ProgressStatus.LOADING : ProgressStatus.PROGRESSING
        })

      Text(this.refreshStatusTxt())
        .fontColor('#595959')
        .fontSize(14)
    }
    .margin(30)
  }

  refreshStatusTxt() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return '下拉刷新';
      case RefreshStatus.OverDrag:
        return '释放刷新';
      case RefreshStatus.Refresh:
        return '刷新中...';
      default:
        return '';
    }
  }

  build() {
    Column() {
      Row() {
        Text('负责老人')
          .fontSize(24)
          .fontColor('#000')
          .fontWeight(500)
      }
      .width('100%')
      .padding({ left: 24, right: 24, bottom: 10, top: 10 })
      .justifyContent(FlexAlign.Start)

      // 列表
      Refresh({ refreshing: $$this.refreshing, builder: this.RefreshBuilder() }) {
        List({ space: 10 }) {
          ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], (item: number) => {
            ListItem() {
              this.CardItem(item)
            }
          })
        }
        .height('100%')
        .width('100%')
        .scrollBar(BarState.Off)
      }
      .layoutWeight(1)
      .padding({
        left: ResManager.SIZE_GUTTER_LG,
        right: ResManager.SIZE_GUTTER_LG
      })
      .onRefreshing(() => {
        setTimeout(() => {
          this.refreshing = false;
        }, 1500);
      })
      .onStateChange((state: RefreshStatus) => {
        this.refreshStatus = state;
        // Log.info(state.toString())
        if (state === RefreshStatus.Done) {
          promptAction.showToast({
            message: '刷新成功'
          });
        }
      })
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
    .backgroundColor(ResManager.EC_MID_BG)
  }
}