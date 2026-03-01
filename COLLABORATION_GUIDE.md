# 🤝 BaniTalk - Collaboration Guide

## Setting Up Team Collaboration

This guide explains how to collaborate with team members on the BaniTalk project.

---

## 👥 Adding Collaborators to Your Repository

### Step 1: Upload Project to GitHub First

If you haven't uploaded yet, run:
```bash
upload-to-github.bat
```

Or follow the manual steps in `GITHUB_UPLOAD.md`

### Step 2: Add Collaborators

1. Go to your repository on GitHub:
   ```
   https://github.com/yourusername/banitalk
   ```

2. Click **"Settings"** tab

3. Click **"Collaborators"** in the left sidebar

4. Click **"Add people"** button

5. Enter your collaborator's GitHub username or email

6. Click **"Add [username] to this repository"**

7. They will receive an invitation email

### Step 3: Collaborator Accepts Invitation

Your collaborator needs to:
1. Check their email
2. Click the invitation link
3. Accept the invitation
4. They now have access!

---

## 🔐 Access Levels

### For Collaborators (Recommended):
- **Write access** - Can push, pull, and create branches
- Can't delete repository or change settings

### For Team Members:
- **Maintain** - Write access + manage issues/PRs
- **Admin** - Full access (be careful!)

---

## 📥 How Your Collaborator Gets Started

### 1. Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/banitalk.git
cd banitalk
```

### 2. Setup Development Environment

**Backend (API):**
```bash
cd api
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

**Frontend (Admin Dashboard):**
```bash
cd frontend
npm install
npm run dev
```

### 3. Configure Git

```bash
git config user.name "Their Name"
git config user.email "their.email@example.com"
```

---

## 🌿 Branching Strategy

### Main Branches

**`main`** - Production-ready code
- Protected branch
- Only merge via Pull Requests
- Always stable

**`develop`** - Development branch
- Latest development changes
- Merge features here first

### Feature Branches

For each new feature:
```bash
# Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/feature-name

# Work on feature
# ... make changes ...

# Commit changes
git add .
git commit -m "feat: Add feature description"

# Push to GitHub
git push -u origin feature/feature-name
```

### Branch Naming Convention

```
feature/user-authentication
feature/admin-dashboard
bugfix/login-error
hotfix/security-patch
docs/update-readme
```

---

## 🔄 Collaboration Workflow

### Daily Workflow

**1. Start Your Day:**
```bash
# Get latest changes
git checkout develop
git pull origin develop

# Create your feature branch
git checkout -b feature/your-feature
```

**2. Work on Your Feature:**
```bash
# Make changes to files
# Test your changes

# Stage changes
git add .

# Commit with clear message
git commit -m "feat: Add user profile editing"

# Push to GitHub
git push -u origin feature/your-feature
```

**3. Create Pull Request:**
1. Go to GitHub repository
2. Click "Pull requests" tab
3. Click "New pull request"
4. Select: `develop` ← `feature/your-feature`
5. Add title and description
6. Click "Create pull request"
7. Request review from team member

**4. After PR is Merged:**
```bash
# Switch back to develop
git checkout develop

# Pull latest changes
git pull origin develop

# Delete local feature branch
git branch -d feature/your-feature
```

---

## 📝 Commit Message Guidelines

### Format:
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance

### Examples:
```bash
git commit -m "feat(auth): Add Google OAuth login"
git commit -m "fix(api): Resolve CORS issue in user endpoint"
git commit -m "docs: Update installation guide"
git commit -m "refactor(dashboard): Improve user table performance"
```

---

## 🔀 Pull Request Process

### Creating a Pull Request

1. **Push your branch:**
   ```bash
   git push -u origin feature/your-feature
   ```

2. **On GitHub:**
   - Go to repository
   - Click "Pull requests"
   - Click "New pull request"
   - Select base: `develop`, compare: `feature/your-feature`
   - Fill in details:
     - Title: Clear, descriptive
     - Description: What changed and why
     - Screenshots (if UI changes)
     - Testing steps

3. **Request Review:**
   - Assign reviewers
   - Add labels (feature, bug, etc.)
   - Link related issues

### Reviewing a Pull Request

1. **Check the code:**
   - Read the changes
   - Look for bugs or issues
   - Check code quality

2. **Test locally:**
   ```bash
   git fetch origin
   git checkout feature/their-feature
   # Test the changes
   ```

3. **Leave feedback:**
   - Approve if good
   - Request changes if needed
   - Add comments on specific lines

