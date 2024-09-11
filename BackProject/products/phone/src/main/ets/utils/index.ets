import { window } from '@kit.ArkUI'

class WindowManager {
  windowStage: window.Window | null = null

  async getWindowStage() {
    if (this.windowStage) {
      return this.windowStage;
    } else {
      return await window.getLastWindow(getContext());
    }
  }

  // 设置开启沉浸式
  enableFullScreen() {
    this.getWindowStage()
      .then((windowStage: window.Window) => {
        // 设置沉浸式
        windowStage.setWindowLayoutFullScreen(true);

        // 获取状态栏高度，并设置到全局
        const topArea = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        AppStorage.setOrCreate('topHeight', px2vp(topArea.topRect.height));

        // 获取导航栏高度
        const bottomArea = windowStage.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        AppStorage.setOrCreate('bottomHeight', px2vp(bottomArea.bottomRect.height));
      })
  }
}

export const windowManager = new WindowManager();