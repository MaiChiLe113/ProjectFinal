# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ComSwin is a Vue 3 + Vite web application for a competition/event management platform targeting Swinburne students and staff. The platform allows users to browse competitions, read news, and manage participation in various academic and extracurricular events.

## Development Commands

### Start Development Server
```bash
npm run dev
```
Starts Vite dev server with hot-reload at http://localhost:5173 (default)

### Build for Production
```bash
npm run build
```
Builds optimized production bundle to `dist/` directory

### Preview Production Build
```bash
npm run preview
```
Preview the production build locally before deployment

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

### Data Management

- `competitions.json` - Competition data including organizer info, dates, participants, requirements, registration settings
- `users.json` - User accounts with roles (student/staff) and plaintext passwords (dev only)
- `projects.json` - Submitted projects with detailed information (name, pitch, about, built-with, links, images, uploader, votes)

**Note**: Currently using static JSON files imported directly into components. The Vuex modules reference API endpoints that should be provided by a backend server (typically running via XAMPP or similar):
- Auth module expects: `POST /api/login` - accepts `{ email, password }` and returns user object
- Project module expects: `POST /api/projects` - accepts FormData with project details
- Project module expects: `GET /api/projects/:id` - returns project data by ID

The frontend assumes these endpoints exist on the same origin or are configured via Vite proxy.

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

The frontend is designed to work with a backend API. The Vite dev server is configured to proxy API requests to `http://localhost:8000` (configured in `vite.config.js`).

**Expected API Endpoints:**

**Authentication:**
- `POST /api/register` - Accepts `{ first_name, last_name, email, phone, password, gender, role }`, returns user object
- `POST /api/login` - Accepts `{ email, password }`, returns user object with email, role, etc.

**Projects:**
- `POST /api/projects` - Accepts FormData with project details (name, pitch, thumbnail, images, etc.)
- `GET /api/projects/:id` - Returns project data by ID

**Current Proxy Configuration** (`vite.config.js`):
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

If your backend runs on a different port, update the `target` value in `vite.config.js`.

## Important Notes

- Currently uses static JSON files (`src/data/`) for development when backend is unavailable
- Both auth and project modules are registered and functional in the Vuex store
- SignIn/SignUp components are routed (`/signin`, `/signup`) and connected to the auth module
- Stage2 directory suggests a phased development approach - indicates work in progress
- Some routes are commented out in the router (MyCompetition, Join, Mark, MarkCompetition), indicating incomplete features
