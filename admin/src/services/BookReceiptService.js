import api from './api';

const API_MODEL_URL = '/book_receipts';

const receiveBook = (books) => api.post(API_MODEL_URL, books);

const getBookReceiptDetails = (id) => api.get(`${API_MODEL_URL}/${id}`);

const BookReceiptService = {
  receiveBook,
  getBookReceiptDetails
};

export default BookReceiptService;
