import {
  Avatar,
  Card,
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
import Page from '../components/Page';
import { fCurrency } from '../utils/formatNumber';

const DISCOUNT_TABLE_HEAD = [
  { label: 'STT', align: 'center' },
  { label: 'Code', align: 'left' },
  { label: 'Value', align: 'right' },
  { label: 'Expired Date', algin: 'left' }
];
const SALE_TABLE_HEAD = [
  { label: 'Book', align: 'left' },
  { label: 'Original Price', align: 'right' },
  { label: 'Sale Price', align: 'right' }
];

const discount = [
  { code: 'CMNM', value: 50000, expiredDate: '21/01/2022' },
  { code: 'CMNM2022', value: 100000, expiredDate: '21/01/2022' },
  { code: 'MERRYCHRISTMAS', value: 200000, expiredDate: '28/12/2021' },
  { code: 'HAPPYNEWYEAR', value: 100000, expiredDate: '02/01/2022' }
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
                    {discount.map((row, index) => (
                      <TableRow key={index}>
                        <TableCell align="center">{index + 1}</TableCell>
                        <TableCell align="left">{row.code}</TableCell>
                        <TableCell align="right">{fCurrency(row.value)}</TableCell>
                        <TableCell align="left">{row.expiredDate}</TableCell>
                      </TableRow>
                    ))}
                  </TableBody>
                </Table>
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
