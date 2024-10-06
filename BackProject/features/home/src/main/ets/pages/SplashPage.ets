import { ResManager, RouterConfig, userStore } from '@hm/basic/Index';
import router from '@ohos.router';
import { Log } from '@abner/log';

@Entry
@Component
struct Index {
  @StorageProp('bottomHeight')
  bottomHeight: number = 0;
  @State
  second: number = 5;
  @State
  timer: number | null = null;

  countdownHandler() {
    this.timer = setInterval(() => {
      Log.info(`${this.second}`)
      this.second--;

      if (this.second < 1) {
        Log.info('倒计时结束')
        // 倒计时结束
        clearInterval(this.timer);
        this.timer = null;

        this.jumpPage();
      }
    }, 1000);
  }

  async jumpPage() {
    // 判断是否登录
    const user = await userStore.getUser();
    if (user.token) {
      // 已登录，跳转首页
      router.replaceUrl({
        url: 'pages/Index'
      })
    } else {
      // 未登录、跳转登录页
      router.replaceUrl({
        url: RouterConfig.LOGIN_PAGE,
      })
    }
  }

  aboutToAppear() {
    this.countdownHandler();
  }

  aboutToDisappear() {
    if (this.timer || this.timer === 0) {
      Log.info('销毁定时器')
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  build() {
    Stack({
      alignContent: Alignment.Bottom
    }) {
      Stack({
        alignContent: Alignment.TopEnd
      }) {
        Image($r('app.media.pic_sp1'))
          .width('100%')
          .height('100%')

        Button(`跳过${this.second}s`)
          .width(80)
          .height(40)
          .backgroundColor('rgba(0,0,0,0.3)')
          .borderRadius(20)
          .margin({ top: 10, right: 10 })
          .onClick(() => {
            this.jumpPage();
          })
      }
      .width('100%')
      .height('100%')

      Row() {
        Image($r('app.media.startIcon'))
          .width(32)
          .aspectRatio(1)
          .margin({ right: 15 })
        Text('翼康养老')
          .fontColor(ResManager.EC_MID_BLACK)
          .fontSize(24)
          .fontWeight(700)
      }
      .width('100%')
      .padding({ top: 30, bottom: this.bottomHeight })
      .backgroundColor(ResManager.EC_MID_WHITE)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}