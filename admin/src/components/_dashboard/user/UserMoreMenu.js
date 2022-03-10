import PropTypes from 'prop-types';
import { toast } from 'react-toastify';
import { Icon } from '@iconify/react';
import { useRef, useState } from 'react';
import editFill from '@iconify/icons-eva/edit-fill';
import lockFill from '@iconify/icons-eva/lock-fill';
import unlockFill from '@iconify/icons-eva/unlock-fill';
import moreVerticalFill from '@iconify/icons-eva/more-vertical-fill';
// material
import { Menu, MenuItem, IconButton, ListItemIcon, ListItemText } from '@mui/material';

import { UserService } from '../../../services';

// ----------------------------------------------------------------------

UserMoreMenu.propTypes = {
  isLocked: PropTypes.bool,
  userId: PropTypes.string,
  handleEditClick: PropTypes.func,
  setIdOnEdit: PropTypes.func,
  onChange: PropTypes.func
};

export default function UserMoreMenu({ isLocked, userId, handleEditClick, setIdOnEdit, onChange }) {
  const ref = useRef(null);
  const [isOpen, setIsOpen] = useState(false);

  const editClick = () => {
    setIdOnEdit(userId);
    handleEditClick();
    setIsOpen(false);
  };

  const changeLockStatus = () => {
    const status = !isLocked;

    console.log(status);

    UserService.changeLockStatus({ userId, status })
      .then((res) => {
        toast.success(res.data.msg);
        setIsOpen(false);
        onChange();
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
        <MenuItem onClick={editClick} sx={{ color: 'text.secondary' }}>
          <ListItemIcon>
            <Icon icon={editFill} width={24} height={24} />
          </ListItemIcon>
          <ListItemText primary="Edit" primaryTypographyProps={{ variant: 'body2' }} />
        </MenuItem>

        <MenuItem onClick={changeLockStatus} sx={{ color: 'text.secondary' }}>
          <ListItemIcon>
            <Icon icon={(isLocked && unlockFill) || lockFill} width={24} height={24} />
          </ListItemIcon>
          <ListItemText
            primary={(isLocked && 'Unlock') || 'Lock'}
            primaryTypographyProps={{ variant: 'body2' }}
          />
        </MenuItem>
      </Menu>
    </>
  );
}
