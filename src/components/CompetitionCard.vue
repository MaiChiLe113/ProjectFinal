<template>
  <div class="card h-100 shadow-sm competition-card">
    <!-- Banner Image -->
    <div class="card-img-top position-relative competition-card__banner">
      <img 
        :src="competition.images.banner || competition.images.thumbnail" 
        :alt="competition.title"
        class="w-100 competition-card__image"
      />
      <div class="competition-card__overlay"></div>
      
      <!-- Badges on Image -->
      <div class="position-absolute top-0 start-0 w-100 p-3 d-flex justify-content-between align-items-start">
        <span class="badge bg-primary bg-opacity-90 px-3 py-2">
          <i class="bi bi-tag-fill me-1"></i>
          {{ competition.category }}
        </span>
        <span
          class="badge px-3 py-2"
          :class="{
            'bg-info': competition.status === 'upcoming',
            'bg-success': competition.status === 'ongoing',
            'bg-secondary': competition.status === 'completed'
          }"
        >
          {{ competition.status }}
        </span>
      </div>

      <!-- Location Type Icon -->
      <div class="position-absolute bottom-0 end-0 p-2">
        <span class="badge bg-dark bg-opacity-75">
          <i :class="getLocationIcon(competition.location.type)" class="me-1"></i>
          {{ competition.location.type }}
        </span>
      </div>
    </div>

    <div class="card-body d-flex flex-column">
      <h5 class="card-title fw-bold mb-2">{{ competition.title }}</h5>
      <p class="card-text text-muted small flex-grow-1 competition-card__description">
        {{ competition.description }}
      </p>

      <div class="mt-3 pt-3 border-top">
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-calendar3 me-2 text-primary"></i>
          <span>{{ formatDate(competition.dates.start) }}</span>
        </div>
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-people-fill me-2 text-primary"></i>
          <span>{{ competition.capacity.current }} / {{ competition.capacity.max }} participants</span>
        </div>
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-building me-2 text-primary"></i>
          <span>{{ competition.organizer.name }}</span>
        </div>
        <div class="d-flex align-items-center text-muted small">
          <i class="bi bi-geo-alt-fill me-2 text-primary"></i>
          <span>{{ competition.participants }}</span>
        </div>
      </div>

      <!-- Prize Badge (if exists) -->
      <div v-if="competition.prizes" class="mt-2">
        <div class="alert alert-warning py-2 px-3 mb-0 small">
          <i class="bi bi-trophy-fill me-2"></i>
          <strong>Prize:</strong> {{ shortenPrize(competition.prizes) }}
        </div>
      </div>

      <button
        v-if="competition.registration.isOpen"
        class="btn btn-primary btn-sm mt-3 w-100"
        @click="registerNow"
      >
        <i class="bi bi-trophy-fill me-2"></i>See more details
      </button>
      <button
        v-else
        class="btn btn-secondary btn-sm mt-3 w-100"
        disabled
      >
        <i class="bi bi-lock-fill me-2"></i>Registration Closed
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CompetitionCard',
  props: {
    competition: {
      type: Object,
      required: true
    }
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    getLocationIcon(locationType) {
      const icons = {
        'online': 'bi bi-laptop',
        'offline': 'bi bi-geo-alt-fill',
        'hybrid': 'bi bi-globe'
      }
      return icons[locationType] || 'bi bi-question-circle'
    },
    shortenPrize(prizeText) {
      // Shorten prize text if too long
      if (prizeText.length > 60) {
        return prizeText.substring(0, 57) + '...'
      }
      return prizeText
    },
    registerNow() {
      // Navigate to competition detail or registration page
      this.$router.push(`/competitions/${this.competition.id}`)
    }
  }
}
</script>

<style scoped>
.competition-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  overflow: hidden;
}

.competition-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15) !important;
}

.competition-card__banner {
  height: 200px;
  overflow: hidden;
  position: relative;
}

.competition-card__image {
  height: 100%;
  object-fit: cover;
  object-position: center;
  transition: transform 0.3s ease;
}

.competition-card:hover .competition-card__image {
  transform: scale(1.05);
}

.competition-card__overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.1));
  pointer-events: none;
}

.competition-card__description {
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

/* Responsive adjustments */
@media (max-width: 768px) {
  .competition-card__banner {
    height: 180px;
  }
}
</style>