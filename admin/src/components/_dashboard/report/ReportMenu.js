import PropTypes from 'prop-types';
import { useState } from 'react';

import { styled } from '@mui/material/styles';
import { Button, MenuItem, TextField, Toolbar } from '@mui/material';

const RootStyle = styled(Toolbar)(({ theme }) => ({
  height: 96,
  spacing: 1,
  display: 'flex',
  padding: theme.spacing(0, 1, 0, 3)
}));

const reportType = [
  { value: 'monthly', label: 'Monthly' },
  { value: 'annual', label: 'Annual' }
];

const months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

ReportMenu.propTypes = {
  showMonthlyReport: PropTypes.func,
  showAnnualReport: PropTypes.func
};

export default function ReportMenu({ showMonthlyReport, showAnnualReport }) {
  const [type, setType] = useState('annual');
  const [month, setMonth] = useState(1);
  const [year, setYear] = useState('');

  const showReport = () => {
    if (type === 'monthly') {
      showMonthlyReport(month, year);
    } else {
      showAnnualReport(year);
    }
  };

  return (
    <RootStyle>
      <TextField
        style={{ width: 200, marginRight: 10 }}
        select
        label="Reporting by"
        value={type}
        onChange={(e) => setType(e.target.value)}
      >
        {reportType.map((option) => (
          <MenuItem key={option.value} value={option.value}>
            {option.label}
          </MenuItem>
        ))}
      </TextField>
      {type === 'monthly' && (
        <TextField
          style={{ width: 200, marginRight: 10 }}
          select
          label="Month"
          value={month}
          onChange={(e) => setMonth(e.target.value)}
        >
          {months.map((month, index) => (
            <MenuItem key={index} value={month}>
              {month}
            </MenuItem>
          ))}
        </TextField>
      )}
      <TextField
        style={{ width: 200, marginRight: 10 }}
        label="Year"
        type="number"
        value={year}
        onChange={(e) => setYear(e.target.value)}
      />
      <Button variant="contained" onClick={showReport}>
        View
      </Button>
    </RootStyle>
  );
}
