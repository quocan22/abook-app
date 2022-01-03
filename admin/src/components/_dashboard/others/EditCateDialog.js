import { useEffect, useState } from 'react';
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

const initialCate = {
  _id: '',
  categoryName: ''
};

EditCateDialog.propTypes = {
  selectedCate: PropTypes.object,
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function EditCateDialog({ selectedCate, open, handleClose, onChange }) {
  const [invalidEdit, setInvalidEdit] = useState(false);
  const [cateOnEdit, setCateOnEdit] = useState(initialCate);
  const [loading, setLoading] = useState(false);

  const [previewImg, setPreviewImg] = useState();
  const [selectedFile, setSelectedFile] = useState();

  useEffect(() => {
    setCateOnEdit(selectedCate);
  }, [selectedCate]);

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

  const confirmUpdate = () => {
    if (!selectedCate.categoryName) {
      setInvalidEdit(true);
      return;
    }

    const updateData = { id: cateOnEdit._id, newName: cateOnEdit.categoryName };

    setLoading(true);
    CategoryService.updateCate(updateData)
      .then((res) => {
        toast.success(res.data.msg);
        setLoading(false);
        handleClose();
        onChange();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  return (
    <Dialog open={open} onClose={handleClose}>
      <DialogTitle>
        Edit Category: {selectedCate.categoryName && selectedCate.categoryName}
      </DialogTitle>
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
                image={(previewImg && previewImg) || cateOnEdit.imageUrl}
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
              error={invalidEdit}
              helperText={invalidEdit && 'Please enter category name'}
              onFocus={() => setInvalidEdit(false)}
              value={cateOnEdit.categoryName}
              onChange={(e) => setCateOnEdit({ ...cateOnEdit, categoryName: e.target.value })}
            />
          </Stack>
        </Box>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <LoadingButton variant="contained" loading={loading} onClick={confirmUpdate}>
          Update
        </LoadingButton>
        <Button variant="outlined" color="error" onClick={handleClose}>
          Cancel
        </Button>
      </DialogActions>
    </Dialog>
  );
}
