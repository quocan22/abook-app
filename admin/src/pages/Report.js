import { useState, useEffect } from 'react';
import { toast } from 'react-toastify';
import {
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
  Typography
} from '@mui/material';
import Page from '../components/Page';
import { ReportMenu } from '../components/_dashboard/report';
import { ReportService } from '../services';
import { fCurrency } from '../utils/formatNumber';

const TABLE_HEAD = [
  { label: 'Month', align: 'center' },
  { label: 'Orders', align: 'center' },
  { label: 'Revenue (VNĐ)', align: 'center' }
];

export default function Report() {
  const [loading, setLoading] = useState(true);
  const [revenue, setRevenue] = useState([]);
  const [showingType, setShowingType] = useState('monthly');
  const [showingMonth, setShowingMonth] = useState('');
  const [showingYear, setShowingYear] = useState('');

  useEffect(() => {
    ReportService.getMonthlyRevenueReport(new Date().getMonth() + 1, new Date().getFullYear())
      .then((res) => {
        setRevenue(res.data.data);
        setShowingMonth(new Date().getMonth() + 1);
        setShowingYear(new Date().getFullYear());
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, []);

  const showMonthlyReport = (m, y) => {
    setLoading(true);

    ReportService.getMonthlyRevenueReport(m, y)
      .then((res) => {
        setRevenue(res.data.data);
        setShowingType('monthly');
        setShowingMonth(m);
        setShowingYear(y);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  const showAnnualReport = (y) => {
    setLoading(true);

    ReportService.getAnnualRevenueReport(y)
      .then((res) => {
        setRevenue(res.data.data);
        setShowingType('annual');
        // setShowingMonth(m);
        setShowingYear(y);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  };

  return (
    <Page title="Report | ABook">
      <Container>
        <Stack direction="row" alignContent="center" justifyContent="space-between" mb={5}>
          <Typography variant="h4" gutterBottom>
            Report
          </Typography>
        </Stack>

        <Card>
          <ReportMenu showMonthlyReport={showMonthlyReport} showAnnualReport={showAnnualReport} />

          <Stack direction="row">
            <Typography variant="h5" sx={{ ml: 3, mb: 2 }}>
              Showing: &#00;
            </Typography>
            {showingType === 'monthly' && (
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
              <Table size="small">
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
                  {revenue.map((row, index) => {
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
            )}
          </TableContainer>
        </Card>
      </Container>
    </Page>
  );
}
