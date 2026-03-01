import { createBrowserRouter, Navigate } from 'react-router-dom';
import { MainLayout } from '@/components/layout/MainLayout';
import { ProtectedRoute } from './ProtectedRoute';
import { LoginPage } from '@/pages/LoginPage';
import { DashboardPage } from '@/pages/DashboardPage';
import { UsersPage } from '@/pages/UsersPage';
import { ReportsPage } from '@/pages/ReportsPage';
import { AnalyticsPage } from '@/pages/AnalyticsPage';
import { GiftsPage } from '@/pages/GiftsPage';
import { RoomsPage } from '@/pages/RoomsPage';
import { AdminsPage } from '@/pages/AdminsPage';
import { SettingsPage } from '@/pages/SettingsPage';

export const router = createBrowserRouter([
  {
    path: '/login',
    element: <LoginPage />,
  },
  {
    path: '/',
    element: (
      <ProtectedRoute>
        <MainLayout />
      </ProtectedRoute>
    ),
    children: [
      {
        index: true,
        element: <Navigate to="/dashboard" replace />,
      },
      {
        path: 'dashboard',
        element: <DashboardPage />,
      },
      {
        path: 'users',
        element: <UsersPage />,
      },
      {
        path: 'reports',
        element: <ReportsPage />,
      },
      {
        path: 'analytics',
        element: <AnalyticsPage />,
      },
      {
        path: 'gifts',
        element: (
          <ProtectedRoute requireSuperAdmin>
            <GiftsPage />
          </ProtectedRoute>
        ),
      },
      {
        path: 'rooms',
        element: <RoomsPage />,
      },
      {
        path: 'admins',
        element: (
          <ProtectedRoute requireSuperAdmin>
            <AdminsPage />
          </ProtectedRoute>
        ),
      },
      {
        path: 'settings',
        element: (
          <ProtectedRoute requireSuperAdmin>
            <SettingsPage />
          </ProtectedRoute>
        ),
      },
    ],
  },
]);
