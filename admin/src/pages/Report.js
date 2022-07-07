import { useState, useEffect, useCallback } from 'react';
import { toast } from 'react-toastify';
import dateFormat from 'dateformat';
import {
  Avatar,
  Box,
  Card,
  CircularProgress,
  Container,
  Divider,
  Grid,
  Paper,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  ToggleButton,
  ToggleButtonGroup,
  Typography
} from '@mui/material';
import Page from '../components/Page';
import { ReportMenu } from '../components/_dashboard/report';
import SearchNotFound from '../components/SearchNotFound';
import { BookReceiptService, ReportService } from '../services';
import { fCurrency } from '../utils/formatNumber';
import { resizeScaleByWidth } from '../utils/resizeImageFromCloudinary';

const TABLE_HEAD_ANNUAL_REVENUE = [
  { label: 'Month', align: 'center' },
  { label: 'Orders', align: 'center' },
  { label: 'Revenue (VNĐ)', align: 'center' }
];

const TABLE_HEAD_MONTHLY_REVENUE = [
  { label: 'Date', align: 'center' },
  { label: 'Orders', align: 'center' },
  { label: 'Revenue (VNĐ)', align: 'center' }
];

const TABLE_HEAD_BOOK_ISSUE = [
  { label: 'No.', align: 'center' },
  { label: 'Book', algin: 'left' },
  { label: 'Quantity', align: 'center' },
  { label: 'Author', align: 'center' }
];

const TABLE_HEAD_BOOK_RECEIPT = [
  { label: 'No.', align: 'center' },
  { label: 'Receipt Date', align: 'left' },
  { label: 'Total Amount (VNĐ)', align: 'right' }
];

const TABLE_HEAD_RECEIPT_DETAILS = [
  { label: 'No.', align: 'center' },
  { label: 'Book Name', align: 'left' },
  { label: 'Quantity', align: 'right' },
  { label: 'Price (VNĐ)', align: 'right' },
  { label: 'Total (VNĐ)', align: 'right' }
];

