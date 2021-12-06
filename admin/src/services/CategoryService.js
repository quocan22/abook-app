import api from './api';

const getAllCates = () => api.get('/categories');

const CategoryService = {
  getAllCates
};

export default CategoryService;
