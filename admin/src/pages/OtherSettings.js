import { useState, useEffect } from 'react';
import {
  Avatar,
  Box,
  Button,
  Card,
  Checkbox,
  CircularProgress,
  Container,
  FormControlLabel,
  Grid,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography
} from '@mui/material';
import dateFormat from 'dateformat';
import { toast } from 'react-toastify';
import { Icon } from '@iconify/react';
import plusFill from '@iconify/icons-eva/plus-fill';
import Page from '../components/Page';
import {
  DiscountMenu,
  CategoryMenu,
  AddCateDialog,
  EditCateDialog,
  DeleteCateDialog,
  AddDiscountDialog,
  EditDiscountDialog,
  DeleteDiscountDialog
} from '../components/_dashboard/others';
import { fCurrency } from '../utils/formatNumber';

import { DiscountService, CategoryService } from '../services';

const initialDiscount = {
  _id: '',
  code: '',
  value: '',
  expiredDate: ''
};

const initialCate = {
  _id: '',
  categoryName: ''
};

const DISCOUNT_TABLE_HEAD = [
  { label: 'No.', align: 'center' },
  { label: 'Code', align: 'left' },
  { label: 'Value', align: 'right' },
  { label: 'Expired Date', align: 'right' },
  { label: '', align: 'right' }
];
const CATE_TABLE_HEAD = [
  { label: 'No.', align: 'center' },
  { label: 'Category', align: 'left' },
  { label: '', align: 'right' }
];

