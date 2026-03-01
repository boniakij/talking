export interface User {
  id: number;
  username: string;
  email: string;
  role: 'user' | 'admin' | 'super_admin';
  status: 'active' | 'suspended' | 'banned';
  country_code: string;
  created_at: string;
  updated_at: string;
  profile?: Profile;
}

export interface Profile {
  id: number;
  user_id: number;
  display_name: string;
  bio: string;
  avatar_url: string;
  country_code: string;
  date_of_birth: string;
  gender: string;
  is_public: boolean;
}

export interface Admin {
  id: number;
  name: string;
  username: string;
  email: string;
  role: 'admin' | 'super_admin';
  created_at: string;
}

export interface Report {
  id: number;
  reporter_id: number;
  reporter: User;
  reportable_type: 'post' | 'comment' | 'message' | 'user' | 'room';
  reportable_id: number;
  type: string;
  reason: string;
  description: string;
  status: 'pending' | 'reviewed' | 'resolved' | 'dismissed';
  admin_notes?: string;
  resolved_by?: number;
  resolved_at?: string;
  created_at: string;
}

export interface Gift {
  id: number;
  category_id: number;
  name: string;
  price_coins: number;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  icon_url: string;
  animation_url?: string;
  is_active: boolean;
  total_sent?: number;
  created_at: string;
}

export interface VoiceRoom {
  id: number;
  host_id: number;
  host: User;
  name: string;
  description: string;
  language: string;
  is_public: boolean;
  max_participants: number;
  participant_count: number;
  status: 'active' | 'closed';
  created_at: string;
}

export interface DashboardStats {
  total_users: number;
  active_users_24h: number;
  daily_active_users: number;
  monthly_active_users: number;
  open_reports: number;
  revenue_today: number;
  active_calls: number;
  active_rooms: number;
  messages_today: number;
}

export interface AnalyticsData {
  labels: string[];
  datasets: {
    label: string;
    data: number[];
  }[];
}

export interface AuthResponse {
  user: User;
  token: string;
  expires_at: string;
}
