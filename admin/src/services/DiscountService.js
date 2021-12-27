import api from './api';

const API_MODEL_URL = '/discounts';

const getAllDiscounts = () => api.get(API_MODEL_URL);

const DiscountService = {
  getAllDiscounts
};

export default DiscountService;
