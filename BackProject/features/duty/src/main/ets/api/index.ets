import { request } from '@hm/basic/Index';
import { DutyData, DutyQueryModel } from '../models';

const getDutyList = (params: DutyQueryModel) => {
  return request<DutyData, DutyQueryModel>({ url: '/employee/elder/pageQuery', params });
};

export {
  getDutyList
}