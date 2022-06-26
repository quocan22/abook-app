import { useState, useEffect } from 'react';
import { filter } from 'lodash';
import { toast } from 'react-toastify';
import { Link } from 'react-router-dom';
// material
import { Box, Button, CircularProgress, Container, Stack, Typography } from '@mui/material';
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

const ITEM_PER_PAGE = 12;

function applyFilter(array, name, cate) {
  const stabilize = filter(
    array,
    (_book) => _book.name.toLowerCase().indexOf(name.toLowerCase()) !== -1
  );

  if (cate && cate !== 'all') {
    return stabilize.filter((_book) => _book.categoryId === cate);
  }

  return stabilize;
}

export default function Products() {
  const [loading, setLoading] = useState(true);
  const [books, setBooks] = useState([]);
  const [page, setPage] = useState(1);
  const [filterName, setFilterName] = useState('');
  const [filterCate, setFilterCate] = useState('all');

  const [openAddDialog, setOpenAddDialog] = useState(false);

  const [productChange, setProductChange] = useState(false);

  useEffect(() => {
    setLoading(true);
    BookService.getAllBooks()
      .then((res) => {
        setBooks(res.data.data);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, [productChange]);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    window.scrollTo(0, 0);
  };

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
          filteredBooks={filteredBooks}
          itemPerPage={ITEM_PER_PAGE}
          page={page}
          handleChangePage={handleChangePage}
        />

        {isBookNotFound && !loading && <SearchNotFound searching searchQuery={filterName} />}

        {loading && (
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
        )}

        <ProductList
          products={filteredBooks.slice(
            (page - 1) * ITEM_PER_PAGE,
            (page - 1) * ITEM_PER_PAGE + ITEM_PER_PAGE
          )}
          onChange={onProductChange}
        />

        {/* {!loading && (
          <Pagination
            sx={{ mt: 2, mr: 0 }}
            size="large"
            color="primary"
            showFirstButton
            showLastButton
            count={parseInt(filteredBooks.length / ITEM_PER_PAGE, 10) + 1}
            page={page}
            onChange={handleChangePage}
          />
        )} */}
      </Container>
    </Page>
  );
}
