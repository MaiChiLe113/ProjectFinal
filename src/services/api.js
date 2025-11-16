/**
 * API Service for ComSwin Frontend
 * Axios-based API client for backend communication
 */

import axios from 'axios';

// Create axios instance with base configuration
const api = axios.create({
  baseURL: 'http://localhost:8000/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - add auth token if available
api.interceptors.request.use(
  (config) => {
    // Get token from localStorage (if using JWT auth)
    const token = localStorage.getItem('auth_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor - handle errors globally
api.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => {
    // Handle common errors
    if (error.response) {
      // Server responded with error status
      const status = error.response.status;
      const message = error.response.data?.detail || 'An error occurred';

      if (status === 401) {
        // Unauthorized - redirect to login
        localStorage.removeItem('auth_token');
        window.location.href = '/login';
      } else if (status === 404) {
        console.error('Resource not found:', message);
      } else if (status >= 500) {
        console.error('Server error:', message);
      }
    } else if (error.request) {
      // Request made but no response
      console.error('Network error: No response from server');
    } else {
      // Error in request setup
      console.error('Request error:', error.message);
    }

    return Promise.reject(error);
  }
);

// ============================================================================
// AUTH API
// ============================================================================

export const authAPI = {
  login: (email, password) => {
    return api.post('/auth/login', { email, password });
  },

  register: (userData) => {
    return api.post('/auth/register', userData);
  },

  logout: () => {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('user');
  },
};

// ============================================================================
// COMPETITIONS API
// ============================================================================

export const competitionsAPI = {
  getAll: (params = {}) => {
    return api.get('/competitions', { params });
  },

  getById: (id) => {
    return api.get(`/competitions/${id}`);
  },

  join: (competitionId, userId) => {
    return api.post(`/competitions/${competitionId}/join`, { user_id: userId });
  },

  create: (competitionData) => {
    return api.post('/competitions', competitionData);
  },
};

// ============================================================================
// PROJECTS API
// ============================================================================

export const projectsAPI = {
  getAll: (params = {}) => {
    return api.get('/projects', { params });
  },

  getById: (id) => {
    return api.get(`/projects/${id}`);
  },

  create: (projectData) => {
    // Create FormData for file upload
    const formData = new FormData();

    // Append all project fields
    Object.keys(projectData).forEach((key) => {
      if (key === 'tryItOutLinks') {
        // Send as JSON string
        formData.append('try_it_out_links', JSON.stringify(projectData[key]));
      } else if (key === 'thumbnail' && projectData[key]) {
        // Append file
        formData.append('thumbnail', projectData[key]);
      } else if (projectData[key] !== null && projectData[key] !== undefined) {
        formData.append(key, projectData[key]);
      }
    });

    return api.post('/projects', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
  },

  vote: (projectId, userId) => {
    return api.post(`/projects/${projectId}/vote`, { user_id: userId });
  },

  addComment: (projectId, userId, comment) => {
    return api.post(`/projects/${projectId}/comments`, {
      project_id: projectId,
      user_id: userId,
      comment,
    });
  },
};

// ============================================================================
// NEWS API
// ============================================================================

export const newsAPI = {
  getAll: (params = {}) => {
    return api.get('/news', { params });
  },

  getById: (id) => {
    return api.get(`/news/${id}`);
  },
};

// ============================================================================
// HEALTH CHECK
// ============================================================================

export const healthAPI = {
  check: () => {
    return api.get('/health');
  },
};
export default api;
