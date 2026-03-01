import apiClient from '../client';
import type { ApiResponse } from '@/types/api';
import type { AuthResponse } from '@/types/models';

export interface LoginCredentials {
  email: string;
  password: string;
}

export const authApi = {
  login: async (credentials: LoginCredentials) => {
    const response = await apiClient.post<ApiResponse<AuthResponse>>(
      '/v1/auth/login',
      credentials
    );
    return response.data;
  },

  logout: async () => {
    const response = await apiClient.post<ApiResponse<null>>('/v1/auth/logout');
    return response.data;
  },

  refresh: async () => {
    const response = await apiClient.post<ApiResponse<AuthResponse>>(
      '/v1/auth/refresh'
    );
    return response.data;
  },

  me: async () => {
    const response = await apiClient.get<ApiResponse<AuthResponse>>(
      '/v1/users/me'
    );
    return response.data;
  },
};
