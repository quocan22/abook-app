import { Icon } from '@iconify/react';
import pieChart2Fill from '@iconify/icons-eva/pie-chart-2-fill';
import peopleFill from '@iconify/icons-eva/people-fill';
import shoppingBagFill from '@iconify/icons-eva/shopping-bag-fill';
import carFill from '@iconify/icons-eva/car-fill';
import fileTextFill from '@iconify/icons-eva/file-text-fill';

// ----------------------------------------------------------------------

const getIcon = (name) => <Icon icon={name} width={22} height={22} />;

const sidebarConfig = [
  {
    title: 'Dashboard',
    path: '/dashboard/app',
    icon: getIcon(pieChart2Fill)
  },
  {
    title: 'Users',
    path: '/dashboard/users',
    icon: getIcon(peopleFill)
  },
  {
    title: 'Products',
    path: '/dashboard/products',
    icon: getIcon(shoppingBagFill)
  },
  {
    title: 'Orders',
    path: '/dashboard/orders',
    icon: getIcon(carFill)
  },
  {
    title: 'Other Settings',
    path: '/dashboard/report',
    icon: getIcon(shoppingBagFill)
  },
  {
    title: 'Report',
    path: '/dashboard/report',
    icon: getIcon(fileTextFill)
  }
];

export default sidebarConfig;
