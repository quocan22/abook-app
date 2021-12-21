import { useState, useEffect } from 'react';
import dateFormat from 'dateformat';
import {
  Container,
  Stack,
  Typography,
  Button,
  Card,
  TableContainer,
  Table,
  TableHead,
  TableRow,
  TableCell,
  Box,
  CircularProgress,
  TablePagination,
  TableBody
} from '@mui/material';
import { toast } from 'react-toastify';
import { Icon } from '@iconify/react';
import plusFill from '@iconify/icons-eva/plus-fill';
import { fCurrency } from '../utils/formatNumber';
import Page from '../components/Page';
import Scrollbar from '../components/Scrollbar';
import Label from '../components/Label';
import { DetailDialog } from '../components/_dashboard/orders';

import OrderService from '../services/OrderService';

const TABLE_HEAD = [
  { label: 'Bill No.', align: 'left' },
  { label: 'Customer Name', align: 'left' },
  { label: 'Customer Phone', align: 'left' },
  { label: 'Order Date', align: 'left' },
  { label: 'Product(s)', align: 'right' },
  { label: 'Amount', align: 'right' },
  { label: 'Paid', align: 'center' },
  { label: 'Shipping', align: 'center' }
];

export default function Orders() {
  const [loading, setLoading] = useState(true);
  const [orders, setOrders] = useState([]);
  const [selectedId, setSelectedId] = useState('');
  const [change, setChange] = useState(false);

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  const [openDetailDialog, setOpenDetailDialog] = useState(false);

  useEffect(() => {
    OrderService.getAllOrdersNotDetails()
      .then((res) => {
        setOrders(res.data.data);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, [change]);

  const convertPaidStatus = (paidStatus) => {
    // convert paid status from number to string
    // 1: unpaid, 2: paid
    switch (paidStatus) {
      case 1:
        return 'Unpaid';
      case 2:
        return 'Paid';
      default:
        return 'Unknown';
    }
  };

  const convertShippingStatus = (shippingStatus) => {
    // convert shipping status from number to string
    // 1: pending, 2: completed, 3: cancelled
    switch (shippingStatus) {
      case 1:
        return 'Pending';
      case 2:
        return 'Completed';
      case 3:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  };

  const onChange = () => {
    setChange(!change);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleOpenDetailDialog = (orderId) => () => {
    setSelectedId(orderId);
    setOpenDetailDialog(true);
  };

  const handleCloseDetailDialog = () => {
    setOpenDetailDialog(false);
  };

  const emptyRows = page > 0 ? Math.max(0, (1 + page) * rowsPerPage - orders.length) : 0;

  return (
    <Page title="Orders Management | ABook">
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
          <Typography variant="h4" gutterBottom>
            Orders
          </Typography>
          <Button variant="contained" startIcon={<Icon icon={plusFill} />}>
            New Order
          </Button>
        </Stack>

        <DetailDialog
          open={openDetailDialog}
          handleClose={handleCloseDetailDialog}
          orderId={selectedId}
          change={change}
          onChange={onChange}
        />

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
                    {orders
                      .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                      .map((row) => {
                        const {
                          _id,
                          billNo,
                          customerName,
                          customerPhone,
                          createdAt,
                          totalProducts,
                          totalPrice,
                          paidStatus,
                          shippingStatus
                        } = row;

                        return (
                          <TableRow
                            style={{ height: 70 }}
                            hover
                            key={billNo}
                            tabIndex={-1}
                            onDoubleClick={handleOpenDetailDialog(_id)}
                            sx={{
                              '&:hover:not(.Mui-disabled)': {
                                cursor: 'pointer'
                              }
                            }}
                          >
                            <TableCell align="left">{billNo}</TableCell>
                            <TableCell align="left">{customerName}</TableCell>
                            <TableCell align="left">{customerPhone}</TableCell>
                            <TableCell align="left">
                              {dateFormat(createdAt, 'dd/mm/yyyy')}
                            </TableCell>
                            <TableCell align="right">{totalProducts}</TableCell>
                            <TableCell align="right">{fCurrency(totalPrice)}&#8363;</TableCell>
                            <TableCell align="center">
                              <Label
                                variant="ghost"
                                color={
                                  (paidStatus === 1 && 'warning') ||
                                  (paidStatus === 2 && 'secondary') ||
                                  'default'
                                }
                              >
                                {convertPaidStatus(paidStatus)}
                              </Label>
                            </TableCell>
                            <TableCell align="center">
                              <Label
                                variant="ghost"
                                color={
                                  (shippingStatus === 1 && 'warning') ||
                                  (shippingStatus === 2 && 'secondary') ||
                                  (shippingStatus === 3 && 'error') ||
                                  'default'
                                }
                              >
                                {convertShippingStatus(shippingStatus)}
                              </Label>
                            </TableCell>
                          </TableRow>
                        );
                      })}
                    {emptyRows > 0 && (
                      <TableRow style={{ height: 53 * emptyRows }}>
                        <TableCell colSpan={6} />
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
            count={orders.length}
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
