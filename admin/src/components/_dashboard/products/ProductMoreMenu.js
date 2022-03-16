import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import { Icon } from '@iconify/react';
import { useRef, useState } from 'react';
import downloadFill from '@iconify/icons-eva/download-fill';
import editFill from '@iconify/icons-eva/edit-fill';
import infoFill from '@iconify/icons-eva/info-fill';
import moreVerticalFill from '@iconify/icons-eva/more-vertical-fill';
// material
import { Menu, MenuItem, IconButton, ListItemIcon, ListItemText } from '@mui/material';

// ----------------------------------------------------------------------

ProductMoreMenu.propTypes = {
  id: PropTypes.string,
  handleEditClick: PropTypes.func,
  handleReceiveClick: PropTypes.func
};

export default function ProductMoreMenu({ id, handleEditClick, handleReceiveClick }) {
  const ref = useRef(null);
  const [isOpen, setIsOpen] = useState(false);

  const editClick = () => {
    handleEditClick();
    setIsOpen(false);
  };

  const receiveClick = () => {
    handleReceiveClick();
    setIsOpen(false);
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
        anchorOrigin={{ vertical: 'top', horizontal: 'left' }}
        transformOrigin={{ vertical: 'top', horizontal: 'left' }}
      >
        <MenuItem onClick={receiveClick} sx={{ color: 'text.secondary' }}>
          <ListItemIcon>
            <Icon icon={downloadFill} width={24} height={24} />
          </ListItemIcon>
          <ListItemText primary="Receive" primaryTypographyProps={{ variant: 'body2' }} />
        </MenuItem>

        <MenuItem onClick={editClick} sx={{ color: 'text.secondary' }}>
          <ListItemIcon>
            <Icon icon={editFill} width={24} height={24} />
          </ListItemIcon>
          <ListItemText primary="Edit" primaryTypographyProps={{ variant: 'body2' }} />
        </MenuItem>

        <MenuItem component={Link} to={`/dashboard/details/${id}`} sx={{ color: 'text.secondary' }}>
          <ListItemIcon>
            <Icon icon={infoFill} width={24} height={24} />
          </ListItemIcon>
          <ListItemText primary="Details" primaryTypographyProps={{ variant: 'body2' }} />
        </MenuItem>
      </Menu>
    </>
  );
}
