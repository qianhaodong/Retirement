import { ResManager } from '@hm/basic/Index';
import { Log } from '@abner/log';
import { promptAction } from '@kit.ArkUI';
import { getDutyList } from '../api';
import { RecordItemData } from '../models';

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
  list: RecordItemData[] = [];
  @State
  pageNum: number = 1;
  @State
  pageSize: number = 10;
  @State
  loading: boolean = false;
  @State
  finished: boolean = false;

  @Builder
  CardItem(item: RecordItemData) {
    Row({ space: 14 }) {
      Image(item.avatar)
        .width(80)
        .height(80)
        .borderRadius(8)

      Column({ space: 6 }) {
        Row({ space:15 }) {
          Text(item.name)
            .fontColor(ResManager.EC_MID_BLACK)
            .fontSize(ResManager.EC_PAGE_TITLE_FS)
            .fontWeight(500)
            .margin({ bottom: 5 })
          Text(`${item.age}岁`)
            .fontColor(ResManager.EC_MID_59)
            .fontSize(13)
          Text(item.sex === 0 ? '男' : '女')
            .width(36)
            .height(20)
            .borderRadius(10)// 女bg：#FFF0D9
            .backgroundColor(item.sex === 0 ? '#DBF0FF' : '#FFF0D9')
            .textAlign(TextAlign.Center)
            .fontColor(ResManager.EC_SUB_BLUE)
            .fontSize(ResManager.EC_SMALL_FS)
        }

        Text(`床位：${item.bedNumber}床`)
          .fontColor(ResManager.EC_MID_59)
          .fontSize(13)
        Text(`护理等级：${item.nursingLevelName}`)
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

  async getRecordData() {
    return await getDutyList({
      pageNum: this.pageNum,
      pageSize: this.pageSize
    });
  }

  // 判断是否最后一页
  listenReachBottom(total: number) {
    if (this.pageNum * this.pageSize > total) {
      this.finished = true;
    }
  }

  // 刷新数据
  async handleRefresh() {
    // 初始化数据
    this.loading = false;
    this.finished = false;
    this.pageNum = 1;

    const data = await this.getRecordData();
    this.list = data.records!;
    this.listenReachBottom(parseInt(data.total!));

    // 关闭刷新状态
    this.refreshing = false;
  }

  // 触底加载（List组件，在列表为空时，会触发一次触底事件）
  async handleReachEndLoad() {
    if (this.loading || this.finished || this.refreshing) return;

    Log.info('触底')
    // 加锁，防止连续触发
    this.loading = true;

    // 加载数据
    const data = await this.getRecordData();
    // Log.info(data);
    this.list = this.list.concat(data.records!);
    this.listenReachBottom(parseInt(data.total!));
    this.loading = false;
    this.pageNum++;
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
          ForEach(this.list, (item: RecordItemData) => {
            ListItem() {
              this.CardItem(item)
            }
          })

          if (this.refreshStatus !== RefreshStatus.Refresh) {
            this.loadingBuilder()
          }
        }
        .height('100%')
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