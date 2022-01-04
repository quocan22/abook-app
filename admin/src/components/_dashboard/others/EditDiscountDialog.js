import { useState, useEffect } from 'react';
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
import { LocalizationProvider, DatePicker, LoadingButton } from '@mui/lab';
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

EditDiscountDialog.propTypes = {
  selectedDiscount: PropTypes.object,
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function EditDiscountDialog({ selectedDiscount, open, handleClose, onChange }) {
  const [loading, setLoading] = useState(false);
  const [discount, setDiscount] = useState(initialDiscount);
  const [invalid, setInvalid] = useState(initialInvalid);

  useEffect(() => {
    setDiscount(selectedDiscount);
  }, [selectedDiscount]);

  const confirmEdit = () => {
    if (!discount.code || !validatePrice(discount.value) || !discount.expiredDate) {
      setInvalid({
        code: !discount.code,
        value: !validatePrice(discount.value),
        expiredDate: !discount.expiredDate
      });
      return;
    }

    setLoading(true);

    const updateData = {
      id: discount._id,
      code: discount.code,
      value: discount.value,
      expiredDate: discount.expiredDate
    };
    DiscountService.updateDiscount(updateData)
      .then((res) => {
        toast.success(res.data.msg);
        setLoading(false);
        onChange();
        handleClose();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const handleChange = (prop) => (event) => {
    setDiscount({ ...discount, [prop]: event.target.value });
  };

  const closeClick = () => {
    handleClose();
    setDiscount(initialDiscount);
  };

  return (
    <Dialog open={open} onClose={closeClick}>
      <DialogTitle>Edit Discount</DialogTitle>
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
            value={discount.code}
            onChange={handleChange('code')}
          />
          <TextField
            type="number"
            variant="outlined"
            label="Discount Value"
            error={invalid.value}
            helperText={invalid.value && 'Invalid discount value'}
            onFocus={() => setInvalid({ ...invalid, value: false })}
            value={discount.value}
            onChange={handleChange('value')}
          />
          <LocalizationProvider dateAdapter={AdapterDateDns} locale={en}>
            <DatePicker
              variant="outlined"
              label="Expired Date"
              mask="__/__/____"
              value={discount.expiredDate}
              error={invalid.expiredDate}
              helperText={invalid.expiredDate && 'Expired date is required'}
              onFocus={() => setInvalid({ ...invalid, expiredDate: false })}
              onChange={(value) => setDiscount({ ...discount, expiredDate: value })}
              renderInput={(params) => <TextField {...params} />}
            />
          </LocalizationProvider>
        </Box>
      </DialogContent>
      <DialogActions sx={{ mb: 2, mr: 2 }}>
        <LoadingButton variant="contained" loading={loading} onClick={confirmEdit}>
          Confirm
        </LoadingButton>
        <Button color="error" onClick={closeClick}>
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
}
