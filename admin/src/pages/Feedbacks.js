import { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import dateFormat from 'dateformat';
import {
  Box,
  Card,
  CircularProgress,
  Container,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination,
  Typography
} from '@mui/material';
import Scrollbar from '../components/Scrollbar';
import Page from '../components/Page';

import { FeedbackService } from '../services';

const TABLE_HEAD = [
  { label: 'No.', align: 'left' },
  { label: 'Email', align: 'left' },
  { label: 'Date Time', align: 'left' },
  { label: 'Content', align: 'left' }
];

export default function Feedbacks() {
  const [loading, setLoading] = useState(false);
  const [feedbacks, setFeedbacks] = useState([]);

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  useEffect(() => {
    FeedbackService.getAllFeedbacks()
      .then((res) => {
        setFeedbacks(res.data.data);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, []);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const emptyRows = page > 0 ? Math.max(0, (1 + page) * rowsPerPage - feedbacks.length) : 0;

  return (
    <Page title="Feedbacks | ABook">
      <Container>
        <Typography sx={{ mb: 5 }} variant="h4" gutterBottom>
          Feedbacks
        </Typography>

        <Card>
          <Scrollbar>
            <TableContainer sx={{ minWidth: 800 }}>
              {loading ? (
                <Box
                  sx={{
                    display: 'flex',
                    width: '100%',
                    flexDirection: 'column',
                    alignItems: 'center'
                  }}
                >
                  <Box
                    sx={{
                      height: 100,
                      display: 'flex',
                      alignItems: 'center'
                    }}
                  >
                    <CircularProgress color="inherit" />
                  </Box>
                </Box>
              ) : (
                <Table>
                  <TableHead>
                    <TableRow>
                      {TABLE_HEAD.map((headCell) => (
                        <TableCell key={headCell.label} align={headCell.align}>
                          {headCell.label}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {feedbacks
                      .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                      .map((row, index) => {
                        const { email, createdAt, content } = row;

                        return (
                          <TableRow style={{ height: 70 }} hover key={index} tabIndex={-1}>
                            <TableCell align="center">{index + 1}</TableCell>
                            <TableCell align="left">{email}</TableCell>
                            <TableCell align="left">
                              {dateFormat(createdAt, 'dd/mm/yyyy')}
                            </TableCell>
                            <TableCell align="left">{content}</TableCell>
                          </TableRow>
                        );
                      })}
                    {emptyRows > 0 && (
                      <TableRow style={{ height: 53 * emptyRows }}>
                        <TableCell colSpan={8} />
                      </TableRow>
                    )}
                  </TableBody>
                </Table>
              )}
            </TableContainer>
          </Scrollbar>

          <TablePagination
            rowsPerPageOptions={[5, 10, 25]}
            component="div"
            count={feedbacks.length}
            rowsPerPage={rowsPerPage}
            page={page}
            onPageChange={handleChangePage}
            onRowsPerPageChange={handleChangeRowsPerPage}
          />
        </Card>
      </Container>
    </Page>
  );
}
