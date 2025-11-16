<template>
  <div class="hosted-competitions">
    <!-- Header Section -->
    <div class="hero-section bg-primary text-white py-5">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-8">
            <h1 class="display-5 fw-bold mb-3">
              <i class="bi bi-star-fill me-3"></i>My Hosted Competitions
            </h1>
            <p class="lead mb-0">
              Manage and track your competitions
            </p>
          </div>
          <div class="col-md-4 text-md-end">
            <router-link to="/host" class="btn btn-light btn-lg">
              <i class="bi bi-plus-circle me-2"></i>Host New Competition
            </router-link>
          </div>
        </div>
      </div>
    </div>

    <!-- Stats Cards -->
    <div class="container py-4">
      <div class="row g-4 mb-4">
        <div class="col-md-3">
          <div class="card stats-card border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-trophy-fill text-warning fs-1 mb-2"></i>
              <h3 class="mb-0">{{ hostedCompetitions.length }}</h3>
              <p class="text-muted mb-0">Total Hosted</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-clock-fill text-primary fs-1 mb-2"></i>
              <h3 class="mb-0">{{ activeCompetitions }}</h3>
              <p class="text-muted mb-0">Active</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-people-fill text-success fs-1 mb-2"></i>
              <h3 class="mb-0">{{ totalParticipants }}</h3>
              <p class="text-muted mb-0">Participants</p>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-eye-fill text-info fs-1 mb-2"></i>
              <h3 class="mb-0">{{ totalViews }}</h3>
              <p class="text-muted mb-0">Total Views</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Competitions List -->
    <div class="container pb-5">
      <!-- Loading State -->
      <div v-if="isLoading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <p class="text-muted mt-3">Loading your competitions...</p>
      </div>

      <!-- Empty State -->
      <div v-else-if="hostedCompetitions.length === 0" class="text-center py-5">
        <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
        <h3 class="mt-3">No Competitions Yet</h3>
        <p class="text-muted">Start by hosting your first competition!</p>
        <router-link to="/host" class="btn btn-primary btn-lg mt-3">
          <i class="bi bi-plus-circle me-2"></i>Host a Competition
        </router-link>
      </div>

      <!-- Competitions Grid -->
      <div v-else class="row g-4">
        <div 
          v-for="competition in hostedCompetitions" 
          :key="competition.id"
          class="col-md-6 col-lg-4">
          <!-- Competition Card with Action Overlay -->
          <div class="position-relative hosted-card-wrapper">
            <CompetitionCard :competition="competition" />
            
            <!-- Management Actions Overlay -->
            <div class="management-actions">
              <div class="btn-group-vertical w-100" role="group">
                <button 
                  class="btn btn-light btn-sm"
                  @click="editCompetition(competition.id)"
                  title="Edit Competition">
                  <i class="bi bi-pencil-fill me-2"></i>Edit
                </button>
                <button 
                  class="btn btn-light btn-sm"
                  @click="viewParticipants(competition.id)"
                  title="View Participants">
                  <i class="bi bi-people-fill me-2"></i>
                  Participants ({{ competition.capacity?.current || 0 }})
                </button>
                <button 
                  class="btn btn-light btn-sm"
                  @click="viewAnalytics(competition.id)"
                  title="View Analytics">
                  <i class="bi bi-graph-up me-2"></i>Analytics
                </button>
                <button 
                  class="btn btn-danger btn-sm"
                  @click="deleteCompetition(competition.id)"
                  title="Delete Competition">
                  <i class="bi bi-trash-fill me-2"></i>Delete
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div 
      class="modal fade" 
      id="deleteModal" 
      tabindex="-1" 
      ref="deleteModal">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Confirm Delete</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <p>Are you sure you want to delete this competition?</p>
            <p class="text-danger"><strong>This action cannot be undone!</strong></p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button 
              type="button" 
              class="btn btn-danger"
              @click="confirmDelete">
              <i class="bi bi-trash-fill me-2"></i>Delete
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CompetitionCard from '../../../components/CompetitionCard.vue'

