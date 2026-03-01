# 🎯 BaniTalk Admin Dashboard - Development Plan

> **Tech Stack:** React 18 + TypeScript + Vite
> **Target:** Super Admin & Admin roles only
> **Purpose:** Platform monitoring, moderation, and management

---

## 📋 Project Overview

A modern, responsive admin dashboard for BaniTalk platform management. Only accessible to Admin and Super Admin roles with role-based access control.

### Key Features
- 🔐 Secure authentication (Admin/Super Admin only)
- 📊 Real-time analytics and monitoring
- 👥 User management and moderation
- 📝 Content moderation (reports queue)
- 🎁 Gift & revenue management (Super Admin)
- 🎙️ Voice room monitoring
- ⚙️ Platform settings (Super Admin)

---

## 🏗️ Tech Stack

### Core
- **React 18.3+** - UI framework
- **TypeScript 5.3+** - Type safety
- **Vite 5.0+** - Build tool & dev server

### State Management
- **TanStack Query (React Query) v5** - Server state & caching
- **Zustand** - Client state (auth, UI preferences)

### Routing
- **React Router v6** - Navigation & protected routes

### UI Framework
- **Tailwind CSS 3.4+** - Utility-first styling
- **shadcn/ui** - Component library (Radix UI primitives)
- **Lucide React** - Icon library

### Data Visualization
- **Recharts** - Charts and graphs
- **React Table (TanStack Table) v8** - Advanced tables

### Forms & Validation
- **React Hook Form** - Form management
- **Zod** - Schema validation

### HTTP Client
- **Axios** - API requests with interceptors

### Additional Libraries
- **date-fns** - Date manipulation
- **clsx** + **tailwind-merge** - Conditional classes
- **sonner** - Toast notifications
- **cmdk** - Command palette

---

## 📁 Project Structure

