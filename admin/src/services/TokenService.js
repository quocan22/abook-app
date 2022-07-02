const getLocalRefreshToken = () => {
  const user = JSON.parse(localStorage.getItem('user'));
  return user?.refreshToken;
};

const getLocalAccessToken = () => {
  const user = JSON.parse(localStorage.getItem('user'));
  return user?.accessToken;
};

const updateLocalAccessToken = (token) => {
  const user = JSON.parse(localStorage.getItem('user'));
  user.accessToken = token;
  localStorage.setItem('user', JSON.stringify(user));
};

const getUser = () => JSON.parse(localStorage.getItem('user'));

const setUser = (user) => {
  localStorage.setItem('user', JSON.stringify(user));
};

const removeUser = () => {
  localStorage.removeItem('user');
};

const updateUser = (displayName, avatarUrl) => {
  const user = JSON.parse(localStorage.getItem('user'));
  user.displayName = displayName;
  user.avatarUrl = avatarUrl;

  setUser(user);
};

const TokenService = {
  getLocalRefreshToken,
  getLocalAccessToken,
  updateLocalAccessToken,
  getUser,
  setUser,
  removeUser,
  updateUser
};

export default TokenService;
