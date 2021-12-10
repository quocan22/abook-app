import { useState } from 'react';
import PropTypes from 'prop-types';
// material
import { Box, Card, Typography, Stack, Rating, Dialog, Zoom } from '@mui/material';
import { styled } from '@mui/material/styles';
// utils
import { fCurrency } from '../../../utils/formatNumber';
//
import Label from '../../Label';
import { ProductMoreMenu } from '.';

// ----------------------------------------------------------------------

const ProductImgStyle = styled('img')({
  top: 0,
  width: '100%',
  height: '100%',
  objectFit: 'cover',
  position: 'absolute'
});

// ----------------------------------------------------------------------

ProductCard.propTypes = {
  product: PropTypes.object
};

export default function ProductCard({ product }) {
  const { _id, name, imageUrl, price, quantity, priceSale, avgRate, isAvailable } = product;

  const [onPreview, setOnPreview] = useState(false);
  const [openEditDialog, setOpenEditDialog] = useState(false);

  const handleEditClick = () => {
    setOpenEditDialog(true);
  };

  return (
    <Card
      onMouseEnter={() => setOnPreview(true)}
      onBlur={() => setOnPreview(false)}
      onMouseLeave={() => setOnPreview(false)}
    >
      <Box
        sx={{
          pt: '100%',
          position: 'relative',
          backgroundColor: 'primary.lighter'
        }}
      >
        {onPreview ? (
          <Zoom in={onPreview}>
            <Box sx={{ position: 'absolute', top: 30, left: 30 }}>
              <Typography variant="subtitle1">
                Price:&nbsp;{fCurrency(price)}&#8363;&nbsp;
                <Typography
                  component="span"
                  variant="body1"
                  sx={{
                    color: 'text.disabled',
                    textDecoration: 'line-through'
                  }}
                >
                  {priceSale && fCurrency(priceSale)}
                </Typography>
              </Typography>
              <Typography variant="subtitle1">Quantity:&nbsp;{quantity}</Typography>
              <Label variant="filled" color={(isAvailable && 'secondary') || 'error'}>
                {(isAvailable && 'Available') || 'Not Available'}
              </Label>
            </Box>
          </Zoom>
        ) : (
          <ProductImgStyle alt={name} src={imageUrl} />
        )}
      </Box>

      <Stack spacing={2} sx={{ p: 3 }}>
        <Stack direction="row" alignItems="center" justifyContent="space-between">
          <Stack>
            <Typography variant="subtitle1" noWrap>
              {name}
            </Typography>
            <Rating readOnly value={avgRate} />
          </Stack>
          <ProductMoreMenu handleEditClick={handleEditClick} />
        </Stack>
      </Stack>
      <Dialog open={openEditDialog} onClose={() => setOpenEditDialog(false)}>
        <Typography variant="subtitle2">
          Price:&nbsp;{fCurrency(price)}&#8363;&nbsp;
          <Typography
            component="span"
            variant="body1"
            sx={{
              color: 'text.disabled',
              textDecoration: 'line-through'
            }}
          >
            {priceSale && fCurrency(priceSale)}
          </Typography>
        </Typography>
        <Typography variant="subtitle1">
          {_id}: {name}
        </Typography>
      </Dialog>
    </Card>
  );
}
