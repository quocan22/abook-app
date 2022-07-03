import { useEffect } from 'react';
import { Navigate, useNavigate, useRoutes, useLocation } from 'react-router-dom';
// layouts
import DashboardLayout from './layouts/dashboard';
import LogoOnlyLayout from './layouts/LogoOnlyLayout';
// components
import Login from './pages/Login';
import Register from './pages/Register';
import Products from './pages/Products';
import Profile from './pages/Profile';
import Users from './pages/Users';
import Orders from './pages/Orders';
import NotFound from './pages/Page404';
import OtherSettings from './pages/OtherSettings';
import Feedbacks from './pages/Feedbacks';
import Report from './pages/Report';
import BookDetails from './pages/BookDetails';
import BookReceipt from './pages/BookReceipt';
// services
import { TokenService } from './services';

// ----------------------------------------------------------------------

export default function Router() {
  const navigate = useNavigate();
  const location = useLocation();

  useEffect(() => {
    if (!TokenService.getUser()) {
      navigate('/login', { replace: true });
    } else if (location.pathname === '/login') {
      navigate('/profile', { replace: true });
    }
  }, [navigate, location]);

  return useRoutes([
    {
      path: '/dashboard',
      element: <DashboardLayout />,
      children: [
        { path: 'profile', element: <Profile /> },
        { path: 'users', element: <Users /> },
        { path: 'products', element: <Products /> },
        { path: 'orders', element: <Orders /> },
        { path: 'other_settings', element: <OtherSettings /> },
        { path: 'feedbacks', element: <Feedbacks /> },
        { path: 'report', element: <Report /> },
        { path: 'details/:bookId', element: <BookDetails /> },
        { path: 'book_receipt', element: <BookReceipt /> }
      ]
    },
    {
      path: '/',
      element: <LogoOnlyLayout />,
      children: [
        { path: 'login', element: <Login /> },
        { path: 'register', element: <Register /> },
        { path: '404', element: <NotFound /> },
        { path: '/', element: <Navigate to="/dashboard/profile" /> },
        { path: '*', element: <Navigate to="/404" /> }
      ]
    },
    { path: '*', element: <Navigate to="/404" replace /> }
  ]);
}
