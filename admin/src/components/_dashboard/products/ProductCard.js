import { useState } from 'react';
import PropTypes from 'prop-types';
// material
import {
  Box,
  Card,
  Typography,
  Stack,
  Rating,
  Dialog,
  Zoom,
  DialogTitle,
  DialogContent,
  TextField,
  Button,
  DialogActions,
  InputLabel,
  InputAdornment
} from '@mui/material';
import { styled } from '@mui/material/styles';
import { toast } from 'react-toastify';
// utils
import { fCurrency } from '../../../utils/formatNumber';
import { validatePrice } from '../../../utils/validate';
//
import Label from '../../Label';
import { ProductMoreMenu } from '.';
import BookService from '../../../services/BookService';

// ----------------------------------------------------------------------

const ProductImgStyle = styled('img')({
  top: 0,
  width: '100%',
  height: '100%',
  objectFit: 'cover',
  position: 'absolute'
});

// ----------------------------------------------------------------------

const initialInvalid = {
  price: false,
  quantity: false
};

ProductCard.propTypes = {
  product: PropTypes.object,
  onChange: PropTypes.func
};

export default function ProductCard({ product, onChange }) {
  const { _id, name, imageUrl, price, quantity, avgRate, isAvailable } = product;

  const [onPreview, setOnPreview] = useState(false);

  const [openReceiveDialog, setOpenReceiveDialog] = useState(false);
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
        setOpenReceiveDialog(false);
        onChange();
      })
      .catch((err) => err.response && toast.error(err.response.data.msg));
  };

  const handleReceiveClick = () => {
    setOpenReceiveDialog(true);
  };

  const handleChangeReceive = (prop) => (event) => {
    setReceiveBook({ ...receiveBook, [prop]: event.target.value });
  };

  return (
    <Card
      onMouseEnter={() => setOnPreview(true)}
      onBlur={() => setOnPreview(false)}
      onMouseLeave={() => setOnPreview(false)}
    >
      <Box
        sx={{
          pt: '100%',
          position: 'relative',
          backgroundColor: 'primary.lighter'
        }}
      >
        {onPreview ? (
          <Zoom in={onPreview}>
            <Box sx={{ position: 'absolute', top: 30, left: 30 }}>
              <Typography variant="subtitle1">Price:&nbsp;{fCurrency(price)}&#8363;</Typography>
              <Typography variant="subtitle1">Quantity:&nbsp;{quantity}</Typography>
              <Label variant="filled" color={(isAvailable && 'secondary') || 'error'}>
                {(isAvailable && 'Available') || 'Not Available'}
              </Label>
            </Box>
          </Zoom>
        ) : (
          <ProductImgStyle alt={name} src={imageUrl} />
        )}
      </Box>

      <Stack spacing={2} sx={{ p: 3 }}>
        <Stack direction="row" alignItems="center" justifyContent="space-between">
          <Stack>
            <Typography variant="subtitle1" noWrap>
              {name}
            </Typography>
            <Rating readOnly value={avgRate} />
          </Stack>
          <ProductMoreMenu handleReceiveClick={handleReceiveClick} />
        </Stack>
      </Stack>
      <Dialog open={openReceiveDialog} onClose={() => setOpenReceiveDialog(false)}>
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
          <Button variant="contained" color="error" onClick={() => setOpenReceiveDialog(false)}>
            Cancel
          </Button>
        </DialogActions>
      </Dialog>
    </Card>
  );
}
