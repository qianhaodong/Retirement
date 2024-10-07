export interface DutyQueryModel {
  /**
   * 老人姓名，模糊查询
   */
  elderName?: string;
  /**
   * 页码
   */
  pageNum: number;
  /**
   * 页面大小
   */
  pageSize: number;
}

export interface DutyData {
  /**
   * 页码
   */
  page?: number;
  /**
   * 总页数
   */
  pages?: string;
  /**
   * 页尺寸
   */
  pageSize?: number;
  records?: RecordItemData[];
  /**
   * 总条目数
   */
  total?: string;
}

export interface RecordItemData {
  /**
   * 年龄
   */
  age: number;
  /**
   * 头像
   */
  avatar: string;
  /**
   * 床位号
   */
  bedNumber: string;
  /**
   * 老人id
   */
  id: string;
  /**
   * 身份证号
   */
  idCardNo: string;
  /**
   * 老人姓名
   */
  name: string;
  /**
   * 护理等级id
   */
  nursingLevelId: string;
  /**
   * 护理等级名称
   */
  nursingLevelName: null | string;
  /**
   * 房间编号
   */
  roomCode: string;
  /**
   * 房间id
   */
  roomId: string;
  /**
   * 性别，0：男，1：女，2：未知
   */
  sex: number;
}

