export const APP_NAME = import.meta.env.VITE_APP_NAME || 'BaniTalk Admin';
export const APP_VERSION = import.meta.env.VITE_APP_VERSION || '1.0.0';
export const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api';

export const USER_ROLES = {
  SUPER_ADMIN: 'super_admin',
  ADMIN: 'admin',
  USER: 'user',
} as const;

export const USER_STATUS = {
  ACTIVE: 'active',
  SUSPENDED: 'suspended',
  BANNED: 'banned',
} as const;

export const REPORT_STATUS = {
  PENDING: 'pending',
  REVIEWED: 'reviewed',
  RESOLVED: 'resolved',
  DISMISSED: 'dismissed',
} as const;

export const REPORT_TYPES = {
  SPAM: 'spam',
  HATE_SPEECH: 'hate_speech',
  HARASSMENT: 'harassment',
  SEXUAL_CONTENT: 'sexual_content',
  VIOLENCE: 'violence',
  MISINFORMATION: 'misinformation',
  OTHER: 'other',
} as const;

export const REPORTABLE_TYPES = {
  POST: 'post',
  COMMENT: 'comment',
  MESSAGE: 'message',
  USER: 'user',
  ROOM: 'room',
} as const;

export const GIFT_RARITY = {
  COMMON: 'common',
  RARE: 'rare',
  EPIC: 'epic',
  LEGENDARY: 'legendary',
} as const;

export const ANALYTICS_PERIODS = {
  DAY: 'day',
  WEEK: 'week',
  MONTH: 'month',
  YEAR: 'year',
} as const;

export const PAGINATION = {
  DEFAULT_PAGE: 1,
  DEFAULT_PER_PAGE: 20,
  PER_PAGE_OPTIONS: [10, 20, 50, 100],
} as const;
