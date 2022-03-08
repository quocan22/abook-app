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

const getAnnualBookReport = (year) =>
  api.get(`${API_MODEL_URL}/book/annual`, {
    params: {
      y: year
    }
  });

const getMonthlyBookReport = (month, year) =>
  api.get(`${API_MODEL_URL}/book/monthly`, {
    params: {
      m: month,
      y: year
    }
  });

const ReportService = {
  getAnnualRevenueReport,
  getMonthlyRevenueReport,
  getAnnualBookReport,
  getMonthlyBookReport
};

export default ReportService;
