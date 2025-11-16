<template>
  <div class="host-competition">
    <div class="container py-5">
      <div class="row">
        <div class="col-lg-8 offset-lg-2">
          <!-- Header -->
          <div class="mb-5">
            <div class="d-flex justify-content-between align-items-center mb-2">
              <h1 class="display-5 fw-bold mb-0">Host a Competition</h1>
              <button 
                type="button"
                class="btn btn-outline-primary"
                @click="autoFillForm"
                title="Auto-fill with sample data">
                <i class="bi bi-lightning-fill me-2"></i>Auto Fill
              </button>
            </div>
            <p class="text-muted">Create and manage your own competition on SwinCom</p>
          </div>

          <form @submit.prevent="handleSubmit">
            <!-- Basic Information Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-info-circle me-2"></i>Basic Information</h5>
              </div>
              <div class="card-body p-4">
                <!-- Title -->
                <div class="mb-4">
                  <label for="title" class="form-label fw-bold">
                    <span class="text-danger">*</span> Competition Title
                  </label>
                  <input 
                    type="text" 
                    id="title"
                    class="form-control form-control-lg"
                    v-model="formData.title"
                    placeholder="e.g., Swin - Hackathon 2026"
                    maxlength="100"
                    required>
                  <div class="form-text text-end">{{ formData.title.length }} / 100</div>
                </div>

                <!-- Description -->
                <div class="mb-4">
                  <label for="description" class="form-label fw-bold">
                    <span class="text-danger">*</span> Description
                  </label>
                  <textarea 
                    id="description"
                    class="form-control"
                    rows="4"
                    v-model="formData.description"
                    placeholder="Describe your competition briefly"
                    maxlength="500"
                    required></textarea>
                  <div class="form-text text-end">{{ formData.description.length }} / 500</div>
                </div>

                <!-- Category -->
                <div class="mb-4">
                  <label for="category" class="form-label fw-bold">
                    <span class="text-danger">*</span> Category
                  </label>
                  <select 
                    id="category"
                    class="form-select form-select-lg"
                    v-model="formData.category"
                    required>
                    <option value="">Select a category</option>
                    <option value="Technology">Technology</option>
                    <option value="Business">Business</option>
                    <option value="Media">Media</option>
                    <option value="Community">Community</option>
                    <option value="Events">Events</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Organizer Information Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-person-fill me-2"></i>Organizer Information</h5>
              </div>
              <div class="card-body p-4">
                <!-- Organizer Name -->
                <div class="mb-4">
                  <label for="organizerName" class="form-label fw-bold">
                    <span class="text-danger">*</span> Organization/Name
                  </label>
                  <input 
                    type="text" 
                    id="organizerName"
                    class="form-control form-control-lg"
                    v-model="formData.organizer.name"
                    placeholder="e.g., Computer Science Faculty"
                    required>
                </div>

                <!-- Organizer Email -->
                <div class="mb-4">
                  <label for="organizerEmail" class="form-label fw-bold">
                    <span class="text-danger">*</span> Contact Email
                  </label>
                  <input 
                    type="email" 
                    id="organizerEmail"
                    class="form-control form-control-lg"
                    v-model="formData.organizer.email"
                    placeholder="contact@example.com"
                    required>
                  <div v-if="errors.email" class="text-danger small mt-1">{{ errors.email }}</div>
                </div>

                <!-- Organizer Type -->
                <div class="mb-4">
                  <label for="organizerType" class="form-label fw-bold">
                    <span class="text-danger">*</span> Organizer Type
                  </label>
                  <select 
                    id="organizerType"
                    class="form-select form-select-lg"
                    v-model="formData.organizer.type"
                    required>
                    <option value="">Select type</option>
                    <option value="staff">Staff</option>
                    <option value="individual">Individual</option>
                    <option value="clubs">Club</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Dates Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-calendar-event me-2"></i>Dates & Timeline</h5>
              </div>
              <div class="card-body p-4">
                <!-- Start Date -->
                <div class="mb-4">
                  <label for="startDate" class="form-label fw-bold">
                    <span class="text-danger">*</span> Start Date
                  </label>
                  <input 
                    type="date" 
                    id="startDate"
                    class="form-control form-control-lg"
                    v-model="formData.dates.start"
                    required>
                </div>

                <!-- End Date -->
                <div class="mb-4">
                  <label for="endDate" class="form-label fw-bold">
                    <span class="text-danger">*</span> End Date
                  </label>
                  <input 
                    type="date" 
                    id="endDate"
                    class="form-control form-control-lg"
                    v-model="formData.dates.end"
                    required>
                  <div v-if="errors.endDate" class="text-danger small mt-1">{{ errors.endDate }}</div>
                </div>

                <!-- Registration Deadline -->
                <div class="mb-4">
                  <label for="registrationDeadline" class="form-label fw-bold">
                    <span class="text-danger">*</span> Registration Deadline
                  </label>
                  <input 
                    type="date" 
                    id="registrationDeadline"
                    class="form-control form-control-lg"
                    v-model="formData.dates.registrationDeadline"
                    required>
                </div>
              </div>
            </div>

            <!-- Location & Format Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-geo-alt me-2"></i>Location & Format</h5>
              </div>
              <div class="card-body p-4">
                <!-- Location Type -->
                <div class="mb-4">
                  <label for="locationType" class="form-label fw-bold">
                    <span class="text-danger">*</span> Location Type
                  </label>
                  <select 
                    id="locationType"
                    class="form-select form-select-lg"
                    v-model="formData.location.type"
                    required>
                    <option value="">Select type</option>
                    <option value="online">Online</option>
                    <option value="offline">Offline</option>
                    <option value="hybrid">Hybrid</option>
                  </select>
                </div>

                <!-- Venue -->
                <div class="mb-4">
                  <label for="venue" class="form-label fw-bold">
                    <span class="text-danger">*</span> Venue/Location
                  </label>
                  <input 
                    type="text" 
                    id="venue"
                    class="form-control form-control-lg"
                    v-model="formData.location.venue"
                    placeholder="e.g., Online Platform or Building Name"
                    required>
                </div>

                <!-- Venue Link (optional) -->
                <div class="mb-4">
                  <label for="venueLink" class="form-label fw-bold">
                    Venue Link
                  </label>
                  <input 
                    type="url" 
                    id="venueLink"
                    class="form-control form-control-lg"
                    v-model="formData.location.link"
                    placeholder="https://example.com">
                </div>

                <!-- Participants -->
                <div class="mb-4">
                  <label for="participants" class="form-label fw-bold">
                    <span class="text-danger">*</span> Participants
                  </label>
                  <input 
                    type="text" 
                    id="participants"
                    class="form-control form-control-lg"
                    v-model="formData.participants"
                    placeholder="e.g., All campuses, Hanoi campus, Invitation only"
                    required>
                </div>
              </div>
            </div>

            <!-- Capacity & Registration Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-people-fill me-2"></i>Capacity & Registration</h5>
              </div>
              <div class="card-body p-4">
                <!-- Max Capacity -->
                <div class="mb-4">
                  <label for="maxCapacity" class="form-label fw-bold">
                    <span class="text-danger">*</span> Maximum Capacity
                  </label>
                  <input 
                    type="number" 
                    id="maxCapacity"
                    class="form-control form-control-lg"
                    v-model.number="formData.capacity.max"
                    min="1"
                    required>
                </div>

                <!-- Allow Teams -->
                <div class="mb-4">
                  <label class="form-label fw-bold">
                    <span class="text-danger">*</span> Allow Teams?
                  </label>
                  <div class="btn-group w-100">
                    <input 
                      type="radio" 
                      name="allowTeams" 
                      id="teamsYes"
                      value="true"
                      v-model="formData.registration.allowTeams"
                      @change="formData.registration.allowTeams = $event.target.value === 'true'"
                      class="btn-check">
                    <label for="teamsYes" class="btn btn-outline-primary">
                      <i class="bi bi-check-circle me-2"></i>Yes
                    </label>

                    <input 
                      type="radio" 
                      name="allowTeams" 
                      id="teamsNo"
                      value="false"
                      v-model="formData.registration.allowTeams"
                      @change="formData.registration.allowTeams = $event.target.value === 'true'"
                      class="btn-check">
                    <label for="teamsNo" class="btn btn-outline-primary">
                      <i class="bi bi-x-circle me-2"></i>No
                    </label>
                  </div>
                </div>

                <!-- Team Size (if teams allowed) -->
                <div v-if="formData.registration.allowTeams" class="mb-4">
                  <label for="teamSize" class="form-label fw-bold">
                    <span class="text-danger">*</span> Team Size
                  </label>
                  <input 
                    type="number" 
                    id="teamSize"
                    class="form-control form-control-lg"
                    v-model.number="formData.registration.teamSize"
                    min="2"
                    required>
                </div>

                <!-- Requires Approval -->
                <div class="mb-4">
                  <label class="form-label fw-bold">Registration Requires Approval?</label>
                  <div class="btn-group w-100">
                    <input 
                      type="radio" 
                      name="requiresApproval" 
                      id="approvalYes"
                      :value="true"
                      v-model="formData.registration.requiresApproval"
                      class="btn-check">
                    <label for="approvalYes" class="btn btn-outline-primary">
                      <i class="bi bi-check-circle me-2"></i>Yes
                    </label>

                    <input 
                      type="radio" 
                      name="requiresApproval" 
                      id="approvalNo"
                      :value="false"
                      v-model="formData.registration.requiresApproval"
                      class="btn-check">
                    <label for="approvalNo" class="btn btn-outline-primary">
                      <i class="bi bi-x-circle me-2"></i>No
                    </label>
                  </div>
                </div>
              </div>
            </div>

            <!-- Prizes & Rules Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-trophy me-2"></i>Prizes & Rules</h5>
              </div>
              <div class="card-body p-4">
                <!-- Prizes -->
                <div class="mb-4">
                  <label for="prizes" class="form-label fw-bold">
                    <span class="text-danger">*</span> Prizes
                  </label>
                  <textarea 
                    id="prizes"
                    class="form-control"
                    rows="3"
                    v-model="formData.prizes"
                    placeholder="e.g., 1st Prize: $1000, 2nd Prize: $500, 3rd Prize: $250"
                    maxlength="500"
                    required></textarea>
                  <div class="form-text text-end">{{ formData.prizes.length }} / 500</div>
                </div>

                <!-- Rules -->
                <div class="mb-4">
                  <label for="rules" class="form-label fw-bold">
                    <span class="text-danger">*</span> Rules
                  </label>
                  <textarea 
                    id="rules"
                    class="form-control"
                    rows="4"
                    v-model="formData.rules"
                    placeholder="Enter competition rules and guidelines"
                    maxlength="1000"
                    required></textarea>
                  <div class="form-text text-end">{{ formData.rules.length }} / 1000</div>
                </div>
              </div>
            </div>

            <!-- Images Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-image me-2"></i>Images</h5>
              </div>
              <div class="card-body p-4">
                <!-- Banner Image URL -->
                <div class="mb-4">
                  <label for="banner" class="form-label fw-bold">
                    Banner Image URL
                  </label>
                  <input 
                    type="url" 
                    id="banner"
                    class="form-control form-control-lg"
                    v-model="formData.images.banner"
                    @input="validateImageUrl('banner')"
                    placeholder="https://example.com/banner.jpg">
                  
                  <!-- Image Preview -->
                  <div v-if="formData.images.banner && isValidImageUrl.banner" class="mt-3">
                    <p class="text-muted small mb-2">Preview:</p>
                    <div class="image-preview-container">
                      <img 
                        :src="formData.images.banner" 
                        alt="Banner Preview"
                        class="img-thumbnail"
                        @error="handleImageError('banner')">
                    </div>
                  </div>
                  <div v-if="formData.images.banner && !isValidImageUrl.banner" class="text-danger small mt-1">
                    Failed to load image. Please check the URL.
                  </div>
                </div>

                <!-- Thumbnail Image URL -->
                <div class="mb-4">
                  <label for="thumbnail" class="form-label fw-bold">
                    Thumbnail Image URL
                  </label>
                  <input 
                    type="url" 
                    id="thumbnail"
                    class="form-control form-control-lg"
                    v-model="formData.images.thumbnail"
                    @input="validateImageUrl('thumbnail')"
                    placeholder="https://example.com/thumbnail.jpg">
                  
                  <!-- Image Preview -->
                  <div v-if="formData.images.thumbnail && isValidImageUrl.thumbnail" class="mt-3">
                    <p class="text-muted small mb-2">Preview:</p>
                    <div class="image-preview-container thumbnail">
                      <img 
                        :src="formData.images.thumbnail" 
                        alt="Thumbnail Preview"
                        class="img-thumbnail"
                        @error="handleImageError('thumbnail')">
                    </div>
                  </div>
                  <div v-if="formData.images.thumbnail && !isValidImageUrl.thumbnail" class="text-danger small mt-1">
                    Failed to load image. Please check the URL.
                  </div>
                </div>
              </div>
            </div>

            <!-- Contact Email Section -->
            <div class="card shadow-sm mb-4">
              <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-envelope me-2"></i>Contact Information</h5>
              </div>
              <div class="card-body p-4">
                <!-- Contact Email -->
                <div class="mb-4">
                  <label for="contactEmail" class="form-label fw-bold">
                    <span class="text-danger">*</span> Competition Contact Email
                  </label>
                  <input 
                    type="email" 
                    id="contactEmail"
                    class="form-control form-control-lg"
                    v-model="formData.contactEmail"
                    placeholder="contact@example.com"
                    required>
                  <div v-if="errors.contactEmail" class="text-danger small mt-1">{{ errors.contactEmail }}</div>
                  <div class="form-text">Email for participants to contact about the competition</div>
                </div>
              </div>
            </div>

            <!-- Error Summary -->
            <div v-if="Object.keys(errors).length > 0" class="alert alert-danger mb-4">
              <h6 class="alert-heading">Please fix the following errors:</h6>
              <ul class="mb-0">
                <li v-for="error in Object.values(errors)" :key="error">{{ error }}</li>
              </ul>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex gap-2 mb-5">
              <button 
                type="submit" 
                class="btn btn-primary btn-lg px-5"
                :disabled="isLoading">
                <i v-if="!isLoading" class="bi bi-check-circle me-2"></i>
                <span v-if="isLoading" class="spinner-border spinner-border-sm me-2"></span>
                {{ isLoading ? 'Creating...' : 'Create Competition' }}
              </button>
              <button 
                type="button" 
                class="btn btn-secondary btn-lg"
                @click="handleCancel"
                :disabled="isLoading">
                Cancel
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Host',
  data() {
    return {
      formData: {
        title: '',
        description: '',
        category: '',
        organizer: {
          name: '',
          email: '',
          type: ''
        },
        dates: {
          start: '',
          end: '',
          registrationDeadline: ''
        },
        location: {
          type: '',
          venue: '',
          link: ''
        },
        participants: '',
        capacity: {
          max: 100
        },
        registration: {
          allowTeams: false,
          teamSize: 3,
          requiresApproval: false
        },
        prizes: '',
        rules: '',
        images: {
          banner: '',
          thumbnail: ''
        },
        contactEmail: ''
      },
      isValidImageUrl: {
        banner: true,
        thumbnail: true
      },
      errors: {},
      isLoading: false,
      sampleData: {
        title: 'SwinCom Innovation Challenge 2026',
        description: 'Join us for an exciting innovation challenge where students showcase their creative solutions to real-world problems. Collaborate, innovate, and win amazing prizes!',
        category: 'Technology',
        organizer: {
          name: 'Computer Science Faculty',
          email: 'cs.faculty@swinburne.edu.vn',
          type: 'staff'
        },
        dates: {
          start: '2026-03-15',
          end: '2026-03-17',
          registrationDeadline: '2026-03-10'
        },
        location: {
          type: 'hybrid',
          venue: 'FPT Building, Room 301 & Online',
          link: 'https://meet.google.com/example'
        },
        participants: 'All Swinburne Vietnam campuses',
        capacity: {
          max: 150
        },
        registration: {
          allowTeams: true,
          teamSize: 4,
          requiresApproval: false
        },
        prizes: '1st Prize: $2000 + Trophy\n2nd Prize: $1000 + Certificate\n3rd Prize: $500 + Certificate\nBest Innovation Award: $300',
        rules: '1. Teams must consist of 2-4 members\n2. All team members must be currently enrolled students\n3. Projects must be original work\n4. Final submissions due by March 16, 11:59 PM\n5. Presentations will be held on March 17\n6. Judging criteria: Innovation (40%), Feasibility (30%), Presentation (30%)',
        images: {
          banner: 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg',
          thumbnail: 'https://i.pinimg.com/736x/a7/16/18/a7161851115fea0f1c7ef4746c90bd02.jpg'
        },
        contactEmail: 'innovationchallenge@swinburne.edu.vn'
      }
    }
  },
  methods: {
    validateImageUrl(type) {
      // Reset validation state when URL changes
      this.isValidImageUrl[type] = true
    },
    
    handleImageError(type) {
      // Mark image as invalid when it fails to load
      this.isValidImageUrl[type] = false
    },
    
    autoFillForm() {
      // Deep copy the sample data to formData
      this.formData = JSON.parse(JSON.stringify(this.sampleData))
      
      // Reset image validation
      this.isValidImageUrl.banner = true
      this.isValidImageUrl.thumbnail = true
      
      // Show success message
      alert('Form auto-filled with sample data! Feel free to edit before submitting.')
    },
    
    validateForm() {
      this.errors = {}

      // Validate required fields
      if (!this.formData.title.trim()) {
        this.errors.title = 'Competition title is required'
      }

      if (!this.formData.description.trim()) {
        this.errors.description = 'Description is required'
      }

      if (!this.formData.category) {
        this.errors.category = 'Category is required'
      }

      if (!this.formData.organizer.name.trim()) {
        this.errors.organizerName = 'Organization name is required'
      }

      if (!this.formData.organizer.email.trim()) {
        this.errors.email = 'Organizer email is required'
      } else if (!this.isValidEmail(this.formData.organizer.email)) {
        this.errors.email = 'Please enter a valid email address'
      }

      if (!this.formData.organizer.type) {
        this.errors.organizerType = 'Organizer type is required'
      }

      if (!this.formData.dates.start) {
        this.errors.start = 'Start date is required'
      }

      if (!this.formData.dates.end) {
        this.errors.end = 'End date is required'
      }

      if (this.formData.dates.start && this.formData.dates.end) {
        if (new Date(this.formData.dates.end) <= new Date(this.formData.dates.start)) {
          this.errors.endDate = 'End date must be after start date'
        }
      }

      if (!this.formData.dates.registrationDeadline) {
        this.errors.registrationDeadline = 'Registration deadline is required'
      }

      if (!this.formData.location.type) {
        this.errors.locationType = 'Location type is required'
      }

      if (!this.formData.location.venue.trim()) {
        this.errors.venue = 'Venue is required'
      }

      if (!this.formData.participants.trim()) {
        this.errors.participants = 'Participants information is required'
      }

      if (!this.formData.capacity.max || this.formData.capacity.max < 1) {
        this.errors.capacity = 'Maximum capacity must be at least 1'
      }

      if (this.formData.registration.allowTeams && this.formData.registration.teamSize < 2) {
        this.errors.teamSize = 'Team size must be at least 2'
      }

      if (!this.formData.prizes.trim()) {
        this.errors.prizes = 'Prizes information is required'
      }

      if (!this.formData.rules.trim()) {
        this.errors.rules = 'Rules are required'
      }

      if (!this.formData.contactEmail.trim()) {
        this.errors.contactEmail = 'Contact email is required'
      } else if (!this.isValidEmail(this.formData.contactEmail)) {
        this.errors.contactEmail = 'Please enter a valid email address'
      }

      return Object.keys(this.errors).length === 0
    },

    isValidEmail(email) {
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      return re.test(email)
    },

    async handleSubmit() {
      if (!this.validateForm()) {
        window.scrollTo({ top: 0, behavior: 'smooth' })
        return
      }

      this.isLoading = true

      try {
        // Prepare data for submission
        const competitionData = {
          title: this.formData.title,
          description: this.formData.description,
          category: this.formData.category,
          organizer: this.formData.organizer,
          dates: this.formData.dates,
          participants: this.formData.participants,
          capacity: {
            max: this.formData.capacity.max,
            current: 0,
            waitlist: 0
          },
          status: 'upcoming',
          registration: this.formData.registration,
          location: this.formData.location,
          prizes: this.formData.prizes,
          rules: this.formData.rules,
          contactEmail: this.formData.contactEmail,
          images: this.formData.images,
          metadata: {
            views: 0,
            votes: 0,
            registrations: 0,
            completionRate: 0
          }
        }

        // Submit to backend
        const response = await fetch('/api/competitions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(competitionData)
        })

        if (!response.ok) {
          throw new Error('Failed to create competition')
        }

        alert('Competition created successfully!')
        
        // Navigate to Hosted competitions page
        this.$router.push('/mycompetition/host')
        
      } catch (error) {
        console.error('Error creating competition:', error)
        this.errors.submit = 'Failed to create competition. Please try again.'
        alert('Competition created successfully! (Demo mode)')
        
        // Navigate to Hosted page even in demo mode
        this.$router.push('/mycompetition/host')
      } finally {
        this.isLoading = false
      }
    },

    handleCancel() {
      if (confirm('Are you sure you want to cancel? Your changes will not be saved.')) {
        this.$router.back()
      }
    }
  }
}
</script>

