import {
  Button,
  Card,
  CardMedia,
  Container,
  Rating,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography
} from '@mui/material';
import { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import dateFormat from 'dateformat';
import { Icon } from '@iconify/react';
import arrowLeftFill from '@iconify/icons-eva/arrow-left-fill';

import Page from '../components/Page';
import Label from '../components/Label';
import Scrollbar from '../components/Scrollbar';
import { fCurrency } from '../utils/formatNumber';
import { formatString } from '../utils/formatString';
import { BookService, CategoryService } from '../services';
import SearchNotFound from '../components/SearchNotFound';
import { DetailMoreMenu } from '../components/_dashboard/products';

const TABLE_HEAD = [
  { id: 'index', label: 'No.', align: 'center' },
  { id: 'displayName', label: 'Owner', align: 'left' },
  { id: 'email', label: 'Email', align: 'left' },
  { id: 'date', label: 'Date', align: 'left' },
  { id: 'rate', label: 'Rate', align: 'right' },
  { id: 'content', label: 'Content', align: 'left' },
  { id: 'menu' }
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

export default function BookDetails() {
  const { bookId } = useParams();
  const navigate = useNavigate();
  const [book, setBook] = useState([]);
  // const [change, setChange] = useState(false);

  useEffect(() => {
    BookService.getBookById(bookId)
      .then((res) => {
        setBook(res.data.data);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        navigate('/404');
      });
  }, [bookId, navigate]);

  useEffect(() => {
    if (book.categoryId) {
      CategoryService.getCateById(book.categoryId)
        .then((res) => {
          setBook({ ...book, categoryName: res.data.data.categoryName });
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
        });
    }
  }, [book]);

  const onChange = (index) => {
    book.comments.splice(index, 1);
  };

  const commentNotFound = book.comments && book.comments.length === 0;

  return (
    <Page title={`${book.name} | ABook`}>
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
          <Typography variant="h4" gutterBottom>
            Book Details
          </Typography>
          <Button
            variant="outlined"
            startIcon={<Icon icon={arrowLeftFill} />}
            onClick={() => navigate(-1)}
          >
            Back
          </Button>
        </Stack>

        <Stack direction="row">
          <Card>
            <CardMedia
              height="250"
              width="250"
              component="img"
              image={book.imageUrl}
              alt="Book image"
            />
          </Card>
          <Stack direction="column" justifyContent="space-between" ml={5}>
            <Stack direction="column">
              <Typography variant="h5">{book.name}</Typography>
              <Typography variant="h6">{book.author}</Typography>
              <Rating readOnly value={book.avgRate} />
              <Typography>{book.categoryName}</Typography>
            </Stack>
            <Stack direction="column">
              <Typography>{`Price: ${fCurrency(book.price)} VNĐ`}</Typography>
              <Typography>{`Quantity: ${book.quantity}`}</Typography>
              <Label
                variant="ghost"
                color={
                  (book.isAvailable && 'secondary') || (!book.isAvailable && 'error') || 'default'
                }
              >
                {convertIsAvailable(book.isAvailable)}
              </Label>
            </Stack>
          </Stack>
        </Stack>

        <Typography variant="h5" sx={{ mt: 2 }}>
          Comments
        </Typography>

        <Card sx={{ mt: 1 }}>
          <Scrollbar>
            <TableContainer sx={{ minWidth: 800 }}>
              <Table>
                <TableHead>
                  <TableRow>
                    {TABLE_HEAD.map((cell) => (
                      <TableCell key={cell.id} align={cell.align}>
                        {cell.label}
                      </TableCell>
                    ))}
                  </TableRow>
                </TableHead>
                <TableBody>
                  {book.comments &&
                    book.comments.map((row, index) => {
                      const { email, owner, commentDate, rate, review } = row;

                      return (
                        <TableRow hover key={index}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell align="left">{formatString(owner)}</TableCell>
                          <TableCell align="left">{email}</TableCell>
                          <TableCell align="left">
                            {dateFormat(commentDate, 'dd/mm/yyyy')}
                          </TableCell>
                          <TableCell align="right">{rate}</TableCell>
                          <TableCell align="left">{review}</TableCell>
                          <TableCell align="right">
                            <DetailMoreMenu bookId={bookId} index={index} onChange={onChange} />
                          </TableCell>
                        </TableRow>
                      );
                    })}
                </TableBody>
                {commentNotFound && (
                  <TableBody>
                    <TableRow>
                      <TableCell align="center" colSpan={6} sx={{ py: 3 }}>
                        <SearchNotFound />
                      </TableCell>
                    </TableRow>
                  </TableBody>
                )}
              </Table>
            </TableContainer>
          </Scrollbar>
        </Card>
      </Container>
    </Page>
  );
}
