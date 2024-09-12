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

  @State
  list: number[] = [];
  @State
  loading: boolean = false;
  @State
  finished: boolean = false;

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
        .fontColor(ResManager.EC_MID_59)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .margin(30)
  }

  @Builder
  loadingBuilder() {
    if (this.finished) {
      ListItem() {
        Row() {
          Text('没有更多了...')
            .fontColor(ResManager.EC_MID_59)
            .fontSize(ResManager.EC_NORMAL_FS)
        }
        .width('100%')
        .height(50)
        .justifyContent(FlexAlign.Center)
      }
    } else {
      if (this.loading) {
        ListItem() {
          Row() {
            LoadingProgress()
              .width(24)
              .margin({ right: 5 })
            Text('加载中...')
              .fontColor(ResManager.EC_MID_59)
              .fontSize(ResManager.EC_NORMAL_FS)
          }
          .width('100%')
          .height(50)
          .justifyContent(FlexAlign.Center)
        }
      }
    }
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

  // 钩子函数
  /*aboutToAppear() {
    // 初始化数据
    this.loading = true;
    this.handleRefresh()
  }*/

  // 刷新数据
  handleRefresh() {
    setTimeout(() => {
      // 初始化数据
      this.loading = false;
      this.finished = false;
      this.list = [];

      for (let i = 0; i < 10; i++) {
        this.list.push(i + 1);
      }

      // 关闭刷新状态
      this.refreshing = false;
    }, 1500);
  }

  // 触底加载（List组件，在列表为空时，会触发一次触底事件）
  handleReachEndLoad() {
    if (this.loading || this.finished) return;

    Log.info('触底')
    // 加锁，防止连续触发
    this.loading = true;

    // 加载数据
    setTimeout(() => {
      for (let i = 0; i < 10; i++) {
        this.list.push(i + 1);
      }

      this.loading = false;
      if (this.list.length > 25) {
        this.finished = true;
      }
    }, 2000);
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
          ForEach(this.list, (item: number) => {
            ListItem() {
              this.CardItem(item)
            }
          })

          if (this.refreshStatus !== RefreshStatus.Refresh) {
            this.loadingBuilder()
          }
        }
        .layoutWeight(1)
        .width('100%')
        .scrollBar(BarState.Off)
        .onReachEnd(() => {
          this.handleReachEndLoad()
        })
      }
      .layoutWeight(1)
      .padding({
        left: ResManager.SIZE_GUTTER_LG,
        right: ResManager.SIZE_GUTTER_LG
      })
      .onRefreshing(() => {
        Log.info('刷新中')
        this.handleRefresh();
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