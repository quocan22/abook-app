import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Box,
  CircularProgress,
  TextField,
  Stack,
  InputLabel,
  Card,
  CardMedia
} from '@mui/material';
import { toast } from 'react-toastify';
import { LoadingButton } from '@mui/lab';

import { UserService } from '../../../services';

EditUserDialog.propTypes = {
  idOnEdit: PropTypes.string,
  openEditDialog: PropTypes.bool,
  handleCloseEditDialog: PropTypes.func,
  onChange: PropTypes.func
};

export default function EditUserDialog({
  idOnEdit,
  openEditDialog,
  handleCloseEditDialog,
  onChange
}) {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState();

  const [previewImg, setPreviewImg] = useState();
  const [selectedFile, setSelectedFile] = useState();

  useEffect(() => {
    if (idOnEdit)
      UserService.getUserInfo(idOnEdit).then(
        (res) => {
          const { displayName, phoneNumber, address, avatarUrl } = res.data.data;
          setUser({
            displayName,
            phoneNumber,
            address,
            avatarUrl
          });
          setLoading(false);
        },
        (err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        }
      );
  }, [idOnEdit]);

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
    setLoading(true);
    setSelectedFile(undefined);
    handleCloseEditDialog();
  };

  const confirmClick = () => {
    const userFormData = new FormData();
    userFormData.append('displayName', user.displayName);
    userFormData.append('phoneNumber', user.phoneNumber);
    userFormData.append('address', user.address);
    if (selectedFile) userFormData.append('image', selectedFile);

    setLoading(true);
    UserService.updateUserInfo(idOnEdit, userFormData)
      .then((res) => {
        toast.success(res.data.msg);
        onChange();
        handleClose();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const handleChangeUser = (prop) => (event) => {
    setUser({ ...user, [prop]: event.target.value });
  };

  return (
    <Dialog open={openEditDialog} onClose={handleClose}>
      <DialogTitle>Edit User Info</DialogTitle>
      {loading ? (
        <Box
          sx={{
            display: 'flex',
            width: '100%',
            flexDirection: 'column',
            alignItems: 'center'
          }}
        >
          <Box sx={{ height: 100 }}>
            <CircularProgress color="inherit" />
          </Box>
        </Box>
      ) : (
        <DialogContent>
          <Box
            component="form"
            sx={{
              '& > :not(style)': { m: 1, width: '26.5ch' }
            }}
            noValidate
          >
            <Stack spacing={1}>
              <InputLabel>Avatar</InputLabel>
              <Card>
                <CardMedia
                  height="250"
                  width="250"
                  component="img"
                  image={(previewImg && previewImg) || user.avatarUrl}
                  alt="Avatar"
                />
              </Card>
              <Button variant="contained" component="label">
                Change Avatar
                <input type="file" accept="image/*" hidden onChange={handleSelectFile} />
              </Button>
            </Stack>
            <TextField
              variant="outlined"
              label="Display Name"
              value={user.displayName}
              onChange={handleChangeUser('displayName')}
            />
            <TextField
              variant="outlined"
              label="Phone Number"
              value={user.phoneNumber}
              onChange={handleChangeUser('phoneNumber')}
            />
            <TextField
              variant="outlined"
              label="Address"
              value={user.address}
              onChange={handleChangeUser('address')}
            />
          </Box>
        </DialogContent>
      )}
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <LoadingButton variant="contained" loading={loading} onClick={confirmClick}>
          Confirm
        </LoadingButton>
        <Button color="error" variant="outlined" onClick={handleClose}>
          Cancel
        </Button>
      </DialogActions>
    </Dialog>
  );
}
