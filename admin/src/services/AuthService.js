import api from './api';

const API_MODEL_URL = '/auth';

const login = (email, password) =>
  api.post(`${API_MODEL_URL}/login`, {
    email,
    password
  });

const adminLogin = (email, password) =>
  api.post(`${API_MODEL_URL}/admin_login`, { email, password });

const AuthService = {
  login,
  adminLogin
};

export default AuthService;
