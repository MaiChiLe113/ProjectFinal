# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ComSwin is a Vue 3 + Vite web application for a competition/event management platform targeting Swinburne students and staff. The platform allows users to browse competitions, read news, and manage participation in various academic and extracurricular events.

## Development Commands

### Frontend Development

**Start Development Server**
```bash
npm run dev
```
Starts Vite dev server with hot-reload at http://localhost:5173 (default)

**Build for Production**
```bash
npm run build
```
Builds optimized production bundle to `dist/` directory

**Preview Production Build**
```bash
npm run preview
```
Preview the production build locally before deployment

### Backend Development

**Install Backend Dependencies**
```bash
cd backend
pip install -r requirements.txt
```

**Start Backend Server**
```bash
cd backend
uvicorn main:app --reload
```
Starts FastAPI backend at http://localhost:8000 with auto-reload

### Full Stack Development Workflow

1. Start XAMPP and ensure MySQL is running
2. Open two terminal windows:
   - Terminal 1: `cd backend && uvicorn main:app --reload`
   - Terminal 2: `npm run dev`
3. Access frontend at http://localhost:5173
4. Backend API available at http://localhost:8000
5. API documentation at http://localhost:8000/docs (FastAPI auto-generated)

## Architecture

### Application Structure

The application follows a standard Vue 3 SPA architecture:

**Entry Point**: `src/main.js` initializes the Vue app with Vue Router and Vuex store

**Root Component**: `src/App.vue` provides the layout shell with Header/Footer and RouterView

**Routing**: Centralized in `src/router/index.js` using Vue Router with HTML5 history mode

**Pages Directory**: `src/pages/` contains top-level route components
- `Home.vue` - Landing page with featured competitions
- `About.vue` - Information about the platform
- `News.vue` - News listing page
- `Stage2/` - Contains competition-related pages (Competition.vue, Join.vue, Host.vue, SubmitProject.vue, PreviewProject.vue, Vote.vue, Projects.vue, DashBoard.vue)
- `Stage2/MyCompetition/` - User's competition management (Host.vue, Join.vue, MyCompetition.vue)
- Authentication pages (SignIn.vue, SignUp.vue) - Now routed at `/signin` and `/signup`

**Components Directory**: `src/components/` contains reusable UI components
- `Header.vue` - Navigation bar
- `Footer.vue` - Footer with links
- `NewsCard.vue` - News item display card
- `NewsDetail.vue` - Individual news article view
- `CompetitionCard.vue` - Competition display card
- `CompetitionDetail.vue` - Competition detail view
- `ProjectCard.vue`, `ProjectDetail.vue`, `ProjectTab.vue`, `ProjectListItem.vue` - Project-related components
- `CommunityGuidelinesModal.vue` - Modal for community guidelines

### State Management with Vuex

The app uses Vuex for state management with two modules:

**Store Setup**: `src/store/index.js` creates the Vuex store with modular structure

**Project Module**: `src/store/modules/project.js` manages project submission workflow
- State: Stores project data (name, pitch, thumbnail, about, built-with, links, images, video)
- Getters: Provide access to project data and validation status
- Mutations: Update project data fields and track timestamps
- Actions: Handle file uploads (with validation for size/type), async save/load operations, and state reset
- Namespaced module accessed via `project/` prefix
- File upload validation: max 5MB for thumbnails, accepts JPG/PNG/GIF only

**Auth Module**: `src/store/modules/auth.js` manages user authentication
- State: Stores user object and authentication status
- Getters: Provide access to current user and authentication state (`isAuthenticated`, `currentUser`, `userLastName`)
- Mutations: SET_USER and CLEAR_USER for managing auth state
- Actions: register (calls `/api/register`), login (calls `/api/login`), logout, and checkAuth (restores from localStorage)
- Uses localStorage with key `swincom_user` for session persistence
- Namespaced module accessed via `auth/` prefix
- **Note**: The auth module is registered in the main Vuex store and ready to use

**Usage Pattern**: Components dispatch actions like `this.$store.dispatch('project/updateProjectName', name)` and access data via `this.$store.getters['project/getProjectData']`

### API Service Layer

**API Client**: `src/services/api.js` provides a centralized axios-based API client for backend communication

**Structure**:
- Base configuration with `http://localhost:8000/api` endpoint
- Request interceptor for adding JWT auth tokens from localStorage
- Response interceptor for global error handling (401 redirects to login, etc.)
- Organized API modules:
  - `authAPI` - login, register, logout
  - `competitionsAPI` - getAll, getById, join, create
  - `projectsAPI` - getAll, getById, create, vote, addComment
  - `newsAPI` - getAll, getById
  - `healthAPI` - health check

