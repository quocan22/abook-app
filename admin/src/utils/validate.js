export function validateEmail(email) {
  const regex =
    /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/g;

  return regex.test(email);
}

export function validatePassword(password) {
  return password.length >= 6;
}

export function validatePrice(value) {
  const regex = /^[1-9].*$/;

  return regex.test(value);
}

export function validateDiscountRatio(discountRatio) {
  return discountRatio <= 100 && discountRatio >= 0;
}
