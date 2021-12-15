import api from './api';

const API_MODEL_URL = '/books';

const getAllBooks = () => api.get(API_MODEL_URL);

const createBook = (book) => api.post(API_MODEL_URL, book);

const updateBook = (bookId, bookInfo) => api.put(`${API_MODEL_URL}/${bookId}`, bookInfo);

const receiveBook = (receive) => api.put(`${API_MODEL_URL}/receive`, receive);

const BookService = {
  getAllBooks,
  createBook,
  updateBook,
  receiveBook
};

export default BookService;