**Usage Example**:
```javascript
import { competitionsAPI } from '@/services/api'

// In component
const competitions = await competitionsAPI.getAll({ limit: 10 })
```

**Note**: The Vuex auth module uses axios directly instead of this service layer. Consider migrating to use the centralized API service for consistency.

### Data Management

**Static JSON Files** (for development fallback):
- `src/data/competitions.json` - Competition data including organizer info, dates, participants, requirements, registration settings
- `src/data/users.json` - User accounts with roles (student/staff) and plaintext passwords (dev only)
- `src/data/projects.json` - Submitted projects with detailed information (name, pitch, about, built-with, links, images, uploader, votes)

**Backend Database**: Production data managed by FastAPI backend with MySQL database (XAMPP)
- Database name: `swincom`
- Default XAMPP credentials: user `root`, password empty
- Connection configured in `backend/main.py`

### Routing Structure

Routes defined in `src/router/index.js`:
- `/` → Home page
- `/about` → About page
- `/news` → News listing
- `/news/:id` → Individual news detail
- `/competitions` → Competitions listing
- `/competitions/:id` → Competition detail
- `/competitions/:id/join` → Join competition form
- `/competitions/:id/projects` → Projects in a competition
- `/competitions/:id/projects/:id` → Individual project detail
- `/submit` → Submit project form
- `/preview` → Preview project before submission
- `/host` → Host a competition
- `/mycompetition/host` → User's hosted competitions
- `/vote` → View all projects for voting
- `/signin` → Sign in page
- `/signup` → Sign up page
- `/dashboard` → User dashboard

**Note**: Some routes have commented-out entries (MyCompetition, Join, Mark, MarkCompetition) indicating incomplete features

### Styling Approach

- **Bootstrap 5.3.8**: Primary UI framework for layout and components
- **Bootstrap Icons**: Icon library for UI elements
- **Global styles**: `src/style.css` contains custom global CSS (mostly commented out default Vite styles)
- **Scoped component styles**: Most components use scoped `<style>` blocks within `.vue` files
- **Sass**: Available as dev dependency but not extensively used yet

### Key Technical Details

**Vue 3 Features Used**:
- Options API in most components (not using Composition API yet)
- Vue Router 4 for navigation
- Vuex 4 for state management (project submission and auth modules exist)

**Build Tool**: Vite 7.2.2 with `@vitejs/plugin-vue` for SFC compilation

**Dependencies**:
- `@popperjs/core` - Used by Bootstrap for positioning
- `axios` - HTTP client (imported in auth module for API calls)
- `vuejs-paginate-next` - Pagination component (loaded via CDN in index.html)
- `vuex` - State management

## Development Workflow

1. **Adding New Routes**: Update `src/router/index.js` and create corresponding page components in `src/pages/`

2. **Creating Components**: Place reusable components in `src/components/`, page-specific components can go in `src/pages/`

3. **Data Updates**: Modify JSON files in `src/data/` - note that this is temporary and should be replaced with API calls in production

4. **Using Vuex Store**:
   - **Project Module**: Access via `this.$store.getters['project/getterName']` and dispatch via `this.$store.dispatch('project/actionName', payload)`
   - **Auth Module**: Access via `this.$store.getters['auth/isAuthenticated']` and dispatch via `this.$store.dispatch('auth/login', { email, password })`
   - Both modules are namespaced, so all access requires the module prefix

5. **Styling**: Use Bootstrap utility classes first, add custom styles in component `<style>` blocks or `src/style.css` for global styles

## Backend Integration

### Technology Stack

**Backend Framework**: FastAPI (Python)
- Located in `backend/` directory
- Main entry: `backend/main.py`
- Database: MySQL via XAMPP
- CORS enabled for frontend at `http://localhost:5173`

**Frontend-Backend Communication**:
- Vite dev server proxies `/api` requests to `http://localhost:8000`
- Configured in `vite.config.js`
- Centralized API client in `src/services/api.js`

**Proxy Configuration** (`vite.config.js`):
```js
server: {
  proxy: {
    '/api': {
      target: 'http://localhost:8000',
      changeOrigin: true
    }
  }
}
```

If your backend runs on a different port, update the `target` value.

### API Endpoints

**Authentication** (`/api/auth/`):
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

**Competitions** (`/api/competitions/`):
- `GET /api/competitions` - Get all competitions (with filters)
- `GET /api/competitions/{id}` - Get competition details
- `POST /api/competitions/{id}/join` - Join a competition

