import { Log } from '@abner/log';
import axios, { AxiosError, AxiosHeaders, AxiosResponse, InternalAxiosRequestConfig, Method, RawAxiosRequestHeaders } from '@ohos/axios';
import { userStore } from './Auth';
import { router } from '@kit.ArkUI';
import { RouterConfig } from '../constants/RouterConfig';
import { delayTime } from './Util';

const instance = axios.create({
  baseURL: 'https://zhyl-harmony.itheima.net',
  timeout: 10000
});

// 添加请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 对请求数据做点什么
  // config.headers.Authorization = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw';
  const token = userStore.getUser().token;
  Log.info('token: ' + token);

  if (token) {
    config.headers.Authorization = token;
  }

  Log.info(`1-请求配置${config.method!}-${config.url}：${JSON.stringify(config.params || config.data)}`);
  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


// 添加响应拦截器
instance.interceptors.response.use((response: AxiosResponse)=> {
  // 对响应数据做点什么

  // 登录态失效
  if (response.data?.code === 401) {
    // 清空token
    userStore.delUser();
    router.replaceUrl({ url: RouterConfig.LOGIN_PAGE })
    return Promise.reject(response.data);
  }

  // 接口异常
  if (response.data?.code !== 200) {
    AlertDialog.show({
      message: response.data?.msg
    });
    Log.error('3-code请求错误：' + JSON.stringify(response.data))
    return Promise.reject(response.data);
  }

  Log.warn('2-请求成功结果：' + JSON.stringify(response.data))

  // 简化返回数据类型
  return response.data?.data;
}, (error:AxiosError)=> {
  // 对响应错误做点什么
  AlertDialog.show({
    message: error.response?.status + '：' + error.message
  });
  Log.error('3-http请求错误：' + JSON.stringify(error))
  return Promise.reject(error);
});

interface RequestParams<D> {
  url?: string;
  method?: Method;
  params?: D;
  data?: D;
  headers?: RawAxiosRequestHeaders | AxiosHeaders;
  context?: null;
}

// 封装请求方法
async function request<T = null, D = null>(requestParams: RequestParams<D>): Promise<T> {
  // 延迟一秒，预览数据加载效果
  await delayTime(1000);
  return instance<null, T>(requestParams);
}

export { request }