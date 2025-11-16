<template>
  <div class="about-page">
    <!-- Hero Header Section -->
    <header class="hero-header position-relative" :style="{ backgroundImage: `url(${heroImages[selectedHeroImage]})` }">
      <div class="hero-overlay position-absolute top-0 start-0 w-100 h-100"></div>
      <div class="container position-relative" style="z-index: 1;">
        <div class="row">
          <div class="col-12">
            <div class="py-5">
              <div class="row">
                <div class="col-12 col-md-8 col-lg-7">
                  <h1 class="display-3 fw-bold text-white mb-3">
                    {{ pageTitle }}
                  </h1>
                  <h3 class="fs-4 text-white mb-4">
                    {{ pageSubtitle }}
                  </h3>
                  
                  <!-- Name Input Section in Hero -->
                  <div class="card bg-white bg-opacity-90 p-4 mb-4">
                    <h4 class="mb-3">Welcome! Please introduce yourself</h4>
                    <div class="row g-3">
                      <div class="col-md-6">
                        <label for="firstName" class="form-label fw-bold">First Name:</label>
                        <input 
                          type="text" 
                          id="firstName" 
                          class="form-control form-control-lg" 
                          v-model="firstName"
                          placeholder="Enter first name"
                          @input="updateGreeting">
                      </div>
                      <div class="col-md-6">
                        <label for="lastName" class="form-label fw-bold">Last Name:</label>
                        <input 
                          type="text" 
                          id="lastName" 
                          class="form-control form-control-lg" 
                          v-model="lastName"
                          placeholder="Enter last name"
                          @input="updateGreeting">
                      </div>
                    </div>
                    
                    <!-- Welcome Message Display -->
                    <div v-show="greetingMessage" class="alert alert-success mt-3 mb-0" role="alert">
                      <h5 class="alert-heading mb-2">{{ greetingMessage }}</h5>
                      <p class="mb-0 small">{{ personalizedMessage }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </header>

    <main class="container">
      <!-- About Mission Section -->
      <section class="my-5 py-4">
        <div class="row">
          <div class="col-12 col-lg-8 mx-auto text-center">
            <h2 class="display-5 fw-bold mb-4">Our Mission</h2>
            <p class="lead text-muted mb-4">
              SwinCom is a comprehensive competition management platform designed to streamline 
              event organization, participant registration, and results tracking for educational 
              institutions and organizations.
            </p>
            <p class="fs-5">
              Built with modern web technologies including Vue 3 and Bootstrap 5, SwinCom makes 
              managing competitions effortless and efficient. Where students and staff come together 
              to build a community through friendly competition.
            </p>
          </div>
        </div>
      </section>

      <!-- Image Selection Section (Mountain/Ocean) -->
      <section class="my-5 py-4">
        <div class="container">
          <div class="row">
            <div class="col-12">
              <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white py-3">
                  <h3 class="mb-0">
                    <i class="bi bi-images me-2"></i>
                    Choose Your Inspiration
                  </h3>
                </div>
                <div class="card-body p-4">
                  <div class="row align-items-center">
                    <!-- Radio Buttons -->
                    <div class="col-md-4 col-lg-3 mb-4 mb-md-0">
                      <h5 class="mb-3">Select :</h5>
                      <div class="d-flex flex-column gap-3">
                        <div class="form-check form-check-lg">
                          <input 
                            class="form-check-input" 
                            type="radio" 
                            id="mountain"
                            value="mountain"
                            v-model="selectedTheme">
                          <label class="form-check-label fs-5" for="mountain">
                            <i class="bi bi-triangle-fill me-2 text-primary"></i>
                            Mountain
                          </label>
                        </div>
                        <div class="form-check form-check-lg">
                          <input 
                            class="form-check-input" 
                            type="radio" 
                            id="ocean"
                            value="ocean"
                            v-model="selectedTheme">
                          <label class="form-check-label fs-5" for="ocean">
                            <i class="bi bi-water me-2 text-info"></i>
                            Ocean
                          </label>
                        </div>
                        <div class="form-check form-check-lg">
                          <input 
                            class="form-check-input" 
                            type="radio" 
                            id="room"
                            value="room"
                            v-model="selectedTheme">
                          <label class="form-check-label fs-5" for="room">
                            <i class="bi bi-box-fill"></i>
                            Room
                          </label>
                        </div>
                      </div>
                      
                      <div class="mt-4 p-3 bg-light rounded">
                        <p class="mb-1 small text-muted"><strong>Current Selection:</strong></p>
                        <h5 class="mb-0">
                          <span class="badge" :class="selectedTheme === 'mountain' ? 'bg-primary' : 'bg-info'">
                            <i :class="selectedTheme === 'mountain' ? 'bi bi-triangle-fill' : 'bi bi-water'"></i>
                            {{ selectedTheme === 'mountain' ? 'Mountain' : 'Ocean' }}
                          </span>
                        </h5>
                      </div>
                    </div>

                    <!-- Image Display -->
                    <div class="col-md-8 col-lg-9">
                      <div class="position-relative">
                        <img 
                          :src="themeImages[selectedTheme]" 
                          :alt="selectedTheme"
                          class="img-fluid rounded-3 shadow-lg w-100 theme-image">
                        <div class="position-absolute bottom-0 start-0 w-100 bg-dark bg-opacity-75 text-white p-3 rounded-bottom">
                          <h4 class="mb-1">
                            <i :class="selectedTheme === 'mountain' ? 'bi bi-triangle-fill' : 'bi bi-water'"></i>
                            {{ themeLabels[selectedTheme] }}
                          </h4>
                          <p class="mb-0">{{ themeDescriptions[selectedTheme] }}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Features Grid -->
      <section class="my-5 py-4">
        <div class="container">
          <h2 class="text-center fw-bold mb-5 display-6">Why Choose SwinCom?</h2>
          <div class="row g-4">
            <div class="col-12 col-md-6 col-lg-4" v-for="(feature, index) in features" :key="index">
              <div class="card h-100 border-0 shadow-sm hover-lift">
                <div class="card-body text-center p-4">
                  <div class="feature-icon mb-3" :style="{ color: feature.color }">
                    <i :class="feature.icon" style="font-size: 3rem;"></i>
                  </div>
                  <h4 class="card-title mb-3">{{ feature.title }}</h4>
                  <p class="card-text text-muted">{{ feature.description }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Statistics Section with Interactivity -->
      <section class="my-5 py-4 bg-light rounded-3">
        <div class="container p-4">
          <h2 class="text-center fw-bold mb-5 display-6">
            Platform Statistics
            <span v-show="firstName" class="text-primary">for {{ firstName }}</span>
          </h2>
          <div class="row text-center g-4">
            <div class="col-md-4" v-for="(stat, index) in stats" :key="index">
              <div class="card h-100 shadow-sm" :class="{'border-primary border-3': stat.highlighted}">
                <div class="card-body py-4">
                  <i :class="stat.icon" class="text-primary mb-3" style="font-size: 3rem;"></i>
                  <h3 class="display-4 fw-bold text-primary mb-2">{{ stat.value }}</h3>
                  <p class="text-muted mb-3">{{ stat.label }}</p>
                  <button 
                    @click="incrementStat(stat)" 
                    class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-plus-circle me-1"></i> Increment
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Interactive Features Toggles -->
      <section class="my-5 py-4">
        <div class="container">
          <div class="card shadow border-0">
            <div class="card-header bg-success text-white py-3">
              <h3 class="mb-0">
                <i class="bi bi-toggles me-2"></i>
                Customize Your Experience
              </h3>
            </div>
            <div class="card-body p-4">
              <div class="row g-4">
                <div class="col-md-6" v-for="(feature, index) in platformFeatures" :key="index">
                  <div class="card h-100 border" :class="feature.enabled ? 'border-success' : 'border-secondary'">
                    <div class="card-body">
                      <div class="form-check form-switch mb-2">
                        <input 
                          class="form-check-input" 
                          type="checkbox" 
                          :id="'feature' + index"
                          v-model="feature.enabled"
                          style="width: 3em; height: 1.5em;">
                        <label class="form-check-label fs-5 fw-bold ms-2" :for="'feature' + index">
                          <i :class="feature.icon" class="me-2"></i>
                          {{ feature.name }}
                        </label>
                      </div>
                      <p v-show="feature.enabled" class="ms-2 mt-3 text-muted">
                        <i class="bi bi-check-circle-fill text-success me-2"></i>
                        {{ feature.description }}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
              
              <div class="mt-4 alert" :class="enabledFeaturesCount > 3 ? 'alert-success' : 'alert-info'" v-show="enabledFeaturesCount > 0">
                <i class="bi bi-info-circle-fill me-2"></i>
                <strong>{{ enabledFeaturesCount }}</strong> feature(s) currently enabled
                <span v-show="enabledFeaturesCount > 3"> - You're using SwinCom to its fullest! </span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Color Customization -->
      <section class="my-5 py-4">
        <div class="container">
          <div class="row">
            <div class="col-lg-8 mx-auto">
              <div class="card shadow border-0">
                <div class="card-header text-white py-3" :style="{ backgroundColor: accentColor }">
                  <h3 class="mb-0">
                    <i class="bi bi-palette-fill me-2"></i>
                    Personalize Your Theme
                  </h3>
                </div>
                <div class="card-body p-4">
                  <div class="row g-4">
                    <div class="col-md-6">
                      <label for="colorPicker" class="form-label fw-bold">Choose Accent Color:</label>
                      <div class="d-flex gap-3 align-items-center">
                        <input 
                          type="color" 
                          id="colorPicker" 
                          class="form-control form-control-color p-1" 
                          v-model="accentColor"
                          style="width: 80px; height: 50px;"
                          title="Choose your color">
                        <div>
                          <span class="badge fs-6 px-3 py-2" :style="{ backgroundColor: accentColor, color: getContrastColor(accentColor) }">
                            {{ accentColor }}
                          </span>
                        </div>
                      </div>
                    </div>
                    
                    <div class="col-md-6">
                      <label class="form-label fw-bold">Text Size: {{ fontSize }}px</label>
                      <input 
                        type="range" 
                        class="form-range" 
                        min="14" 
                        max="28" 
                        v-model="fontSize">
                      <p class="mt-2 p-3 bg-light rounded" :style="{ fontSize: fontSize + 'px' }">
                        Sample text at {{ fontSize }}px
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Contact Section -->
      <section class="my-5 py-5">
        <div class="container">
          <div class="row">
            <div class="col-lg-8 mx-auto">
              <div class="card shadow-lg border-0">
                <div class="card-body p-5 text-center">
                  <h2 class="display-6 fw-bold mb-4">Get in Touch</h2>
                  <p class="lead mb-4">
                    Have questions or want to learn more about SwinCom? 
                    <span v-show="firstName">{{ firstName }}, we'd</span>
                    <span v-show="!firstName">We'd</span>
                    love to hear from you.
                  </p>
                  
                  <div class="mb-4">
                    <input 
                      type="email" 
                      class="form-control form-control-lg mb-3" 
                      v-model="contactEmail"
                      placeholder="your.email@example.com">
                    <textarea 
                      class="form-control form-control-lg" 
                      rows="4"
                      v-model="contactMessage"
                      placeholder="Your message..."
                      maxlength="500"></textarea>
                    <small class="text-muted d-block mt-2">{{ contactMessage.length }} / 500 characters</small>
                  </div>
                  
                  <button 
                    class="btn btn-lg px-5 py-3"
                    :style="{ backgroundColor: accentColor, borderColor: accentColor, color: getContrastColor(accentColor) }"
                    :disabled="!contactEmail || !contactMessage"
                    @click="showContactPreview = !showContactPreview">
                    <i class="bi bi-envelope-fill me-2"></i>
                    {{ showContactPreview ? 'Hide Preview' : 'Preview Message' }}
                  </button>
                  
                  <div v-show="showContactPreview" class="alert alert-info mt-4 text-start">
                    <h5><i class="bi bi-eye-fill me-2"></i>Message Preview:</h5>
                    <hr>
                    <p><strong>From:</strong> {{ firstName || 'Guest' }} {{ lastName }} ({{ contactEmail }})</p>
                    <p><strong>Message:</strong></p>
                    <p class="mb-0">{{ contactMessage }}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Timer Section -->
      <section class="my-5 text-center">
        <p class="text-muted">
          <i class="bi bi-clock-fill me-2"></i>
          You've been exploring for <strong>{{ timeOnPage }}</strong> seconds
          <span v-show="firstName">, {{ firstName }}</span>!
        </p>
        <button @click="resetTimer" class="btn btn-sm btn-outline-secondary">
          <i class="bi bi-arrow-clockwise me-1"></i> Reset Timer
        </button>
      </section>
    </main>
  </div>
</template>

<script>
export default {
  name: 'About',
  data() {
    return {
      // Page Info
      pageTitle: 'About SwinCom',
      pageSubtitle: 'Where students and staff come together to build a community through competition',
      
      // User Info
      firstName: '',
      lastName: '',
      greetingMessage: '',
      personalizedMessage: '',
      
      // Hero Background Images
      heroImages: [
        'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=1600&h=900&fit=crop',
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=1600&h=900&fit=crop',
        'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=1600&h=900&fit=crop'
      ],
      selectedHeroImage: 0,
      
      // Theme Selection (Mountain/Ocean)
      selectedTheme: 'mountain',
      themeImages: {
        mountain: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&h=600&fit=crop',
        ocean: 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=1200&h=600&fit=crop',
        room: 'https://i.pinimg.com/1200x/da/ce/c7/dacec76d4a2f572ce3c9b6d9eec1a853.jpg' 
      },
      themeLabels: {
        mountain: 'Mountain - Reach New Heights',
        ocean: 'Ocean - Navigate with Ease',
        room: 'Room - Hehehe'
      },
      themeDescriptions: {
        mountain: 'Like climbing a mountain, SwinCom helps you reach new competitive heights with every challenge.',
        ocean: 'Navigate the waves of competition management with the calm efficiency of the ocean.',
        room:'idk'
      },
      
      // Features
      features: [
        {
          icon: 'bi bi-lightning-charge-fill',
          title: 'Lightning Fast',
          description: 'Built with Vue 3 and modern technologies for instant performance and real-time updates.',
          color: '#0d6efd'
        },
        {
          icon: 'bi bi-shield-check',
          title: 'Secure & Reliable',
          description: 'Your data is protected with enterprise-level security and automated backups.',
          color: '#198754'
        },
        {
          icon: 'bi bi-phone',
          title: 'Fully Responsive',
          description: 'Perfect experience on mobile, tablet, and desktop - manage competitions anywhere.',
          color: '#6f42c1'
        },
        {
          icon: 'bi bi-graph-up-arrow',
          title: 'Analytics Dashboard',
          description: 'Track participation, engagement, and competition metrics with beautiful visualizations.',
          color: '#dc3545'
        },
        {
          icon: 'bi bi-people-fill',
          title: 'Team Collaboration',
          description: 'Coordinate with organizers, judges, and participants seamlessly.',
          color: '#fd7e14'
        },
        {
          icon: 'bi bi-trophy-fill',
          title: 'Automated Results',
          description: 'Instant winner calculations and leaderboard updates in real-time.',
          color: '#ffc107'
        }
      ],
      
      // Statistics
      stats: [
        { 
          label: 'Active Competitions', 
          value: 42, 
          highlighted: false,
          icon: 'bi bi-trophy-fill'
        },
        { 
          label: 'Registered Users', 
          value: 1250, 
          highlighted: false,
          icon: 'bi bi-people-fill'
        },
        { 
          label: 'Events Managed', 
          value: 189, 
          highlighted: false,
          icon: 'bi bi-calendar-event-fill'
        }
      ],
      
      // Customization
      accentColor: '#0d6efd',
      fontSize: 16,
      
      // Platform Features
      platformFeatures: [
        { 
          name: 'Email Notifications', 
          description: 'Get instant updates about new competitions, registrations, and results',
          enabled: true,
          icon: 'bi bi-envelope-fill'
        },
        { 
          name: 'Live Scoreboards', 
          description: 'Real-time competition results with automatic updates',
          enabled: false,
          icon: 'bi bi-trophy'
        },
        { 
          name: 'Team Management', 
          description: 'Organize participants into teams and manage rosters easily',
          enabled: true,
          icon: 'bi bi-people'
        },
        { 
          name: 'Analytics Dashboard', 
          description: 'Detailed insights and metrics about your competitions',
          enabled: false,
          icon: 'bi bi-graph-up'
        },
        { 
          name: 'Mobile App Access', 
          description: 'Manage competitions on the go with our mobile app',
          enabled: false,
          icon: 'bi bi-phone'
        },
        { 
          name: 'API Integration', 
          description: 'Connect SwinCom with your existing systems via REST API',
          enabled: false,
          icon: 'bi bi-code-slash'
        }
      ],
      
      // Contact
      contactEmail: '',
      contactMessage: '',
      showContactPreview: false,
      
      // Timer
      timeOnPage: 0,
      timerInterval: null
    }
  },
  computed: {
    enabledFeaturesCount() {
      return this.platformFeatures.filter(f => f.enabled).length;
    }
  },
  methods: {
    updateGreeting() {
      if (this.firstName && this.lastName) {
        this.greetingMessage = `Welcome, ${this.firstName} ${this.lastName}! 🎉`;
        this.personalizedMessage = `We're excited to have you explore SwinCom. Discover how our platform transforms competition management.`;
      } else if (this.firstName) {
        this.greetingMessage = `Hi ${this.firstName}! 👋`;
        this.personalizedMessage = 'Thanks for stopping by! Feel free to explore all the interactive features.';
      } else if (this.lastName) {
        this.greetingMessage = `Welcome, ${this.lastName}! 🎉`;
        this.personalizedMessage = 'Great to see you! Add your first name for a personalized experience.';
      } else {
        this.greetingMessage = '';
        this.personalizedMessage = '';
      }
    },
    incrementStat(stat) {
      stat.value++;
      stat.highlighted = true;
      setTimeout(() => {
        stat.highlighted = false;
      }, 600);
    },
    getContrastColor(hexcolor) {
      const hex = hexcolor.replace('#', '');
      const r = parseInt(hex.substr(0, 2), 16);
      const g = parseInt(hex.substr(2, 2), 16);
      const b = parseInt(hex.substr(4, 2), 16);
      const brightness = (r * 299 + g * 587 + b * 114) / 1000;
      return brightness > 155 ? '#000000' : '#ffffff';
    },
    resetTimer() {
      this.timeOnPage = 0;
    },
    startTimer() {
      this.timerInterval = setInterval(() => {
        this.timeOnPage++;
      }, 1000);
    },
    cycleHeroImage() {
      setInterval(() => {
        this.selectedHeroImage = (this.selectedHeroImage + 1) % this.heroImages.length;
      }, 5000);
    }
  },
  mounted() {
    this.startTimer();
    this.cycleHeroImage();
  },
  beforeUnmount() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
    }
  }
}
</script>

