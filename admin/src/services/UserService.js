const axios = require('axios');

const UserService = (token) => {
  const getAllUsers = async () => {
    axios
      .get('http://localhost:5000/api/users')
      .then((res) => res.data)
      .catch((err) => {
        console.error(err);
        return null;
      });
  };

  return {
    getAllUsers
  };
};

export default UserService;
