import { useState, useEffect } from 'react';
import {
  Avatar,
  Box,
  Card,
  CircularProgress,
  Container,
  Grid,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography
} from '@mui/material';
import dateFormat from 'dateformat';
import { toast } from 'react-toastify';
import Page from '../components/Page';
import { DiscountTableButton } from '../components/_dashboard/others';
import { fCurrency } from '../utils/formatNumber';

import { DiscountService } from '../services';

const DISCOUNT_TABLE_HEAD = [
  { label: 'STT', align: 'center' },
  { label: 'Code', align: 'left' },
  { label: 'Value', align: 'right' },
  { label: 'Expired Date', align: 'right' },
  { label: '', align: 'right' }
];
const SALE_TABLE_HEAD = [
  { label: 'Book', align: 'left' },
  { label: 'Original Price', align: 'right' },
  { label: 'Sale Price', align: 'right' }
];

const sale = [
  {
    imageUrl:
      'https://res.cloudinary.com/quocan/image/upload/v1639584057/abook/book/hsakk7a3kxmkm5xlu6x1.jpg',
    name: 'Đắc nhân tâm',
    original: 250000,
    sale: '25000 (10%)'
  },
  {
    imageUrl:
      'https://res.cloudinary.com/quocan/image/upload/v1639583476/abook/book/ozaqmxmmgfom5lqdspid.jpg',
    name: 'Tuổi trẻ đáng giá bao nhiêu',
    original: 79000,
    sale: '20000 (25%)'
  },
  {
    imageUrl:
      'https://res.cloudinary.com/quocan/image/upload/v1639585521/abook/book/n8ro8rhlybxavshsbexp.jpg',
    name: '5 Centimet trên giây',
    original: 38000,
    sale: '3800 (10%)'
  },
  {
    imageUrl:
      'https://res.cloudinary.com/quocan/image/upload/v1639811584/abook/book/gvboc1tjpjbrf7miv5d3.png',
    name: 'Chó sủa nhầm cây',
    original: 102000,
    sale: '15300 (15%)'
  }
];

export default function OtherSettings() {
  const [loading, setLoading] = useState(false);
  const [discounts, setDiscounts] = useState([]);

  useEffect(() => {
    DiscountService.getAllDiscounts()
      .then((res) => {
        setLoading(false);
        setDiscounts(res.data.data);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, []);

  return (
    <Page title="Other Settings | ABook">
      <Container>
        <Typography sx={{ mb: 5 }} variant="h4" gutterBottom>
          Other Settings
        </Typography>

        <Stack direction="row" justifyContent="space-between" spacing={2}>
          <Grid item xs={6}>
            <Card>
              <Typography variant="h5" sx={{ ml: 2, mt: 2 }}>
                Discount Code
              </Typography>
              <TableContainer>
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
                  <Table>
                    <TableHead>
                      <TableRow>
                        {DISCOUNT_TABLE_HEAD.map((headCell) => (
                          <TableCell key={headCell.label} align={headCell.align}>
                            {headCell.label}
                          </TableCell>
                        ))}
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {discounts.map((row, index) => (
                        <TableRow hover tabIndex={-1} key={index}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell align="left">{row.code}</TableCell>
                          <TableCell align="right">{fCurrency(row.value)}</TableCell>
                          <TableCell align="right">
                            {dateFormat(row.expiredDate, 'dd/mm/yyyy')}
                          </TableCell>
                          <TableCell align="right">
                            <DiscountTableButton />
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                )}
              </TableContainer>
            </Card>
          </Grid>
          <Grid item xs={6}>
            <Card>
              <Typography variant="h5" sx={{ ml: 2, mt: 2 }}>
                Sale Products
              </Typography>
              <TableContainer>
                <Table>
                  <TableHead>
                    <TableRow>
                      {SALE_TABLE_HEAD.map((headCell) => (
                        <TableCell key={headCell.label} align={headCell.align}>
                          {headCell.label}
                        </TableCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {sale.map((row, index) => (
                      <TableRow hover tabIndex={-1} key={index}>
                        <TableCell component="th" scope="row">
                          <Stack direction="row" alignItems="center" spacing={1}>
                            <Avatar alt={row.name} src={row.imageUrl} />
                            <Typography variant="subtitle2" noWrap>
                              {row.name}
                            </Typography>
                          </Stack>
                        </TableCell>
                        <TableCell align="right">{fCurrency(row.original)}</TableCell>
                        <TableCell align="right">{row.sale}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
              </TableContainer>
            </Card>
          </Grid>
        </Stack>
      </Container>
    </Page>
  );
}
