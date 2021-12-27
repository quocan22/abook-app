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
  DialogContentText,
  Collapse,
  InputLabel
} from '@mui/material';
import { toast } from 'react-toastify';
import { Icon } from '@iconify/react';
import trashFill from '@iconify/icons-eva/trash-fill';
import editFill from '@iconify/icons-eva/edit-fill';
import plusFill from '@iconify/icons-eva/plus-fill';
import closeFill from '@iconify/icons-eva/close-fill';

import { CategoryService } from '../../../services';

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
  const [newCate, setNewCate] = useState('');

  const [invalidNew, setInvalidNew] = useState(false);
  const [invalidEdit, setInvalidEdit] = useState(false);

  const [openAdd, setOpenAdd] = useState(false);
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

  const confirmAdd = () => {
    if (!newCate) {
      setInvalidNew(true);
      return;
    }

    setLoading(true);
    CategoryService.createCates({ categoryName: newCate })
      .then((res) => {
        toast.success(res.data.msg);
        setChange(!change);
        addClick();
        onChange();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const confirmUpdate = () => {
    if (!cateOnEdit.categoryName) {
      setInvalidEdit(true);
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

  const addClick = () => {
    setOpenAdd(!openAdd);
  };

  const closeClick = () => {
    setOpenAdd(false);
    handleClose();
  };

  const editClick = (cate) => () => {
    setCateOnEdit(cate);
    setOpenEdit(true);
  };

  const cancelEditClick = () => {
    setOpenEdit(false);
    setCateOnEdit(initialCate);
  };

  const deleteClick = (cate) => () => {
    setCateOnDelete(cate);
    setOpenDelete(true);
  };

  const cancelDeleteClick = () => {
    setOpenDelete(false);
    setCateOnDelete(initialCate);
  };

  return (
    <Dialog open={open} onClose={closeClick}>
      <DialogTitle>Category Management</DialogTitle>
      <DialogContent style={{ width: 400 }}>
        <InputLabel sx={{ mx: 2 }}>Categories List</InputLabel>
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
                      <IconButton edge="end" aria-label="edit" onClick={editClick(c)}>
                        <Icon icon={editFill} style={{ color: '#0096C7' }} />
                      </IconButton>
                      <IconButton edge="end" aria-label="delete" onClick={deleteClick(c)}>
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
        <Button
          variant="contained"
          sx={{ mb: 2, ml: 2 }}
          startIcon={(openAdd && <Icon icon={closeFill} />) || <Icon icon={plusFill} />}
          onClick={addClick}
        >
          {(openAdd && 'Cancel') || 'Add New Category'}
        </Button>
        <Collapse in={openAdd} timeout="auto" unmountOnExit>
          <Stack sx={{ mx: 2 }} direction="row" justifyContent="space-between">
            <TextField
              error={invalidNew}
              helperText={invalidNew && 'Please enter category name'}
              onFocus={() => setInvalidNew(false)}
              variant="outlined"
              label="Category name"
              value={newCate}
              onChange={(e) => setNewCate(e.target.value)}
            />
            <Button variant="contained" onClick={confirmAdd}>
              Add
            </Button>
          </Stack>
        </Collapse>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <Button color="error" onClick={closeClick}>
          Close
        </Button>
      </DialogActions>

      {/* Edit dialog */}
      <Dialog open={openEdit} onClose={() => setOpenEdit(false)}>
        <DialogTitle>
          Edit Category: {cateOnEdit.categoryName && cateOnEdit.categoryName}
        </DialogTitle>
        <DialogContent>
          <TextField
            error={invalidEdit}
            helperText={invalidEdit && 'Please enter category name'}
            onFocus={() => setInvalidEdit(false)}
            value={cateOnEdit.categoryName}
            onChange={(e) => setCateOnEdit({ ...cateOnEdit, categoryName: e.target.value })}
          />
        </DialogContent>
        <DialogActions sx={{ mr: 2, mb: 2 }}>
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
        <DialogActions sx={{ mr: 2, mb: 2 }}>
          <Button variant="contained" color="error" onClick={confirmDelete}>
            Delete
          </Button>
          <Button onClick={cancelDeleteClick}>Cancel</Button>
        </DialogActions>
      </Dialog>
    </Dialog>
  );
}