```
frontend/
├── public/
│   ├── favicon.ico
│   └── logo.svg
│
├── src/
│   ├── api/                    # API client & endpoints
│   │   ├── client.ts           # Axios instance with interceptors
│   │   ├── endpoints/
│   │   │   ├── auth.ts
│   │   │   ├── users.ts
│   │   │   ├── reports.ts
│   │   │   ├── analytics.ts
│   │   │   ├── gifts.ts
│   │   │   └── settings.ts
│   │   └── types.ts            # API response types
│   │
│   ├── components/             # Reusable components
│   │   ├── ui/                 # shadcn/ui components
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── dialog.tsx
│   │   │   ├── table.tsx
│   │   │   ├── input.tsx
│   │   │   ├── select.tsx
│   │   │   └── ...
│   │   ├── layout/
│   │   │   ├── Sidebar.tsx
│   │   │   ├── Header.tsx
│   │   │   ├── MainLayout.tsx
│   │   │   └── PageHeader.tsx
│   │   ├── charts/
│   │   │   ├── LineChart.tsx
│   │   │   ├── BarChart.tsx
│   │   │   ├── PieChart.tsx
│   │   │   └── AreaChart.tsx
│   │   └── common/
│   │       ├── DataTable.tsx
│   │       ├── StatCard.tsx
│   │       ├── LoadingSpinner.tsx
│   │       ├── ErrorBoundary.tsx
│   │       └── ProtectedRoute.tsx
│   │
│   ├── features/               # Feature-based modules
│   │   ├── auth/
│   │   │   ├── components/
│   │   │   │   ├── LoginForm.tsx
│   │   │   │   └── AuthGuard.tsx
│   │   │   ├── hooks/
│   │   │   │   └── useAuth.ts
│   │   │   ├── store/
│   │   │   │   └── authStore.ts
│   │   │   └── types.ts
│   │   │
│   │   ├── dashboard/
│   │   │   ├── components/
│   │   │   │   ├── OverviewStats.tsx
│   │   │   │   ├── ActivityChart.tsx
│   │   │   │   ├── RecentReports.tsx
│   │   │   │   └── LiveMetrics.tsx
│   │   │   └── hooks/
│   │   │       └── useDashboardData.ts
│   │   │
│   │   ├── users/
│   │   │   ├── components/
│   │   │   │   ├── UserTable.tsx
│   │   │   │   ├── UserDetail.tsx
│   │   │   │   ├── UserActions.tsx
│   │   │   │   ├── SuspendDialog.tsx
│   │   │   │   └── BanDialog.tsx
│   │   │   ├── hooks/
│   │   │   │   ├── useUsers.ts
│   │   │   │   └── useUserActions.ts
│   │   │   └── types.ts
│   │   │
│   │   ├── reports/
│   │   │   ├── components/
│   │   │   │   ├── ReportQueue.tsx
│   │   │   │   ├── ReportDetail.tsx
│   │   │   │   ├── ReportFilters.tsx
│   │   │   │   └── ResolveDialog.tsx
│   │   │   ├── hooks/
│   │   │   │   └── useReports.ts
│   │   │   └── types.ts
│   │   │
│   │   ├── analytics/
│   │   │   ├── components/
│   │   │   │   ├── UserAnalytics.tsx
│   │   │   │   ├── CallAnalytics.tsx
│   │   │   │   ├── RevenueAnalytics.tsx
│   │   │   │   └── EngagementMetrics.tsx
│   │   │   └── hooks/
│   │   │       └── useAnalytics.ts
│   │   │
│   │   ├── gifts/
│   │   │   ├── components/
│   │   │   │   ├── GiftTable.tsx
│   │   │   │   ├── GiftForm.tsx
│   │   │   │   ├── GiftPreview.tsx
│   │   │   │   └── RevenueStats.tsx
│   │   │   └── hooks/
│   │   │       └── useGifts.ts
│   │   │
│   │   ├── rooms/
│   │   │   ├── components/
│   │   │   │   ├── ActiveRooms.tsx
│   │   │   │   ├── RoomDetail.tsx
│   │   │   │   └── RoomHistory.tsx
│   │   │   └── hooks/
│   │   │       └── useRooms.ts
│   │   │
│   │   └── settings/
│   │       ├── components/
│   │       │   ├── PlatformSettings.tsx
│   │       │   ├── AdminManagement.tsx
│   │       │   ├── FeatureFlags.tsx
│   │       │   └── SystemConfig.tsx
│   │       └── hooks/
│   │           └── useSettings.ts
│   │
│   ├── hooks/                  # Global hooks
│   │   ├── useDebounce.ts
│   │   ├── useLocalStorage.ts
│   │   ├── usePermissions.ts
│   │   └── useWebSocket.ts
│   │
│   ├── lib/                    # Utilities
│   │   ├── utils.ts            # Helper functions
│   │   ├── constants.ts        # App constants
│   │   ├── formatters.ts       # Date, number formatters
│   │   └── validators.ts       # Validation schemas
│   │
│   ├── pages/                  # Page components
│   │   ├── LoginPage.tsx
│   │   ├── DashboardPage.tsx
│   │   ├── UsersPage.tsx
│   │   ├── UserDetailPage.tsx
│   │   ├── ReportsPage.tsx
│   │   ├── ReportDetailPage.tsx
│   │   ├── AnalyticsPage.tsx
│   │   ├── GiftsPage.tsx
│   │   ├── RoomsPage.tsx
│   │   ├── SettingsPage.tsx
│   │   ├── AdminsPage.tsx
│   │   └── NotFoundPage.tsx
│   │
│   ├── routes/                 # Route configuration
│   │   ├── index.tsx           # Route definitions
│   │   └── ProtectedRoute.tsx  # Auth wrapper
│   │
│   ├── styles/                 # Global styles
│   │   ├── globals.css         # Tailwind imports
│   │   └── themes.css          # Theme variables
│   │
│   ├── types/                  # TypeScript types
│   │   ├── api.ts              # API types
│   │   ├── models.ts           # Data models
│   │   └── enums.ts            # Enums
│   │
│   ├── App.tsx                 # Root component
│   ├── main.tsx                # Entry point
│   └── vite-env.d.ts           # Vite types
│
├── .env.example                # Environment variables template
├── .env.development            # Dev environment
├── .env.production             # Prod environment
├── .eslintrc.cjs               # ESLint config
├── .prettierrc                 # Prettier config
├── components.json             # shadcn/ui config
├── index.html                  # HTML template
├── package.json                # Dependencies
├── postcss.config.js           # PostCSS config
├── tailwind.config.js          # Tailwind config
├── tsconfig.json               # TypeScript config
├── tsconfig.node.json          # Node TypeScript config
└── vite.config.ts              # Vite config
```

