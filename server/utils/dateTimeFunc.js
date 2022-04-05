const dateTimeFunc = {
  validYear(year) {
    // regex for checking if year is valid
    const regex = /\b(19|20)\d\d\b/g;

    return regex.test(year);
  },
  validMonth(month) {
    // regex for checking if month is valid
    const regex = /^([1-9]|[1][0-2]?)$/g;

    return regex.test(month);
  },
  daysOfMonth(month, year) {
    // month in javascript starts at 0 (Jan is 0, Feb is 1), but by using 0 as the day
    // it will give us the last day of previous month, so passing 0 as day and month as
    // month will return the last day of that month
    return new Date(year, month, 0).getDate();
  },
};

module.exports = dateTimeFunc;
