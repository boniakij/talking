import { NavLink } from 'react-router-dom';
import { useAuthStore } from '@/features/auth/store/authStore';
import { cn } from '@/lib/utils';
import {
  LayoutDashboard,
  Users,
  Flag,
  BarChart3,
  Gift,
  Radio,
  Settings,
  Shield,
} from 'lucide-react';

interface NavItem {
  title: string;
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  superAdminOnly?: boolean;
}

const navItems: NavItem[] = [
  {
    title: 'Dashboard',
    href: '/dashboard',
    icon: LayoutDashboard,
  },
  {
    title: 'Users',
    href: '/users',
    icon: Users,
  },
  {
    title: 'Reports',
    href: '/reports',
    icon: Flag,
  },
  {
    title: 'Analytics',
    href: '/analytics',
    icon: BarChart3,
  },
  {
    title: 'Gifts',
    href: '/gifts',
    icon: Gift,
    superAdminOnly: true,
  },
  {
    title: 'Voice Rooms',
    href: '/rooms',
    icon: Radio,
  },
  {
    title: 'Admins',
    href: '/admins',
    icon: Shield,
    superAdminOnly: true,
  },
  {
    title: 'Settings',
    href: '/settings',
    icon: Settings,
    superAdminOnly: true,
  },
];

export function Sidebar() {
  const isSuperAdmin = useAuthStore((state) => state.isSuperAdmin);

  const filteredNavItems = navItems.filter(
    (item) => !item.superAdminOnly || isSuperAdmin
  );

  return (
    <aside className="fixed left-0 top-0 z-40 h-screen w-64 border-r bg-card">
      <div className="flex h-full flex-col">
        {/* Logo */}
        <div className="flex h-16 items-center border-b px-6">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-primary flex items-center justify-center">
              <span className="text-lg font-bold text-primary-foreground">B</span>
            </div>
            <div>
              <h1 className="text-lg font-semibold">BaniTalk</h1>
              <p className="text-xs text-muted-foreground">Admin Panel</p>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <nav className="flex-1 space-y-1 p-4">
          {filteredNavItems.map((item) => (
            <NavLink
              key={item.href}
              to={item.href}
              className={({ isActive }) =>
                cn(
                  'flex items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
                  isActive
                    ? 'bg-primary text-primary-foreground'
                    : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
                )
              }
            >
              <item.icon className="h-5 w-5" />
              {item.title}
            </NavLink>
          ))}
        </nav>

        {/* Footer */}
        <div className="border-t p-4">
          <div className="text-xs text-muted-foreground">
            <p>Version 1.0.0</p>
            <p className="mt-1">© 2026 BaniTalk</p>
          </div>
        </div>
      </div>
    </aside>
  );
}