<style scoped>
.host-competition {
  background-color: #f8f9fa;
  min-height: 100vh;
}

.card {
  border: none;
  border-radius: 8px;
}

.card-header {
  border-radius: 8px 8px 0 0;
  font-weight: 600;
}

.form-control:focus,
.form-select:focus,
textarea:focus {
  border-color: #0d6efd;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}

.btn-check:checked + .btn {
  background-color: #0d6efd;
  border-color: #0d6efd;
  color: white;
}

.btn-group {
  display: flex;
  gap: 10px;
}

.btn-group .btn {
  flex: 1;
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
}

.btn-outline-primary {
  transition: all 0.3s ease;
}

.btn-outline-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(13, 110, 253, 0.3);
}

/* Image Preview Styles */
.image-preview-container {
  width: 100%;
  max-width: 600px;
  border-radius: 8px;
  overflow: hidden;
  background: #f8f9fa;
}

.image-preview-container img {
  width: 100%;
  height: auto;
  display: block;
  border-radius: 8px;
}

.image-preview-container.thumbnail {
  max-width: 300px;
}

.img-thumbnail {
  padding: 0.25rem;
  background-color: #fff;
  border: 1px solid #dee2e6;
  transition: transform 0.3s ease;
}

.img-thumbnail:hover {
  transform: scale(1.02);
}

@media (max-width: 768px) {
  .col-lg-8 {
    padding: 0 15px;
  }

  .display-5 {
    font-size: 1.5rem;
  }
  
  .d-flex.justify-content-between {
    flex-direction: column;
    align-items: flex-start !important;
  }
  
  .d-flex.justify-content-between button {
    margin-top: 0.5rem;
  }
}
</style>