**Projects** (`/api/projects/`):
- `GET /api/projects` - Get all projects (with filters)
- `GET /api/projects/{id}` - Get project details
- `POST /api/projects` - Create new project (multipart/form-data)
- `POST /api/projects/{id}/vote` - Vote for a project
- `POST /api/projects/{id}/comments` - Add comment to project

**News** (`/api/news/`):
- `GET /api/news` - Get all news (with filters)
- `GET /api/news/{id}` - Get news item

**Health Check**:
- `GET /` - API status
- `GET /api/health` - Database health check

### API Response Formats

The backend API returns data wrapped in objects rather than direct arrays:

**Competitions:**
- `GET /api/competitions?limit=N` - Returns `{ competitions: [...] }` (not a direct array)
- Each competition has nested objects for `organizer`, `dates`, `capacity`, `registration`, `location`, `images`

**Authentication:**
- `POST /api/auth/register` - Accepts `{ first_name, last_name, email, phone, password, gender, role }`, returns user object
- `POST /api/auth/login` - Accepts `{ email, password }`, returns user object with email, role, etc.

**Projects:**
- `POST /api/projects` - Accepts FormData with project details (name, pitch, thumbnail, images, etc.)
- `GET /api/projects/{id}` - Returns project data by ID

### Data Structure Compatibility

Components are built to handle **both nested (JSON) and flat (database) structures**. For example, `CompetitionCard.vue` uses helper methods to access fields like:
- `competition.images?.banner` OR `competition.banner`
- `competition.dates?.start` OR `competition.start_date`
- `competition.organizer?.name` OR `competition.organizer_name`

This dual compatibility allows the frontend to work with static JSON files during development and database APIs in production without code changes.

## Important Notes

### Development Environment

- **Dual Data Sources**: App can work with static JSON files (`src/data/`) when backend is unavailable OR with FastAPI backend
- **Database Setup**: Requires XAMPP with MySQL database named `swincom`, default credentials (user: `root`, password: empty)
- **CORS**: Backend configured to accept requests from `http://localhost:5173` only
- **Auth Storage**: Uses localStorage key `swincom_user` for session persistence, `auth_token` for JWT tokens

### Code Organization

- **Vuex Modules**: Both `auth` and `project` modules are registered and functional
- **API Layers**: Two API approaches exist:
  - Centralized: `src/services/api.js` (recommended)
  - Direct axios: Used in `auth` module (consider migrating)
- **Phased Development**: `Stage2/` directory indicates work-in-progress features
- **Incomplete Routes**: Some routes commented out in router (`MyCompetition`, `Join`, `Mark`, `MarkCompetition`)

### Component Patterns

- **Options API**: All components use Vue 3 Options API (not Composition API)
- **Defensive Rendering**: Components like `CompetitionCard.vue` include helper methods to handle both nested and flat data structures
- **Bootstrap-first**: Use Bootstrap utility classes before writing custom CSS

## Troubleshooting

### Backend Connection Issues

If frontend cannot connect to backend:

1. **Check backend is running** - Verify `uvicorn main:app --reload` is running in `backend/` directory
2. **Verify MySQL is running** - Start XAMPP and ensure MySQL service is active
3. **Check database exists** - Database `swincom` must exist in MySQL
4. **Test health endpoint** - Visit `http://localhost:8000/api/health` directly
5. **Check proxy configuration** - Ensure `vite.config.js` proxy target matches backend port (default: 8000)

### Cards/Components Not Displaying

If data from the backend API isn't displaying in components:

1. **Check API response structure** - Open browser DevTools console and look for API logs showing the data structure
2. **Verify response format** - The API should return `{ competitions: [...] }` not `[...]` directly
3. **Check component helper methods** - Components like `CompetitionCard.vue` have defensive helper methods (e.g., `getImageUrl()`, `getStatus()`) that handle multiple field naming conventions
4. **Add console.log** - Components already have debug logging in `loadCompetitions()` methods to inspect API responses

### Authentication Issues

If login/registration not working:

1. **Check localStorage** - Verify `swincom_user` key exists after successful login
2. **Verify API endpoints** - Auth module calls `/api/login` and `/api/register` (NOT `/api/auth/login`)
3. **Check CORS** - Backend must allow `http://localhost:5173` origin
4. **Inspect network tab** - Look for 401/403 errors indicating auth failures

### Content Security Policy Errors in Development

CSP errors about `'unsafe-eval'` during development are expected from Vue DevTools and Vite HMR. These won't appear in production builds and don't affect functionality.
