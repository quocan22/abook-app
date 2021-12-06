import api from './api';

const getAllBooks = () => api.get('/books');

const BookService = {
  getAllBooks
};

export default BookService;
