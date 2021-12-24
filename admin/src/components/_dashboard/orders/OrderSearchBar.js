import PropTypes from 'prop-types';
import { Icon } from '@iconify/react';
import searchFill from '@iconify/icons-eva/search-fill';

import { styled } from '@mui/material/styles';
import { Box, Toolbar, OutlinedInput, InputAdornment, TextField, MenuItem } from '@mui/material';

const RootStyle = styled(Toolbar)(({ theme }) => ({
  height: 96,
  spacing: 1,
  display: 'flex',
  padding: theme.spacing(0, 1, 0, 3)
}));

const SearchStyle = styled(OutlinedInput)(({ theme }) => ({
  width: 240,
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

const searchOptions = [
  { value: '_id', label: 'Bill No' },
  { value: 'customerName', label: 'Customer Name' },
  { value: 'customerPhone', label: 'Customer Phone' },
  { value: 'paidStatus', label: 'Paid Status' },
  { value: 'shippingStatus', label: 'Shipping Status' }
];

const paidValues = [
  { value: '1', label: 'Unpaid' },
  { value: '2', label: 'Paid' }
];

const shippingValues = [
  { value: '1', label: 'Pending' },
  { value: '2', label: 'Completed' },
  { value: '3', label: 'Cancelled' }
];

OrderSearchBar.propTypes = {
  searchValue: PropTypes.string,
  changeSearchValue: PropTypes.func,
  searchField: PropTypes.string,
  changeSearchField: PropTypes.func
};

export default function OrderSearchBar({
  searchValue,
  changeSearchValue,
  searchField,
  changeSearchField
}) {
  return (
    <RootStyle>
      {/* Select options */}
      <TextField
        style={{ width: 200, marginRight: 10 }}
        select
        label="Search field"
        value={searchField}
        onChange={changeSearchField}
      >
        {searchOptions.map((option) => (
          <MenuItem key={option.value} value={option.value}>
            {option.label}
          </MenuItem>
        ))}
      </TextField>

      {/* Value entering input */}
      {(searchField === 'paidStatus' && (
        <TextField
          style={{ width: 200 }}
          select
          label="Search value"
          value={searchValue}
          onChange={changeSearchValue}
        >
          {paidValues.map((option, index) => (
            <MenuItem key={index} value={option.value}>
              {option.label}
            </MenuItem>
          ))}
        </TextField>
      )) ||
        (searchField === 'shippingStatus' && (
          <TextField
            style={{ width: 200, marginRight: 10 }}
            select
            label="Search value"
            value={searchValue}
            onChange={changeSearchValue}
          >
            {shippingValues.map((option, index) => (
              <MenuItem key={index} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
        )) || (
          <SearchStyle
            value={searchValue}
            onChange={changeSearchValue}
            placeholder="Search order..."
            startAdornment={
              <InputAdornment position="start">
                <Box component={Icon} icon={searchFill} sx={{ color: 'text.disabled' }} />
              </InputAdornment>
            }
          />
        )}
    </RootStyle>
  );
}
