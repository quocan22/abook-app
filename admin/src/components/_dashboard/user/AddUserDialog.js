import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Box,
  TextField,
  MenuItem,
  Button,
  Card,
  CardMedia,
  Stack,
  InputLabel
} from '@mui/material';

import { validateEmail, validatePassword } from '../../../utils/validate';

// role of account
// 1: user, 2: staff, 3: admin
const roles = [
  {
    value: 1,
    label: 'User'
  },
  {
    value: 2,
    label: 'Staff'
  },
  {
    value: 3,
    label: 'Admin'
  }
];

const initialInvalid = {
  email: false,
  password: false,
  role: false
};

const initialUser = {
  email: '',
  password: '',
  displayName: '',
  role: '',
  phoneNumber: '',
  address: ''
};

AddUserDialog.propTypes = {
  openAddDialog: PropTypes.bool,
  handleCloseAddDialog: PropTypes.func,
  handleAddUser: PropTypes.func
};

export default function AddUserDialog({ openAddDialog, handleCloseAddDialog, handleAddUser }) {
  const [invalid, setInvalid] = useState(initialInvalid);
  const [user, setUser] = useState(initialUser);

  const [previewImg, setPreviewImg] = useState();
  const [selectedFile, setSelectedFile] = useState();

  useEffect(() => {
    if (!selectedFile) {
      setPreviewImg(undefined);
      return;
    }
    const objectURL = URL.createObjectURL(selectedFile);
    setPreviewImg(objectURL);
  }, [selectedFile]);

  useEffect(() => {
    URL.revokeObjectURL(previewImg);
  }, [previewImg]);

  const handleSelectFile = (e) => {
    if (!e.target.files || e.target.files.length === 0) {
      setSelectedFile(undefined);
      return;
    }
    setSelectedFile(e.target.files[0]);
  };

  const handleClose = () => {
    setUser(initialUser);
    setInvalid(initialInvalid);
    setSelectedFile(undefined);
    handleCloseAddDialog();
  };

  const applyClick = () => {
    if (!validateEmail(user.email) || !validatePassword(user.password) || !user.role) {
      setInvalid({
        email: !validateEmail(user.email),
        password: !validatePassword(user.password),
        role: !user.role
      });
      return;
    }

    // Have to use form data for sending file
    const userFormData = new FormData();
    userFormData.append('email', user.email);
    userFormData.append('password', user.password);
    userFormData.append('role', user.role);
    userFormData.append('userClaim[displayName]', user.displayName);
    userFormData.append('userClaim[phoneNumber]', user.phoneNumber);
    userFormData.append('userClaim[address]', user.address);
    if (selectedFile) {
      userFormData.append('image', selectedFile);
    }
    handleAddUser(userFormData);
    handleClose();
  };

  const handleChangeUser = (prop) => (event) => {
    setUser({ ...user, [prop]: event.target.value });
  };

  return (
    <Dialog open={openAddDialog} onClose={handleClose}>
      <DialogTitle>Add New Account</DialogTitle>
      <DialogContent>
        <Box
          component="form"
          sx={{
            '& > :not(style)': { m: 1, width: '26.5ch' }
          }}
          noValidate
          autoComplete="off"
        >
          <InputLabel>Information</InputLabel>
          <TextField
            error={invalid.email}
            required
            autoComplete="nope"
            label="Email"
            variant="outlined"
            helperText={invalid.email && 'Invalid email.'}
            onFocus={() => setInvalid({ ...invalid, email: false })}
            onChange={handleChangeUser('email')}
            value={user.email}
          />
          <TextField
            error={invalid.password}
            required
            autoComplete="new-password"
            label="Password"
            type="password"
            variant="outlined"
            helperText={invalid.password && 'Password must have at least 6 characters.'}
            onFocus={() => setInvalid({ ...invalid, password: false })}
            onChange={handleChangeUser('password')}
            value={user.password}
          />
          <TextField
            label="Full Name"
            variant="outlined"
            autoComplete="nope"
            value={user.displayName}
            onChange={handleChangeUser('displayName')}
          />
          <TextField
            error={invalid.role}
            required
            label="Role"
            variant="outlined"
            onChange={handleChangeUser('role')}
            value={user.role}
            select
            helperText={invalid.role && 'Choose a role.'}
            onFocus={() => setInvalid({ ...invalid, role: false })}
          >
            {roles.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            label="Phone Number"
            variant="outlined"
            autoComplete="nope"
            value={user.phoneNumber}
            onChange={handleChangeUser('phoneNumber')}
          />
          <TextField
            label="Address"
            variant="outlined"
            autoComplete="nope"
            value={user.address}
            onChange={handleChangeUser('address')}
          />
          <Stack spacing={1}>
            <InputLabel>Avatar</InputLabel>
            <Card>
              <CardMedia
                height="250"
                width="250"
                component="img"
                image={(previewImg && previewImg) || '/static/empty_image.jpg'}
                alt="Preview avatar"
              />
            </Card>
            <Button variant="contained" component="label">
              Upload Image
              <input type="file" accept="image/*" hidden onChange={handleSelectFile} />
            </Button>
          </Stack>
        </Box>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <Button color="error" variant="outlined" onClick={handleClose}>
          Cancel
        </Button>
        <Button variant="contained" onClick={applyClick}>
          Confirm
        </Button>
      </DialogActions>
    </Dialog>
  );
}
