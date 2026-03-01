import apiClient from '../client';
import type { ApiResponse, PaginatedResponse } from '@/types/api';
import type { User } from '@/types/models';

export interface UserFilters {
  page?: number;
  per_page?: number;
  search?: string;
  status?: string;
  role?: string;
  country?: string;
}

export interface SuspendUserData {
  reason: string;
  days?: number;
}

export interface BanUserData {
  reason: string;
}

export interface WarnUserData {
  reason: string;
  details?: string;
}

export const usersApi = {
  list: async (filters: UserFilters = {}) => {
    const response = await apiClient.get<ApiResponse<PaginatedResponse<User>>>(
      '/v1/admin/users',
      { params: filters }
    );
    return response.data;
  },

  getById: async (id: number) => {
    const response = await apiClient.get<ApiResponse<User>>(
      `/v1/admin/users/${id}`
    );
    return response.data;
  },

  suspend: async (id: number, data: SuspendUserData) => {
    const response = await apiClient.post<ApiResponse<User>>(
      `/v1/admin/users/${id}/suspend`,
      data
    );
    return response.data;
  },

  ban: async (id: number, data: BanUserData) => {
    const response = await apiClient.post<ApiResponse<User>>(
      `/v1/admin/users/${id}/ban`,
      data
    );
    return response.data;
  },

  restore: async (id: number) => {
    const response = await apiClient.post<ApiResponse<User>>(
      `/v1/admin/users/${id}/restore`
    );
    return response.data;
  },

  warn: async (id: number, data: WarnUserData) => {
    const response = await apiClient.post<ApiResponse<null>>(
      `/v1/admin/users/${id}/warn`,
      data
    );
    return response.data;
  },
};
