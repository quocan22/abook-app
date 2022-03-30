import { useState, useEffect } from 'react';
import { filter } from 'lodash';
import { toast } from 'react-toastify';
import { Link } from 'react-router-dom';
// material
import { Button, Container, Stack, Typography } from '@mui/material';
import { Icon } from '@iconify/react';
import plusFill from '@iconify/icons-eva/plus-fill';
import downloadFill from '@iconify/icons-eva/download-fill';
// components
import Page from '../components/Page';
import SearchNotFound from '../components/SearchNotFound';
import { ProductList, ProductSearchBar, AddBookDialog } from '../components/_dashboard/products';
//
import { BookService } from '../services';

// ----------------------------------------------------------------------

function applyFilter(array, name, cate) {
  const stabilize = filter(
    array,
    (_book) => _book.name.toLowerCase().indexOf(name.toLowerCase()) !== -1
  );

  if (cate) {
    return stabilize.filter((_book) => _book.categoryId === cate);
  }

  return stabilize;
}

export default function Products() {
  const [books, setBooks] = useState([]);
  const [filterName, setFilterName] = useState('');
  const [filterCate, setFilterCate] = useState('');

  const [openAddDialog, setOpenAddDialog] = useState(false);

  const [productChange, setProductChange] = useState(false);

  useEffect(() => {
    BookService.getAllBooks()
      .then((res) => setBooks(res.data.data))
      .catch((err) => err.response && toast.error(err.response.data.msg));
  }, [productChange]);

  const handleFilterByName = (event) => {
    setFilterName(event.target.value);
  };

  const handleFilterByCate = (event) => {
    setFilterCate(event.target.value);
  };

  const handleCloseAddDialog = () => {
    setOpenAddDialog(false);
  };

  const onProductChange = () => {
    setProductChange(!productChange);
  };

  const filteredBooks = applyFilter(books, filterName, filterCate);

  const isBookNotFound = filteredBooks.length === 0;

  return (
    <Page title="Products Management | ABook">
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="space-between">
          <Typography variant="h4" gutterBottom>
            Products
          </Typography>
          <Stack direction="row" alignItems="center" justifyContent="flex-end">
            <Button
              sx={{ mr: 2 }}
              variant="contained"
              startIcon={<Icon icon={downloadFill} />}
              component={Link}
              to="/dashboard/book_receipt"
              color="secondary"
            >
              Receive Book
            </Button>
            <Button
              variant="contained"
              startIcon={<Icon icon={plusFill} />}
              onClick={() => setOpenAddDialog(true)}
            >
              New Book
            </Button>
          </Stack>
        </Stack>

        <AddBookDialog
          open={openAddDialog}
          handleClose={handleCloseAddDialog}
          onChange={onProductChange}
        />

        <ProductSearchBar
          filterName={filterName}
          onFilterName={handleFilterByName}
          filterCate={filterCate}
          onFilterCate={handleFilterByCate}
        />

        {isBookNotFound && <SearchNotFound searching searchQuery={filterName} />}

        <ProductList products={filteredBooks} onChange={onProductChange} />
      </Container>
    </Page>
  );
}