---

## 🎨 Design System

### Color Palette
```css
/* Primary - Purple */
--primary: 262 83% 58%        /* #7C6AF7 */
--primary-foreground: 0 0% 100%

/* Background - Dark */
--background: 222 47% 11%      /* #0F1419 */
--surface: 220 26% 14%         /* #1A1F2E */
--card: 220 26% 18%            /* #222938 */

/* Text */
--foreground: 0 0% 98%         /* #FAFAFA */
--muted: 215 20% 65%           /* #9CA3AF */

/* Status Colors */
--success: 142 76% 36%         /* #16A34A */
--warning: 38 92% 50%          /* #F59E0B */
--error: 0 84% 60%             /* #EF4444 */
--info: 217 91% 60%            /* #3B82F6 */
```

### Typography
- **Font Family:** Inter (primary), JetBrains Mono (code)
- **Headings:** 600-700 weight
- **Body:** 400-500 weight

---

## 🔐 Authentication Flow

```
┌─────────────────────────────────────────────────────────┐
│                    Login Page                           │
│  Email: admin@banitalk.app                              │
│  Password: ********                                     │
│  [Login Button]                                         │
└────────────────┬────────────────────────────────────────┘
                 │
                 ▼
         POST /api/v1/auth/login
                 │
                 ├─── Success (role: admin/super_admin)
                 │    │
                 │    ├─ Store token in localStorage
                 │    ├─ Store user data in Zustand
                 │    └─ Redirect to /dashboard
                 │
                 └─── Error (role: user or invalid)
                      └─ Show error: "Admin access required"
```

### Protected Routes
- All routes except `/login` require authentication
- Super Admin routes check `user.role === 'super_admin'`
- Admin routes check `user.role === 'admin' || user.role === 'super_admin'`

---

## 📊 Dashboard Pages

### 1. Overview Dashboard (`/dashboard`)
**Access:** Admin + Super Admin

**Components:**
- **Stats Cards** (4 cards)
  - Total Users (with growth %)
  - Active Users (24h)
  - Open Reports (with alert badge)
  - Revenue Today (Super Admin only)

- **Activity Chart** (Line chart)
  - DAU/MAU over 30 days
  - Selectable metrics

- **Recent Reports** (Table)
  - Last 10 reports
  - Quick action buttons

- **Live Metrics** (Real-time)
  - Active calls
  - Active voice rooms
  - Online users

---

### 2. User Management (`/users`)
**Access:** Admin + Super Admin

**Features:**
- **User Table** with columns:
  - Avatar + Username
  - Email
  - Country
  - Status (Active/Suspended/Banned)
  - Joined Date
  - Actions

- **Filters:**
  - Search by username/email
  - Filter by status
  - Filter by country
  - Filter by role

- **Actions:**
  - View Details
  - Suspend (Admin + Super Admin)
  - Ban (Super Admin only)
  - Restore
  - Warn User

**User Detail Page (`/users/:id`):**
- Profile information
- Activity log
- Reports filed against user
- Conversations (admin view)
- Action buttons

---

### 3. Content Moderation (`/reports`)
**Access:** Admin + Super Admin

**Features:**
- **Report Queue** (Table)
  - Report ID
  - Reporter
  - Content Type (Post/Comment/User/Room)
  - Reason
  - Status (Pending/Reviewed/Resolved)
  - Date
  - Actions

