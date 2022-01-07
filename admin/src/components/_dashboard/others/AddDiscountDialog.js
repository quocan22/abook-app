import { useState } from 'react';
import PropTypes from 'prop-types';
import { toast } from 'react-toastify';
import {
  Box,
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField
} from '@mui/material';
import en from 'date-fns/locale/en-US';
import { LocalizationProvider, LoadingButton, DateTimePicker } from '@mui/lab';
import AdapterDateDns from '@mui/lab/AdapterDateFns';
import { validatePrice } from '../../../utils/validate';

import { DiscountService } from '../../../services';

const initialDiscount = {
  code: '',
  value: '',
  expiredDate: new Date()
};

const initialInvalid = {
  code: false,
  value: false,
  expiredDate: false
};

AddDiscountDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function AddDiscountDialog({ open, handleClose, onChange }) {
  const [loading, setLoading] = useState(false);
  const [newDiscount, setNewDiscount] = useState(initialDiscount);
  const [invalid, setInvalid] = useState(initialInvalid);

  const confirmAdd = () => {
    if (!newDiscount.code || !validatePrice(newDiscount.value) || !newDiscount.expiredDate) {
      setInvalid({
        code: !newDiscount.code,
        value: !validatePrice(newDiscount.value),
        expiredDate: !newDiscount.expiredDate
      });
      return;
    }

    setLoading(true);

    DiscountService.createDiscount(newDiscount)
      .then((res) => {
        toast.success(res.data.msg);
        setLoading(false);
        setNewDiscount(initialDiscount);
        onChange();
        handleClose();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const handleChange = (prop) => (event) => {
    setNewDiscount({ ...newDiscount, [prop]: event.target.value });
  };

  const closeClick = () => {
    handleClose();
    setNewDiscount(initialDiscount);
  };

  return (
    <Dialog open={open} onClose={closeClick}>
      <DialogTitle>Add New Discount</DialogTitle>
      <DialogContent>
        <Box
          component="form"
          sx={{
            '& > :not(style)': { m: 1, width: '26.5ch' }
          }}
          noValidate
        >
          <TextField
            variant="outlined"
            label="Discount Code"
            error={invalid.code}
            helperText={invalid.code && 'Discount code is required'}
            onFocus={() => setInvalid({ ...invalid, code: false })}
            value={newDiscount.code}
            onChange={handleChange('code')}
          />
          <TextField
            type="number"
            variant="outlined"
            label="Discount Value"
            error={invalid.value}
            helperText={invalid.value && 'Invalid discount value'}
            onFocus={() => setInvalid({ ...invalid, value: false })}
            value={newDiscount.value}
            onChange={handleChange('value')}
          />
          <LocalizationProvider dateAdapter={AdapterDateDns} locale={en}>
            <DateTimePicker
              variant="outlined"
              label="Expired Date"
              mask="__/__/____"
              value={newDiscount.expiredDate}
              error={invalid.expiredDate}
              helperText={invalid.expiredDate && 'Expired date is required'}
              onFocus={() => setInvalid({ ...invalid, expiredDate: false })}
              onChange={(value) => setNewDiscount({ ...newDiscount, expiredDate: value })}
              renderInput={(params) => <TextField {...params} />}
            />
          </LocalizationProvider>
        </Box>
      </DialogContent>
      <DialogActions sx={{ mb: 2, mr: 2 }}>
        <LoadingButton variant="contained" loading={loading} onClick={confirmAdd}>
          Confirm
        </LoadingButton>
        <Button color="error" onClick={closeClick}>
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
}
