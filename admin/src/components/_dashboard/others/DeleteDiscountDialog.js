import { useState } from 'react';
import PropTypes from 'prop-types';
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle
} from '@mui/material';
import { toast } from 'react-toastify';
import { LoadingButton } from '@mui/lab';
import { DiscountService } from '../../../services';

DeleteDiscountDialog.propTypes = {
  selectedDiscount: PropTypes.object,
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function DeleteDiscountDialog({ selectedDiscount, open, handleClose, onChange }) {
  const [loading, setLoading] = useState(false);

  const confirmDelete = () => {
    setLoading(true);
    DiscountService.deleteDiscount(selectedDiscount._id)
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
      <DialogTitle>Are you sure to delete {selectedDiscount.code} discount?</DialogTitle>
      <DialogContent>
        <DialogContentText>This discount will be deleted forever.</DialogContentText>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <LoadingButton variant="contained" color="error" loading={loading} onClick={confirmDelete}>
          Delete
        </LoadingButton>
        <Button variant="outlined" onClick={handleClose}>
          Cancel
        </Button>
      </DialogActions>
    </Dialog>
  );
}
