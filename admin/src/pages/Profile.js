import { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import {
  Box,
  Button,
  Card,
  CardMedia,
  CircularProgress,
  Container,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Divider,
  IconButton,
  InputLabel,
  Stack,
  TextField,
  Typography
} from '@mui/material';
import { Icon } from '@iconify/react';
import eyeFill from '@iconify/icons-eva/eye-fill';
import editFill from '@iconify/icons-eva/edit-fill';
import closeFill from '@iconify/icons-eva/close-fill';

import Page from '../components/Page';

import { TokenService, UserService, AssetService } from '../services';

export default function Profile() {
  const [loading, setLoading] = useState(true);
  const [user, setUser] = useState('');

  const [openProfilePictureViewDialog, setOpenProfilePictureViewDialog] = useState(false);
  const [openProfilePictureEditDialog, setOpenProfilePictureEditDialog] = useState(false);
  const [previewImg, setPreviewImg] = useState();
  const [selectedFile, setSelectedFile] = useState();

  const [userOnEdit, setUserOnEdit] = useState('');
  const [onEdit, setOnEdit] = useState(false);
  const [change, setChange] = useState(false);

  useEffect(() => {
    setLoading(true);

    UserService.getUserInfo(TokenService.getUser().id)
      .then((res) => {
        setUser(res.data.data);
        setUserOnEdit(res.data.data);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, [change]);

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

  const handleUpdateInfo = () => {
    if (userOnEdit === user) {
      toast.warning('Nothing changed');
      return;
    }

    const userFormData = new FormData();
    userFormData.append('displayName', userOnEdit.displayName);
    userFormData.append('phoneNumber', userOnEdit.phoneNumber);
    userFormData.append('address', userOnEdit.address);

    setLoading(true);

    UserService.updateUserInfo(TokenService.getUser().id, userFormData)
      .then((res) => {
        setChange(!change);
        toast.success(res.data.msg);
        setOnEdit(false);
        modifyChanges();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const handleUpdateAvatar = () => {
    if (!selectedFile && !userOnEdit.avatarUrl) {
      setLoading(true);

      AssetService.deleteAvatar(TokenService.getUser().id)
        .then((res) => {
          toast.success(res.data.msg);
          setChange(!change);
          handleCloseProfilePictureEditDialog();
          modifyChanges();
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    } else if (selectedFile) {
      const profilePictureFormData = new FormData();

      profilePictureFormData.append('image', selectedFile);

      setLoading(true);

      AssetService.updateAvatar(TokenService.getUser().id, profilePictureFormData)
        .then((res) => {
          toast.success(res.data.msg);
          setChange(!change);
          handleCloseProfilePictureEditDialog();
          modifyChanges();
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    } else {
      toast.warning('Nothing changed');
    }
  };

  const modifyChanges = () => {
    UserService.getUserInfo(TokenService.getUser().id)
      .then((res) => {
        TokenService.updateUser(res.data.data.displayName, res.data.data.avatarUrl);
        window.location.reload(false);
      })
      .catch(() => {
        toast.error('Something went wrong when updating information');
      });
  };

  const handleCloseProfilePictureViewDialog = () => {
    setOpenProfilePictureViewDialog(false);
  };

  const handleCloseProfilePictureEditDialog = () => {
    setOpenProfilePictureEditDialog(false);
    setUserOnEdit(user);
    setSelectedFile(undefined);
  };

  const handleRemovePicture = () => {
    setSelectedFile(undefined);
    setUserOnEdit({ ...userOnEdit, avatarUrl: undefined });
  };

  const handleCancelUpdateInfo = () => {
    setOnEdit(false);
    setUserOnEdit(user);
  };

  const handleChangeUser = (prop) => (event) => {
    setUserOnEdit({ ...userOnEdit, [prop]: event.target.value });
  };

  return (
    <Page title="Profile | ABook">
      <Container>
        <Typography sx={{ mb: 5 }} variant="h4" gutterBottom>
          Profile
        </Typography>

        {loading || !user ? (
          <Box
            sx={{
              display: 'flex',
              width: '100%',
              flexDirection: 'column',
              alignItems: 'center'
            }}
          >
            <Box sx={{ height: 100, display: 'flex', alignItems: 'center' }}>
              <CircularProgress color="inherit" />
            </Box>
          </Box>
        ) : (
          <Stack direction="column" alignItems="center">
            <Card sx={{ width: 250, height: 250, borderRadius: '50%' }}>
              <CardMedia
                sx={{ width: '100%', height: '100%', objectFit: 'cover' }}
                component="img"
                image={user.avatarUrl}
                alt="Profile picture"
              />
            </Card>
            <Stack sx={{ my: 2, width: 250 }} direction="row" justifyContent="center" spacing={2}>
              <Button
                sx={{ width: 100 }}
                variant="contained"
                startIcon={<Icon icon={eyeFill} />}
                color="secondary"
                onClick={() => setOpenProfilePictureViewDialog(true)}
              >
                View
              </Button>
              <Button
                sx={{ width: 100 }}
                variant="contained"
                startIcon={<Icon icon={editFill} />}
                onClick={() => setOpenProfilePictureEditDialog(true)}
              >
                Update
              </Button>
            </Stack>

            <Dialog
              open={openProfilePictureViewDialog}
              onClose={handleCloseProfilePictureViewDialog}
            >
              <DialogTitle>
                Profile Picture View
                {handleCloseProfilePictureViewDialog ? (
                  <IconButton
                    aria-label="close"
                    onClick={handleCloseProfilePictureViewDialog}
                    sx={{
                      position: 'absolute',
                      right: 8,
                      top: 8,
                      color: (theme) => theme.palette.grey[500]
                    }}
                  >
                    <Icon icon={closeFill} />
                  </IconButton>
                ) : null}
              </DialogTitle>
              <DialogContent>
                <CardMedia
                  sx={{ maxWidth: 600, maxHeight: 600 }}
                  component="img"
                  image={user.avatarUrl}
                  alt="Avatar View"
                />
              </DialogContent>
            </Dialog>

            <Dialog
              open={openProfilePictureEditDialog}
              onClose={handleCloseProfilePictureEditDialog}
            >
              <DialogTitle>Edit Profile Picture</DialogTitle>
              <DialogContent>
                <Stack direction="column" spacing={2}>
                  <Card sx={{ maxWidth: 600, maxHeight: 600 }}>
                    <CardMedia
                      component="img"
                      image={
                        !previewImg && !userOnEdit.avatarUrl
                          ? 'https://res.cloudinary.com/quocan/image/upload/v1633830550/abook/avatar/anonymous_lx6zwf.png'
                          : (previewImg && previewImg) || userOnEdit.avatarUrl
                      }
                      alt="Avatar"
                    />
                  </Card>
                  <Stack direction="row" justifyContent="center" spacing={2}>
                    <Button variant="contained" component="label">
                      Choose A Picture
                      <input type="file" accept="image/*" hidden onChange={handleSelectFile} />
                    </Button>
                    <Button variant="contained" color="error" onClick={handleRemovePicture}>
                      Remove Picture
                    </Button>
                  </Stack>
                </Stack>
              </DialogContent>
              <DialogActions sx={{ mr: 2, mb: 2 }}>
                <Button onClick={handleUpdateAvatar}>Update</Button>
                <Button color="error" onClick={handleCloseProfilePictureEditDialog}>
                  Close
                </Button>
              </DialogActions>
            </Dialog>

            <Divider variant="middle" sx={{ m: 1, width: '50%' }}>
              INTRO
            </Divider>

            <Stack direction="column" spacing={2} alignItems="center">
              <Stack direction="row" justifyContent="center" spacing={2}>
                <Stack>
                  <InputLabel>Email</InputLabel>
                  <TextField value={userOnEdit.email} disabled />
                </Stack>
                <Stack>
                  <InputLabel>Full Name</InputLabel>
                  <TextField
                    autoComplete="nope"
                    value={userOnEdit.displayName}
                    disabled={!onEdit}
                    onChange={handleChangeUser('displayName')}
                  />
                </Stack>
              </Stack>
              <Stack direction="row" justifyContent="center" spacing={2}>
                <Stack>
                  <InputLabel>Address</InputLabel>
                  <TextField
                    autoComplete="nope"
                    value={userOnEdit.address}
                    disabled={!onEdit}
                    onChange={handleChangeUser('address')}
                  />
                </Stack>
                <Stack>
                  <InputLabel>Phone Number</InputLabel>
                  <TextField
                    autoComplete="nope"
                    value={userOnEdit.phoneNumber}
                    disabled={!onEdit}
                    onChange={handleChangeUser('phoneNumber')}
                  />
                </Stack>
              </Stack>
              {onEdit ? (
                <Stack direction="row" justifyContent="center" spacing={2}>
                  <Button variant="contained" onClick={handleUpdateInfo}>
                    Update
                  </Button>
                  <Button variant="contained" color="error" onClick={handleCancelUpdateInfo}>
                    Cancel
                  </Button>
                </Stack>
              ) : (
                <Button sx={{ width: 150 }} variant="contained" onClick={() => setOnEdit(true)}>
                  Edit Profile
                </Button>
              )}
            </Stack>
          </Stack>
        )}
      </Container>
    </Page>
  );
}
