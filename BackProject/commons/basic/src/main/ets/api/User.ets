import { LoginParams } from '../models/UserModel';
import { request } from '../utils/Request';

const login = (data: LoginParams) => {
  return request<string, LoginParams>({ url: '/employee/login', method: 'POST', data })
};

export {
  login
}