import { ResManager } from '@hm/basic/Index'
import { StageTabItemClass, StageTaskItemClass } from '../models';
import { CardItem } from './CardItem';
import { Log } from '@abner/log';
import { promptAction } from '@kit.ArkUI';

@Component
export struct CardList {
  @ObjectLink
  tabItem: StageTabItemClass;

  @State
  refreshStatus: RefreshStatus = RefreshStatus.Inactive;
  @State
  refreshing: boolean = false;
  @State
  loading: boolean = false;
  @State
  finished: boolean = false;

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
  };

  @Builder
  loadingBuilder() {
    if (this.tabItem.finished) {
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
      if (this.tabItem.loading) {
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
  };

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
  };

  // 触底事件
  handleReachEndLoad: (id: string) => void = () => {};

  // 刷新事件
  handleRefresh: (id: string) => Promise<void> = async () => {};

  build() {
    Refresh({ refreshing: $$this.refreshing, builder: this.RefreshBuilder() }) {
      List() {
        ForEach(this.tabItem.list, (item: StageTaskItemClass) => {
          ListItem() {
            CardItem({ cardData: item })
          }
          .margin({ bottom: 10 })
        })

        if (this.refreshStatus !== RefreshStatus.Refresh) {
          this.loadingBuilder()
        }
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .onReachEnd(() => {
        if (this.refreshing) return;
        this.handleReachEndLoad(this.tabItem.id);
      })
    }
    .width('100%')
    .height('100%')
    .padding({
      left: ResManager.SIZE_GUTTER_LG,
      right: ResManager.SIZE_GUTTER_LG
    })
    .onRefreshing(async () => {
      Log.info('刷新中')
      await this.handleRefresh(this.tabItem.id);
      // 关闭刷新状态
      this.refreshing = false;
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
}