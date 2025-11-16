# API Integration Guide

This guide shows how to integrate the backend API with your Vue.js frontend using the API service.

## Setup

### 1. Install Axios

```bash
npm install axios
```

### 2. Import API Service

The API service is located at `src/services/api.js` and provides organized methods for all backend endpoints.

## Usage Examples

### Authentication

```javascript
import { authAPI } from '@/services/api';

// Register new user
async function register() {
  try {
    const result = await authAPI.register({
      first_name: 'John',
      last_name: 'Doe',
      email: 'john@example.com',
      password: 'password123',
      role: 'student'
    });
    console.log('Registration successful:', result);
  } catch (error) {
    console.error('Registration failed:', error);
  }
}

// Login
async function login() {
  try {
    const result = await authAPI.login('john@example.com', 'password123');
    // Store token and user data
    localStorage.setItem('auth_token', result.token);
    localStorage.setItem('user', JSON.stringify(result.user));
    console.log('Login successful:', result.user);
  } catch (error) {
    console.error('Login failed:', error);
  }
}
```

### Competitions

```javascript
import { competitionsAPI } from '@/services/api';

// Get all competitions
async function getCompetitions() {
  try {
    const data = await competitionsAPI.getAll({
      status: 'upcoming',
      limit: 10
    });
    return data.competitions;
  } catch (error) {
    console.error('Error fetching competitions:', error);
  }
}

// Get single competition
async function getCompetition(id) {
  try {
    const competition = await competitionsAPI.getById(id);
    return competition;
  } catch (error) {
    console.error('Error fetching competition:', error);
  }
}

// Join competition
async function joinCompetition(competitionId) {
  try {
    const user = JSON.parse(localStorage.getItem('user'));
    const result = await competitionsAPI.join(competitionId, user.id);
    console.log('Joined successfully:', result);
  } catch (error) {
    console.error('Error joining competition:', error);
  }
}
```

### Projects

```javascript
import { projectsAPI } from '@/services/api';
import { useStore } from 'vuex';

// Get all projects for a competition
async function getProjectsForCompetition(competitionId) {
  try {
    const data = await projectsAPI.getAll({
      competition_id: competitionId,
      status: 'approved',
      limit: 20
    });
    return data.projects;
  } catch (error) {
    console.error('Error fetching projects:', error);
  }
}

// Get single project
async function getProject(id) {
  try {
    const project = await projectsAPI.getById(id);
    return project;
  } catch (error) {
    console.error('Error fetching project:', error);
  }
}

// Submit project (using Vuex store data)
async function submitProject() {
  const store = useStore();
  const user = JSON.parse(localStorage.getItem('user'));

  try {
    // Get project data from Vuex store
    const projectData = {
      competition_id: 1, // Get from route or props
      user_id: user.id,
      project_name: store.getters['project/getProjectName'],
      elevator_pitch: store.getters['project/getElevatorPitch'],
      about_project: store.getters['project/getAboutProject'],
      built_with: store.getters['project/getBuiltWith'],
      video_demo_link: store.getters['project/getVideoDemoLink'],
      try_it_out_links: store.getters['project/getTryItOutLinks'],
      thumbnail: store.getters['project/getThumbnail'], // File object
    };

    const result = await projectsAPI.create(projectData);
    console.log('Project submitted:', result);

    // Reset store after successful submission
    store.dispatch('project/resetProject');

    return result;
  } catch (error) {
    console.error('Error submitting project:', error);
    throw error;
  }
}

// Vote for project
async function voteForProject(projectId) {
  try {
    const user = JSON.parse(localStorage.getItem('user'));
    const result = await projectsAPI.vote(projectId, user.id);
    console.log('Vote recorded:', result);
  } catch (error) {
    console.error('Error voting:', error);
  }
}

// Add comment
async function addComment(projectId, commentText) {
  try {
    const user = JSON.parse(localStorage.getItem('user'));
    const result = await projectsAPI.addComment(projectId, user.id, commentText);
    console.log('Comment added:', result);
  } catch (error) {
    console.error('Error adding comment:', error);
  }
}
```

### News

```javascript
import { newsAPI } from '@/services/api';

// Get all news
async function getNews() {
  try {
    const news = await newsAPI.getAll({
      category: 'Competition',
      limit: 10
    });
    return news;
  } catch (error) {
    console.error('Error fetching news:', error);
  }
}

// Get single news item
async function getNewsItem(id) {
  try {
    const news = await newsAPI.getById(id);
    return news;
  } catch (error) {
    console.error('Error fetching news item:', error);
  }
}
```

## Vue Component Example

Here's a complete example of a Vue component using the API service:

