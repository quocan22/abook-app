import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { toast } from 'react-toastify';
import {
  Autocomplete,
  Box,
  Button,
  Card,
  Container,
  IconButton,
  Paper,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TextField,
  Typography
} from '@mui/material';
import { LoadingButton } from '@mui/lab';
import { Icon } from '@iconify/react';
import arrowLeftFill from '@iconify/icons-eva/arrow-left-fill';
import plusFill from '@iconify/icons-eva/plus-fill';
import minusFill from '@iconify/icons-eva/minus-fill';

import Page from '../components/Page';
import Scrollbar from '../components/Scrollbar';
import { AddBookDialog } from '../components/_dashboard/products';
import { ClearReceiptConfirmDialog } from '../components/_dashboard/receipts';
import { resizeScaleByWidth } from '../utils/resizeImageFromCloudinary';
import { validatePrice } from '../utils/validate';
import { BookService, BookReceiptService } from '../services';

const TABLE_HEAD = [
  { id: 'index', label: 'No.', align: 'left' },
  { id: 'name', label: 'Book Name', align: 'left' },
  { id: 'price', label: 'Price (VNĐ)', align: 'right' },
  { id: 'quantity', label: 'Quantity', align: 'right' },
  { id: 'menu' }
];

const initialInvalid = {
  book: false,
  price: false,
  quantity: false
};

