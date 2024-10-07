import { ResManager } from '@hm/basic/Index';
import { getStageTabs, getStageTaskList } from '../api';
import { StageTabItemClass } from '../models';
import { Log } from '@abner/log';
import { CardList } from './CardList';

@Component
export struct Stage {
  @StorageProp('topHeight')
  topHeight: number = 0;

  @State
  tabList: StageTabItemClass[] = [];
  @State
  currentIndex: number = 0;
  @State
  pageNum: number = 1;
  @State
  pageSize: number = 10;
  @State
  loading: boolean = false;
  @State
  finished: boolean = false;

  @Builder
  TabBuilder(item: StageTabItemClass, index: number) {
    Button(item.name)
      .height(28)
      .fontSize(ResManager.EC_MODULE_TITLE_FS)
      .fontColor(index === this.currentIndex ? ResManager.EC_MID_WHITE : ResManager.EC_MID_99)
      .backgroundColor(index === this.currentIndex ? ResManager.EC_MAIN_COLOR : ResManager.EC_MID_BG)
      .animation({ duration: 200 })
  };

  // 获取tabList
  async _getStageTabs() {
    let tabList: StageTabItemClass[] = [];
    let data = await getStageTabs();

    // 添加全部选项
    tabList.unshift(new StageTabItemClass({
      id: '-1',
      name: '全部'
    }))

    // 对接口数据进行new处理，方便Observed监听
    for(let i = 0; i < data.length; i++) {
      let item = new StageTabItemClass(data[i])
      tabList.push(item);
    }

    return tabList;
  };

  // 获取护理任务列表
  async _getStageTaskList(tabItem: StageTabItemClass) {
    return await getStageTaskList({
      nursingProjectId: tabItem.id,
      pageNum: tabItem.pageNum,
      pageSize: this.pageSize
    });
  };

  // 刷新数据
  async handleRefresh(id: string) {
    const index = this.tabList.findIndex(item => item.id === id);

    if (index !== -1) {
      // 初始化数据
      this.tabList[index].loading = false;
      this.tabList[index].finished = false;
      this.tabList[index].pageNum = 1;

      const data = await this._getStageTaskList(this.tabList[index]);
      this.tabList[index].list = data.records;
      this.tabList[index].finished = this.listenReachBottom(parseInt(data.total!), this.tabList[index].pageNum);
      this.tabList[index].pageNum++;
    }
  };

  // 触底加载（List组件，在列表为空时，会触发一次触底事件）
  async handleReachEndLoad(id: string) {
    const index = this.tabList.findIndex(item => item.id === id);

    if (index !== -1) {
      const tabItem = this.tabList[index];
      if (tabItem.loading || tabItem.finished) return;

      Log.info('触底')
      // 加锁，防止连续触发
      this.tabList[index].loading = true;

      // 加载数据
      const data = await this._getStageTaskList(this.tabList[index]);
      // Log.info(data);
      this.tabList[index].list = this.tabList[index].list.concat(data.records!);
      this.tabList[index].loading = false;
      this.tabList[index].finished = this.listenReachBottom(parseInt(data.total!), this.tabList[index].pageNum);
      this.tabList[index].pageNum++;
    }
  };

  // 判断是否最后一页
  listenReachBottom(total: number, pageNum: number) {
    if (pageNum * this.pageSize > total) {
      return true;
    }
    return false;
  }

  async aboutToAppear() {
    this.tabList = await this._getStageTabs();

    // 获取第一个tab任务列表
    this.tabList[0].loading = true;
    const data = await this._getStageTaskList(this.tabList[0]);

    this.tabList[0].list = data.records;
    this.tabList[0].loading = false;
    this.tabList[0].finished = this.listenReachBottom(parseInt(data.total!), this.tabList[0].pageNum);
    this.tabList[0].pageNum++;

    Log.info(this.tabList);
  };

  build() {
    Column() {
      Row() {
        Text('护理工作台')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_PAGE_TITLE_FS)
          .fontWeight(500)
        Text('护理记录')
          .fontColor(ResManager.EC_MID_19)
          .fontSize(ResManager.EC_NORMAL_FS)
      }
      .width('100%')
      .height(56)
      .padding({ left: 24, right: 15 })
      .backgroundColor(ResManager.EC_MID_WHITE)
      .justifyContent(FlexAlign.SpaceBetween)

      Tabs({
        index: $$this.currentIndex
      }) {
        ForEach(this.tabList, (tabItem: StageTabItemClass, tabIndex) => {
          TabContent() {
            CardList({
              tabItem: tabItem,
              handleRefresh: async (id: string) => {
                await this.handleRefresh(id);
              },
              handleReachEndLoad: (id: string) => {
                this.handleReachEndLoad(id);
              }
            })
          }
          .tabBar(this.TabBuilder(tabItem, tabIndex))
        })
      }
      .width('100%')
      .layoutWeight(1)
      .barMode(BarMode.Scrollable)
      .backgroundColor(ResManager.EC_MID_BG)
      /*.onChange(async (index) => {
        if (!this.tabList[index].list?.length) {
          this.tabList[index].loading = true;

          const data = await this._getStageTaskList(this.tabList[index]);
          this.tabList[index].list = data.records;
          this.tabList[index].loading = false;
          this.tabList[index].finished = this.listenReachBottom(parseInt(data.total!), this.tabList[index].pageNum);
          Log.info('index: ' + index)
          Log.info(data)
        }
      })*/
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
  }
}