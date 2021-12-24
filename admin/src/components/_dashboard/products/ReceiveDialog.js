import { useState } from 'react';
import PropTypes from 'prop-types';
// material
import {
  Dialog,
  DialogTitle,
  DialogContent,
  TextField,
  Button,
  DialogActions,
  InputLabel,
  InputAdornment
} from '@mui/material';
import { toast } from 'react-toastify';
// utils
import { validatePrice } from '../../../utils/validate';
//
import BookService from '../../../services/BookService';

const initialInvalid = {
  price: false,
  quantity: false
};

ReceiveDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  product: PropTypes.object,
  onChange: PropTypes.func
};

export default function ReceiveDialog({ open, handleClose, product, onChange }) {
  const { _id, price } = product;
  const [receiveBook, setReceiveBook] = useState({ bookId: _id, price, quantity: '' });
  const [invalid, setInvalid] = useState(initialInvalid);

  const confirmReceive = () => {
    if (!validatePrice(receiveBook.price) || !validatePrice(receiveBook.quantity)) {
      setInvalid({
        price: !validatePrice(receiveBook.price),
        quantity: !validatePrice(receiveBook.quantity)
      });
      return;
    }

    const formData = {
      bookId: receiveBook.bookId,
      price: parseInt(receiveBook.price, 10),
      quantity: parseInt(receiveBook.quantity, 10)
    };
    BookService.receiveBook(formData)
      .then((res) => {
        setReceiveBook({ bookId: _id, price: '', quantity: '' });
        toast.success(res.data.msg);
        onChange();
        handleClose();
      })
      .catch((err) => err.response && toast.error(err.response.data.msg));
  };

  const handleChangeReceive = (prop) => (event) => {
    setReceiveBook({ ...receiveBook, [prop]: event.target.value });
  };

  return (
    <Dialog open={open} onClose={handleClose}>
      <DialogTitle>Receive Book</DialogTitle>
      <DialogContent>
        <InputLabel>Price</InputLabel>
        <TextField
          type="number"
          margin="dense"
          variant="outlined"
          error={invalid.price}
          helperText={invalid.price && 'Invalid price'}
          onFocus={() => setInvalid({ ...invalid, price: false })}
          InputProps={{ endAdornment: <InputAdornment position="end">&#8363;</InputAdornment> }}
          value={receiveBook.price}
          onChange={handleChangeReceive('price')}
        />
        <InputLabel sx={{ mt: 1 }}>Quantity</InputLabel>
        <TextField
          type="number"
          fullWidth
          margin="dense"
          variant="outlined"
          error={invalid.quantity}
          helperText={invalid.quantity && 'Invalid quantity'}
          onFocus={() => setInvalid({ ...invalid, quantity: false })}
          value={receiveBook.quantity}
          onChange={handleChangeReceive('quantity')}
        />
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <Button variant="contained" onClick={confirmReceive}>
          Receive
        </Button>
        <Button color="error" onClick={handleClose}>
          Cancel
        </Button>
      </DialogActions>
    </Dialog>
  );
}
