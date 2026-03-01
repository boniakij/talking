import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import type { User } from '@/types/models';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isAdmin: boolean;
  isSuperAdmin: boolean;
  setAuth: (user: User, token: string) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      isAdmin: false,
      isSuperAdmin: false,

      setAuth: (user, token) => {
        localStorage.setItem('auth_token', token);
        localStorage.setItem('auth_user', JSON.stringify(user));
        set({
          user,
          token,
          isAuthenticated: true,
          isAdmin: user.role === 'admin' || user.role === 'super_admin',
          isSuperAdmin: user.role === 'super_admin',
        });
      },

      logout: () => {
        localStorage.removeItem('auth_token');
        localStorage.removeItem('auth_user');
        set({
          user: null,
          token: null,
          isAuthenticated: false,
          isAdmin: false,
          isSuperAdmin: false,
        });
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);