export default function Report() {
  const [loading, setLoading] = useState(true);
  const [type, setType] = useState('revenue');
  const [revenueReport, setRevenueReport] = useState([]);
  const [bookIssueReport, setBookIssueReport] = useState([]);
  const [bookReceiptReport, setBookReceiptReport] = useState([]);
  const [period, setPeriod] = useState('monthly');
  const [showingMonth, setShowingMonth] = useState('');
  const [showingYear, setShowingYear] = useState('');

  const [loadingDetails, setLoadingDetails] = useState(false);
  const [selectedReceiptId, setSelectedReceiptId] = useState('');
  const [receiptDetails, setReceiptDetails] = useState([]);

  const showMonthlyReport = useCallback(
    (m, y) => {
      setLoading(true);

      if (type === 'revenue') {
        ReportService.getMonthlyRevenueReport(m, y)
          .then((res) => {
            setRevenueReport(res.data.data);
            setPeriod('monthly');
            setShowingMonth(m);
            setShowingYear(y);
            setLoading(false);
          })
          .catch((err) => {
            if (err.response) toast.error(err.response.data.msg);
            setLoading(false);
          });
      } else if (type === 'book issue') {
        ReportService.getMonthlyBookIssueReport(m, y)
          .then((res) => {
            setBookIssueReport(res.data.data);
            setPeriod('monthly');
            setShowingMonth(m);
            setShowingYear(y);
            setLoading(false);
          })
          .catch((err) => {
            if (err.response) toast.error(err.response.data.msg);
            setLoading(false);
          });
      } else if (type === 'book receipt') {
        ReportService.getMonthlyBookReceiptReport(m, y)
          .then((res) => {
            setBookReceiptReport(res.data.data);
            setSelectedReceiptId('');
            setReceiptDetails([]);
            setPeriod('monthly');
            setShowingMonth(m);
            setShowingYear(y);
            setLoading(false);
          })
          .catch((err) => {
            if (err.response) toast.error(err.response.data.msg);
            setLoading(false);
          });
      } else {
        toast.error('Something went wrong when attempting to fetch data');
        setLoading(false);
      }
    },
    [type]
  );

  useEffect(() => {
    showMonthlyReport(new Date().getMonth() + 1, new Date().getFullYear());
  }, [showMonthlyReport]);

  const handleChangeType = (event, newType) => {
    if (newType !== null) {
      setType(newType);
    }
  };

  const showAnnualReport = (y) => {
    setLoading(true);

    if (type === 'revenue') {
      ReportService.getAnnualRevenueReport(y)
        .then((res) => {
          setRevenueReport(res.data.data);
          setPeriod('annual');
          setShowingYear(y);
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    } else if (type === 'book issue') {
      ReportService.getAnnualBookIssueReport(y)
        .then((res) => {
          setBookIssueReport(res.data.data);
          setPeriod('monthly');
          setShowingYear(y);
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    } else if (type === 'book receipt') {
      ReportService.getAnnualBookReceiptReport(y)
        .then((res) => {
          setBookReceiptReport(res.data.data);
          setSelectedReceiptId('');
          setReceiptDetails([]);
          setPeriod('annual');
          setShowingYear(y);
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    } else {
      toast.error('Something went wrong when attempting to fetch data');
    }
  };

  const receiptRowClick = (id) => {
    if (selectedReceiptId === id) {
      setSelectedReceiptId('');
      setReceiptDetails([]);
    } else {
      setLoadingDetails(true);
      setSelectedReceiptId(id);

      BookReceiptService.getBookReceiptDetails(id)
        .then((res) => {
          setReceiptDetails(res.data.data);
          setLoadingDetails(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoadingDetails(false);
        });
    }
  };

  const isIssueReportNotFound = bookIssueReport.length === 0;

  const isReceiptReportNotFound = bookReceiptReport.length === 0;

  return (
    <Page title="Report | ABook">
      <Container>
        <Stack direction="row" alignContent="center" justifyContent="space-between" mb={5}>
          <Typography variant="h4" gutterBottom>
            Report
          </Typography>

          <ToggleButtonGroup color="primary" value={type} exclusive onChange={handleChangeType}>
            <ToggleButton value="revenue">Revenue</ToggleButton>
            <ToggleButton value="book issue">Book Issue</ToggleButton>
            <ToggleButton value="book receipt">Book Receipt</ToggleButton>
          </ToggleButtonGroup>
        </Stack>

        <Card>
          <ReportMenu showMonthlyReport={showMonthlyReport} showAnnualReport={showAnnualReport} />

          <Stack direction="row">
            <Typography variant="h5" sx={{ ml: 3, mb: 2 }}>
              Report {type} at:&nbsp;
            </Typography>
            {period === 'monthly' && (
              <Typography variant="h5" sx={{ mb: 2 }}>
                {showingMonth}/
              </Typography>
            )}
            <Typography variant="h5" sx={{ mb: 2 }}>
              {showingYear}
            </Typography>
          </Stack>

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
                <Box sx={{ height: 100, display: 'flex', alignItems: 'center' }}>
                  <CircularProgress color="inherit" />
                </Box>
              </Box>
            ) : (
              (type === 'revenue' && (
                <Table size="small">
                  <TableHead>
                    <TableRow>
                      {(
                        (period === 'annual' && TABLE_HEAD_ANNUAL_REVENUE) ||
                        TABLE_HEAD_MONTHLY_REVENUE
                      ).map((headCell) => (
                        <TableCell key={headCell.label} align={headCell.align}>
                          {headCell.label}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {revenueReport.map((row, index) => {
                      const { order, revenue } = row;

                      return (
                        <TableRow hover key={index} tabIndex={-1}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell align="center">{order}</TableCell>
                          <TableCell align="center">{fCurrency(revenue)}</TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>
                </Table>
              )) ||
              (type === 'book issue' && (
                <Table>
                  <TableHead>
                    <TableRow>
                      {TABLE_HEAD_BOOK_ISSUE.map((headCell) => (
                        <TableCell key={headCell.label} align={headCell.align}>
                          {headCell.label}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {bookIssueReport.map((row, index) => {
                      const { name, imageUrl, quantity, author } = row;

                      return (
                        <TableRow hover key={index} tabIndex={-1}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell component="th" scope="row">
                            <Stack direction="row" alignItems="center" spacing={2}>
                              <Avatar alt={name} src={resizeScaleByWidth(imageUrl, 100)} />
                              <Typography variant="subtitle2" noWrap>
                                {name}
                              </Typography>
                            </Stack>
                          </TableCell>
                          <TableCell align="center">{quantity}</TableCell>
                          <TableCell align="center">{author}</TableCell>
                        </TableRow>
                      );
                    })}
                  </TableBody>

                  {isIssueReportNotFound && (
                    <TableBody>
                      <TableRow>
                        <TableCell align="center" colSpan={8} sx={{ py: 3 }}>
                          <SearchNotFound />
                        </TableCell>
                      </TableRow>
                    </TableBody>
                  )}
                </Table>
              )) || (
                <Grid container>
                  <Grid item xs>
                    <Typography align="center" variant="h5">
                      Receipts List
                    </Typography>
                    <Table>
                      <TableHead>
                        <TableRow>
                          {TABLE_HEAD_BOOK_RECEIPT.map((headCell) => (
                            <TableCell key={headCell.label} align={headCell.align}>
                              {headCell.label}
                            </TableCell>
                          ))}
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {bookReceiptReport.map((row, index) => {
                          const { _id, totalPrice, receiptDate } = row;

                          return (
                            <TableRow
                              hover
                              selected={_id === selectedReceiptId}
                              key={index}
                              tabIndex={-1}
                              onClick={() => receiptRowClick(_id)}
                            >
                              <TableCell align="center">{index + 1}</TableCell>
                              <TableCell align="left">
                                {dateFormat(receiptDate, 'dd/mm/yyyy HH:MM')}
                              </TableCell>
                              <TableCell align="right">{fCurrency(totalPrice)}</TableCell>
                            </TableRow>
                          );
                        })}
                      </TableBody>

                      {isReceiptReportNotFound && (
                        <TableBody>
                          <TableRow>
                            <TableCell align="center" colSpan={3} sx={{ py: 3 }}>
                              <SearchNotFound />
                            </TableCell>
                          </TableRow>
                        </TableBody>
                      )}
                    </Table>
                  </Grid>
                  <Divider orientation="vertical" flexItem sx={{ my: 1, mx: 2 }} />
                  <Grid item xs>
                    <Typography align="center" variant="h5">
                      Details
                    </Typography>
                    {loadingDetails ? (
                      <Box
                        sx={{
                          display: 'flex',
                          width: '100%',
                          flexDirection: 'column',
                          alignItems: 'center'
                        }}
                      >
                        <Box sx={{ height: 100, display: 'flex', alignItems: 'center' }}>
                          <CircularProgress color="inherit" />
                        </Box>
                      </Box>
                    ) : (
                      <Table>
                        <TableHead>
                          <TableRow>
                            {TABLE_HEAD_RECEIPT_DETAILS.map((headCell) => (
                              <TableCell key={headCell.label} align={headCell.align}>
                                {headCell.label}
                              </TableCell>
                            ))}
                          </TableRow>
                        </TableHead>
                        <TableBody>
                          {receiptDetails.map((row, index) => {
                            const { name, quantity, price, total } = row;

                            return (
                              <TableRow hover key={index} tabIndex={-1}>
                                <TableCell align="center">{index + 1}</TableCell>
                                <TableCell align="left">{name}</TableCell>
                                <TableCell align="right">{quantity}</TableCell>
                                <TableCell align="right">{fCurrency(price)}</TableCell>
                                <TableCell align="right">{fCurrency(total)}</TableCell>
                              </TableRow>
                            );
                          })}
                        </TableBody>

                        {(selectedReceiptId !== '' && receiptDetails.length === 0 && (
                          <TableBody>
                            <TableRow>
                              <TableCell align="center" colSpan={5} sx={{ py: 3 }}>
                                <SearchNotFound />
                              </TableCell>
                            </TableRow>
                          </TableBody>
                        )) ||
                          (selectedReceiptId === '' && (
                            <TableBody>
                              <TableRow>
                                <TableCell align="center" colSpan={5} sx={{ py: 3 }}>
                                  <Paper>
                                    <Typography gutterBottom align="center" variant="subtitle1">
                                      Click on a receipt to see details
                                    </Typography>
                                  </Paper>
                                </TableCell>
                              </TableRow>
                            </TableBody>
                          ))}
                      </Table>
                    )}
                  </Grid>
                </Grid>
              )
            )}
          </TableContainer>
        </Card>
      </Container>
    </Page>
  );
}
