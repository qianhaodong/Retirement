import { request } from '@hm/basic/Index';
import { QueryStageTaskModel, StageTabItemModel, StageTaskDataModel } from '../models';

// 获取护理项目Tab
const getStageTabs = () => {
  return request<StageTabItemModel[]>({ url: '/employee/nursing-task/allPendingProject' })
};

// 获取护理任务列表
const getStageTaskList = (params: QueryStageTaskModel) => {
  return request<StageTaskDataModel, QueryStageTaskModel>({ url: '/employee/nursing-task/pageQuery', params })
};

export {
  getStageTabs,
  getStageTaskList
}