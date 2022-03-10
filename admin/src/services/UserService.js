import api from './api';

const API_MODEL_URL = '/users';

const getAllUsers = () => api.get(API_MODEL_URL);

const addNewUser = (user) => api.post(`${API_MODEL_URL}/register`, user);

const getUserInfo = (userId) => api.get(`${API_MODEL_URL}/${userId}`);

const updateUserInfo = (userId, userClaim) => api.put(`${API_MODEL_URL}/${userId}`, userClaim);

const changeLockStatus = (data) => api.post(`${API_MODEL_URL}/lock`, data);

const UserService = {
  getAllUsers,
  addNewUser,
  getUserInfo,
  updateUserInfo,
  changeLockStatus
};

export default UserService;
