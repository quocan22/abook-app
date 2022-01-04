import api from './api';

const API_MODEL_URL = '/discounts';

const getAllDiscounts = () => api.get(API_MODEL_URL);

const getAvailableDiscounts = () => api.get(`${API_MODEL_URL}/available`);

const createDiscount = (discount) => api.post(API_MODEL_URL, discount);

const updateDiscount = (discount) => api.put(API_MODEL_URL, discount);

const deleteDiscount = (id) => api.delete(`${API_MODEL_URL}/${id}`);

const DiscountService = {
  getAllDiscounts,
  getAvailableDiscounts,
  createDiscount,
  updateDiscount,
  deleteDiscount
};

export default DiscountService;
