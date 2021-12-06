import api from './api';

const getAllUsers = () => api.get('/users');

const addNewUser = (user) => api.post('/users/register', user);

const getUserInfo = (userId) => api.get(`/users/${userId}`);

const updateUserInfo = (userId, userClaim) => api.put(`/users/${userId}`, userClaim);

const UserService = {
  getAllUsers,
  addNewUser,
  getUserInfo,
  updateUserInfo
};

export default UserService;
