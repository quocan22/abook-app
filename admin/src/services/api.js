import TokenService from './TokenService';

const axios = require('axios');

const API_BASE_URL = 'http://localhost:5000/api';

const instance = axios.create({
  baseURL: API_BASE_URL
});

instance.interceptors.request.use(
  (config) => {
    const token = TokenService.getLocalAccessToken();

    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

instance.interceptors.response.use(
  (res) => res,
  async (err) => {
    const originalConfig = err.config;

    if (originalConfig.url !== '/auth/login' && err.response) {
      // If access token was expired
      if (err.response.status === 401 && !originalConfig._retry) {
        originalConfig._retry = true;

        try {
          const rs = await instance.post('/auth/refresh_token', {
            refreshToken: TokenService.getLocalRefreshToken()
          });

          const { accessToken } = rs.data;

          console.log(rs);

          TokenService.updateLocalAccessToken(accessToken);

          return instance(originalConfig);
        } catch (error) {
          return Promise.reject(error);
        }
      }
    }

    return Promise.reject(err);
  }
);

export default instance;
