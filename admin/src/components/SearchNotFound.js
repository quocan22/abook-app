import PropTypes from 'prop-types';
import { Paper, Typography } from '@mui/material';

// ----------------------------------------------------------------------

SearchNotFound.propTypes = {
  searching: PropTypes.bool
};

export default function SearchNotFound({ searching }) {
  return (
    <Paper>
      <Typography gutterBottom align="center" variant="subtitle1">
        Not found
      </Typography>
      {searching && (
        <Typography variant="body2" align="center">
          No results found. Try checking for typos or using complete words.
        </Typography>
      )}
    </Paper>
  );
}
