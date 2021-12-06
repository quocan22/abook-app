import { Paper, Typography } from '@mui/material';

// ----------------------------------------------------------------------

export default function SearchNotFound() {
  return (
    <Paper>
      <Typography gutterBottom align="center" variant="subtitle1">
        Not found
      </Typography>
      <Typography variant="body2" align="center">
        No results found. Try checking for typos or using complete words.
      </Typography>
    </Paper>
  );
}
