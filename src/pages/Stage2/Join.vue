<template>
  <div class="join-competition">
    <div class="container py-5">
      <div class="row justify-content-center">
        <div class="col-lg-8">
          <!-- Header -->
          <div class="mb-4">
            <h1 class="display-5 fw-bold mb-3">Register</h1>
            <p class="text-muted">
              Please respect our 
              <a href="#" @click.prevent="showGuidelinesModal = true" class="text-primary">
                community guidelines
              </a>.
            </p>
          </div>

          <div class="card shadow-sm">
            <div class="card-body p-4 p-md-5">
              <form @submit.prevent="handleSubmit">
                <!-- Team Status -->
                <div class="mb-4">
                  <label class="form-label fw-bold">
                    <span class="text-danger">*</span> Do you have teammates?
                  </label>
                  <div class="btn-group-toggle d-flex flex-wrap gap-2">
                    <label 
                      class="btn btn-outline-primary" 
                      :class="{ active: formData.teamStatus === 'solo' }">
                      <input 
                        type="radio" 
                        name="teamStatus" 
                        value="solo"
                        v-model="formData.teamStatus"
                        required>
                      <i class="bi bi-person-fill me-2"></i>Working solo
                    </label>
                    <label 
                      class="btn btn-outline-primary" 
                      :class="{ active: formData.teamStatus === 'looking' }">
                      <input 
                        type="radio" 
                        name="teamStatus" 
                        value="looking"
                        v-model="formData.teamStatus"
                        required>
                      <i class="bi bi-search me-2"></i>Looking for teammates
                    </label>
                    <label 
                      class="btn btn-outline-primary" 
                      :class="{ active: formData.teamStatus === 'have' }">
                      <input 
                        type="radio" 
                        name="teamStatus" 
                        value="have"
                        v-model="formData.teamStatus"
                        required>
                      <i class="bi bi-people-fill me-2"></i>Already have a team
                    </label>
                  </div>
                </div>

                <!-- Why Join -->
                <div class="mb-4">
                  <label for="whyJoin" class="form-label fw-bold">
                    Why do you want to join this competition?
                  </label>
                  <textarea 
                    id="whyJoin"
                    class="form-control" 
                    rows="4"
                    v-model="formData.whyJoin"
                    placeholder="Tell us about your motivation, goals, or what you hope to achieve..."
                    maxlength="500"></textarea>
                  <div class="form-text text-end">
                    {{ formData.whyJoin.length }} / 500 characters
                  </div>
                </div>

                <hr class="my-4">

                <!-- Contact Email -->
                <div class="mb-4">
                  <label for="email" class="form-label fw-bold">
                    <span class="text-danger">*</span> Your contact email:
                  </label>
                  <div class="form-text mb-2">(i.e. hello@swinburne.edu.vn)</div>
                  <input 
                    type="email" 
                    id="email"
                    class="form-control form-control-lg" 
                    v-model="formData.email"
                    placeholder="your.email@swinburne.edu.vn"
                    required>
                  <div v-if="errors.email" class="text-danger small mt-1">
                    {{ errors.email }}
                  </div>
                </div>

                <!-- Name -->
                <div class="mb-4">
                  <label for="name" class="form-label fw-bold">
                    <span class="text-danger">*</span> Your name:
                  </label>
                  <input 
                    type="text" 
                    id="name"
                    class="form-control form-control-lg" 
                    v-model="formData.name"
                    placeholder="Enter your full name"
                    required>
                  <div v-if="errors.name" class="text-danger small mt-1">
                    {{ errors.name }}
                  </div>
                </div>

                <!-- Student ID -->
                <div class="mb-4">
                  <label for="studentId" class="form-label fw-bold">
                    <span class="text-danger">*</span> Student ID:
                  </label>
                  <input 
                    type="text" 
                    id="studentId"
                    class="form-control form-control-lg" 
                    v-model="formData.studentId"
                    placeholder="e.g., 103456789"
                    required>
                  <div v-if="errors.studentId" class="text-danger small mt-1">
                    {{ errors.studentId }}
                  </div>
                  <div class="form-text">9 digits starting with 1</div>
                </div>

                <!-- Campus -->
                <div class="mb-4">
                  <label for="campus" class="form-label fw-bold">
                    <span class="text-danger">*</span> Campus:
                  </label>
                  <select 
                    id="campus"
                    class="form-select form-select-lg" 
                    v-model="formData.campus"
                    required>
                    <option value="">Select your campus</option>
                    <option value="Hanoi">Hanoi Campus</option>
                    <option value="HCMC">Ho Chi Minh City Campus</option>
                    <option value="Hawthorne">Hawthorne Campus</option>
                    <option value="Other">Other</option>
                  </select>
                  <div v-if="errors.campus" class="text-danger small mt-1">
                    {{ errors.campus }}
                  </div>
                </div>

                <hr class="my-4">

                <!-- Eligibility Requirements -->
                <div class="mb-4">
                  <h5 class="fw-bold mb-3">Eligibility requirements</h5>
                  
                  <div class="form-check mb-3">
                    <input 
                      class="form-check-input" 
                      type="checkbox" 
                      id="eligibilityAge"
                      v-model="formData.eligibility.age"
                      required>
                    <label class="form-check-label" for="eligibilityAge">
                      <span class="text-danger">*</span> I have read and agree to the eligibility requirements for this competition:
                      <ul class="mt-2 small text-muted">
                        <li>Above legal age of majority in country of residence</li>
                        <li>
                          Specific countries/territories may be excluded 
                          <i class="bi bi-info-circle text-primary" 
                             role="button"
                             @click="showEligibilityInfo = !showEligibilityInfo"></i>
                        </li>
                      </ul>
                    </label>
                  </div>

                  <div v-show="showEligibilityInfo" class="alert alert-info small">
                    <strong>Eligibility Information:</strong><br>
                    Please check the competition rules for specific country restrictions. 
                    Some competitions may have limitations based on local laws and regulations.
                  </div>

                  <div class="form-check">
                    <input 
                      class="form-check-input" 
                      type="checkbox" 
                      id="communityGuidelines"
                      v-model="formData.eligibility.guidelines"
                      required>
                    <label class="form-check-label" for="communityGuidelines">
                      <span class="text-danger">*</span> I agree to follow the 
                      <a href="#" @click.prevent="showGuidelinesModal = true" class="text-primary">Community Guidelines</a>
                    </label>
                  </div>
                </div>

                <!-- Action Buttons -->
                <div class="d-flex gap-3 mt-4">
                  <button 
                    type="submit" 
                    class="btn btn-primary btn-lg px-5"
                    @click="handleSubmit"
                    >
                    <i class="bi bi-check-circle me-2"></i>Register
                  </button>
                  <button 
                    type="button" 
                    class="btn btn-outline-secondary btn-lg"
                    @click="handleCancel">
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Community Guidelines Modal -->
    <CommunityGuidelinesModal 
      v-if="showGuidelinesModal"
      @close="showGuidelinesModal = false" />
  </div>
