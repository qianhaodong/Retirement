import { request } from '@hm/basic/Index'
import { MessageCountData } from '../models'

// 获取未读消息
const statisticsUnreadByType = () => {
  return request<MessageCountData>({ url: '/employee/message/statisticsUnreadByType' });
}

export {
  statisticsUnreadByType
}