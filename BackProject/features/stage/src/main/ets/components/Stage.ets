import { ResManager } from '@hm/basic/Index';
import { CardItem } from './CardItem';

@Component
export struct Stage {
  @StorageProp('topHeight')
  topHeight: number = 0;
  @State
  tabList: string[] = ['全部', '助餐', '洗头', '剪指甲', '整理床铺', '洗脚脚', '洗澡澡', '喂药'];
  @State
  currentIndex: number = 0;

  @Builder
  TabBuilder(item: string, index: number) {
    Button(item)
      .height(28)
      .fontSize(ResManager.EC_MODULE_TITLE_FS)
      .fontColor(index === this.currentIndex ? ResManager.EC_MID_WHITE : ResManager.EC_MID_99)
      .backgroundColor(index === this.currentIndex ? ResManager.EC_MAIN_COLOR : ResManager.EC_MID_BG)
      .animation({ duration: 200 })
  }

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
        ForEach(this.tabList, (tabItem: string, tabIndex) => {
          TabContent() {
            List() {
              ForEach(this.tabList, (item: string, index) => {
                ListItem() {
                  CardItem({ cardData: item })
                }
                .margin({ bottom: 10 })
              })
            }
            .width('100%')
            .layoutWeight(1)
            .padding({
              left: ResManager.SIZE_GUTTER_LG,
              right: ResManager.SIZE_GUTTER_LG
            })
            .scrollBar(BarState.Off)
          }
          .tabBar(this.TabBuilder(tabItem, tabIndex))
        })
      }
      .width('100%')
      .layoutWeight(1)
      .barMode(BarMode.Scrollable)
      .backgroundColor(ResManager.EC_MID_BG)
    }
    .width('100%')
    .height('100%')
    .padding({ top: this.topHeight })
  }
}