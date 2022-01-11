import { filter } from 'lodash';
import { Icon } from '@iconify/react';
import { useState, useEffect } from 'react';
import plusFill from '@iconify/icons-eva/plus-fill';
// material
import {
  Card,
  Table,
  Stack,
  Avatar,
  Button,
  TableRow,
  TableBody,
  TableCell,
  Container,
  Typography,
  TableContainer,
  TablePagination,
  Box,
  CircularProgress
} from '@mui/material';
import { toast } from 'react-toastify';
// components
import Page from '../components/Page';
import Label from '../components/Label';
import Scrollbar from '../components/Scrollbar';
import SearchNotFound from '../components/SearchNotFound';
import {
  UserListHead,
  UserListToolbar,
  UserMoreMenu,
  AddUserDialog,
  EditUserDialog
} from '../components/_dashboard/user';
import { formatString } from '../utils/formatString';
// ----------------------------------------------------------------------
import { UserService } from '../services';

const TABLE_HEAD = [
  { id: 'name', label: 'Display Name', alignRight: false },
  { id: 'email', label: 'Email', alignRight: false },
  { id: 'role', label: 'Role', alignRight: false },
  { id: 'phoneNumber', label: 'Phone Number', alignRight: false },
  { id: 'address', label: 'Address', alignRight: false },
  { id: '' }
];

// ----------------------------------------------------------------------

function descendingComparator(a, b, orderBy) {
  if (b[orderBy] < a[orderBy]) {
    return -1;
  }
  if (b[orderBy] > a[orderBy]) {
    return 1;
  }
  return 0;
}

function getComparator(order, orderBy) {
  return order === 'desc'
    ? (a, b) => descendingComparator(a, b, orderBy)
    : (a, b) => -descendingComparator(a, b, orderBy);
}

function applySortFilter(array, comparator, query) {
  const stabilizedThis = array.map((el, index) => [el, index]);
  stabilizedThis.sort((a, b) => {
    const order = comparator(a[0], b[0]);
    if (order !== 0) return order;
    return a[1] - b[1];
  });
  if (query) {
    return filter(array, (_user) => _user.email.toLowerCase().indexOf(query.toLowerCase()) !== -1);
  }
  return stabilizedThis.map((el) => el[0]);
}

