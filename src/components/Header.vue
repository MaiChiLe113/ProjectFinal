<template>
  <div>
    <nav class="navbar navbar-expand-lg bg-light border-bottom sticky-top">
      <div class="container-fluid px-3 px-lg-4">
        <router-link class="navbar-brand fw-bold fs-5 me-4" to="/">SwinCom</router-link>
        
        <button 
          class="navbar-toggler" 
          type="button" 
          data-bs-toggle="collapse" 
          data-bs-target="#navbarSupportedContent" 
          aria-controls="navbarSupportedContent" 
          aria-expanded="false" 
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>

        <!-- AUTHENTICATED USER VIEW -->
        <div v-if="isAuthenticated" class="d-flex gap-2">
          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
              <!-- User Dropdown -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  User
                </a>
                <ul class="dropdown-menu dropdown-menu-end">
                  <li class="dropdown-header">
                    <span class="fw-bold">{{ currentUser.name }}</span>
                    <br>
                    <small class="text-muted">{{ currentUser.email }}</small>
                  </li>
                  <li><hr class="dropdown-divider"></li>
                  <li><router-link class="dropdown-item" to="/dashboard">Dashboard</router-link></li>
                  <li><router-link class="dropdown-item" to="/profile">My Profile</router-link></li>
                  <li><router-link class="dropdown-item" to="/settings">Settings</router-link></li>
                  <li><a class="dropdown-item" href="#" @click.prevent="handleLogout">Log Out</a></li>
                </ul>
              </li>

              <!-- Join a SwinCom -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  Join a SwinCom
                </a>
                <ul class="dropdown-menu">
                  <li><router-link class="dropdown-item" to="/competitions">Browse Competitions</router-link></li>
                  <li><router-link class="dropdown-item" to="/mycompetition/join">My SwinCom</router-link></li>
                  <li><router-link class="dropdown-item" to="/vote">Voting</router-link></li>
                </ul>
              </li>

              <!-- Host a SwinCom -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  Host a SwinCom
                </a>
                <ul class="dropdown-menu">
                  <li><router-link class="dropdown-item" to="/host">Host a SwinCom</router-link></li>
                  <li><router-link class="dropdown-item" to="/mycompetition/host">My Competitions</router-link></li>
                  <li><router-link class="dropdown-item" to="/mark">Mark Submissions</router-link></li>
                </ul>
              </li>

              <!-- Resources -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  Resources
                </a>
                <ul class="dropdown-menu">
                  <li><router-link class="dropdown-item" to="/news">News</router-link></li>
                  <li><router-link class="dropdown-item" to="/about">About SwinCom</router-link></li>
                </ul>
              </li>
            </ul>

            <!-- Search and Logout -->
            <div class="d-flex gap-2 align-items-center mt-3 mt-lg-0 ms-lg-4">
              <div class="input-group input-group-sm" style="width: 200px;">
                <input 
                  class="form-control" 
                  type="search" 
                  placeholder="Search SwinComs" 
                  aria-label="Search"
                  @keyup.enter="handleSearch"
                />
                <button class="btn btn-outline-secondary btn-sm" type="button" @click="handleSearch">
                  <i class="bi bi-search"></i> Search
                </button>
                
              </div>

              <!-- Notifications Badge (if applicable) -->
              <div class="position-relative">
                <button class="btn btn-link text-dark position-relative" title="Notifications">
                  <i class="bi bi-bell"></i>
                  <span v-if="notificationCount > 0" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                    {{ notificationCount }}
                  </span>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- UNAUTHENTICATED USER VIEW -->
        <div v-else class="d-flex gap-2 w-100">
          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
              <!-- Join a SwinCom -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  Join a SwinCom
                </a>
                <ul class="dropdown-menu">
                  <li><router-link class="dropdown-item" to="/competitions">Browse Competitions</router-link></li>
                  <li><router-link class="dropdown-item" to="/signin">Join a SwinCom</router-link></li>
                </ul>
              </li>

              <!-- Host a SwinCom -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  Host a SwinCom
                </a>
                <ul class="dropdown-menu">
                  <li><a class="dropdown-item" href="#" @click.prevent="redirectToAuth('signin')">Sign In to Host</a></li>
                </ul>
              </li>

              <!-- Resources -->
              <li class="nav-item dropdown">
                <a 
                  class="nav-link dropdown-toggle" 
                  href="#" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false"
                >
                  Resources
                </a>
                <ul class="dropdown-menu">
                  <li><router-link class="dropdown-item" to="/news">News</router-link></li>
                  <li><router-link class="dropdown-item" to="/about">About SwinCom</router-link></li>
                </ul>
              </li>
            </ul>

            <!-- Search and Auth Buttons -->
            <div class="d-flex gap-2 align-items-center mt-3 mt-lg-0 ms-lg-4 flex-wrap">
              <div class="input-group input-group-sm" style="width: 200px;">
                <input 
                  class="form-control" 
                  type="search" 
                  placeholder="Search SwinComs" 
                  aria-label="Search"
                  @keyup.enter="handleSearch"
                />
                <button class="btn btn-outline-secondary btn-sm" type="button" @click="handleSearch">
                  <i class="bi bi-search"></i>
                </button>
              </div>

              <router-link class="btn btn-outline-dark btn-sm px-3" to="/signin">
                Sign In
              </router-link>

              <router-link class="btn btn-dark btn-sm px-3" to="/signup">
                Sign Up
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </nav>
  </div>
</template>

<script>
export default {
  name: 'Header',
  data() {
    return {
      notificationCount: 0,
      searchQuery: ''
    };
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters['auth/isAuthenticated'];
    },
    currentUser() {
      const user = this.$store.getters['auth/currentUser'];
      if (!user) {
        return {
          name: 'User',
          firstName: 'User',
          email: 'user@example.com',
          avatar: null,
          role: 'user'
        };
      }

      return {
        ...user,
        firstName: user.first_name || user.firstName || 'User',
        name: user.first_name && user.last_name
          ? `${user.first_name} ${user.last_name}`
          : user.name || 'User'
      };
    }
  },
  mounted() {
    this.fetchNotifications();
  },
  methods: {
    handleLogout() {
      this.$store.dispatch('auth/logout');
      this.$router.push('/');
      this.showNotification('Logged out successfully', 'success');
    },
    handleSearch() {
      if (this.searchQuery.trim()) {
        this.$router.push(`/search?q=${encodeURIComponent(this.searchQuery)}`);
        this.searchQuery = '';
      }
    },
    redirectToAuth(action) {
      this.$router.push(`/${action}?redirect=${this.$route.fullPath}`);
    },
    fetchNotifications() {
      if (this.isAuthenticated) {
      }
    },
    showNotification(message, type = 'info') {
      console.log(`Notification (${type}):`, message);
    }
  },
  watch: {
    isAuthenticated(newVal) {
      if (newVal) {
        this.fetchNotifications();
      }
    }
  }
};
</script>

<style scoped>
.dropdown-menu-end {
  right: 0;
}

.navbar-nav .dropdown-menu {
  border: 1px solid #dee2e6;
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
}

.navbar-nav .dropdown-item:hover {
  background-color: #f8f9fa;
  color: #333;
}

.btn-link {
  text-decoration: none;
}

.badge {
  font-size: 0.65rem;
  padding: 0.35rem 0.5rem;
}

@media (max-width: 991.98px) {
  .navbar-collapse {
    margin-top: 1rem;
    border-top: 1px solid #dee2e6;
    padding-top: 1rem;
  }
}
</style>