export default function BookReceipt() {
  const navigate = useNavigate();
  const [bookDetails, setBookDetails] = useState([]);
  const [change, setChange] = useState(false);
  const [selectedBook, setSelectedBook] = useState(null);
  const [receivePrice, setReceivePrice] = useState('');
  const [receiveQuantity, setReceiveQuantity] = useState('');
  const [invalid, setInvalid] = useState(initialInvalid);
  const [receiveList, setReceiveList] = useState([]);
  const [receiving, setReceiving] = useState(false);

  const [openAddDialog, setOpenAddDialog] = useState(false);
  const [openClearConfirmClearDialog, setOpenClearConfirmClearDialog] = useState(false);

  useEffect(() => {
    BookService.getAllBooksGeneralInfo()
      .then((res) => {
        setBookDetails(res.data.data);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
      });
  }, [change]);

  const confirmReceiveBook = () => {
    setReceiving(true);
    BookReceiptService.receiveBook({ books: receiveList })
      .then((res) => {
        setReceiving(false);
        toast.success(res.data.msg);
        setSelectedBook(null);
        setReceivePrice('');
        setReceiveQuantity('');
        setReceiveList([]);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setReceiving(false);
      });
  };

  const onChange = () => {
    setChange(!change);
  };

  const handleCloseAddDialog = () => {
    setOpenAddDialog(false);
  };

  const handleCloseClearConfirmDialog = () => {
    setOpenClearConfirmClearDialog(false);
  };

  const addBookToList = () => {
    if (!selectedBook || !validatePrice(receivePrice) || !validatePrice(receiveQuantity)) {
      setInvalid({
        book: !selectedBook,
        price: !validatePrice(receivePrice),
        quantity: !validatePrice(receiveQuantity)
      });
      return;
    }

    if (receiveList.find((ele) => ele.bookId === selectedBook._id)) {
      const tempArr = [];
      receiveList.forEach((ele) => {
        if (ele.bookId === selectedBook._id) {
          ele.price = receivePrice;
          ele.quantity = Number(ele.quantity) + Number(receiveQuantity);
        }
        tempArr.push(ele);
      });
      setReceiveList(tempArr);
    } else {
      setReceiveList([
        ...receiveList,
        {
          bookId: selectedBook._id,
          name: selectedBook.name,
          price: receivePrice,
          quantity: receiveQuantity
        }
      ]);
    }

    setSelectedBook(null);
    setReceivePrice('');
    setReceiveQuantity('');
  };

  const removeFromList = (index) => {
    const tempArr = [receiveList];
    tempArr.splice(index, 1);
    setReceiveList(tempArr);
  };

  const clearAllClick = () => {
    if (receiveList.length > 1) {
      setOpenClearConfirmClearDialog(true);
    } else {
      clearReceiptList();
    }
  };

  const clearReceiptList = () => {
    setReceiveList([]);
    handleCloseClearConfirmDialog();
  };

  const receiveListIsEmpty = receiveList.length === 0;

  return (
    <Page title="Book Receipt | ABook">
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="space-between">
          <Typography variant="h4" gutterBottom>
            Book Receipt
          </Typography>
          <Stack direction="row" alignItems="center" justifyContent="flex-end">
            <Button
              sx={{ mr: 2 }}
              variant="contained"
              startIcon={<Icon icon={plusFill} />}
              onClick={() => setOpenAddDialog(true)}
            >
              Add New Book
            </Button>
            <Button
              variant="outlined"
              startIcon={<Icon icon={arrowLeftFill} />}
              onClick={() => navigate(-1)}
            >
              Back
            </Button>
          </Stack>
        </Stack>

        <Stack sx={{ mt: 4 }} direction="row" alignItems="center" justifyContent="space-between">
          <Stack direction="row" alignItems="center" justifyContent="flex-start">
            <Autocomplete
              sx={{ width: 300, mr: 2 }}
              value={selectedBook}
              onChange={(event, newValue) => setSelectedBook(newValue)}
              options={bookDetails}
              getOptionLabel={(option) => option.name}
              autoHighlight
              renderOption={(props, option) => (
                <Box component="li" sx={{ '& > img': { mr: 2, flexShrink: 0 } }} {...props}>
                  <img
                    loading="lazy"
                    width="20"
                    src={resizeScaleByWidth(option.imageUrl, 100)}
                    alt=""
                  />
                  {option.name} - {option.author}
                </Box>
              )}
              renderInput={(params) => (
                <TextField
                  error={invalid.book}
                  helperText={invalid.book && 'Please choose a book'}
                  onFocus={() => setInvalid({ ...invalid, book: false })}
                  {...params}
                  label="Choose a book"
                  inputProps={{
                    ...params.inputProps,
                    autoComplete: 'new-password'
                  }}
                />
              )}
            />
            <TextField
              sx={{ mr: 2 }}
              variant="outlined"
              label="Price"
              type="number"
              error={invalid.price}
              helperText={invalid.price && 'Invalid price'}
              onFocus={() => setInvalid({ ...invalid, price: false })}
              value={receivePrice}
              onChange={(e) => setReceivePrice(e.target.value)}
            />
            <TextField
              sx={{ mr: 2 }}
              variant="outlined"
              label="Quantity"
              type="number"
              error={invalid.quantity}
              helperText={invalid.quantity && 'Invalid quantity'}
              onFocus={() => setInvalid({ ...invalid, quantity: false })}
              value={receiveQuantity}
              onChange={(e) => setReceiveQuantity(e.target.value)}
            />
            <Button sx={{ height: 55, paddingX: 3 }} variant="contained" onClick={addBookToList}>
              Add to list
            </Button>
          </Stack>
        </Stack>

        <AddBookDialog
          open={openAddDialog}
          handleClose={handleCloseAddDialog}
          onChange={onChange}
          addInfoOnly
        />

        <Typography variant="h5" sx={{ my: 2 }}>
          Receive List
        </Typography>

        <Card>
          <Scrollbar>
            <TableContainer sx={{ minWith: 800 }}>
              <Table>
                <TableHead>
                  <TableRow>
                    {TABLE_HEAD.map((headCell) => (
                      <TableCell key={headCell.id} align={headCell.align}>
                        {headCell.label}
                      </TableCell>
                    ))}
                  </TableRow>
                </TableHead>
                <TableBody>
                  {receiveList.map((row, index) => (
                    <TableRow hover key={index}>
                      <TableCell align="left">{index + 1}</TableCell>
                      <TableCell align="left">{row.name}</TableCell>
                      <TableCell align="right">{row.price}</TableCell>
                      <TableCell align="right">{row.quantity}</TableCell>
                      <TableCell align="right">
                        <IconButton onClick={() => removeFromList(index)}>
                          <Icon icon={minusFill} width={20} height={20} color="red" />
                        </IconButton>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
                <TableBody>
                  <TableRow>
                    {(receiveListIsEmpty && (
                      <TableCell align="center" colSpan={5}>
                        <Paper>
                          <Typography gutterBottom align="center" variant="subtitle1">
                            The Receive List Is Empty
                          </Typography>
                        </Paper>
                      </TableCell>
                    )) || (
                      <TableCell align="right" colSpan={5}>
                        <Paper>
                          <LoadingButton
                            loading={receiving}
                            loadingIndicator="Receiving..."
                            variant="contained"
                            sx={{ mr: 2 }}
                            onClick={confirmReceiveBook}
                          >
                            Confirm receipt
                          </LoadingButton>
                          <Button variant="outlined" color="error" onClick={clearAllClick}>
                            Clear All
                          </Button>
                        </Paper>
                      </TableCell>
                    )}
                  </TableRow>
                </TableBody>
              </Table>
            </TableContainer>
          </Scrollbar>
        </Card>

        <ClearReceiptConfirmDialog
          open={openClearConfirmClearDialog}
          handleClose={handleCloseClearConfirmDialog}
          confirmClear={clearReceiptList}
        />
      </Container>
    </Page>
  );
}