- **Filters:**
  - Status filter
  - Type filter
  - Date range

- **Actions:**
  - View Details
  - Resolve
  - Dismiss

**Report Detail Page (`/reports/:id`):**
- Reporter info
- Reported content preview
- Reason & description
- Resolution form
- Action buttons (Remove content, Warn, Suspend, Ban, Dismiss)

---

### 4. Analytics (`/analytics`)
**Access:** Admin (limited) + Super Admin (full)

**Tabs:**
- **Users** (Admin + Super Admin)
  - Registration trend
  - Retention cohorts
  - Country distribution map
  - Language distribution

- **Communication** (Admin + Super Admin)
  - Messages per day
  - Calls per day
  - Average call duration
  - Active voice rooms

- **Revenue** (Super Admin only)
  - Daily revenue chart
  - Coin purchases
  - Gift transactions
  - Top spenders

- **Engagement** (Admin + Super Admin)
  - Posts per day
  - Like/comment rates
  - Match acceptance rate

---

### 5. Gift Management (`/gifts`)
**Access:** Super Admin only

**Features:**
- **Gift Table**
  - Name
  - Category
  - Price (coins)
  - Rarity
  - Status (Active/Inactive)
  - Total Sent
  - Actions

- **Actions:**
  - Create Gift
  - Edit Gift
  - Toggle Active/Inactive
  - Delete Gift

- **Gift Form:**
  - Name
  - Category dropdown
  - Price (coins)
  - Rarity (Common/Rare/Epic/Legendary)
  - Icon/Animation upload
  - Cultural tag

---

### 6. Voice Rooms (`/rooms`)
**Access:** Admin + Super Admin

**Features:**
- **Active Rooms** (Live list)
  - Room name
  - Host
  - Participants count
  - Language
  - Created time
  - Actions

- **Actions:**
  - View Details
  - Force Close (with reason)
  - Flag for Review

- **Room Detail:**
  - Host info
  - Co-hosts
  - Speakers
  - Audience list
  - Room chat (admin view)

---

### 7. Admin Management (`/admins`)
**Access:** Super Admin only

**Features:**
- **Admin Table**
  - Name
  - Username
  - Email
  - Role (Admin/Super Admin)
  - Created Date
  - Actions

- **Actions:**
  - Create Admin
  - Edit Admin
  - Remove Admin

- **Create/Edit Form:**
  - Name
  - Username
  - Email
  - Password (create only)
  - Role dropdown

---

### 8. Platform Settings (`/settings`)
**Access:** Super Admin only

**Sections:**
- **General Settings**
  - Maintenance mode toggle
  - Platform name
  - Support email

- **Feature Flags**
  - Enable/disable features
  - Voice rooms
  - Gifts
  - Matching
  - Speech learning

- **Rate Limits**
  - API rate limits
  - Message rate limits
  - Call rate limits

- **External Services**
  - TURN server config
  - Firebase FCM config
  - Translation API config
  - S3/Storage config

---

## 🔌 API Integration

### Axios Client Setup
```typescript
// src/api/client.ts
import axios from 'axios';
import { authStore } from '@/features/auth/store/authStore';

const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Request interceptor - Add auth token
apiClient.interceptors.request.use((config) => {
  const token = authStore.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor - Handle errors
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      authStore.getState().logout();
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default apiClient;
```

### API Endpoints Structure
```typescript
// src/api/endpoints/users.ts
import apiClient from '../client';
import type { User, PaginatedResponse } from '../types';

export const usersApi = {
  list: (params: {
    page?: number;
    search?: string;
    status?: string;
    role?: string;
  }) => apiClient.get<PaginatedResponse<User>>('/v1/admin/users', { params }),
  
  getById: (id: number) => 
    apiClient.get<{ data: User }>(`/v1/admin/users/${id}`),
  
  suspend: (id: number, data: { reason: string; days?: number }) =>
    apiClient.post(`/v1/admin/users/${id}/suspend`, data),
  
  ban: (id: number, data: { reason: string }) =>
    apiClient.post(`/v1/admin/users/${id}/ban`, data),
  
  restore: (id: number) =>
    apiClient.post(`/v1/admin/users/${id}/restore`),
  
  warn: (id: number, data: { reason: string; details?: string }) =>
    apiClient.post(`/v1/admin/users/${id}/warn`, data),
};
```

