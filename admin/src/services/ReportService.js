import api from './api';

const API_MODEL_URL = '/report';

const getAnnualRevenueReport = (year) =>
  api.get(`${API_MODEL_URL}/revenue/annual`, {
    params: {
      y: year
    }
  });

const getMonthlyRevenueReport = (month, year) =>
  api.get(`${API_MODEL_URL}/revenue/monthly`, {
    params: {
      m: month,
      y: year
    }
  });

const getAnnualBookIssueReport = (year) =>
  api.get(`${API_MODEL_URL}/book_issue/annual`, {
    params: {
      y: year
    }
  });

const getMonthlyBookIssueReport = (month, year) =>
  api.get(`${API_MODEL_URL}/book_issue/monthly`, {
    params: {
      m: month,
      y: year
    }
  });

const getAnnualBookReceiptReport = (year) =>
  api.get(`${API_MODEL_URL}/book_receipt/annual`, {
    params: {
      y: year
    }
  });

const getMonthlyBookReceiptReport = (month, year) =>
  api.get(`${API_MODEL_URL}/book_receipt/monthly`, {
    params: {
      m: month,
      y: year
    }
  });

const ReportService = {
  getAnnualRevenueReport,
  getMonthlyRevenueReport,
  getAnnualBookIssueReport,
  getMonthlyBookIssueReport,
  getAnnualBookReceiptReport,
  getMonthlyBookReceiptReport
};

export default ReportService;
