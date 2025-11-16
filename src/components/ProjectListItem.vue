<template>
  <div class="card project-list-item shadow-sm">
    <div class="row g-0">
      <!-- Project Image -->
      <div class="col-md-4 col-lg-3">
        <div class="project-image-wrapper">
          <img
            :src="project.projectImages[0]?.url || 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg'"
            :alt="project.projectName"
            class="project-image"
            @click="viewDetails">
          <div class="image-overlay">
            <button class="btn btn-light btn-sm" @click="viewDetails">
              <i class="bi bi-eye-fill"></i> View
            </button>
          </div>
          
          <!-- Status Badge -->
          <span class="badge bg-success position-absolute top-0 start-0 m-2">
            <i class="bi bi-check-circle-fill me-1"></i>{{ project.status }}
          </span>
        </div>
      </div>

      <!-- Project Content -->
      <div class="col-md-8 col-lg-9">
        <div class="card-body d-flex flex-column h-100">
          <div class="flex-grow-1">
            <!-- Title and Date -->
            <div class="d-flex justify-content-between align-items-start mb-2">
              <div>
                <h5 class="card-title mb-1">
                  <a href="#" @click.prevent="viewDetails" class="text-decoration-none text-dark">
                    {{ project.projectName }}
                  </a>
                </h5>
                <small class="text-muted">
                  <i class="bi bi-calendar3 me-1"></i>
                  {{ formatDate(project.dates.submitted) }}
                </small>
              </div>
              
              <!-- Awards -->
              <div v-if="project.awards && project.awards.length > 0">
                <span 
                  v-for="award in project.awards.slice(0, 1)" 
                  :key="award"
                  class="badge bg-warning text-dark">
                  <i class="bi bi-trophy-fill me-1"></i>{{ award }}
                </span>
              </div>
            </div>

            <!-- Elevator Pitch -->
            <p class="card-text text-muted mb-3">{{ project.elevatorPitch }}</p>

            <!-- Team and Stats -->
            <div class="d-flex flex-wrap gap-3 mb-3">
              <div class="d-flex align-items-center text-muted small">
                <i class="bi bi-person-circle me-1"></i>
                <span>{{ project.uploader.name }}</span>
              </div>
              <div class="d-flex align-items-center text-muted small">
                <i class="bi bi-people-fill me-1"></i>
                <span>{{ project.team.length }} member{{ project.team.length > 1 ? 's' : '' }}</span>
              </div>
              <div class="d-flex align-items-center text-muted small">
                <i class="bi bi-heart-fill text-danger me-1"></i>
                <span>{{ project.votes }} votes</span>
              </div>
              <div class="d-flex align-items-center text-muted small">
                <i class="bi bi-chat-fill text-primary me-1"></i>
                <span>{{ project.comments.length }} comments</span>
              </div>
            </div>

            <!-- Tags -->
            <div class="d-flex flex-wrap gap-1 mb-3">
              <span 
                v-for="(tag, index) in project.tags.slice(0, 5)" 
                :key="index"
                class="badge bg-light text-dark border">
                {{ tag }}
              </span>
              <span 
                v-if="project.tags.length > 5"
                class="badge bg-light text-dark border">
                +{{ project.tags.length - 5 }}
              </span>
            </div>
          </div>

          <!-- Actions -->
          <div class="d-flex gap-2 align-items-center border-top pt-3">
            <button
              class="btn btn-outline-danger btn-sm"
              @click="toggleVote"
              :class="{ 'active': hasVoted }">
              <i class="bi bi-heart-fill me-1"></i>
              {{ hasVoted ? 'Voted' : 'Vote' }}
            </button>
            <button
              class="btn btn-outline-primary btn-sm"
              @click="openCommentModal">
              <i class="bi bi-chat-fill me-1"></i>
              Comment
            </button>
            <button
              class="btn btn-primary btn-sm ms-auto"
              @click="viewDetails">
              <i class="bi bi-eye-fill me-1"></i>
              View Details
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProjectListItem',
  props: {
    project: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      hasVoted: false
    }
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    viewDetails() {
      this.$router.push(`/projects/${this.project.id}`)
    },
    toggleVote() {
      this.hasVoted = !this.hasVoted
      this.$emit('vote', this.project.id)
    },
    openCommentModal() {
      this.$emit('comment', this.project.id)
    }
  }
}
</script>

<style scoped>
.project-list-item {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  overflow: hidden;
  border: 1px solid #e9ecef;
}

.project-list-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1) !important;
}

.project-image-wrapper {
  position: relative;
  height: 100%;
  min-height: 250px;
  overflow: hidden;
}

.project-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  transition: transform 0.3s ease;
  cursor: pointer;
}

.project-image-wrapper:hover .project-image {
  transform: scale(1.1);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.project-image-wrapper:hover .image-overlay {
  opacity: 1;
}

.card-title a {
  transition: color 0.3s ease;
}

.card-title a:hover {
  color: #0d6efd !important;
}

.btn {
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-outline-danger:hover,
.btn-outline-danger.active {
  background-color: #dc3545;
  border-color: #dc3545;
  color: white;
}

.btn-outline-danger.active {
  transform: scale(1.05);
}

.btn-outline-primary:hover {
  transform: translateY(-2px);
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
}

.badge {
  font-weight: 600;
}

/* Responsive */
@media (max-width: 768px) {
  .project-image-wrapper {
    min-height: 200px;
  }

  .card-body {
    padding: 1rem;
  }

  .d-flex.gap-3 {
    gap: 0.5rem !important;
  }
}
</style>