---

## 🎯 Development Phases

### Phase 1: Project Setup (Week 1)
- [x] Initialize Vite + React + TypeScript project
- [x] Install and configure dependencies
- [x] Setup Tailwind CSS + shadcn/ui
- [x] Configure ESLint + Prettier
- [x] Setup folder structure
- [x] Configure environment variables
- [x] Setup Axios client with interceptors

### Phase 2: Authentication (Week 1)
- [ ] Create login page UI
- [ ] Implement auth store (Zustand)
- [ ] Create auth API endpoints
- [ ] Implement login flow
- [ ] Create protected route wrapper
- [ ] Add role-based access control
- [ ] Handle token refresh

### Phase 3: Layout & Navigation (Week 2)
- [ ] Create main layout component
- [ ] Build sidebar navigation
- [ ] Create header with user menu
- [ ] Implement responsive design
- [ ] Add breadcrumbs
- [ ] Create page header component

### Phase 4: Dashboard Overview (Week 2)
- [ ] Create stats cards component
- [ ] Implement activity charts (Recharts)
- [ ] Build recent reports table
- [ ] Add live metrics (WebSocket)
- [ ] Integrate dashboard API
- [ ] Add loading states

### Phase 5: User Management (Week 3)
- [ ] Create user table with filters
- [ ] Implement pagination
- [ ] Build user detail page
- [ ] Create suspend/ban dialogs
- [ ] Add user actions
- [ ] Integrate user API endpoints

### Phase 6: Content Moderation (Week 3-4)
- [ ] Create report queue table
- [ ] Build report filters
- [ ] Create report detail page
- [ ] Implement resolve dialog
- [ ] Add content preview
- [ ] Integrate reports API

### Phase 7: Analytics (Week 4)
- [ ] Create analytics page layout
- [ ] Build user analytics charts
- [ ] Implement communication analytics
- [ ] Add revenue analytics (Super Admin)
- [ ] Create engagement metrics
- [ ] Integrate analytics API

### Phase 8: Gift Management (Week 5)
- [ ] Create gift table
- [ ] Build gift form (create/edit)
- [ ] Add gift preview
- [ ] Implement revenue stats
- [ ] Integrate gifts API
- [ ] Add image upload

### Phase 9: Voice Rooms (Week 5)
- [ ] Create active rooms list
- [ ] Build room detail page
- [ ] Add room history
- [ ] Implement force close
- [ ] Integrate rooms API

### Phase 10: Admin Management (Week 6)
- [ ] Create admin table
- [ ] Build admin form
- [ ] Implement CRUD operations
- [ ] Add role management
- [ ] Integrate admin API

### Phase 11: Platform Settings (Week 6)
- [ ] Create settings page layout
- [ ] Build feature flags UI
- [ ] Add rate limit config
- [ ] Implement external services config
- [ ] Integrate settings API

### Phase 12: Polish & Testing (Week 7)
- [ ] Add error boundaries
- [ ] Implement toast notifications
- [ ] Add loading skeletons
- [ ] Optimize performance
- [ ] Write unit tests
- [ ] E2E testing
- [ ] Accessibility audit
- [ ] Browser compatibility testing

### Phase 13: Deployment (Week 8)
- [ ] Setup CI/CD pipeline
- [ ] Configure production build
- [ ] Deploy to hosting (Vercel/Netlify)
- [ ] Setup monitoring (Sentry)
- [ ] Performance monitoring
- [ ] Documentation

---

## 📦 Dependencies

