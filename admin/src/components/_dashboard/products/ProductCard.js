import { useState } from 'react';
import PropTypes from 'prop-types';
// material
import { Box, Card, Typography, Stack, Rating, Zoom, Tooltip } from '@mui/material';
import { styled } from '@mui/material/styles';
// utils
import { fCurrency } from '../../../utils/formatNumber';
//
import Label from '../../Label';
import { ProductMoreMenu, EditDialog } from '.';

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
  product: PropTypes.object,
  onChange: PropTypes.func
};

export default function ProductCard({ product, onChange }) {
  const { _id, name, author, imageUrl, price, quantity, avgRate, isAvailable } = product;

  const [onPreview, setOnPreview] = useState(false);

  const [openEditDialog, setOpenEditDialog] = useState(false);

  const handleCloseEditDialog = () => {
    setOpenEditDialog(false);
  };

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
              <Typography variant="subtitle1">Author:&nbsp;{author}</Typography>
              <Typography variant="subtitle1">Price:&nbsp;{fCurrency(price)}&#8363;</Typography>
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
            <Tooltip title={<h2>{name}</h2>}>
              <Typography sx={{ maxWidth: 150 }} variant="subtitle1" noWrap>
                {name}
              </Typography>
            </Tooltip>
            <Rating readOnly value={avgRate} />
          </Stack>
          <ProductMoreMenu id={_id} handleEditClick={handleEditClick} />
        </Stack>
      </Stack>

      <EditDialog
        open={openEditDialog}
        handleClose={handleCloseEditDialog}
        product={product}
        onChange={onChange}
      />
    </Card>
  );
}
