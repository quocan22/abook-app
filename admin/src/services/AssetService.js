import api from './api';

const API_MODEL_URL = '/asset';

const updateAvatar = (userId, image) => api.put(`${API_MODEL_URL}/avatar/${userId}`, image);

const deleteAvatar = (userId) => api.delete(`${API_MODEL_URL}/avatar/${userId}`);

const AssetService = {
  updateAvatar,
  deleteAvatar
};

export default AssetService;
