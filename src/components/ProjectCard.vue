<template>
  <div class="card h-100 shadow-sm project-card">
    <!-- Project Image -->
    <div class="card-img-top position-relative project-card__banner">
      <img
        :src="project.projectImages[0]?.url || 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg'"
        :alt="project.projectName"
        class="w-100 project-card__image"
      />
      <div class="project-card__overlay"></div>

      <!-- Badges on Image -->
      <div class="position-absolute top-0 start-0 w-100 p-3 d-flex justify-content-between align-items-start">
        <span class="badge bg-primary bg-opacity-90 px-3 py-2">
          <i class="bi bi-folder-fill me-1"></i>
          Project
        </span>
        <span class="badge bg-success bg-opacity-90 px-3 py-2">
          <i class="bi bi-check-circle-fill me-1"></i>
          {{ project.status }}
        </span>
      </div>

      <!-- Vote Badge -->
      <div class="position-absolute bottom-0 end-0 p-2">
        <span class="badge bg-dark bg-opacity-75">
          <i class="bi bi-heart-fill me-1 text-danger"></i>
          {{ project.votes }} votes
        </span>
      </div>
    </div>

    <div class="card-body d-flex flex-column">
      <h5 class="card-title fw-bold mb-2">{{ project.projectName }}</h5>
      <p class="card-text text-muted small flex-grow-1 project-card__description">
        {{ project.elevatorPitch }}
      </p>

      <div class="mt-3 pt-3 border-top">
        <!-- Team Info -->
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-people-fill me-2 text-primary"></i>
          <span>{{ project.team.length }} team member{{ project.team.length > 1 ? 's' : '' }}</span>
        </div>

        <!-- Uploader -->
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-person-circle me-2 text-primary"></i>
          <span>{{ project.uploader.name }}</span>
        </div>

        <!-- Submitted Date -->
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-calendar3 me-2 text-primary"></i>
          <span>{{ formatDate(project.dates.submitted) }}</span>
        </div>

        <!-- Tags -->
        <div class="d-flex flex-wrap gap-1 mt-2">
          <span 
            v-for="(tag, index) in project.tags.slice(0, 3)" 
            :key="index"
            class="badge bg-light text-dark border">
            {{ tag }}
          </span>
          <span 
            v-if="project.tags.length > 3"
            class="badge bg-light text-dark border">
            +{{ project.tags.length - 3 }}
          </span>
        </div>
      </div>

      <!-- Comments Badge -->
      <div v-if="project.comments.length > 0" class="mt-2">
        <div class="alert alert-info py-2 px-3 mb-0 small">
          <i class="bi bi-chat-fill me-2"></i>
          {{ project.comments.length }} comment{{ project.comments.length > 1 ? 's' : '' }}
        </div>
      </div>

      <!-- Awards Badge (if exists) -->
      <div v-if="project.awards && project.awards.length > 0" class="mt-2">
        <div class="alert alert-warning py-2 px-3 mb-0 small">
          <i class="bi bi-trophy-fill me-2"></i>
          <strong>{{ project.awards[0] }}</strong>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="d-flex gap-2 mt-3">
        <button
          class="btn btn-primary btn-sm flex-grow-1"
          @click="viewDetails">
          <i class="bi bi-eye-fill me-2"></i>View Details
        </button>
        <button
          class="btn btn-outline-danger btn-sm"
          @click="toggleVote"
          :class="{ 'active': hasVoted }">
          <i class="bi bi-heart-fill"></i>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProjectCard',
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
      // Navigate to project detail page
      this.$router.push(`/projects/${this.project.id}`)
    },
    toggleVote() {
      this.hasVoted = !this.hasVoted
      // Here you would typically make an API call to register the vote
      if (this.hasVoted) {
        this.project.votes++
      } else {
        this.project.votes--
      }
    }
  }
}
</script>

<style scoped>
.project-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  overflow: hidden;
}

.project-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
}

.project-card__banner {
  height: 200px;
  overflow: hidden;
  position: relative;
}

.project-card__image {
  height: 100%;
  object-fit: cover;
  object-position: center;
  transition: transform 0.3s ease;
}

.project-card:hover .project-card__image {
  transform: scale(1.05);
}

.project-card__overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.1));
  pointer-events: none;
}

.project-card__description {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.5;
}

.badge {
  font-weight: 600;
  letter-spacing: 0.3px;
}

.card-body {
  padding: 1.25rem;
}

.btn {
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
}

.btn-outline-danger {
  transition: all 0.3s ease;
}

.btn-outline-danger:hover,
.btn-outline-danger.active {
  background-color: #dc3545;
  border-color: #dc3545;
  color: white;
  transform: scale(1.1);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .project-card__banner {
    height: 180px;
  }
}
</style>