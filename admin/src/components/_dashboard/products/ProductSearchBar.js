import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Icon } from '@iconify/react';
import searchFill from '@iconify/icons-eva/search-fill';
import closeCircleFill from '@iconify/icons-eva/close-circle-fill';
import { toast } from 'react-toastify';

import { styled } from '@mui/material/styles';
import {
  Box,
  Toolbar,
  OutlinedInput,
  InputAdornment,
  TextField,
  MenuItem,
  Button
} from '@mui/material';

import { CategoryService } from '../../../services';

const RootStyle = styled(Toolbar)(({ theme }) => ({
  height: 96,
  spacing: 1,
  display: 'flex',
  padding: theme.spacing(0, 1, 0, 3)
}));

const SearchStyle = styled(OutlinedInput)(({ theme }) => ({
  width: 240,
  marginRight: 10,
  transition: theme.transitions.create(['box-shadow', 'width'], {
    easing: theme.transitions.easing.easeInOut,
    duration: theme.transitions.duration.shorter
  }),
  '&.Mui-focused': { width: 320, boxShadow: theme.customShadows.z8 },
  '& fieldset': {
    borderWidth: `1px !important`,
    borderColor: `${theme.palette.grey[500_32]} !important`
  }
}));

ProductSearchBar.propTypes = {
  filterName: PropTypes.string,
  onFilterName: PropTypes.func,
  filterCate: PropTypes.string,
  onFilterCate: PropTypes.func
};

export default function ProductSearchBar({ filterName, onFilterName, filterCate, onFilterCate }) {
  const [cates, setCates] = useState([{ _id: '', categoryName: 'All' }]);

  useEffect(() => {
    CategoryService.getAllCates()
      .then((res) => setCates(res.data.data))
      .catch((err) => err.response && toast.error(err.response.data.msg));
  }, []);

  return (
    <RootStyle>
      <SearchStyle
        value={filterName}
        onChange={onFilterName}
        placeholder="Search book by name..."
        startAdornment={
          <InputAdornment position="start">
            <Box component={Icon} icon={searchFill} sx={{ color: 'text.disabled' }} />
          </InputAdornment>
        }
      />
      <TextField
        style={{ width: 200 }}
        select
        label="Sort by category"
        value={filterCate}
        onChange={onFilterCate}
        defaultValue=""
      >
        {cates.map((option) => (
          <MenuItem key={option._id} value={option._id}>
            {option.categoryName}
          </MenuItem>
        ))}
      </TextField>
      <Button
        style={{ marginLeft: 10, fontSize: 16 }}
        value=""
        onClick={onFilterCate}
        endIcon={<Icon icon={closeCircleFill} />}
      >
        Clear
      </Button>
    </RootStyle>
  );
}
