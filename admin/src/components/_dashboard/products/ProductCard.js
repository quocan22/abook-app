import PropTypes from 'prop-types';
// material
import { Icon } from '@iconify/react';
import { Box, Card, Typography, Stack, IconButton, Rating } from '@mui/material';
import Tooltip, { tooltipClasses } from '@mui/material/Tooltip';
import moreVerticalFill from '@iconify/icons-eva/more-vertical-fill';
import { styled } from '@mui/material/styles';
// utils
import { fCurrency } from '../../../utils/formatNumber';
//
import Label from '../../Label';

// ----------------------------------------------------------------------

const ProductImgStyle = styled('img')({
  top: 0,
  width: '100%',
  height: '100%',
  objectFit: 'cover',
  position: 'absolute'
});

// ----------------------------------------------------------------------

const LightTooltip = styled(({ className, ...props }) => (
  <Tooltip {...props} classes={{ popper: className }} />
))(({ theme }) => ({
  [`& .${tooltipClasses.tooltip}`]: {
    backgroundColor: theme.palette.common.white,
    color: 'rgba(0, 0, 0, 0.87)',
    boxShadow: theme.shadows[10],
    fontSize: 11
  }
}));

ShopProductCard.propTypes = {
  product: PropTypes.object
};

export default function ShopProductCard({ product }) {
  const { name, imageUrl, price, quantity, status, priceSale, avgRate, isAvailable } = product;

  return (
    <LightTooltip
      placement="bottom-start"
      title={
        <Stack>
          <Stack direction="row" alignItems="center" justifyContent="space-between">
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
          </Stack>
          <Typography variant="subtitle2">Quantity:&nbsp;{quantity}</Typography>
          <Label variant="ghost" color={(isAvailable && 'secondary') || 'error'}>
            {(isAvailable && 'Available') || 'Not Available'}
          </Label>
        </Stack>
      }
    >
      <Card>
        <Box sx={{ pt: '100%', position: 'relative' }}>
          {status && (
            <Label
              variant="filled"
              color={(status === 'sale' && 'error') || 'info'}
              sx={{
                zIndex: 9,
                top: 16,
                right: 16,
                position: 'absolute',
                textTransform: 'uppercase'
              }}
            >
              {status}
            </Label>
          )}
          <ProductImgStyle alt={name} src={imageUrl} />
        </Box>

        <Stack spacing={2} sx={{ p: 3 }}>
          <Stack direction="row" alignItems="center" justifyContent="space-between">
            <Stack>
              <Typography variant="subtitle1" noWrap>
                {name}
              </Typography>
              <Rating readOnly value={avgRate} />
            </Stack>
            <IconButton>
              <Icon icon={moreVerticalFill} width={20} height={20} />
            </IconButton>
          </Stack>
        </Stack>
      </Card>
    </LightTooltip>
  );
}
