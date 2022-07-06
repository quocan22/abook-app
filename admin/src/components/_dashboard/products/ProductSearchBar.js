import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import { Icon } from '@iconify/react';
import searchFill from '@iconify/icons-eva/search-fill';
import { toast } from 'react-toastify';

import { styled } from '@mui/material/styles';
import {
  Box,
  Toolbar,
  OutlinedInput,
  InputAdornment,
  TextField,
  MenuItem,
  Stack,
  Pagination,
  FormControlLabel,
  Checkbox
} from '@mui/material';

import { CategoryService } from '../../../services';

const RootStyle = styled(Toolbar)(({ theme }) => ({
  height: 96,
  width: '100%',
  spacing: 1,
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
  onFilterCate: PropTypes.func,
  filteredBooks: PropTypes.array,
  itemPerPage: PropTypes.number,
  page: PropTypes.number,
  handleChangePage: PropTypes.func,
  loading: PropTypes.bool,
  filterOnSale: PropTypes.bool,
  handleChangeFilterOnSale: PropTypes.func
};

export default function ProductSearchBar({
  filterName,
  onFilterName,
  filterCate,
  onFilterCate,
  filteredBooks,
  itemPerPage,
  page,
  handleChangePage,
  loading,
  filterOnSale,
  handleChangeFilterOnSale
}) {
  const [cates, setCates] = useState([]);

  useEffect(() => {
    CategoryService.getAllCates()
      .then((res) => {
        setCates([{ _id: 'all', categoryName: 'All' }, ...res.data.data]);
      })
      .catch((err) => err.response && toast.error(err.response.data.msg));
  }, []);

  return (
    <RootStyle>
      <Stack sx={{ width: '100%' }} direction="row" justifyContent="space-between">
        <Stack direction="row">
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
          <FormControlLabel
            sx={{ ml: 2 }}
            label="Show On Sale"
            control={<Checkbox checked={filterOnSale} onChange={handleChangeFilterOnSale} />}
          />
        </Stack>
        {!loading && (
          <Pagination
            color="primary"
            showFirstButton
            showLastButton
            count={parseInt(filteredBooks.length / itemPerPage, 10) + 1}
            page={page}
            onChange={handleChangePage}
          />
        )}
      </Stack>
    </RootStyle>
  );
}
