import api from './api';

const API_MODEL_URL = '/books';

const getAllBooks = () => api.get(API_MODEL_URL);

const getAllBooksGeneralInfo = () => api.get(`${API_MODEL_URL}/general_info`);

const getBookById = (id) => api.get(`${API_MODEL_URL}/${id}`);

const createBook = (book) => api.post(API_MODEL_URL, book);

const updateBook = (bookId, bookInfo) => api.put(`${API_MODEL_URL}/${bookId}`, bookInfo);

const deleteComment = (data) => api.put(`${API_MODEL_URL}/comment`, data);

const BookService = {
  getAllBooks,
  getAllBooksGeneralInfo,
  getBookById,
  createBook,
  updateBook,
  deleteComment
};

export default BookService;
