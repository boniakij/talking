import apiClient from '../client';
import type { ApiResponse } from '@/types/api';
import type { DashboardStats } from '@/types/models';

export const dashboardApi = {
  getStats: async () => {
    const response = await apiClient.get<ApiResponse<DashboardStats>>(
      '/v1/admin/analytics/overview'
    );
    return response.data;
  },
};
