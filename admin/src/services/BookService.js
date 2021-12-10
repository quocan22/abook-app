import api from './api';

const API_MODEL_URL = '/books';

const getAllBooks = () => api.get(API_MODEL_URL);

const BookService = {
  getAllBooks
};

export default BookService;
