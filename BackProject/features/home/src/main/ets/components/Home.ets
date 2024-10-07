import { ResManager } from '@hm/basic/Index'
import router from '@ohos.router'
import { statisticsUnreadByType } from '../api';
import { MessageCountData } from '../models';
import { Log } from '@abner/log';

import('@ec/message/src/main/ets/pages/Index');

@Component
struct Home {
  @State
  unreadMessages: MessageCountData | null = null;

  @Styles
  boxStyles() {
    .layoutWeight(1)
    .borderRadius(8)
    .backgroundColor(ResManager.EC_MID_WHITE)
  }

  @Builder
  MessageItemBuilder(value: string, index: number, icon: ResourceStr) {
    Column() {
      Badge({
        count: index === 0 ? this.unreadMessages?.elderAlertMsgCount! : this.unreadMessages?.nursingTaskMsgCount!,
        style: {
          badgeColor: '#FF6363',
          borderColor: '#fff',
          borderWidth: 2,
          badgeSize: 20
        }
      }) {
        Image(icon)
          .width(40)
          .aspectRatio(1)
          .margin({ bottom: 10 })
      }

      Text(value)
        .fontSize(ResManager.EC_SMALL_FS)
        .fontColor(ResManager.EC_MID_19)
    }
    .boxStyles()
    .padding({ top: 20, bottom: 23 })
    .onClick(() => {
      /*router.pushUrl({
        url: '@bundle:com.example.backproject/message/ets/pages/Index',
      })*/

      // 命名路由，跳转共享包
      router.pushNamedRoute({
        name: 'messagePage'
      })
    })
  }

  @Builder
  CareItemBuilder(value: string, icon: ResourceStr) {
    Row({ space: 10 }) {
      Image(icon)
        .width(48)
        .aspectRatio(1)
      Text(value)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_NORMAL_FS)
    }
    .boxStyles()
    .padding({ top: 20, bottom: 23, left: 13, right: 13 })
  }

  @Builder
  DeviceItemBuilder(value: string, icon: ResourceStr) {
    Column({ space: 10 }) {
      Image(icon)
        .width(40)
        .aspectRatio(1)
      Text(value)
        .fontColor(ResManager.EC_MID_19)
        .fontSize(ResManager.EC_SMALL_FS)
    }
    .boxStyles()
    .padding({ top: 23, bottom: 23 })
  }

  // 获取未读消息
  async getUnreadMessages() {
    const data = await statisticsUnreadByType();
    Log.info(data);
    // data.elderAlertMsgCount += 1;
    // data.nursingTaskMsgCount += 2;
    this.unreadMessages = data;
  }

  aboutToAppear() {
    this.getUnreadMessages();
  }

  build() {
    Stack({
      alignContent: Alignment.Bottom
    }) {
      Column() {
        // 广告图
        Column() {
          Image($r("app.media.img_banner"))
            .width('100%')
            .aspectRatio(1.32)

          Row({ space: 10 }) {
            this.MessageItemBuilder('老人报警消息', 0, $r("app.media.ic_home_jkbj"))
            this.MessageItemBuilder('任务提醒消息', 1, $r("app.media.ic_home_rwtx"))
          }
          .width('100%')
          .padding({
            left: ResManager.SIZE_GUTTER_LG,
            right: ResManager.SIZE_GUTTER_LG
          })
          .margin({ top: -50 })
        }
        .margin({ bottom: 25 })

        Column({ space: 25 }) {
          // 护理工作台
          Column() {
            Text('护理工作台')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })

            Row({ space: 10 }) {
              this.CareItemBuilder('护理任务', $r('app.media.icon_home_hlrw'))
              this.CareItemBuilder('护理记录', $r('app.media.icon_home_hljl'))
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)

          // 设备管理
          Column() {
            Text('设备管理')
              .fontColor(ResManager.EC_MID_19)
              .fontSize(ResManager.EC_MODULE_TITLE_FS)
              .fontWeight(500)
              .margin({ bottom: 13 })

            Row({ space: 10 }) {
              this.DeviceItemBuilder('设备安装', $r('app.media.icon_home_sbaz'))
              this.DeviceItemBuilder('设备绑定', $r('app.media.icon_home_sbkz'))
              this.DeviceItemBuilder('我的设备', $r('app.media.icon_home_wdsb'))
              this.DeviceItemBuilder('报警设备', $r('app.media.icon_home_bjsb'))
            }
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .padding({
          left: ResManager.SIZE_GUTTER_LG,
          right: ResManager.SIZE_GUTTER_LG
        })
      }
      .width('100%')
      .height('100%')

      // 广告标语
      Row() {
        Image($r("app.media.img_home_kouhao"))
          .width(211)
          .height(15)
      }
      .margin({ bottom: 28 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(ResManager.EC_MID_BG)
  }
}

export { Home }