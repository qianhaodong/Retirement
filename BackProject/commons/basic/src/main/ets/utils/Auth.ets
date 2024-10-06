import { preferences } from '@kit.ArkData'
import { User } from '../models/UserModel';

const TOKEN_KEY = 'TOKEN_KEY';

class UserStore {
  key = 'user-store'

  // 获取store
  getStore() {
    return preferences.getPreferencesSync(getContext(this), { name: this.key })
  }

  // 更新token
  async setUser(data: User) {
    const store = this.getStore();
    store.putSync(TOKEN_KEY, JSON.stringify(data));
    // 更新首选项
    await store.flush()
  }

  // 获取token
  getUser() {
    const store = this.getStore();
    const data = store.getSync(TOKEN_KEY, '{}');
    const user: User = JSON.parse(data as string);
    return user;
  }

  // 删除token
  async delUser() {
    const store = this.getStore();
    store.deleteSync(TOKEN_KEY);
    await store.flush();
  }
}

const userStore = new UserStore();

// 导出单例
export { userStore }