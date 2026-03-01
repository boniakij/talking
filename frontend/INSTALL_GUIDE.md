# Installation Guide - BaniTalk Admin Dashboard

## ⚠️ Prerequisites Required

You need to install Node.js before running this project.

### Step 1: Install Node.js

**Download Node.js:**
- Visit: https://nodejs.org/
- Download the **LTS version** (recommended)
- Run the installer
- Follow the installation wizard

**Verify Installation:**
After installation, open a new terminal and run:
```bash
node --version
npm --version
```

You should see version numbers like:
```
v20.x.x
10.x.x
```

---

## 🚀 Quick Start (After Node.js is Installed)

### Option 1: Using Command Line

1. **Open Terminal in the frontend folder:**
   ```bash
   cd D:\Boniyeamin\talking\frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```
   This will take 2-3 minutes to download all packages.

3. **Start development server:**
   ```bash
   npm run dev
   ```

4. **Open browser:**
   - Go to: `http://localhost:3000`
   - Login with:
     - Email: `admin@talkin.app`
     - Password: `TalkinAdmin@2026!`

### Option 2: Using the Batch Script

I've created a `start.bat` file for you. Just double-click it!

---

## 📦 What Gets Installed

When you run `npm install`, these packages will be downloaded:

**Core (Required):**
- react (18.3.1) - UI framework
- react-dom (18.3.1) - React DOM renderer
- typescript (5.4.2) - Type checking
- vite (5.1.6) - Build tool

**State Management:**
- @tanstack/react-query (5.28.0) - Server state
- zustand (4.5.2) - Client state

**Routing & Forms:**
- react-router-dom (6.22.0) - Navigation
- react-hook-form (7.51.0) - Forms
- zod (3.22.4) - Validation

**UI & Styling:**
- tailwindcss (3.4.1) - CSS framework
- lucide-react (0.344.0) - Icons
- Various Radix UI components

**HTTP & Utils:**
- axios (1.6.7) - API client
- date-fns (3.3.1) - Date utilities
- sonner (1.4.3) - Notifications

**Total Size:** ~300-400 MB (node_modules folder)

---

## 🔧 Troubleshooting

### Issue: "npm is not recognized"
**Solution:** Install Node.js from https://nodejs.org/

### Issue: "Cannot find module"
**Solution:** 
```bash
rm -rf node_modules package-lock.json
npm install
```

### Issue: Port 3000 already in use
**Solution:** 
- Stop other applications using port 3000
- Or change port in `vite.config.ts`:
```ts
server: {
  port: 3001, // Change to any available port
}
```

### Issue: API connection failed
**Solution:**
1. Make sure Laravel API is running on `http://localhost:8000`
2. Check `.env.development` has correct API URL
3. Verify CORS is configured in Laravel

---

## 📝 Available Commands

After installation, you can use these commands:

```bash
# Start development server (with hot reload)
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run linter
npm run lint

# Type check
npm run type-check
```

---

## 🌐 Accessing the Dashboard

Once the server is running:

1. **Development URL:** `http://localhost:3000`

2. **Login Credentials:**
   - Email: `admin@talkin.app`
   - Password: `TalkinAdmin@2026!`

3. **Available Pages:**
   - `/dashboard` - Overview
   - `/users` - User management
   - `/reports` - Content moderation
   - `/analytics` - Platform analytics
   - `/gifts` - Gift management (Super Admin)
   - `/rooms` - Voice rooms
   - `/admins` - Admin management (Super Admin)
   - `/settings` - Platform settings (Super Admin)

---

## 🔄 Development Workflow

1. **Make changes** to files in `src/`
2. **Save the file** - Changes appear instantly (Hot Module Replacement)
3. **Check browser** - No need to refresh!

---

## 📱 Testing on Mobile/Other Devices

1. Find your computer's IP address:
   ```bash
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., 192.168.1.100)

2. Update `vite.config.ts`:
   ```ts
   server: {
     host: '0.0.0.0',
     port: 3000,
   }
   ```

3. Access from other devices:
   ```
   http://192.168.1.100:3000
   ```

---

## 🎯 Next Steps After Installation

1. ✅ Install Node.js
2. ✅ Run `npm install`
3. ✅ Run `npm run dev`
4. ✅ Open `http://localhost:3000`
5. ✅ Login with admin credentials
6. 🎉 Start developing!

---

## 💡 Tips

- **Keep terminal open** while developing
- **Use VS Code** for best experience
- **Install extensions:**
  - ESLint
  - Prettier
  - Tailwind CSS IntelliSense
  - TypeScript Vue Plugin (Volar)

---

## 📞 Need Help?

If you encounter issues:
1. Check this guide again
2. Review `SETUP.md` for detailed info
3. Check `README.md` for features
4. Contact the development team

---

**Ready to start? Install Node.js and run `npm install`!** 🚀
