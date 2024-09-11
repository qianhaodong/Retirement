import { Home } from '@ec/home/Index';

import { TabBarItem } from '../model';

@Entry
@Component
struct Index {
  @State
  currentIndex: number = 0;
  @State
  tabBarList: TabBarItem[] = [
    {
      defaultIcon: $r('app.media.icon_tab_home_nor'),
      activeIcon: $r('app.media.icon_tab_home_sel'),
      label: '首页'
    },
    {
      defaultIcon: $r('app.media.icon_tab_laoren_nor'),
      activeIcon: $r('app.media.icon_tab_laoren_sel'),
      label: '负责老人'
    },
    {
      defaultIcon: $r('app.media.icon_tab_hl_nor'),
      activeIcon: $r('app.media.icon_tab_hl_sel'),
      label: '护理工作台'
    },
    {
      defaultIcon: $r('app.media.icon_tab_mine_nor'),
      activeIcon: $r('app.media.icon_tab_mine_sel'),
      label: '我的'
    }
  ];

  @Builder
  TabBarBuilder(item: TabBarItem, index: number) {
    Column() {
      Image(this.currentIndex === index ? item.activeIcon :item.defaultIcon)
        .width(24)
        .aspectRatio(1)

      Text(item.label)
        .fontSize(10)
        .margin({ top: 4 })
        .lineHeight(12)
        .fontColor(this.currentIndex === index ? '#000' : '#aaa')
    }
  }

  build() {
    Tabs({
      barPosition: BarPosition.End
    }) {
      ForEach(this.tabBarList, (item: TabBarItem, index) => {
        TabContent() {
          if (index === 0) {
            Home()
          } else {
            Text(item.label)
          }
        }
        .tabBar(this.TabBarBuilder(item, index))
      })
    }
    .onChange(index => {
      this.currentIndex = index;
    })
  }
}