</template>

<script>
import CommunityGuidelinesModal from '../../components/CommunityGuidelinesModal.vue'

export default {
    
  name: 'Join',
  components:{
    CommunityGuidelinesModal
  },
  data() {
    return {
      formData: {
        teamStatus: '',
        whyJoin: '',
        email: '',
        name: '',
        studentId: '',
        campus: '',
        eligibility: {
          age: false,
          terms: false,
          guidelines: false
        }
      },
      errors: {},
      showGuidelinesModal: false,
      showRulesModal: false,
      showTermsModal: false,
      showEligibilityInfo: false
    }
  },
  methods: {
    handleSubmit() {
      this.errors = {}
      
      // Validate email
      if (!this.validateEmail(this.formData.email)) {
        this.errors.email = 'Please enter a valid email address'
        return
      }

      // Validate name
      if (!this.formData.name.trim()) {
        this.errors.name = 'Name is required'
        return
      }

      // Validate student ID
      if (!this.formData.studentId.trim()) {
        this.errors.studentId = 'Student ID is required'
        return
      }

      if (!/^\d{9}$/.test(this.formData.studentId)) {
        this.errors.studentId = 'Student ID must be exactly 9 digits'
        return
      }

      if (this.formData.studentId[0] !== '1') {
        this.errors.studentId = 'Student ID must start with 1'
        return
      }

      // Validate campus
      if (!this.formData.campus) {
        this.errors.campus = 'Campus is required'
        return
      }
      alert('Registration successful! You will receive a confirmation email shortly.')
      
      this.$router.push({
        name: 'CompetitionDetail',
        params: { id: this.$route.params.id },
      })
    },
    handleCancel() {
      if (confirm('Are you sure you want to cancel registration?')) {
        this.$router.back()
      }
    },
    validateEmail(email) {
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      return re.test(email)
    }
  }
}
</script>

<style scoped>
/* Team Status Buttons */
.btn-group-toggle .btn {
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-group-toggle input[type="radio"] {
  display: none;
}

.btn-group-toggle .btn.active {
  background-color: #0d6efd;
  color: white;
  border-color: #0d6efd;
}

/* Form Styles */
.form-control:focus,
.form-select:focus {
  border-color: #0d6efd;
  box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
}

.form-check-input:checked {
  background-color: #0d6efd;
  border-color: #0d6efd;
}

/* Modal Styles */
.modal {
  background-color: rgba(0, 0, 0, 0.5);
}

.modal.show {
  display: block;
}

.modal-backdrop {
  z-index: 1040;
}

.modal {
  z-index: 1050;
}

/* Responsive */
@media (max-width: 768px) {
  .btn-group-toggle {
    flex-direction: column;
  }
  
  .btn-group-toggle .btn {
    width: 100%;
  }
}
</style>