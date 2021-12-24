import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  Box,
  CircularProgress,
  TextField,
  DialogActions,
  Button,
  MenuItem,
  Stack,
  InputLabel,
  Card,
  CardMedia
} from '@mui/material';
import { toast } from 'react-toastify';
import BookService from '../../../services/BookService';
import CategoryService from '../../../services/CategoryService';
import { validatePrice } from '../../../utils/validate';

const initialBook = {
  categoryId: '',
  name: '',
  price: '',
  quantity: '',
  description: ''
};

const initialInvalid = {
  categoryId: false,
  name: false,
  price: false,
  quantity: false,
  description: false
};

AddBookDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function AddBookDialog({ open, handleClose, onChange }) {
  const [book, setBook] = useState(initialBook);
  const [cates, setCates] = useState([]);
  const [invalid, setInvalid] = useState(initialInvalid);
  const [loading, setLoading] = useState(true);

  const [previewImg, setPreviewImg] = useState();
  const [selectedFile, setSelectedFile] = useState();

  useEffect(() => {
    CategoryService.getAllCates()
      .then((res) => {
        setCates(res.data.data);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response.data.msg) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, []);

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

  const confirmCreate = () => {
    if (
      !book.categoryId ||
      !book.name ||
      !validatePrice(book.price) ||
      !validatePrice(book.quantity) ||
      !book.description
    ) {
      setInvalid({
        categoryId: !book.categoryId,
        name: !book.name,
        price: !validatePrice(book.price),
        quantity: !validatePrice(book.quantity),
        description: !book.description
      });
      return;
    }

    setLoading(true);

    // Have to use form data for sending file
    const bookFormData = new FormData();
    bookFormData.append('categoryId', book.categoryId);
    bookFormData.append('name', book.name);
    bookFormData.append('price', parseInt(book.price, 10));
    bookFormData.append('quantity', parseInt(book.quantity, 10));
    bookFormData.append('description', book.description);
    if (selectedFile) {
      bookFormData.append('image', selectedFile);
    }

    BookService.createBook(bookFormData)
      .then((res) => {
        setLoading(false);
        toast.success(res.data.msg);
        onChange();
        cancelClick();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const cancelClick = () => {
    setBook(initialBook);
    setInvalid(initialInvalid);
    setSelectedFile(undefined);
    handleClose();
  };

  const handleChangeBook = (prop) => (event) => {
    setBook({ ...book, [prop]: event.target.value });
  };

  return (
    <Dialog open={open} onClose={cancelClick}>
      <DialogTitle>Edit Book Information</DialogTitle>
      <DialogContent>
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
          <Box
            component="form"
            sx={{
              '& > :not(style)': { m: 1, width: '26.5ch' }
            }}
            noValidate
            autoComplete="off"
          >
            <Stack spacing={1}>
              <InputLabel>Book Image</InputLabel>
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
            <TextField
              autoComplete="nope"
              variant="outlined"
              label="Name"
              error={invalid.name}
              helperText={invalid.name && 'Name is required'}
              onFocus={() => setInvalid({ ...invalid, name: false })}
              value={book.name}
              onChange={handleChangeBook('name')}
            />
            <TextField
              select
              variant="outlined"
              label="Category"
              error={invalid.categoryId}
              helperText={invalid.categoryId && 'Category is required'}
              onFocus={() => setInvalid({ ...invalid, categoryId: false })}
              value={book.categoryId}
              onChange={handleChangeBook('categoryId')}
            >
              {cates.map((c) => (
                <MenuItem key={c._id} value={c._id}>
                  {c.categoryName}
                </MenuItem>
              ))}
            </TextField>
            <TextField
              variant="outlined"
              label="Price"
              type="number"
              error={invalid.price}
              helperText={invalid.price && 'Invalid price'}
              onFocus={() => setInvalid({ ...invalid, price: false })}
              value={book.price}
              onChange={handleChangeBook('price')}
            />
            <TextField
              variant="outlined"
              label="Quantity"
              type="number"
              error={invalid.quantity}
              helperText={invalid.quantity && 'Invalid quantity'}
              onFocus={() => setInvalid({ ...invalid, quantity: false })}
              value={book.quantity}
              onChange={handleChangeBook('quantity')}
            />
            <TextField
              variant="outlined"
              label="Description"
              multiline
              fullWidth
              rows={3}
              error={invalid.description}
              helperText={invalid.description && 'Description is required'}
              onFocus={() => setInvalid({ ...invalid, description: false })}
              value={book.description}
              onChange={handleChangeBook('description')}
            />
          </Box>
        )}
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <Button variant="contained" onClick={confirmCreate}>
          Confirm
        </Button>
        <Button color="error" onClick={cancelClick}>
          Cancel
        </Button>
      </DialogActions>
    </Dialog>
  );
}
