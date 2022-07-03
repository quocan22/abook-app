const formatCurrency = (currency) => {
  return currency.toLocaleString("it-IT", {
    style: "currency",
    currency: "VND",
  });
};

module.exports = formatCurrency;