export default function Users() {
  // all state
  const [page, setPage] = useState(0);
  const [order, setOrder] = useState('asc');
  const [orderBy, setOrderBy] = useState('name');
  const [filterEmail, setFilterEmail] = useState('');
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [openAddDialog, setOpenAddDialog] = useState(false);
  const [openEditDialog, setOpenEditDialog] = useState(false);

  const [loading, setLoading] = useState(true);
  const [users, setUsers] = useState([]);
  const [change, setChange] = useState(false);
  const [idOnEdit, setIdOnEdit] = useState('');

  // all effect
  useEffect(() => {
    UserService.getAllUsers()
      .then((res) => {
        setUsers(res.data.users);
        setLoading(false);
      })
      .catch((err) => {
        if (err.response) toast.error(err.response.data.msg);
        setLoading(false);
      });
  }, [change]);

  // function
  const convertRole = (role) => {
    // convert role from number to string
    // 1: user, 2: staff, 3: admin
    switch (role) {
      case 1:
        return 'User';
      case 2:
        return 'Staff';
      case 3:
        return 'Admin';
      default:
        return 'Unknown';
    }
  };

  const handleRequestSort = (event, property) => {
    const isAsc = orderBy === property && order === 'asc';
    setOrder(isAsc ? 'desc' : 'asc');
    setOrderBy(property);
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const handleFilterByEmail = (event) => {
    setFilterEmail(event.target.value);
  };

  const onChange = () => {
    setChange(!change);
  };

  const handleAddClick = () => {
    setOpenAddDialog(true);
  };

  const handleEditClick = () => {
    setOpenEditDialog(true);
  };

  const handleCloseAddDialog = () => {
    setOpenAddDialog(false);
  };

  const handleCloseEditDialog = () => {
    setIdOnEdit('');
    setOpenEditDialog(false);
  };

  const emptyRows = page > 0 ? Math.max(0, (1 + page) * rowsPerPage - users.length) : 0;

  const filteredUsers = applySortFilter(users, getComparator(order, orderBy), filterEmail);

  const isUserNotFound = filteredUsers.length === 0;

  return (
    <Page title="Users Management | ABook">
      <Container>
        <Stack direction="row" alignItems="center" justifyContent="space-between" mb={5}>
          <Typography variant="h4" gutterBottom>
            Users
          </Typography>
          <Button variant="contained" startIcon={<Icon icon={plusFill} />} onClick={handleAddClick}>
            New User
          </Button>
        </Stack>

        <AddUserDialog
          openAddDialog={openAddDialog}
          handleCloseAddDialog={handleCloseAddDialog}
          onChange={onChange}
        />

        <EditUserDialog
          idOnEdit={idOnEdit}
          openEditDialog={openEditDialog}
          handleCloseEditDialog={handleCloseEditDialog}
          onChange={onChange}
        />

        <Card>
          <UserListToolbar filterEmail={filterEmail} onFilterEmail={handleFilterByEmail} />

          <Scrollbar>
            <TableContainer sx={{ minWidth: 800 }}>
              {loading ? (
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
                  <UserListHead
                    order={order}
                    orderBy={orderBy}
                    headLabel={TABLE_HEAD}
                    onRequestSort={handleRequestSort}
                  />
                  <TableBody>
                    {filteredUsers
                      .slice(page * rowsPerPage, page * rowsPerPage + rowsPerPage)
                      .map((row) => {
                        const { _id, email, role, userClaim } = row;

                        return (
                          <TableRow hover key={_id} tabIndex={-1} role="checkbox">
                            <TableCell component="th" scope="row">
                              <Stack direction="row" alignItems="center" spacing={2}>
                                <Avatar alt={userClaim.displayName} src={userClaim.avatarUrl} />
                                <Typography variant="subtitle2" noWrap>
                                  {formatString(userClaim.displayName)}
                                </Typography>
                              </Stack>
                            </TableCell>
                            <TableCell align="left">{email}</TableCell>
                            <TableCell align="left">
                              <Label
                                variant="ghost"
                                color={
                                  (role === 1 && 'default') ||
                                  (role === 2 && 'primary') ||
                                  (role === 3 && 'secondary') ||
                                  'error'
                                }
                              >
                                {convertRole(role)}
                              </Label>
                            </TableCell>
                            <TableCell align="left">
                              {formatString(userClaim.phoneNumber)}
                            </TableCell>
                            <TableCell align="left">{formatString(userClaim.address)}</TableCell>
                            <TableCell align="right">
                              <UserMoreMenu
                                userId={_id}
                                handleEditClick={handleEditClick}
                                setIdOnEdit={setIdOnEdit}
                              />
                            </TableCell>
                          </TableRow>
                        );
                      })}
                    {emptyRows > 0 && (
                      <TableRow style={{ height: 53 * emptyRows }}>
                        <TableCell colSpan={6} />
                      </TableRow>
                    )}
                  </TableBody>
                  {isUserNotFound && (
                    <TableBody>
                      <TableRow>
                        <TableCell align="center" colSpan={6} sx={{ py: 3 }}>
                          <SearchNotFound searchQuery={filterEmail} />
                        </TableCell>
                      </TableRow>
                    </TableBody>
                  )}
                </Table>
              )}
            </TableContainer>
          </Scrollbar>

          <TablePagination
            rowsPerPageOptions={[5, 10, 25]}
            component="div"
            count={users.length}
            rowsPerPage={rowsPerPage}
            page={page}
            onPageChange={handleChangePage}
            onRowsPerPageChange={handleChangeRowsPerPage}
          />
        </Card>
      </Container>
    </Page>
  );
}
