import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle
} from '@mui/material';
import PropTypes from 'prop-types';

ClearReceiptConfirmDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  confirmClear: PropTypes.func
};

export default function ClearReceiptConfirmDialog({ open, handleClose, confirmClear }) {
  return (
    <Dialog open={open} onClose={handleClose}>
      <DialogTitle>Are you sure to clear the receipt list?</DialogTitle>
      <DialogContent>
        <DialogContentText>
          All books in the list with be cleared, the receipt will be undone.
        </DialogContentText>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <Button variant="contained" color="error" onClick={confirmClear}>
          Yes
        </Button>
        <Button variant="outlined" onClick={handleClose}>
          No
        </Button>
      </DialogActions>
    </Dialog>
  );
}
