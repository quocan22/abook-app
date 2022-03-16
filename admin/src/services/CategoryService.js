import api from './api';

const API_MODEL_URL = '/categories';

const getAllCates = () => api.get(API_MODEL_URL);

const getCateById = (id) => api.get(`${API_MODEL_URL}/${id}`);

const createCates = (cate) => api.post(API_MODEL_URL, cate);

const updateCate = (cate) => api.put(API_MODEL_URL, cate);

const deleteCate = (cateId) => api.delete(`${API_MODEL_URL}/${cateId}`);

const CategoryService = {
  getAllCates,
  getCateById,
  createCates,
  updateCate,
  deleteCate
};

export default CategoryService;
