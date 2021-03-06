import PropTypes from 'prop-types';
// material
import { Grid } from '@mui/material';
import ProductCard from './ProductCard';

// ----------------------------------------------------------------------

ProductList.propTypes = {
  products: PropTypes.array.isRequired,
  onChange: PropTypes.func
};

export default function ProductList({ products, onChange }) {
  return (
    <Grid container spacing={3}>
      {products.map((product) => (
        <Grid key={product._id} item xs={12} sm={6} md={3}>
          <ProductCard product={product} onChange={onChange} />
        </Grid>
      ))}
    </Grid>
  );
}
