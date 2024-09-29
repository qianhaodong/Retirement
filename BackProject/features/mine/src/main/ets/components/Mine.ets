import { request } from '@hm/basic/src/main/ets/utils/Request';
import { Log } from '@abner/log';

export interface UserData {
  /**
   * 头像
   */
  avatar: null | string;
  /**
   * 用户id
   */
  id: string;
  /**
   * 用户昵称
   */
  nickName: string;
  /**
   * 用户账号，即邮箱
   */
  username: string;
}

@Component
export struct Mine {
  @State
  count: number = 0;

  async getData() {
    const res = await request<UserData>({ url: '/employee/user', method: 'get' });
    Log.info(res);
  }

  aboutToAppear() {
    this.getData();
  }

  build() {
    Column() {
      Text(`点击次数：${this.count}`)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)

      Button('点击')
        .width(120)
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          this.count++;
        })

      Button('清空')
        .width(120)
        .onClick(() => {
          this.count = 0;
        })
    }
  }
}