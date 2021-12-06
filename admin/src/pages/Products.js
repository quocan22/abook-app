import { useState, useEffect } from 'react';
import { filter } from 'lodash';
// material
import { Container, Typography } from '@mui/material';
// components
import Page from '../components/Page';
import SearchNotFound from '../components/SearchNotFound';
import { ProductList, ProductSearchBar } from '../components/_dashboard/products';
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

  useEffect(() => {
    BookService.getAllBooks()
      .then((res) => setBooks(res.data.data))
      .catch((err) => console.error(err));
  }, []);

  const handleFilterByName = (event) => {
    setFilterName(event.target.value);
  };

  const handleFilterByCate = (event) => {
    setFilterCate(event.target.value);
  };

  const filteredBooks = applyFilter(books, filterName, filterCate);

  const isBookNotFound = filteredBooks.length === 0;

  return (
    <Page title="Product Management | ABook">
      <Container>
        <Typography variant="h4" sx={{ mb: 5 }}>
          Products
        </Typography>

        <ProductSearchBar
          filterName={filterName}
          onFilterName={handleFilterByName}
          filterCate={filterCate}
          onFilterCate={handleFilterByCate}
        />

        {isBookNotFound && <SearchNotFound searchQuery={filterName} />}

        <ProductList products={filteredBooks} />
      </Container>
    </Page>
  );
}
