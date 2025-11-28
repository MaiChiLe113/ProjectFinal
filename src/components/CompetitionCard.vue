<template>
  <div class="card h-100 shadow-sm competition-card">
    <!-- Banner Image -->
    <div class="card-img-top position-relative competition-card__banner">
      <img
        :src="getImageUrl()"
        :alt="competition.title"
        class="w-100 competition-card__image"
      />
      <div class="competition-card__overlay"></div>

      <!-- Badges on Image -->
      <div class="position-absolute top-0 start-0 w-100 p-3 d-flex justify-content-between align-items-start">
        <span class="badge bg-primary bg-opacity-90 px-3 py-2">
          <i class="bi bi-tag-fill me-1"></i>
          {{ competition.category || 'General' }}
        </span>
        <span
          class="badge px-3 py-2"
          :class="{
            'bg-info': getStatus() === 'upcoming',
            'bg-success': getStatus() === 'ongoing',
            'bg-secondary': getStatus() === 'completed'
          }"
        >
          {{ getStatus() }}
        </span>
      </div>

      <!-- Location Type Icon -->
      <div class="position-absolute bottom-0 end-0 p-2">
        <span class="badge bg-dark bg-opacity-75">
          <i :class="getLocationIcon(getLocationType())" class="me-1"></i>
          {{ getLocationType() }}
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
          <span>{{ formatDate(getStartDate()) }}</span>
        </div>
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-people-fill me-2 text-primary"></i>
          <span>{{ getCurrentParticipants() }} / {{ getMaxParticipants() }} participants</span>
        </div>
        <div class="d-flex align-items-center text-muted small mb-2">
          <i class="bi bi-building me-2 text-primary"></i>
          <span>{{ getOrganizerName() }}</span>
        </div>
        <div class="d-flex align-items-center text-muted small">
          <i class="bi bi-geo-alt-fill me-2 text-primary"></i>
          <span>{{ getParticipantsInfo() }}</span>
        </div>
      </div>

      <!-- Prize Badge (if exists) -->
      <div v-if="getPrizes()" class="mt-2">
        <div class="alert alert-warning py-2 px-3 mb-0 small">
          <i class="bi bi-trophy-fill me-2"></i>
          <strong>Prize:</strong> {{ shortenPrize(getPrizes()) }}
        </div>
      </div>

      <button
        v-if="isRegistrationOpen()"
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
    // Helper methods to handle both flat and nested data structures
    getImageUrl() {
      // Try nested structure first (from JSON)
      if (this.competition.images?.banner) {
        return this.competition.images.banner
      }
      // Try flat structure (from database)
      if (this.competition.banner) {
        return this.competition.banner
      }
      if (this.competition.banner_image) {
        return this.competition.banner_image
      }
      // Fallback to placeholder
      return 'https://via.placeholder.com/400x200?text=Competition'
    },
    getStatus() {
      return this.competition.status || 'upcoming'
    },
    getLocationType() {
      // Try nested structure
      if (this.competition.location?.type) {
        return this.competition.location.type
      }
      // Try flat structure
      if (this.competition.location_type) {
        return this.competition.location_type
      }
      return 'hybrid'
    },
    getStartDate() {
      // Try nested structure
      if (this.competition.dates?.start) {
        return this.competition.dates.start
      }
      // Try flat structure
      if (this.competition.start_date) {
        return this.competition.start_date
      }
      return new Date().toISOString()
    },
    getCurrentParticipants() {
      // Try nested structure
      if (this.competition.capacity?.current !== undefined) {
        return this.competition.capacity.current
      }
      // Try flat structure
      if (this.competition.current_participants !== undefined) {
        return this.competition.current_participants
      }
      return 0
    },
    getMaxParticipants() {
      // Try nested structure
      if (this.competition.capacity?.max) {
        return this.competition.capacity.max
      }
      // Try flat structure
      if (this.competition.max_participants) {
        return this.competition.max_participants
      }
      return 100
    },
    getOrganizerName() {
      // Try nested structure
      if (this.competition.organizer?.name) {
        return this.competition.organizer.name
      }
      // Try flat structure
      if (this.competition.organizer_name) {
        return this.competition.organizer_name
      }
      return 'Unknown Organizer'
    },
    getParticipantsInfo() {
      // This field represents location/campus info
      return this.competition.participants || this.competition.location || 'All campuses'
    },
    getPrizes() {
      return this.competition.prizes || this.competition.prize || null
    },
    isRegistrationOpen() {
      // Try nested structure
      if (this.competition.registration?.isOpen !== undefined) {
        return this.competition.registration.isOpen
      }
      // Try flat structure
      if (this.competition.registration_open !== undefined) {
        return this.competition.registration_open
      }
      if (this.competition.is_open !== undefined) {
        return this.competition.is_open
      }
      return true
    },
    formatDate(dateString) {
      if (!dateString) return 'TBD'
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
      if (!prizeText) return ''
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