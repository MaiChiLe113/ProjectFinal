<template>
  <div class="project-tab">
    <h2 class="mb-4">My Project</h2>
    
    <!-- Loading State -->
    <div v-if="isLoading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="text-muted mt-3">Loading your project...</p>
    </div>

    <!-- Has Submitted Project -->
    <div v-else-if="userProject">
      <!-- Project Summary Card -->
      <div class="card mb-4">
        <div class="row g-0">
          <div class="col-md-4">
            <img 
              :src="userProject.projectImages[0]?.url || 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg'"
              :alt="userProject.projectName"
              class="img-fluid rounded-start h-100"
              style="object-fit: cover;">
          </div>
          <div class="col-md-8">
            <div class="card-body">
              <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                  <h3 class="card-title">{{ userProject.projectName }}</h3>
                  <p class="text-muted">{{ userProject.elevatorPitch }}</p>
                </div>
                <span 
                  class="badge bg-success px-3 py-2"
                  :class="getStatusClass(userProject.status)">
                  {{ userProject.status }}
                </span>
              </div>

              <!-- Stats -->
              <div class="row g-3 mb-3">
                <div class="col-6 col-sm-3">
                  <div class="text-center p-2 bg-light rounded">
                    <i class="bi bi-heart-fill text-danger fs-4 d-block"></i>
                    <strong class="d-block">{{ userProject.votes }}</strong>
                    <small class="text-muted">Votes</small>
                  </div>
                </div>
                <div class="col-6 col-sm-3">
                  <div class="text-center p-2 bg-light rounded">
                    <i class="bi bi-chat-fill text-primary fs-4 d-block"></i>
                    <strong class="d-block">{{ userProject.comments.length }}</strong>
                    <small class="text-muted">Comments</small>
                  </div>
                </div>
                <div class="col-6 col-sm-3">
                  <div class="text-center p-2 bg-light rounded">
                    <i class="bi bi-people-fill text-info fs-4 d-block"></i>
                    <strong class="d-block">{{ userProject.team.length }}</strong>
                    <small class="text-muted">Team</small>
                  </div>
                </div>
                <div class="col-6 col-sm-3">
                  <div class="text-center p-2 bg-light rounded">
                    <i class="bi bi-trophy-fill text-warning fs-4 d-block"></i>
                    <strong class="d-block">{{ userProject.awards.length }}</strong>
                    <small class="text-muted">Awards</small>
                  </div>
                </div>
              </div>

              <!-- Actions -->
              <div class="d-flex gap-2">
                <router-link 
                  :to="`/projects/${userProject.id}`"
                  class="btn btn-primary">
                  <i class="bi bi-eye-fill me-2"></i>View Details
                </router-link>
                <button 
                  class="btn btn-outline-secondary"
                  @click="editProject">
                  <i class="bi bi-pencil-fill me-2"></i>Edit
                </button>
                <button 
                  class="btn btn-outline-danger"
                  @click="confirmDelete">
                  <i class="bi bi-trash-fill me-2"></i>Delete
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Awards Section -->
      <div v-if="userProject.awards && userProject.awards.length > 0" class="card mb-4">
        <div class="card-body">
          <h5 class="card-title mb-3">
            <i class="bi bi-trophy-fill text-warning me-2"></i>Awards & Recognition
          </h5>
          <div class="d-flex flex-wrap gap-2">
            <span 
              v-for="award in userProject.awards" 
              :key="award"
              class="badge bg-warning text-dark px-3 py-2 fs-6">
              <i class="bi bi-award-fill me-2"></i>{{ award }}
            </span>
          </div>
        </div>
      </div>

      <!-- Team Members -->
      <div class="card mb-4">
        <div class="card-body">
          <h5 class="card-title mb-3">
            <i class="bi bi-people-fill text-primary me-2"></i>Team Members
          </h5>
          <div class="row g-3">
            <div v-for="member in userProject.team" :key="member.id" class="col-md-6">
              <div class="d-flex align-items-center p-3 bg-light rounded">
                <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                  style="width: 50px; height: 50px;">
                  {{ member.name.charAt(0) }}
                </div>
                <div>
                  <h6 class="mb-0">{{ member.name }}</h6>
                  <small class="text-muted">{{ member.role }}</small>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Comments -->
      <div class="card" v-if="userProject.comments.length > 0">
        <div class="card-body">
          <h5 class="card-title mb-3">
            <i class="bi bi-chat-dots-fill text-primary me-2"></i>Recent Comments
          </h5>
          <div v-for="comment in userProject.comments.slice(0, 3)" :key="comment.id" class="mb-3 pb-3 border-bottom">
            <div class="d-flex align-items-start">
              <div class="avatar bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                style="width: 40px; height: 40px;">
                {{ comment.userName.charAt(0) }}
              </div>
              <div class="flex-grow-1">
                <div class="d-flex justify-content-between align-items-start mb-1">
                  <strong>{{ comment.userName }}</strong>
                  <small class="text-muted">{{ formatDate(comment.timestamp) }}</small>
                </div>
                <p class="mb-1">{{ comment.comment }}</p>
                <small class="text-muted">
                  <i class="bi bi-heart-fill me-1"></i>{{ comment.likes }} likes
                </small>
              </div>
            </div>
          </div>
          <router-link 
            :to="`/projects/${userProject.id}?tab=comments`"
            class="btn btn-sm btn-outline-primary w-100">
            View All Comments
          </router-link>
        </div>
      </div>
    </div>

    <!-- No Project Submitted -->
    <div v-else>
      <div class="alert alert-info">
        <i class="bi bi-info-circle me-2"></i>
        You haven't submitted a project yet. Start by creating your submission below.
      </div>

      <div class="card">
        <div class="card-body text-center py-5">
          <i class="bi bi-folder-plus text-muted" style="font-size: 4rem;"></i>
          <h4 class="mt-3">Create Your Submission</h4>
          <p class="text-muted">Upload your project files and details</p>
          <router-link to="/submit" class="btn btn-primary btn-lg">
            <i class="bi bi-plus-circle me-2"></i>New Submission
          </router-link>
        </div>
      </div>

      <!-- Submission Guidelines -->
      <div class="card mt-4">
        <div class="card-body">
          <h5 class="card-title mb-3">
            <i class="bi bi-list-check text-primary me-2"></i>Submission Guidelines
          </h5>
          <ul class="mb-0">
            <li>Fill in all required fields including project name and elevator pitch</li>
            <li>Write a compelling project story with inspiration, challenges, and learnings</li>
            <li>Add project images and video demo (if available)</li>
            <li>List all technologies and tools used</li>
            <li>Include links to live demo and source code</li>
            <li>Add all team members and their roles</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProjectTab',
  props: {
    competitionId: {
      type: Number,
      required: false
    }
  },
  data() {
    return {
      userProject: null,
      isLoading: true
    }
  },
  methods: {
    async loadUserProject() {
      this.isLoading = true
      try {
        // Get current user's ID (this would come from your auth system)
        const currentUserId = 101 // Mock user ID
        
        const response = await fetch('/src/data/projects.json')
        const data = await response.json()
        
        // Find project submitted by current user for this competition
        this.userProject = data.projects.find(p => 
          p.uploader.id === currentUserId && 
          (!this.competitionId || p.competitionId === this.competitionId)
        )
      } catch (error) {
        console.error('Error loading user project:', error)
      } finally {
        this.isLoading = false
      }
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    getStatusClass(status) {
      const classes = {
        'approved': 'bg-success',
        'pending': 'bg-warning',
        'rejected': 'bg-danger'
      }
      return classes[status] || 'bg-secondary'
    },
    editProject() {
      this.$router.push(`/submit?projectId=${this.userProject.id}`)
    },
    confirmDelete() {
      if (confirm('Are you sure you want to delete this project? This action cannot be undone.')) {
        this.deleteProject()
      }
    },
    async deleteProject() {
      try {
        // API call to delete project would go here
        console.log('Deleting project:', this.userProject.id)
        
        // Show success message
        alert('Project deleted successfully')
        
        // Reload the project tab
        this.userProject = null
      } catch (error) {
        console.error('Error deleting project:', error)
        alert('Failed to delete project. Please try again.')
      }
    }
  },
  mounted() {
    this.loadUserProject()
  },
  watch: {
    competitionId() {
      this.loadUserProject()
    }
  }
}
</script>

<style scoped>
.project-tab {
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.avatar {
  font-weight: 600;
}

.card {
  border: 1px solid #e9ecef;
  transition: box-shadow 0.3s ease;
}

.card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.btn {
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
}

/* Responsive */
@media (max-width: 768px) {
  .card .row.g-0 {
    flex-direction: column;
  }

  .card .row.g-0 .col-md-4 img {
    height: 250px;
    width: 100%;
  }
}
</style>