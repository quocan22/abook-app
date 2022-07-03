import { Icon } from '@iconify/react';
import pieChart2Fill from '@iconify/icons-eva/pie-chart-2-fill';
import personFill from '@iconify/icons-eva/person-fill';
import peopleFill from '@iconify/icons-eva/people-fill';
import shoppingBagFill from '@iconify/icons-eva/shopping-bag-fill';
import carFill from '@iconify/icons-eva/car-fill';
import settingFill from '@iconify/icons-eva/settings-fill';
import messageFill from '@iconify/icons-eva/message-square-fill';

// ----------------------------------------------------------------------

const getIcon = (name) => <Icon icon={name} width={22} height={22} />;

const sidebarConfig = [
  // {
  //   title: 'Dashboard',
  //   path: '/dashboard/app',
  //   icon: getIcon(pieChart2Fill)
  // },
  {
    title: 'Profile',
    path: '/dashboard/profile',
    icon: getIcon(personFill)
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
    path: '/dashboard/other_settings',
    icon: getIcon(settingFill)
  },
  {
    title: 'Feedbacks',
    path: '/dashboard/feedbacks',
    icon: getIcon(messageFill)
  },
  {
    title: 'Report',
    path: '/dashboard/report',
    icon: getIcon(pieChart2Fill)
  }
];

export default sidebarConfig;
