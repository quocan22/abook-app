import api from './api';

const API_MODEL_URL = '/books';

const getAllBooks = () => api.get(API_MODEL_URL);

const receiveBook = (receive) => api.put(`${API_MODEL_URL}/receive`, receive);

const BookService = {
  getAllBooks,
  receiveBook
};

export default BookService;
