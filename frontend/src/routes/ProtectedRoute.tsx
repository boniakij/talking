import { Navigate } from 'react-router-dom';
import { useAuthStore } from '@/features/auth/store/authStore';

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireSuperAdmin?: boolean;
}

export function ProtectedRoute({
  children,
  requireSuperAdmin = false,
}: ProtectedRouteProps) {
  const { isAuthenticated, isAdmin, isSuperAdmin } = useAuthStore();

  if (!isAuthenticated || !isAdmin) {
    return <Navigate to="/login" replace />;
  }

  if (requireSuperAdmin && !isSuperAdmin) {
    return <Navigate to="/dashboard" replace />;
  }

  return <>{children}</>;
}