export default {
  name: 'Host',
  components: {
    CompetitionCard
  },
  data() {
    return {
      hostedCompetitions: [
        {
        id: 101,
        title: "AI Art Generator Challenge",
        description: "Create stunning AI-generated artwork using any AI tool. Show us your creativity and technical skills!",
        category: "Technology",
        organizer: {
          id: 999,
          name: "Alex Chen",
          email: "alex.chen@example.com",
          type: "individual"
        },
        dates: {
          start: "2026-04-10",
          end: "2026-04-25",
          registrationDeadline: "2026-04-08"
        },
        participants: "Open to all",
        capacity: {
          max: 50,
          current: 28,
          waitlist: 0
        },
        status: "ongoing",
        registration: {
          isOpen: true,
          allowTeams: false,
          teamSize: 1,
          requiresApproval: false
        },
        location: {
          type: "online",
          venue: "Discord Server",
          link: "https://discord.gg/example"
        },
        prizes: "1st: $500, 2nd: $300, 3rd: $150",
        rules: "Use any AI tool, Submit original work only, Follow community guidelines",
        contactEmail: "aiart@example.com",
        images: {
          banner: "https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=800",
          thumbnail: "https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?w=400"
        },
        metadata: {
          views: 342,
          votes: 0,
          registrations: 28,
          completionRate: 0
        }
      },
      {
        id: 102,
        title: "Mobile Photography Contest",
        description: "Capture the beauty of everyday life using only your smartphone camera. Best photos win amazing prizes!",
        category: "Media",
        organizer: {
          id: 999,
          name: "Sarah Johnson",
          email: "sarah.j@example.com",
          type: "individual"
        },
        dates: {
          start: "2026-03-20",
          end: "2026-04-15",
          registrationDeadline: "2026-03-18"
        },
        participants: "Photography enthusiasts worldwide",
        capacity: {
          max: 100,
          current: 67,
          waitlist: 5
        },
        status: "upcoming",
        registration: {
          isOpen: true,
          allowTeams: false,
          teamSize: 1,
          requiresApproval: false
        },
        location: {
          type: "online",
          venue: "Instagram & Website Submission",
          link: "https://photochallenge.example.com"
        },
        prizes: "1st: $1000 + Featured Exhibition, 2nd: $500, 3rd: $250, People's Choice: $200",
        rules: "Smartphone photos only, No heavy editing, Original work required, Max 3 submissions per person",
        contactEmail: "photo.contest@example.com",
        images: {
          banner: "https://images.unsplash.com/photo-1452587925148-ce544e77e70d?w=800",
          thumbnail: "https://images.unsplash.com/photo-1452587925148-ce544e77e70d?w=400"
        },
        metadata: {
          views: 1256,
          votes: 0,
          registrations: 67,
          completionRate: 0
        }
      }
    ],
    isLoading: true,
    selectedCompetitionId: null
  }
},
  computed: {
    activeCompetitions() {
      return this.hostedCompetitions.filter(c => c.status === 'ongoing' || c.status === 'upcoming').length
    },
    totalParticipants() {
      return this.hostedCompetitions.reduce((sum, c) => sum + (c.capacity?.current || 0), 0)
    },
    totalViews() {
      return this.hostedCompetitions.reduce((sum, c) => sum + (c.metadata?.views || 0), 0)
    }
  },
  methods: {
    async loadHostedCompetitions() {
      this.isLoading = true
      try {
        // In a real app, this would fetch from an API filtered by current user
        // For now, we'll load from competitions.json and filter by organizer
        const response = await fetch('./data/competitions.json')
        const data = await response.json()
        
        // TODO: Replace with actual user ID from authentication
        const currentUserId = 101 // Mock user ID
        
        // Filter competitions where current user is the organizer
        this.hostedCompetitions = data.competitions.filter(c => 
          c.organizer?.id === currentUserId || 
          c.organizer?.email === 'organizer@example.com' // Mock filter
        )
        
      } catch (error) {
        console.error('Error loading competitions:', error)
      } finally {
        this.isLoading = false
      }
    },
    getStatusBadgeClass(status) {
      const classes = {
        'upcoming': 'bg-info',
        'ongoing': 'bg-success',
        'completed': 'bg-secondary',
        'cancelled': 'bg-danger'
      }
      return classes[status] || 'bg-secondary'
    },
    formatDate(dateString) {
      if (!dateString) return 'N/A'
      const options = { month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    formatFullDate(dateString) {
      if (!dateString) return 'N/A'
      const options = { year: 'numeric', month: 'long', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    editCompetition(competitionId) {
      // Navigate to edit page (to be implemented)
      this.$router.push(`/competitions/${competitionId}/edit`)
    },
    viewParticipants(competitionId) {
      // Navigate to participants page
      this.$router.push(`/competitions/${competitionId}/participants`)
    },
    viewAnalytics(competitionId) {
      // Navigate to analytics page
      this.$router.push(`/competitions/${competitionId}/analytics`)
    },
    deleteCompetition(competitionId) {
      this.selectedCompetitionId = competitionId
      const modal = new bootstrap.Modal(this.$refs.deleteModal)
      modal.show()
    },
    async confirmDelete() {
      if (!this.selectedCompetitionId) return
      
      try {
        // In a real app, this would call an API to delete the competition
        const response = await fetch(`/api/competitions/${this.selectedCompetitionId}`, {
          method: 'DELETE'
        })
        
        if (!response.ok) {
          throw new Error('Failed to delete competition')
        }
        
        // Remove from local list
        this.hostedCompetitions = this.hostedCompetitions.filter(
          c => c.id !== this.selectedCompetitionId
        )
        
        // Close modal
        const modal = bootstrap.Modal.getInstance(this.$refs.deleteModal)
        modal.hide()
        
        alert('Competition deleted successfully!')
      } catch (error) {
        console.error('Error deleting competition:', error)
        alert('Failed to delete competition. Please try again.')
      }
    }
  },
  mounted() {
    this.loadHostedCompetitions()
  }
}
</script>

<style scoped>
.hosted-competitions {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.hero-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stats-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stats-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
}

/* Hosted Card Wrapper with Management Overlay */
.hosted-card-wrapper {
  position: relative;
}

.hosted-card-wrapper:hover .management-actions {
  opacity: 1;
  visibility: visible;
}

.management-actions {
  position: absolute;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background: rgba(0, 0, 0, 0.85);
  backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
  z-index: 10;
  border-radius: 0.375rem;
}

.management-actions .btn-group-vertical {
  gap: 0.5rem;
}

.management-actions .btn {
  font-weight: 600;
  border: none;
  transition: all 0.3s ease;
}

.management-actions .btn-light {
  background: white;
  color: #212529;
}

.management-actions .btn-light:hover {
  background: #f8f9fa;
  transform: translateX(5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.management-actions .btn-danger {
  background: #dc3545;
  color: white;
}

.management-actions .btn-danger:hover {
  background: #c82333;
  transform: translateX(5px);
  box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
}

.btn {
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .hero-section h1 {
    font-size: 2rem;
  }
  
  /* Always show actions on mobile */
  .management-actions {
    position: static;
    opacity: 1;
    visibility: visible;
    background: transparent;
    backdrop-filter: none;
    margin-top: -1rem;
    padding: 1rem;
  }
  
  .hosted-card-wrapper {
    margin-bottom: 1rem;
  }
}
</style>