4. **Merge:**
   - Click "Merge pull request"
   - Delete the branch after merge

---

## 🚨 Handling Conflicts

### When You Have Conflicts:

```bash
# Update your branch with latest develop
git checkout feature/your-feature
git fetch origin
git merge origin/develop

# If conflicts occur:
# 1. Open conflicted files
# 2. Look for <<<<<<< HEAD markers
# 3. Resolve conflicts manually
# 4. Remove conflict markers

# After resolving:
git add .
git commit -m "merge: Resolve conflicts with develop"
git push
```

---

## 📋 Project Structure for Collaboration

### Who Works on What

**Backend Developer:**
```
api/
├── app/Http/Controllers/    # API endpoints
├── app/Models/              # Database models
├── database/migrations/     # Database changes
└── routes/api.php          # Route definitions
```

**Frontend Developer:**
```
frontend/
├── src/components/         # UI components
├── src/pages/             # Page components
├── src/api/               # API integration
└── src/features/          # Feature modules
```

**Mobile Developer:**
```
apk/
├── lib/features/          # App features
├── lib/widgets/           # UI widgets
└── lib/services/          # API services
```

---

## 🔧 Development Best Practices

### 1. Always Pull Before Starting
```bash
git pull origin develop
```

### 2. Create Feature Branches
```bash
git checkout -b feature/your-feature
```

### 3. Commit Often
```bash
# Small, focused commits
git commit -m "feat: Add user validation"
git commit -m "feat: Add error handling"
```

### 4. Push Regularly
```bash
git push origin feature/your-feature
```

### 5. Keep Branches Updated
```bash
# Regularly merge develop into your branch
git merge origin/develop
```

### 6. Write Clear PR Descriptions
- What changed
- Why it changed
- How to test
- Screenshots (if applicable)

---

## 🛠️ Useful Git Commands

### Check Status
```bash
git status                    # See changed files
git log --oneline            # See commit history
git branch                   # List branches
git remote -v                # See remote URLs
```

### Undo Changes
```bash
git checkout -- file.txt     # Discard changes to file
git reset HEAD~1             # Undo last commit (keep changes)
git reset --hard HEAD~1      # Undo last commit (discard changes)
```

### Stash Changes
```bash
git stash                    # Save changes temporarily
git stash pop                # Restore stashed changes
git stash list               # List all stashes
```

### Update Branch
```bash
git fetch origin             # Get latest from GitHub
git pull origin develop      # Pull and merge
git rebase origin/develop    # Rebase on develop
```

---

## 📞 Communication

### Use GitHub Features:

1. **Issues** - Track bugs and features
   - Create issue for each task
   - Assign to team members
   - Use labels (bug, feature, etc.)

2. **Pull Requests** - Code review
   - Request reviews
   - Discuss changes
   - Approve/reject

3. **Discussions** - General chat
   - Ask questions
   - Share ideas
   - Plan features

4. **Projects** - Task management
   - Create project board
   - Track progress
   - Organize work

---

## 🎯 Quick Reference

### Start Working
```bash
git checkout develop
git pull origin develop
git checkout -b feature/my-feature
```

### Save Work
```bash
git add .
git commit -m "feat: Description"
git push -u origin feature/my-feature
```

### Create PR
1. Go to GitHub
2. Click "Pull requests"
3. Click "New pull request"
4. Select branches
5. Create PR

### After PR Merged
```bash
git checkout develop
git pull origin develop
git branch -d feature/my-feature
```

---

## ✅ Collaboration Checklist

### For Repository Owner:
- [ ] Upload project to GitHub
- [ ] Add collaborators
- [ ] Set up branch protection for `main`
- [ ] Create `develop` branch
- [ ] Add project description and topics
- [ ] Enable Issues
- [ ] Create initial issues for tasks

### For Collaborators:
- [ ] Accept invitation
- [ ] Clone repository
- [ ] Setup development environment
- [ ] Configure Git (name, email)
- [ ] Create feature branch
- [ ] Make first commit
- [ ] Create first PR

---

## 🎊 You're Ready to Collaborate!

**Repository Owner:** Add your team members as collaborators
**Team Members:** Clone the repo and start contributing

**Happy coding together! 🚀**

---

## 📚 Additional Resources

- **Git Basics:** https://git-scm.com/doc
- **GitHub Flow:** https://guides.github.com/introduction/flow/
- **Pull Requests:** https://docs.github.com/en/pull-requests
- **Code Review:** https://github.com/features/code-review

---

*Last Updated: March 1, 2026*
