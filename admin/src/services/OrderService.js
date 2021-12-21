import api from './api';

const API_MODEL_URL = '/orders';

const getAllOrdersNotDetails = () => api.get(API_MODEL_URL);

const getOrderInfo = (orderId) => api.get(`${API_MODEL_URL}/${orderId}`);

const updateShippingStatus = (data) => api.post(`${API_MODEL_URL}/shipping_status`, data);

const OrderService = {
  getAllOrdersNotDetails,
  getOrderInfo,
  updateShippingStatus
};

export default OrderService;
