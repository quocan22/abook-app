import { Navigate, useRoutes } from 'react-router-dom';
// layouts
import DashboardLayout from './layouts/dashboard';
import LogoOnlyLayout from './layouts/LogoOnlyLayout';
//
import Login from './pages/Login';
import Register from './pages/Register';
import DashboardApp from './pages/DashboardApp';
import Products from './pages/Products';
import Blog from './pages/Blog';
import Users from './pages/Users';
import Orders from './pages/Orders';
import NotFound from './pages/Page404';
import OtherSettings from './pages/OtherSettings';
import Feedbacks from './pages/Feedbacks';

// ----------------------------------------------------------------------

export default function Router() {
  function handleNavigate() {
    if (!localStorage.getItem('user')) {
      return <Navigate to="/login" replace />;
    }
    return <Navigate to="/dashboard/users" replace />;
  }
  return useRoutes([
    {
      path: '/dashboard',
      element: <DashboardLayout />,
      children: [
        { element: handleNavigate() },
        { path: 'app', element: <DashboardApp /> },
        { path: 'users', element: <Users /> },
        { path: 'products', element: <Products /> },
        { path: 'orders', element: <Orders /> },
        { path: 'other_settings', element: <OtherSettings /> },
        { path: 'feedbacks', element: <Feedbacks /> },
        { path: 'report', element: <Blog /> }
      ]
    },
    {
      path: '/',
      element: <LogoOnlyLayout />,
      children: [
        { path: 'login', element: <Login /> },
        { path: 'register', element: <Register /> },
        { path: '404', element: <NotFound /> },
        { path: '/', element: <Navigate to="/dashboard" /> },
        { path: '*', element: <Navigate to="/404" /> }
      ]
    },
    { path: '*', element: <Navigate to="/404" replace /> }
  ]);
}
