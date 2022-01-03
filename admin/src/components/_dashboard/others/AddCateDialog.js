import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Box,
  Button,
  Card,
  CardMedia,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  InputLabel,
  Stack,
  TextField
} from '@mui/material';
import { LoadingButton } from '@mui/lab';
import { toast } from 'react-toastify';
import { CategoryService } from '../../../services';

AddCateDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function AddCateDialog({ open, handleClose, onChange }) {
  const [newCate, setNewCate] = useState('');
  const [invalidNew, setInvalidNew] = useState(false);
  const [loading, setLoading] = useState(false);

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

  const confirmAdd = () => {
    if (!newCate) {
      setInvalidNew(true);
      return;
    }

    setLoading(true);

    // Have to use form data for sending file
    const cateFormData = new FormData();
    cateFormData.append('categoryName', newCate);
    if (selectedFile) {
      cateFormData.append('image', selectedFile);
    }

    CategoryService.createCates(cateFormData)
      .then((res) => {
        toast.success(res.data.msg);
        setLoading(false);
        closeClick();
        onChange();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const closeClick = () => {
    handleClose();
    setSelectedFile(undefined);
    setNewCate('');
  };

  return (
    <Dialog open={open} onClose={closeClick}>
      <DialogTitle>Add New Category</DialogTitle>
      <DialogContent>
        <Box
          component="form"
          sx={{
            '& > :not(style)': { m: 1, width: '26.5ch' }
          }}
          noValidate
        >
          <Stack spacing={1}>
            <InputLabel>Category Thumbnail</InputLabel>
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
          <Stack spacing={1}>
            <InputLabel>Category Name</InputLabel>
            <TextField
              error={invalidNew}
              helperText={invalidNew && 'Please enter category name'}
              onFocus={() => setInvalidNew(false)}
              variant="outlined"
              value={newCate}
              onChange={(e) => setNewCate(e.target.value)}
            />
          </Stack>
        </Box>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <LoadingButton variant="contained" loading={loading} onClick={confirmAdd}>
          Confirm
        </LoadingButton>
        <Button variant="outlined" color="error" onClick={closeClick}>
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
}
