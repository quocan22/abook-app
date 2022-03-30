import api from './api';

const API_MODEL_URL = '/book_receipts';

const receiveBook = (books) => api.post(API_MODEL_URL, books);

const BookReceiptService = {
  receiveBook
};

export default BookReceiptService;
