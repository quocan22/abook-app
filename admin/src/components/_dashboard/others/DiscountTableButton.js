import { IconButton, Stack } from '@mui/material';
import { Icon } from '@iconify/react';
import editFill from '@iconify/icons-eva/edit-fill';
import trashFill from '@iconify/icons-eva/trash-fill';

export default function DiscountTableButton() {
  return (
    <Stack direction="row">
      <IconButton>
        <Icon icon={editFill} style={{ color: '#0096C7' }} />
      </IconButton>
      <IconButton>
        <Icon icon={trashFill} style={{ color: '#FF4842' }} />
      </IconButton>
    </Stack>
  );
}
