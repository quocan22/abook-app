import { useState, useEffect } from 'react';
import { filter } from 'lodash';
// material
import { Button, Container, Stack, Typography } from '@mui/material';
import { Icon } from '@iconify/react';
import bookFill from '@iconify/icons-eva/book-fill';
import layersFill from '@iconify/icons-eva/layers-fill';
import { toast } from 'react-toastify';
// components
import Page from '../components/Page';
import SearchNotFound from '../components/SearchNotFound';
import {
  ProductList,
  ProductSearchBar,
  CategoryDialog,
  AddBookDialog
} from '../components/_dashboard/products';
//
import BookService from '../services/BookService';

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
  const [openCateDialog, setOpenCateDialog] = useState(false);

  const [productChange, setProductChange] = useState(false);
  const [cateChange, setCateChange] = useState(false);

  useEffect(() => {
    BookService.getAllBooks()
      .then((res) => setBooks(res.data.data))
      .catch((err) => err.response.data.msg && toast.error(err.response.data.msg));
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

  const handleCloseCateDialog = () => {
    setOpenCateDialog(false);
  };

  const onProductChange = () => {
    setProductChange(!productChange);
  };

  const onCateChange = () => {
    setCateChange(!cateChange);
  };

  const filteredBooks = applyFilter(books, filterName, filterCate);

  const isBookNotFound = filteredBooks.length === 0;

  return (
    <Page title="Product Management | ABook">
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="space-between">
          <Typography variant="h4" gutterBottom>
            Products
          </Typography>
          <Stack direction="row" spacing={1}>
            <Button
              variant="contained"
              startIcon={<Icon icon={bookFill} />}
              onClick={() => setOpenAddDialog(true)}
            >
              Add New Book
            </Button>
            <Button
              variant="contained"
              color="secondary"
              startIcon={<Icon icon={layersFill} />}
              onClick={() => setOpenCateDialog(true)}
            >
              Category Management
            </Button>
          </Stack>
        </Stack>

        <AddBookDialog
          open={openAddDialog}
          handleClose={handleCloseAddDialog}
          onChange={onProductChange}
        />

        <CategoryDialog
          open={openCateDialog}
          handleClose={handleCloseCateDialog}
          onChange={onCateChange}
        />

        <ProductSearchBar
          filterName={filterName}
          onFilterName={handleFilterByName}
          filterCate={filterCate}
          onFilterCate={handleFilterByCate}
          change={cateChange}
        />

        {isBookNotFound && <SearchNotFound searchQuery={filterName} />}

        <ProductList products={filteredBooks} onChange={onProductChange} />
      </Container>
    </Page>
  );
}
