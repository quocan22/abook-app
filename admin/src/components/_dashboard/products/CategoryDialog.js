import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import {
  Button,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  List,
  ListItem,
  ListItemText,
  IconButton,
  Stack,
  Paper,
  Box,
  CircularProgress,
  TextField,
  DialogContentText
} from '@mui/material';
import { toast } from 'react-toastify';
import { Icon } from '@iconify/react';
import trashFill from '@iconify/icons-eva/trash-fill';
import editFill from '@iconify/icons-eva/edit-fill';
import plusFill from '@iconify/icons-eva/plus-fill';

import CategoryService from '../../../services/CategoryService';

const initialCate = {
  _id: '',
  categoryName: ''
};

CategoryDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  onChange: PropTypes.func
};

export default function CategoryDialog({ open, handleClose, onChange }) {
  const [loading, setLoading] = useState(true);
  const [cates, setCates] = useState([]);
  const [change, setChange] = useState(false);

  const [openEdit, setOpenEdit] = useState(false);
  const [cateOnEdit, setCateOnEdit] = useState(initialCate);
  const [openDelete, setOpenDelete] = useState(false);
  const [cateOnDelete, setCateOnDelete] = useState(initialCate);

  useEffect(() => {
    setLoading(true);
    CategoryService.getAllCates()
      .then((res) => {
        setCates(res.data.data);
        setLoading(false);
      })
      .catch((err) => {
        setLoading(false);
        if (err.response) toast.error(err.response.data.msg);
      });
  }, [change]);

  const confirmUpdate = () => {
    if (!cateOnEdit.categoryName) {
      toast.error('Please enter category name');
      return;
    }

    const updateData = { id: cateOnEdit._id, newName: cateOnEdit.categoryName };

    setLoading(true);
    CategoryService.updateCate(updateData)
      .then((res) => {
        toast.success(res.data.msg);
        setChange(!change);
        cancelEditClick();
        onChange();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const confirmDelete = () => {
    setLoading(true);
    CategoryService.deleteCate(cateOnDelete._id)
      .then((res) => {
        toast.success(res.data.msg);
        setChange(!change);
        cancelDeleteClick();
        onChange();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const closeClick = () => {
    handleClose();
  };

  const editClick = (cate) => {
    setCateOnEdit(cate);
    setOpenEdit(true);
  };

  const cancelEditClick = () => {
    setCateOnEdit(initialCate);
    setOpenEdit(false);
  };

  const deleteClick = (cate) => {
    setCateOnDelete(cate);
    setOpenDelete(true);
  };

  const cancelDeleteClick = () => {
    setCateOnDelete(initialCate);
    setOpenDelete(false);
  };

  return (
    <Dialog open={open} onClose={closeClick}>
      <DialogTitle>Category Management</DialogTitle>
      <DialogContent style={{ width: 400 }}>
        <Button variant="contained" sx={{ mb: 2, ml: 2 }} startIcon={<Icon icon={plusFill} />}>
          Add New Category
        </Button>
        <Paper style={{ maxHeight: 300, overflow: 'auto' }}>
          {loading ? (
            <Box
              sx={{
                display: 'flex',
                width: '100%',
                height: 100,
                alignItems: 'center',
                justifyContent: 'center'
              }}
            >
              <CircularProgress color="inherit" />
            </Box>
          ) : (
            <List>
              {cates.map((c) => (
                <ListItem
                  key={c._id}
                  secondaryAction={
                    <Stack direction="row" spacing={2}>
                      <IconButton edge="end" aria-label="edit" onClick={() => editClick(c)}>
                        <Icon icon={editFill} style={{ color: '#0096C7' }} />
                      </IconButton>
                      <IconButton edge="end" aria-label="delete" onClick={() => deleteClick(c)}>
                        <Icon icon={trashFill} style={{ color: '#FF4842' }} />
                      </IconButton>
                    </Stack>
                  }
                >
                  <ListItemText primary={c.categoryName} />
                </ListItem>
              ))}
            </List>
          )}
        </Paper>
      </DialogContent>
      <DialogActions>
        <Button variant="contained" color="error" onClick={closeClick}>
          Close
        </Button>
      </DialogActions>

      {/* Edit dialog */}
      <Dialog open={openEdit} onClose={() => setOpenEdit(false)}>
        <DialogTitle>Edit Category</DialogTitle>
        <DialogContent>
          <TextField
            value={cateOnEdit.categoryName}
            onChange={(e) => setCateOnEdit({ ...cateOnEdit, categoryName: e.target.value })}
          />
        </DialogContent>
        <DialogActions>
          <Button variant="contained" onClick={confirmUpdate}>
            Update
          </Button>
          <Button variant="contained" color="error" onClick={cancelEditClick}>
            Cancel
          </Button>
        </DialogActions>
      </Dialog>

      {/* Delete dialog */}
      <Dialog open={openDelete} onClose={() => setOpenDelete(false)}>
        <DialogTitle>Are you sure to delete {cateOnDelete.categoryName} category?</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Make sure this category is empty (there is no book in), and this category will be
            deleted forever.
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button variant="contained" color="error" onClick={confirmDelete}>
            Delete
          </Button>
          <Button variant="contained" onClick={cancelDeleteClick}>
            Cancel
          </Button>
        </DialogActions>
      </Dialog>
    </Dialog>
  );
}
