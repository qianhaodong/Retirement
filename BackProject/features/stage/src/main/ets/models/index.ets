export interface StageTabItemModel {
  /**
   * 护理项目id
   */
  id: string;
  /**
   * 护理项目名称
   */
  name: string;
  /**
   * 护理列表
   */
  list?: StageTaskItemClass[];
}

@Observed
export class StageTabItemClass {
  id: string;
  name: string;
  list: StageTaskItemClass[] = [];
  loading: boolean = false;
  finished: boolean = false;
  pageNum: number = 1;

  constructor(data: StageTabItemModel) {
    this.id = data.id;
    this.name = data.name;
  }
};

@Observed
export class StageTaskItemClass {
  /**
   * 创建时间，格式：yyyy-MM-dd HH:mm:ss
   */
  createTime: string = '';
  /**
   * 老人id
   */
  elderId: string = '';
  /**
   * 老人姓名
   */
  elderName: string = '';
  /**
   * 期望服务时间，格式：yyyy-MM-dd HH:mm:ss
   */
  estimatedServerTime: string = '';
  /**
   * 执行人
   */
  executor: null | string = '';
  /**
   * 护理任务id
   */
  id: string = '';
  /**
   * 执行记录
   */
  mark: null | string = '';
  /**
   * 护理项目id
   */
  projectId: string = '';
  /**
   * 护理项目名称
   */
  projectName: string = '';
  /**
   * 实际服务时间，格式：yyyy-MM-dd HH:mm:ss
   */
  realServerTime: null | string = '';
  /**
   * 备注
   */
  remark: null | string = '';
  /**
   * 执行图片
   */
  taskImage: null | string = '';
  /**
   * 任务类型，1：护理计划外，2：护理计划内
   */
  taskType: number = 0;
  /**
   * 更新时间，格式：yyyy-MM-dd HH:mm:ss
   */
  updateTime: null | string = '';
}

export interface QueryStageTaskModel {
  /**
   * 老人id
   */
  elderId?: number;
  /**
   * 老人姓名，模糊查询
   */
  elderName?: string;
  /**
   * 护理项目id,全部传-1
   */
  nursingProjectId?: string;
  /**
   * 页码
   */
  pageNum: number;
  /**
   * 页面大小
   */
  pageSize: number;
  /**
   * 状态  1待执行 2已执行 3已关闭
   */
  status?: number;
}

export interface StageTaskDataModel {
  /**
   * 页码
   */
  page: number;
  /**
   * 总页数
   */
  pages: string;
  /**
   * 页尺寸
   */
  pageSize: number;
  /**
   * 数据列表
   */
  records: StageTaskItemClass[];
  /**
   * 总条目数
   */
  total: string;
}


