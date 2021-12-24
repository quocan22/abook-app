import { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import dateFormat from 'dateformat';
import {
  Avatar,
  Button,
  CardMedia,
  Chip,
  Container,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  Divider,
  Grid,
  IconButton,
  Paper,
  Skeleton,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Tooltip,
  Typography
} from '@mui/material';
import { toast } from 'react-toastify';
import { LoadingButton } from '@mui/lab';
import { Icon } from '@iconify/react';
import closeFill from '@iconify/icons-eva/close-fill';
import checkFill from '@iconify/icons-eva/checkmark-fill';
import Label from '../../Label';
import { fCurrency } from '../../../utils/formatNumber';

import OrderService from '../../../services/OrderService';

const TABLE_HEAD = [
  { label: 'No.', align: 'left' },
  { label: 'Book Name', align: 'left' },
  { label: 'Price (VNĐ)', align: 'right' },
  { label: 'Quantity', align: 'right' },
  { label: 'Available', align: 'center' }
];

const convertIsAvailable = (isAvailable) => {
  switch (isAvailable) {
    case true:
      return 'Available';
    case false:
      return 'Not available';
    default:
      return 'Unknown';
  }
};

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

DetailDialog.propTypes = {
  open: PropTypes.bool,
  handleClose: PropTypes.func,
  orderId: PropTypes.string,
  change: PropTypes.bool,
  onChange: PropTypes.func
};

export default function DetailDialog({ open, handleClose, orderId, change, onChange }) {
  const [loading, setLoading] = useState(true);
  const [completing, setCompleting] = useState(false);
  const [cancelling, setCancelling] = useState(false);
  const [order, setOrder] = useState('');

  useEffect(() => {
    if (orderId) {
      setLoading(true);
      OrderService.getOrderInfo(orderId)
        .then((res) => {
          setOrder(res.data.data);
          setLoading(false);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoading(false);
        });
    }
  }, [orderId, change]);

  const handleSubmit = (status) => () => {
    if (status === 2) {
      setCompleting(true);
    } else if (status === 3) {
      setCancelling(true);
    }

    OrderService.updateShippingStatus({ id: orderId, status })
      .then((res) => {
        toast.success(res.data.msg);
        setCompleting(false);
        setCancelling(false);
        onChange();
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setCompleting(false);
        setCancelling(false);
      });
  };

  return (
    <Dialog open={open} onClose={handleClose} fullWidth maxWidth="md">
      <DialogTitle>
        Order Details
        {handleClose ? (
          <IconButton
            aria-label="close"
            onClick={handleClose}
            sx={{
              position: 'absolute',
              right: 8,
              top: 8,
              color: (theme) => theme.palette.grey[500]
            }}
          >
            <Icon icon={closeFill} />
          </IconButton>
        ) : null}
      </DialogTitle>
      <DialogContent>
        <Container>
          {loading ? (
            <Skeleton variant="h6" />
          ) : (
            <Stack direction="row" justifyContent="space-between">
              <Typography variant="h6">Bill No:&nbsp;{order._id}</Typography>
              <Stack direction="row" spacing={1}>
                <Chip
                  label={<strong>{convertPaidStatus(order.paidStatus)}</strong>}
                  color={
                    (order.paidStatus === 1 && 'warning') ||
                    (order.paidStatus === 2 && 'secondary') ||
                    'default'
                  }
                />
                <Chip
                  label={<strong>{convertShippingStatus(order.shippingStatus)}</strong>}
                  color={
                    (order.shippingStatus === 1 && 'warning') ||
                    (order.shippingStatus === 2 && 'secondary') ||
                    (order.shippingStatus === 3 && 'error') ||
                    'default'
                  }
                />
              </Stack>
            </Stack>
          )}
          <Divider variant="middle" sx={{ m: 1 }} />
          <Stack direction="row" justifyContent="space-between">
            <Grid item xs={5}>
              <Typography sx={{ mb: 2 }} variant="h6">
                Customer Information
              </Typography>
              {loading ? (
                <Stack spacing={1}>
                  <Skeleton variant="body1" />
                  <Skeleton variant="body1" />
                  <Skeleton variant="body1" />
                </Stack>
              ) : (
                <Stack>
                  <Stack direction="row" justifyContent="space-between">
                    <Typography>Name:</Typography>
                    <Typography align="right">{order.customerName}</Typography>
                  </Stack>
                  <Stack direction="row" justifyContent="space-between">
                    <Typography>Phone number:</Typography>
                    <Typography align="right">{order.customerPhone}</Typography>
                  </Stack>
                  <Stack direction="row" justifyContent="space-between">
                    <Typography>Address:</Typography>
                    <Typography align="right">{order.customerAddress}</Typography>
                  </Stack>
                </Stack>
              )}
            </Grid>
            <Grid item xs={5}>
              <Typography sx={{ mb: 2 }} variant="h6">
                Order Information
              </Typography>
              {loading ? (
                <Stack spacing={1}>
                  <Skeleton variant="body1" />
                  <Skeleton variant="body1" />
                  <Skeleton variant="body1" />
                </Stack>
              ) : (
                <Stack>
                  <Stack direction="row" justifyContent="space-between">
                    <Typography>Order date:</Typography>
                    <Typography align="right">
                      {dateFormat(order.createdAt, 'dd/mm/yyyy')}
                    </Typography>
                  </Stack>
                  <Stack direction="row" justifyContent="space-between">
                    <Typography>Discount:</Typography>
                    <Typography align="right">{fCurrency(order.discountPrice)}&nbsp;VNĐ</Typography>
                  </Stack>
                  <Stack direction="row" justifyContent="space-between">
                    <Typography>Total amount:</Typography>
                    <Typography align="right">{fCurrency(order.totalPrice)}&nbsp;VNĐ</Typography>
                  </Stack>
                </Stack>
              )}
            </Grid>
          </Stack>
          <Divider variant="middle" sx={{ m: 1 }} />
          {order.shippingStatus !== 2 && order.shippingStatus !== 3 && (
            <Stack direction="row" justifyContent="flex-end" spacing={1}>
              <LoadingButton
                variant="contained"
                color="secondary"
                endIcon={<Icon icon={checkFill} />}
                loadingPosition="end"
                loading={completing}
                onClick={handleSubmit(2)}
              >
                Complete
              </LoadingButton>
              <Button
                variant="contained"
                color="error"
                endIcon={<Icon icon={closeFill} />}
                loadingPosition="end"
                loading={cancelling}
                onClick={handleSubmit(3)}
              >
                Cancel
              </Button>
            </Stack>
          )}
          <Typography sx={{ mt: 2 }} variant="h6">
            Details
          </Typography>
          <Paper elevation={3}>
            <TableContainer sx={{ maxHeight: 300 }}>
              {loading ? (
                <Skeleton sx={{ height: 300 }} variant="reactangular" />
              ) : (
                <Table stickyHeader>
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
                    {order.details.map((row, index) => (
                      <TableRow hover key={index} tabIndex={-1} role="checkbox">
                        <TableCell align="left">{index + 1}</TableCell>
                        <TableCell>
                          <Stack direction="row" alignItems="center" spacing={2}>
                            <Tooltip
                              placement="left-end"
                              title={
                                <CardMedia
                                  height="250"
                                  width="250"
                                  component="img"
                                  image={
                                    (row.imageUrl && row.imageUrl) || '/static/empty_image.jpg'
                                  }
                                  alt="Preview avatar"
                                />
                              }
                            >
                              <Avatar alt={row.name} src={row.imageUrl} />
                            </Tooltip>
                            <Typography variant="subtitle2" noWrap>
                              {row.name}
                            </Typography>
                          </Stack>
                        </TableCell>
                        <TableCell align="right">{fCurrency(row.sellPrice)}</TableCell>
                        <TableCell align="right">{row.quantity}</TableCell>
                        <TableCell align="center">
                          <Label
                            variant="ghost"
                            color={
                              (row.isAvailable && 'secondary') ||
                              (!row.isAvailable && 'error') ||
                              'default'
                            }
                          >
                            {convertIsAvailable(row.isAvailable)}
                          </Label>
                        </TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              )}
            </TableContainer>
          </Paper>
        </Container>
      </DialogContent>
      <DialogActions sx={{ mr: 2, mb: 2 }}>
        <Button color="error" onClick={handleClose}>
          Close
        </Button>
      </DialogActions>
    </Dialog>
  );
}
