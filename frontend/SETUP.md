# BaniTalk Admin Dashboard - Setup Guide

## Quick Start

### 1. Install Dependencies

```bash
cd frontend
npm install
```

### 2. Configure Environment

Copy the example environment file:
```bash
cp .env.example .env.development
```

Update `.env.development` with your API URL:
```env
VITE_API_BASE_URL=http://localhost:8000/api
VITE_APP_NAME=BaniTalk Admin (Dev)
VITE_APP_VERSION=1.0.0
```

### 3. Start Development Server

```bash
npm run dev
```

The application will be available at: `http://localhost:3000`

### 4. Login

Use the following credentials to login:

**Super Admin:**
- Email: `admin@talkin.app`
- Password: `TalkinAdmin@2026!`

## Project Structure

```
frontend/
├── src/
│   ├── api/                    # API client & endpoints
│   │   ├── client.ts           # Axios instance
│   │   └── endpoints/          # API endpoint functions
│   │       ├── auth.ts
│   │       ├── users.ts
│   │       └── dashboard.ts
│   │
│   ├── components/             # Reusable components
│   │   ├── ui/                 # shadcn/ui components
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── input.tsx
│   │   │   └── ...
│   │   └── layout/             # Layout components
│   │       ├── MainLayout.tsx
│   │       ├── Sidebar.tsx
│   │       └── Header.tsx
│   │
│   ├── features/               # Feature modules
│   │   └── auth/
│   │       ├── components/
│   │       │   └── LoginForm.tsx
│   │       └── store/
│   │           └── authStore.ts
│   │
│   ├── lib/                    # Utilities
│   │   ├── constants.ts
│   │   └── utils.ts
│   │
│   ├── pages/                  # Page components
│   │   ├── LoginPage.tsx
│   │   ├── DashboardPage.tsx
│   │   ├── UsersPage.tsx
│   │   ├── ReportsPage.tsx
│   │   ├── AnalyticsPage.tsx
│   │   ├── GiftsPage.tsx
│   │   ├── RoomsPage.tsx
│   │   ├── AdminsPage.tsx
│   │   └── SettingsPage.tsx
│   │
│   ├── routes/                 # Route configuration
│   │   ├── index.tsx
│   │   └── ProtectedRoute.tsx
│   │
│   ├── styles/                 # Global styles
│   │   └── globals.css
│   │
│   ├── types/                  # TypeScript types
│   │   ├── api.ts
│   │   └── models.ts
│   │
│   ├── App.tsx                 # Root component
│   └── main.tsx                # Entry point
│
├── public/                     # Static assets
├── .env.development            # Development environment
├── .env.example                # Environment template
├── package.json                # Dependencies
├── tailwind.config.js          # Tailwind configuration
├── tsconfig.json               # TypeScript configuration
└── vite.config.ts              # Vite configuration
```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint
- `npm run type-check` - Run TypeScript type checking

## Features Implemented

### ✅ Phase 1: Authentication
- Login page with form validation
- JWT token management
- Role-based access control (Admin/Super Admin)
- Protected routes
- Auto-redirect on authentication

### ✅ Phase 2: Layout & Navigation
- Responsive sidebar navigation
- Header with user menu
- Role-based menu items
- Logout functionality

### ✅ Phase 3: Dashboard
- Overview statistics cards
- Live metrics display
- System status indicators
- Recent activity feed

### ✅ Phase 4: Page Structure
- Users management page
- Reports moderation page
- Analytics page
- Gifts management page (Super Admin)
- Voice rooms monitoring page
- Admin management page (Super Admin)
- Platform settings page (Super Admin)

## Tech Stack

- **React 18.3** - UI framework
- **TypeScript 5.4** - Type safety
- **Vite 5.1** - Build tool
- **TanStack Query v5** - Server state management
- **Zustand 4.5** - Client state management
- **React Router v6** - Navigation
- **Tailwind CSS 3.4** - Styling
- **shadcn/ui** - Component library
- **Axios 1.6** - HTTP client
- **React Hook Form 7.51** - Form management
- **Zod 3.22** - Schema validation

## API Integration

The dashboard connects to the BaniTalk Laravel API at:
```
http://localhost:8000/api/v1
```

### Authentication Flow

1. User submits login credentials
2. API validates and returns JWT token
3. Token stored in localStorage
4. Token added to all subsequent requests via Axios interceptor
5. On 401 response, user is logged out and redirected to login

### API Endpoints Used

- `POST /v1/auth/login` - User login
- `POST /v1/auth/logout` - User logout
- `GET /v1/users/me` - Get current user
- `GET /v1/admin/users` - List users
- `GET /v1/admin/reports` - List reports
- `GET /v1/admin/analytics/overview` - Dashboard stats

## Role-Based Access Control

### Admin Role
Can access:
- Dashboard
- Users management
- Reports moderation
- Analytics (limited)
- Voice rooms monitoring

### Super Admin Role
Full access including:
- All Admin features
- Gift management
- Admin management
- Platform settings
- Revenue analytics

## Development Guidelines

### Adding a New Page

1. Create page component in `src/pages/`:
```tsx
// src/pages/NewPage.tsx
export function NewPage() {
  return (
    <div className="space-y-6">
      <h1 className="text-3xl font-bold">New Page</h1>
      {/* Page content */}
    </div>
  );
}
```

2. Add route in `src/routes/index.tsx`:
```tsx
{
  path: 'new-page',
  element: <NewPage />,
}
```

3. Add navigation item in `src/components/layout/Sidebar.tsx`:
```tsx
{
  title: 'New Page',
  href: '/new-page',
  icon: IconComponent,
}
```

### Adding a New API Endpoint

1. Create endpoint file in `src/api/endpoints/`:
```tsx
// src/api/endpoints/newEndpoint.ts
import apiClient from '../client';

export const newApi = {
  getData: async () => {
    const response = await apiClient.get('/v1/endpoint');
    return response.data;
  },
};
```

2. Use in component with React Query:
```tsx
import { useQuery } from '@tanstack/react-query';
import { newApi } from '@/api/endpoints/newEndpoint';

const { data, isLoading } = useQuery({
  queryKey: ['data-key'],
  queryFn: newApi.getData,
});
```

## Troubleshooting

### CORS Issues

If you encounter CORS errors, ensure your Laravel API has CORS configured:

```php
// config/cors.php
'paths' => ['api/*'],
'allowed_origins' => ['http://localhost:3000'],
```

### API Connection Failed

1. Verify API is running: `http://localhost:8000`
2. Check `.env.development` has correct API URL
3. Verify network tab in browser DevTools

### Authentication Issues

1. Clear localStorage: `localStorage.clear()`
2. Verify credentials are correct
3. Check API returns proper JWT token format

## Next Steps

### Immediate Tasks

1. ✅ Complete user table with pagination
2. ✅ Add user detail modal
3. ✅ Implement suspend/ban dialogs
4. ✅ Create reports queue table
5. ✅ Add analytics charts (Recharts)
6. ✅ Implement gift CRUD operations

### Future Enhancements

- Real-time updates via WebSocket
- Advanced filtering and search
- Export data to CSV/Excel
- Dark/Light theme toggle
- Notification system
- Activity audit logs
- Performance monitoring dashboard

## Support

For issues or questions:
- Check the main README.md
- Review API documentation in `docs/blueprint/`
- Contact the development team

---

**Happy Coding! 🚀**
