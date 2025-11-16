<template>
  <div class="card h-100 shadow-sm news-card" @click="goToDetail">
    <div class="position-relative">
      <img
        :src="newsItem.image"
        :alt="newsItem.title"
        class="card-img-top"
        style="height: 200px; object-fit: cover;"
        @error="handleImageError"
      />
      <span class="position-absolute top-0 end-0 m-3 badge bg-primary rounded-pill">
        {{ newsItem.category }}
      </span>
    </div>
    <div class="card-body d-flex flex-column">
      <div class="text-muted small mb-2">
        <i class="bi bi-calendar3 me-1"></i>
        {{ formatDate(newsItem.date) }}
      </div>
      <h5 class="card-title fw-bold">{{ newsItem.title }}</h5>
      <p class="card-text text-muted flex-grow-1 truncate-text">{{ truncatedContent }}</p>
      <div class="text-end mt-2">
        <span class="text-primary small fw-semibold read-more">
          Read more <i class="bi bi-arrow-right"></i>
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NewsCard',
  props: {
    newsItem: {
      type: Object,
      required: true
    }
  },
  computed: {
    truncatedContent() {
      const maxLength = 150
      if (this.newsItem.content.length > maxLength) {
        return this.newsItem.content.substring(0, maxLength) + '...'
      }
      return this.newsItem.content
    }
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'short', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    handleImageError(event) {
      event.target.src = 'https://placehold.co/400x200/6366f1/ffffff?text=News+Image'
    },
    goToDetail() {
      this.$router.push({
        name: 'NewsDetail',
        params: { id: this.newsItem.id }
      })
    }
  }
}
</script>

<style scoped>
.news-card {
  cursor: pointer;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.news-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
}

.truncate-text {
  overflow: hidden;
  display: -webkit-box;
  -webkit-box-orient: vertical;
}

.read-more {
  cursor: pointer;
}

.read-more:hover {
  text-decoration: underline;
}
</style>