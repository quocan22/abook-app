import { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import {
  Avatar,
  Box,
  Card,
  CircularProgress,
  Container,
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
import { ReportService } from '../services';
import { fCurrency } from '../utils/formatNumber';

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

const TABLE_HEAD_BOOK = [
  { label: 'No.', align: 'center' },
  { label: 'Book', algin: 'left' },
  { label: 'Quantity', align: 'center' },
  { label: 'Author', align: 'center' }
];

export default function Report() {
  const [loading, setLoading] = useState(true);
  const [type, setType] = useState('revenue');
  const [revenueReport, setRevenueReport] = useState([]);
  const [bookReport, setBookReport] = useState([]);
  const [period, setPeriod] = useState('monthly');
  const [showingMonth, setShowingMonth] = useState('');
  const [showingYear, setShowingYear] = useState('');

  useEffect(() => {
    if (type === 'revenue') {
      ReportService.getMonthlyRevenueReport(new Date().getMonth() + 1, new Date().getFullYear())
        .then((res) => {
          setRevenueReport(res.data.data);
          setShowingMonth(new Date().getMonth() + 1);
          setShowingYear(new Date().getFullYear());
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    } else {
      ReportService.getMonthlyBookReport(new Date().getMonth() + 1, new Date().getFullYear())
        .then((res) => {
          setBookReport(res.data.data);
          setShowingMonth(new Date().getMonth() + 1);
          setShowingYear(new Date().getFullYear());
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    }
  }, [type]);

  const handleChangeType = (event, newType) => {
    setType(newType);
  };

  const showMonthlyReport = (m, y) => {
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
    } else {
      ReportService.getMonthlyBookReport(m, y)
        .then((res) => {
          setBookReport(res.data.data);
          setPeriod('monthly');
          setShowingMonth(m);
          setShowingYear(y);
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
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
    } else {
      ReportService.getAnnualBookReport(y)
        .then((res) => {
          setBookReport(res.data.data);
          setPeriod('monthly');
          setShowingYear(y);
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    }
  };

  const isReportNotFound = bookReport.length === 0;

  return (
    <Page title="Report | ABook">
      <Container>
        <Stack direction="row" alignContent="center" justifyContent="space-between" mb={5}>
          <Typography variant="h4" gutterBottom>
            Report
          </Typography>

          <ToggleButtonGroup color="primary" value={type} exclusive onChange={handleChangeType}>
            <ToggleButton value="revenue">Revenue</ToggleButton>
            <ToggleButton value="book">Book</ToggleButton>
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
              )) || (
                <Table>
                  <TableHead>
                    <TableRow>
                      {TABLE_HEAD_BOOK.map((headCell) => (
                        <TableCell key={headCell.label} align={headCell.align}>
                          {headCell.label}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {bookReport.map((row, index) => {
                      const { name, imageUrl, quantity, author } = row;

                      return (
                        <TableRow hover key={index} tabIndex={-1}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell component="th" scope="row">
                            <Stack direction="row" alignItems="center" spacing={2}>
                              <Avatar alt={name} src={imageUrl} />
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

                  {isReportNotFound && (
                    <TableBody>
                      <TableRow>
                        <TableCell align="center" colSpan={8} sx={{ py: 3 }}>
                          <SearchNotFound />
                        </TableCell>
                      </TableRow>
                    </TableBody>
                  )}
                </Table>
              )
            )}
          </TableContainer>
        </Card>
      </Container>
    </Page>
  );
}
