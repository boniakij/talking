# BaniTalk Admin Dashboard

Modern React + TypeScript admin dashboard for BaniTalk platform management.

## Features

- 🔐 Secure authentication (Admin/Super Admin only)
- 📊 Real-time analytics and monitoring
- 👥 User management and moderation
- 📝 Content moderation (reports queue)
- 🎁 Gift & revenue management (Super Admin)
- 🎙️ Voice room monitoring
- ⚙️ Platform settings (Super Admin)

## Tech Stack

- **React 18** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool
- **TanStack Query** - Server state management
- **Zustand** - Client state management
- **React Router** - Navigation
- **Tailwind CSS** - Styling
- **shadcn/ui** - Component library
- **Axios** - HTTP client

## Getting Started

### Prerequisites

- Node.js 18+ and npm/yarn
- BaniTalk API running on `http://localhost:8000`

### Installation

1. Install dependencies:
```bash
npm install
```

2. Copy environment variables:
```bash
cp .env.example .env.development
```

3. Update `.env.development` with your API URL:
```env
VITE_API_BASE_URL=http://localhost:8000/api
```

### Development

Start the development server:
```bash
npm run dev
```

The app will be available at `http://localhost:3000`

### Build

Build for production:
```bash
npm run build
```

Preview production build:
```bash
npm run preview
```

## Project Structure

```
frontend/
├── src/
│   ├── api/              # API client & endpoints
│   ├── components/       # Reusable components
│   │   ├── ui/          # shadcn/ui components
│   │   └── layout/      # Layout components
│   ├── features/        # Feature modules
│   │   └── auth/        # Authentication
│   ├── lib/             # Utilities
│   ├── pages/           # Page components
│   ├── routes/          # Route configuration
│   ├── styles/          # Global styles
│   └── types/           # TypeScript types
├── public/              # Static assets
└── package.json
```

## Default Credentials

For testing, use the following credentials:

**Super Admin:**
- Email: `admin@talkin.app`
- Password: `TalkinAdmin@2026!`

## Available Routes

- `/login` - Login page
- `/dashboard` - Overview dashboard
- `/users` - User management
- `/reports` - Content moderation
- `/analytics` - Platform analytics
- `/gifts` - Gift management (Super Admin)
- `/rooms` - Voice room monitoring
- `/admins` - Admin management (Super Admin)
- `/settings` - Platform settings (Super Admin)

## Role-Based Access

- **Admin**: Can access users, reports, analytics, and rooms
- **Super Admin**: Full access including gifts, admins, and settings

## Development Guidelines

### Code Style

- Use TypeScript for type safety
- Follow React best practices
- Use functional components with hooks
- Keep components small and focused
- Use Tailwind CSS for styling

### State Management

- Use TanStack Query for server state
- Use Zustand for client state (auth, UI preferences)
- Avoid prop drilling with context when needed

### API Integration

- All API calls go through `src/api/endpoints/`
- Use React Query hooks for data fetching
- Handle loading and error states

## License

MIT License - see LICENSE file for details

---

**Made with ❤️ by the BaniTalk Team**
