import PropTypes from 'prop-types';
import { toast } from 'react-toastify';
import { Icon } from '@iconify/react';
import { useRef, useState } from 'react';
import trashFill from '@iconify/icons-eva/trash-fill';
import moreVerticalFill from '@iconify/icons-eva/more-vertical-fill';
// material
import { Menu, MenuItem, IconButton, ListItemIcon, ListItemText } from '@mui/material';

import { BookService } from '../../../services';

// ----------------------------------------------------------------------

DetailMoreMenu.propTypes = {
  bookId: PropTypes.bool,
  index: PropTypes.string,
  onChange: PropTypes.func
};

export default function DetailMoreMenu({ bookId, index, onChange }) {
  const ref = useRef(null);
  const [isOpen, setIsOpen] = useState(false);

  const deleteComment = () => {
    BookService.deleteComment({ bookId, deleteIndex: index })
      .then((res) => {
        toast.success(res.data.msg);
        setIsOpen(false);
        onChange(index);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setIsOpen(false);
      });
  };

  return (
    <>
      <IconButton ref={ref} onClick={() => setIsOpen(true)}>
        <Icon icon={moreVerticalFill} width={20} height={20} />
      </IconButton>

      <Menu
        open={isOpen}
        anchorEl={ref.current}
        onClose={() => setIsOpen(false)}
        PaperProps={{
          sx: { width: 200, maxWidth: '100%' }
        }}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
        transformOrigin={{ vertical: 'top', horizontal: 'right' }}
      >
        <MenuItem onClick={deleteComment} sx={{ color: 'text.secondary' }}>
          <ListItemIcon>
            <Icon icon={trashFill} width={24} height={24} />
          </ListItemIcon>
          <ListItemText primary="Delete" primaryTypographyProps={{ variant: 'body2' }} />
        </MenuItem>
      </Menu>
    </>
  );
}