```json
{
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.22.0",
    "@tanstack/react-query": "^5.28.0",
    "zustand": "^4.5.2",
    "axios": "^1.6.7",
    "react-hook-form": "^7.51.0",
    "zod": "^3.22.4",
    "@hookform/resolvers": "^3.3.4",
    "recharts": "^2.12.2",
    "@tanstack/react-table": "^8.13.2",
    "date-fns": "^3.3.1",
    "clsx": "^2.1.0",
    "tailwind-merge": "^2.2.1",
    "lucide-react": "^0.344.0",
    "sonner": "^1.4.3",
    "cmdk": "^1.0.0"
  },
  "devDependencies": {
    "@types/react": "^18.3.1",
    "@types/react-dom": "^18.3.0",
    "@typescript-eslint/eslint-plugin": "^7.1.1",
    "@typescript-eslint/parser": "^7.1.1",
    "@vitejs/plugin-react": "^4.2.1",
    "autoprefixer": "^10.4.18",
    "eslint": "^8.57.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-react-refresh": "^0.4.5",
    "postcss": "^8.4.35",
    "prettier": "^3.2.5",
    "tailwindcss": "^3.4.1",
    "typescript": "^5.4.2",
    "vite": "^5.1.6"
  }
}
```

---

## 🔒 Security Considerations

1. **Authentication**
   - Store JWT in localStorage (or httpOnly cookie)
   - Implement token refresh mechanism
   - Auto-logout on token expiration

2. **Authorization**
   - Role-based access control (RBAC)
   - Route-level protection
   - Component-level permission checks

3. **API Security**
   - HTTPS only
   - CORS configuration
   - Rate limiting
   - Input validation

4. **XSS Protection**
   - Sanitize user inputs
   - Use React's built-in XSS protection
   - Content Security Policy headers

5. **Audit Logging**
   - Log all admin actions
   - Track IP addresses
   - Monitor suspicious activity

---

## 🚀 Performance Optimization

1. **Code Splitting**
   - Lazy load routes
   - Dynamic imports for heavy components

2. **Caching**
   - React Query caching strategy
   - Stale-while-revalidate pattern

3. **Bundle Optimization**
   - Tree shaking
   - Minification
   - Compression (gzip/brotli)

4. **Image Optimization**
   - Lazy loading images
   - WebP format
   - Responsive images

---

## 📱 Responsive Design

- **Desktop:** 1920px+ (primary target)
- **Laptop:** 1366px - 1919px
- **Tablet:** 768px - 1365px
- **Mobile:** 320px - 767px (limited support)

---

## 🧪 Testing Strategy

1. **Unit Tests** (Vitest)
   - Utility functions
   - Custom hooks
   - Store logic

2. **Component Tests** (React Testing Library)
   - UI components
   - User interactions
   - Form validation

3. **Integration Tests**
   - API integration
   - Route navigation
   - Auth flow

4. **E2E Tests** (Playwright)
   - Critical user flows
   - Admin actions
   - Report moderation

---

## 📚 Documentation

1. **README.md** - Setup instructions
2. **CONTRIBUTING.md** - Development guidelines
3. **API.md** - API integration guide
4. **DEPLOYMENT.md** - Deployment instructions
5. **CHANGELOG.md** - Version history

---

## 🎯 Success Metrics

- **Performance:** < 2s initial load time
- **Accessibility:** WCAG 2.1 AA compliance
- **Browser Support:** Chrome, Firefox, Safari, Edge (latest 2 versions)
- **Mobile Support:** Responsive down to 768px
- **Test Coverage:** > 80%

---

## 📝 Next Steps

1. Review and approve this plan
2. Setup development environment
3. Create GitHub repository
4. Initialize project with Vite
5. Start Phase 1 implementation

---

**Estimated Timeline:** 8 weeks (1 developer)
**Start Date:** TBD
**Target Launch:** TBD

---

*Last Updated: 2026-02-28*
*Maintained by: BaniTalk Development Team*
