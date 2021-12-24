import api from './api';

const API_MODEL_URL = '/feedbacks';

const getAllFeedbacks = () => api.get(API_MODEL_URL);

const FeedbackService = {
  getAllFeedbacks
};

export default FeedbackService;