export default function OtherSettings() {
  const [loadingDiscount, setLoadingDiscount] = useState(false);
  const [discounts, setDiscounts] = useState([]);
  const [showAvailable, setShowAvailable] = useState(false);
  const [discountChange, setDiscountChange] = useState(false);
  const [selectedDis, setSelectedDis] = useState(initialDiscount);

  const [loadingCate, setLoadingCate] = useState(false);
  const [cates, setCates] = useState([]);
  const [cateChange, setCateChange] = useState(false);
  const [selectedCate, setSelectedCate] = useState(initialCate);

  const [openAddDisDialog, setOpenAddDisDialog] = useState(false);
  const [openEditDisDialog, setOpenEditDisDialog] = useState(false);
  const [openDeleteDisDialog, setOpenDeleteDisDialog] = useState(false);

  const [openAddCateDialog, setOpenAddCateDialog] = useState(false);
  const [openEditCateDialog, setOpenEditCateDialog] = useState(false);
  const [openDeleteCateDialog, setOpenDeleteCateDialog] = useState(false);

  useEffect(() => {
    setLoadingDiscount(true);

    if (showAvailable) {
      DiscountService.getAvailableDiscounts()
        .then((res) => {
          setLoadingDiscount(false);
          setDiscounts(res.data.data);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoadingDiscount(false);
        });
    } else {
      DiscountService.getAllDiscounts()
        .then((res) => {
          setLoadingDiscount(false);
          setDiscounts(res.data.data);
        })
        .catch((err) => {
          if (err.response) toast.error(err.response.data.msg);
          setLoadingDiscount(false);
        });
    }
  }, [discountChange, showAvailable]);

  useEffect(() => {
    CategoryService.getAllCates()
      .then((res) => {
        setLoadingCate(false);
        setCates(res.data.data);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoadingCate(false);
      });
  }, [cateChange]);

  const onDiscountChange = () => {
    setDiscountChange(!discountChange);
  };

  const handleCloseAddDisDialog = () => {
    setOpenAddDisDialog(false);
  };

  const handleOpenEditDisDialog = () => {
    setOpenEditDisDialog(true);
  };

  const handleCloseEditDisDialog = () => {
    setOpenEditDisDialog(false);
  };

  const handleOpenDeleteDisDialog = () => {
    setOpenDeleteDisDialog(true);
  };

  const handleCloseDeleteDisDialog = () => {
    setOpenDeleteDisDialog(false);
  };

  const onCateChange = () => {
    setCateChange(!cateChange);
  };

  const handleCloseAddCateDialog = () => {
    setOpenAddCateDialog(false);
  };

  const handleOpenEditCateDialog = () => {
    setOpenEditCateDialog(true);
  };

  const handleCloseEditCateDialog = () => {
    setOpenEditCateDialog(false);
  };

  const handleOpenDeleteCateDialog = () => {
    setOpenDeleteCateDialog(true);
  };

  const handleCloseDeleteCateDialog = () => {
    setOpenDeleteCateDialog(false);
  };

  return (
    <Page title="Other Settings | ABook">
      <Container>
        <Typography sx={{ mb: 5 }} variant="h4" gutterBottom>
          Other Settings
        </Typography>

        <Stack direction="row" justifyContent="space-between" spacing={2}>
          <Grid item xs={7}>
            <Card>
              <Stack direction="row" alignItems="center" justifyContent="space-between" mr={2}>
                <Typography variant="h5" sx={{ ml: 3, my: 2 }}>
                  Discount Code
                </Typography>
                <Button
                  variant="contained"
                  startIcon={<Icon icon={plusFill} />}
                  onClick={() => setOpenAddDisDialog(true)}
                >
                  New Discount
                </Button>
              </Stack>
              <FormControlLabel
                sx={{ ml: 2 }}
                control={
                  <Checkbox
                    checked={showAvailable}
                    onChange={(e) => setShowAvailable(e.target.checked)}
                  />
                }
                label="Show Available Only"
              />
              <TableContainer>
                {loadingDiscount ? (
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
                ) : (
                  <Table>
                    <TableHead>
                      <TableRow>
                        {DISCOUNT_TABLE_HEAD.map((headCell) => (
                          <TableCell key={headCell.label} align={headCell.align}>
                            {headCell.label}
                          </TableCell>
                        ))}
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {discounts.map((row, index) => (
                        <TableRow hover tabIndex={-1} key={index}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell align="left">{row.code}</TableCell>
                          <TableCell align="right">{fCurrency(row.value)}&#8363;</TableCell>
                          <TableCell align="right">
                            {dateFormat(row.expiredDate, 'HH:MM - dd/mm/yyyy')}
                          </TableCell>
                          <TableCell align="right">
                            <DiscountMenu
                              discount={row}
                              setSelectedDiscount={setSelectedDis}
                              handleEditClick={handleOpenEditDisDialog}
                              handleDeleteClick={handleOpenDeleteDisDialog}
                            />
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                )}
              </TableContainer>

              <AddDiscountDialog
                open={openAddDisDialog}
                handleClose={handleCloseAddDisDialog}
                onChange={onDiscountChange}
              />

              <EditDiscountDialog
                selectedDiscount={selectedDis}
                open={openEditDisDialog}
                handleClose={handleCloseEditDisDialog}
                onChange={onDiscountChange}
              />

              <DeleteDiscountDialog
                selectedDiscount={selectedDis}
                open={openDeleteDisDialog}
                handleClose={handleCloseDeleteDisDialog}
                onChange={onDiscountChange}
              />
            </Card>
          </Grid>
          <Grid item xs={5}>
            <Card>
              <Stack direction="row" alignItems="center" justifyContent="space-between" mr={2}>
                <Typography variant="h5" sx={{ ml: 3, my: 2 }}>
                  Categories
                </Typography>
                <Button
                  variant="contained"
                  startIcon={<Icon icon={plusFill} />}
                  onClick={() => setOpenAddCateDialog(true)}
                >
                  New Category
                </Button>
              </Stack>
              <TableContainer>
                {loadingCate ? (
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
                ) : (
                  <Table>
                    <TableHead>
                      <TableRow>
                        {CATE_TABLE_HEAD.map((headCell) => (
                          <TableCell key={headCell.label} align={headCell.align}>
                            {headCell.label}
                          </TableCell>
                        ))}
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {cates.map((row, index) => (
                        <TableRow hover tabIndex={-1} key={index}>
                          <TableCell align="center">{index + 1}</TableCell>
                          <TableCell component="th" scope="row">
                            <Stack direction="row" alignItems="center" spacing={2}>
                              <Avatar alt={row.categoryName} src={row.imageUrl} />
                              <Typography variant="subtitle2" noWrap>
                                {row.categoryName}
                              </Typography>
                            </Stack>
                          </TableCell>
                          <TableCell align="right">
                            <CategoryMenu
                              cate={row}
                              setSelectedCate={setSelectedCate}
                              handleEditClick={handleOpenEditCateDialog}
                              handleDeleteClick={handleOpenDeleteCateDialog}
                            />
                          </TableCell>
                        </TableRow>
                      ))}
                    </TableBody>
                  </Table>
                )}
              </TableContainer>

              <AddCateDialog
                open={openAddCateDialog}
                handleClose={handleCloseAddCateDialog}
                onChange={onCateChange}
              />

              <EditCateDialog
                selectedCate={selectedCate}
                open={openEditCateDialog}
                handleClose={handleCloseEditCateDialog}
                onChange={onCateChange}
              />

              <DeleteCateDialog
                selectedCate={selectedCate}
                open={openDeleteCateDialog}
                handleClose={handleCloseDeleteCateDialog}
                onChange={onCateChange}
              />
            </Card>
          </Grid>
        </Stack>
      </Container>
    </Page>
  );
}
