import api from './api';

const API_MODEL_URL = '/categories';

const getAllCates = () => api.get(API_MODEL_URL);

const createCates = (cate) => api.post(API_MODEL_URL, cate);

const updateCate = (cate) => api.put(API_MODEL_URL, cate);

const deleteCate = (cateId) => api.delete(`${API_MODEL_URL}/${cateId}`);

const CategoryService = {
  getAllCates,
  createCates,
  updateCate,
  deleteCate
};

export default CategoryService;