<style scoped>
/* Hero Header */
.hero-header {
  min-height: 500px;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transition: background-image 1s ease-in-out;
}

.hero-overlay {
  background: linear-gradient(135deg, rgba(13, 110, 253, 0.85), rgba(111, 66, 193, 0.75));
}

@media (max-width: 768px) {
  .hero-header {
    min-height: 400px;
  }
}

/* Theme Image */
.theme-image {
  height: 400px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

/* Hover Effects */
.hover-lift {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.hover-lift:hover {
  transform: translateY(-10px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2) !important;
}

/* Feature Icons */
.feature-icon {
  transition: transform 0.3s ease;
}

.card:hover .feature-icon {
  transform: scale(1.1) rotate(5deg);
}

/* Smooth Transitions */
.card {
  transition: all 0.3s ease;
}

.form-check-input:checked {
  background-color: #198754;
  border-color: #198754;
}

/* Responsive Typography */
@media (max-width: 576px) {
  .display-3 {
    font-size: 2.5rem;
  }
  
  .display-5 {
    font-size: 2rem;
  }
  
  .display-6 {
    font-size: 1.75rem;
  }
}

/* Animation for stats */
@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

.border-primary.border-3 {
  animation: pulse 0.6s ease;
}

/* Radio button enhancements */
.form-check-input {
  cursor: pointer;
}

.form-check-label {
  cursor: pointer;
}

/* Footer links hover */
footer a:hover {
  color: #ffffff !important;
  transition: color 0.3s ease;
}
</style>