```vue
<template>
  <div class="competitions-page">
    <h1>Competitions</h1>

    <div v-if="loading">Loading...</div>
    <div v-else-if="error">{{ error }}</div>
    <div v-else>
      <div v-for="competition in competitions" :key="competition.id" class="competition-card">
        <h3>{{ competition.title }}</h3>
        <p>{{ competition.description }}</p>
        <button @click="joinCompetition(competition.id)">Join</button>
      </div>
    </div>
  </div>
</template>

<script>
import { competitionsAPI } from '@/services/api';

export default {
  name: 'CompetitionsPage',
  data() {
    return {
      competitions: [],
      loading: false,
      error: null,
    };
  },
  async mounted() {
    await this.fetchCompetitions();
  },
  methods: {
    async fetchCompetitions() {
      this.loading = true;
      this.error = null;

      try {
        const data = await competitionsAPI.getAll({ status: 'upcoming' });
        this.competitions = data.competitions;
      } catch (error) {
        this.error = 'Failed to load competitions';
        console.error(error);
      } finally {
        this.loading = false;
      }
    },

    async joinCompetition(competitionId) {
      try {
        const user = JSON.parse(localStorage.getItem('user'));
        if (!user) {
          this.$router.push('/signin');
          return;
        }

        const result = await competitionsAPI.join(competitionId, user.id);
        alert(result.message);
        await this.fetchCompetitions(); // Refresh list
      } catch (error) {
        alert('Failed to join competition');
        console.error(error);
      }
    },
  },
};
</script>
```

## Composition API Example (Vue 3)

```vue
<script setup>
import { ref, onMounted } from 'vue';
import { competitionsAPI } from '@/services/api';

const competitions = ref([]);
const loading = ref(false);
const error = ref(null);

const fetchCompetitions = async () => {
  loading.value = true;
  error.value = null;

  try {
    const data = await competitionsAPI.getAll({ status: 'upcoming' });
    competitions.value = data.competitions;
  } catch (err) {
    error.value = 'Failed to load competitions';
    console.error(err);
  } finally {
    loading.value = false;
  }
};

const joinCompetition = async (competitionId) => {
  try {
    const user = JSON.parse(localStorage.getItem('user'));
    if (!user) {
      // Redirect to login
      return;
    }

    const result = await competitionsAPI.join(competitionId, user.id);
    alert(result.message);
    await fetchCompetitions();
  } catch (err) {
    alert('Failed to join competition');
    console.error(err);
  }
};

onMounted(() => {
  fetchCompetitions();
});
</script>

<template>
  <div class="competitions-page">
    <h1>Competitions</h1>

    <div v-if="loading">Loading...</div>
    <div v-else-if="error">{{ error }}</div>
    <div v-else>
      <div v-for="competition in competitions" :key="competition.id" class="competition-card">
        <h3>{{ competition.title }}</h3>
        <p>{{ competition.description }}</p>
        <button @click="joinCompetition(competition.id)">Join</button>
      </div>
    </div>
  </div>
</template>
```

## Updating Vuex Store Actions

Update `src/store/modules/project.js` to use the API service:

```javascript
import { projectsAPI } from '@/services/api';

const actions = {
  // ... other actions ...

  async saveProject({ state, commit }) {
    commit('SET_LOADING', true);
    commit('SET_ERROR', null);

    try {
      const user = JSON.parse(localStorage.getItem('user'));
      const competitionId = 1; // Get from route or state

      const projectData = {
        competition_id: competitionId,
        user_id: user.id,
        project_name: state.projectData.projectName,
        elevator_pitch: state.projectData.elevatorPitch,
        about_project: state.projectData.aboutProject,
        built_with: state.projectData.builtWith,
        video_demo_link: state.projectData.videoDemoLink,
        try_it_out_links: state.projectData.tryItOutLinks,
        thumbnail: state.projectData.thumbnail,
      };

      const result = await projectsAPI.create(projectData);
      commit('SET_LOADING', false);
      return result;
    } catch (error) {
      commit('SET_ERROR', error.message);
      commit('SET_LOADING', false);
      throw error;
    }
  },

  async loadProject({ commit }, projectId) {
    commit('SET_LOADING', true);
    commit('SET_ERROR', null);

    try {
      const project = await projectsAPI.getById(projectId);
      commit('SET_PROJECT_DATA', project);
      commit('SET_LOADING', false);
      return project;
    } catch (error) {
      commit('SET_ERROR', error.message);
      commit('SET_LOADING', false);
      throw error;
    }
  },
};
```

## Error Handling Best Practices

1. **Global Error Handling**: The API service includes interceptors for common errors
2. **Component-Level Handling**: Always use try-catch blocks
3. **User Feedback**: Show meaningful error messages to users
4. **Loading States**: Show loading indicators during API calls

```javascript
async function fetchData() {
  this.loading = true;
  this.error = null;

  try {
    const data = await competitionsAPI.getAll();
    this.competitions = data.competitions;
  } catch (error) {
    // API interceptor already logged the error
    // Just show user-friendly message
    this.error = 'Unable to load competitions. Please try again.';
  } finally {
    this.loading = false;
  }
}
```

## Testing API Connection

1. Start backend: `uvicorn main:app --reload`
2. Check health endpoint: http://localhost:8000/api/health
3. View API docs: http://localhost:8000/docs
4. Test in browser console:

```javascript
import { healthAPI } from '@/services/api';

healthAPI.check().then(result => {
  console.log('API Status:', result);
});
```
