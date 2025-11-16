<template>
  <div class="signup-page">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
          <div class="signup-card card-elevated">
            <div class="text-center mb-4">
              <i class="bi bi-compass-fill fs-1 text-primary"></i>
              <h2 class="title-section mt-2">Join SwinCom</h2>
              <p class="text-muted">Create your account to get started</p>
            </div>

            <!-- Alert messages -->
            <div v-if="error" class="alert alert-danger alert-dismissible fade show" role="alert">
              <i class="bi bi-exclamation-circle-fill me-2"></i>
              {{ error }}
              <button type="button" class="btn-close" @click="error = null"></button>
            </div>

            <div v-if="successMessage" class="alert alert-success alert-dismissible fade show" role="alert">
              <i class="bi bi-check-circle-fill me-2"></i>
              {{ successMessage }}
              <button type="button" class="btn-close" @click="successMessage = null"></button>
            </div>

            <!-- Sign Up Form -->
            <form @submit.prevent="handleSignUp">
              <div class="row">
                <div class="col-md-6 mb-3">
                  <label for="firstName" class="form-label">First Name</label>
                  <input
                    type="text"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.firstName }"
                    id="firstName"
                    v-model="formData.firstName"
                    placeholder="Enter first name"
                    @blur="validateFirstName"
                    required
                  />
                  <div v-if="validationErrors.firstName" class="text-danger small mt-1">
                    {{ validationErrors.firstName }}
                  </div>
                </div>
                <div class="col-md-6 mb-3">
                  <label for="lastName" class="form-label">Last Name</label>
                  <input
                    type="text"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.lastName }"
                    id="lastName"
                    v-model="formData.lastName"
                    placeholder="Enter last name"
                    @blur="validateLastName"
                    required
                  />
                  <div v-if="validationErrors.lastName" class="text-danger small mt-1">
                    {{ validationErrors.lastName }}
                  </div>
                </div>
              </div>

              <div class="mb-3">
                <label for="email" class="form-label">Email address</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-envelope"></i>
                  </span>
                  <input
                    type="email"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.email }"
                    id="email"
                    v-model="formData.email"
                    placeholder="Enter your email"
                    @blur="validateEmail"
                    required
                  />
                </div>
                <div v-if="validationErrors.email" class="text-danger small mt-1">
                  {{ validationErrors.email }}
                </div>
              </div>

              <div class="mb-3">
                <label for="phone" class="form-label">Phone Number</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-telephone"></i>
                  </span>
                  <input
                    type="tel"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.phone }"
                    id="phone"
                    v-model="formData.phone"
                    placeholder="Enter 11-digit phone number"
                    @input="formatPhone"
                    @blur="validatePhone"
                    maxlength="11"
                    required
                  />
                </div>
                <div v-if="validationErrors.phone" class="text-danger small mt-1">
                  {{ validationErrors.phone }}
                </div>
              </div>

              <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                  <span class="input-group-text">
                    <i class="bi bi-lock"></i>
                  </span>
                  <input
                    :type="showPassword ? 'text' : 'password'"
                    class="form-control"
                    :class="{ 'is-invalid': validationErrors.password }"
                    id="password"
                    v-model="formData.password"
                    placeholder="Create a password"
                    @blur="validatePassword"
                    required
                  />
                  <button
                    class="btn btn-outline-secondary"
                    type="button"
                    @click="showPassword = !showPassword"
                  >
                    <i :class="showPassword ? 'bi bi-eye-slash' : 'bi bi-eye'"></i>
                  </button>
                </div>
                <div v-if="validationErrors.password" class="text-danger small mt-1">
                  {{ validationErrors.password }}
                </div>
              </div>

              <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <input
                  :type="showPassword ? 'text' : 'password'"
                  class="form-control"
                  :class="{ 'is-invalid': validationErrors.confirmPassword }"
                  id="confirmPassword"
                  v-model="formData.confirmPassword"
                  placeholder="Confirm your password"
                  @blur="validateConfirmPassword"
                  required
                />
                <div v-if="validationErrors.confirmPassword" class="text-danger small mt-1">
                  {{ validationErrors.confirmPassword }}
                </div>
              </div>

              <div class="mb-3">
                <label for="gender" class="form-label">Gender</label>
                <select
                  class="form-select"
                  :class="{ 'is-invalid': validationErrors.gender }"
                  id="gender"
                  v-model="formData.gender"
                  @blur="validateGender"
                  required
                >
                  <option value="" disabled>Select gender</option>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
                  <option value="Other">Other</option>
                </select>
                <div v-if="validationErrors.gender" class="text-danger small mt-1">
                  {{ validationErrors.gender }}
                </div>
              </div>

              <div class="mb-3 form-check">
                <input
                  type="checkbox"
                  class="form-check-input"
                  :class="{ 'is-invalid': validationErrors.agreeToTerms }"
                  id="terms"
                  v-model="formData.agreeToTerms"
                  @change="validateTerms"
                  required
                />
                <label class="form-check-label" for="terms">
                  I agree to the <a href="#" class="text-primary">Terms and Conditions</a>
                </label>
                <div v-if="validationErrors.agreeToTerms" class="text-danger small mt-1">
                  {{ validationErrors.agreeToTerms }}
                </div>
              </div>

              <button type="submit" class="btn btn-primary w-100 mb-3" :disabled="loading || !isFormValid">
                <span v-if="loading">
                  <span class="spinner-border spinner-border-sm me-2" role="status"></span>
                  Creating account...
                </span>
                <span v-else>
                  <i class="bi bi-person-plus me-2"></i>
                  Sign Up
                </span>
              </button>
            </form>

            <div class="text-center mt-3">
              <p class="text-muted">
                Already have an account?
                <router-link to="/signin" class="text-primary fw-bold">Login</router-link>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'SignUp',
  data() {
    return {
      formData: {
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        password: '',
        confirmPassword: '',
        gender: '',
        agreeToTerms: false,
      },
      showPassword: false,
      error: null,
      successMessage: null,
      loading: false,
      validationErrors: {
        firstName: null,
        lastName: null,
        email: null,
        phone: null,
        password: null,
        confirmPassword: null,
        gender: null,
        agreeToTerms: null,
      },
    }
  },
  computed: {
    isFormValid() {
      return (
        this.formData.firstName &&
        this.formData.lastName &&
        this.formData.email &&
        this.formData.phone &&
        this.formData.password &&
        this.formData.confirmPassword &&
        this.formData.gender &&
        this.formData.agreeToTerms &&
        !this.validationErrors.firstName &&
        !this.validationErrors.lastName &&
        !this.validationErrors.email &&
        !this.validationErrors.phone &&
        !this.validationErrors.password &&
        !this.validationErrors.confirmPassword &&
        !this.validationErrors.gender &&
        !this.validationErrors.agreeToTerms
      )
    },
  },
  methods: {
    ...mapActions('auth', ['register']),

    validateFirstName() {
      this.validationErrors.firstName = null
      if (!this.formData.firstName) {
        this.validationErrors.firstName = 'First name is required'
        return false
      }
      if (this.formData.firstName.length < 2) {
        this.validationErrors.firstName = 'First name must be at least 2 characters'
        return false
      }
      return true
    },

    validateLastName() {
      this.validationErrors.lastName = null
      if (!this.formData.lastName) {
        this.validationErrors.lastName = 'Last name is required'
        return false
      }
      if (this.formData.lastName.length < 2) {
        this.validationErrors.lastName = 'Last name must be at least 2 characters'
        return false
      }
      return true
    },

    validateEmail() {
      this.validationErrors.email = null

      if (!this.formData.email) {
        this.validationErrors.email = 'Email is required'
        return false
      }

      if (!this.formData.email.includes('@')) {
        this.validationErrors.email = 'Email must contain @'
        return false
      }

      // More comprehensive email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(this.formData.email)) {
        this.validationErrors.email = 'Please enter a valid email address'
        return false
      }

      return true
    },

    formatPhone(event) {
      // Remove all non-numeric characters
      this.formData.phone = this.formData.phone.replace(/\D/g, '')
    },

    validatePhone() {
      this.validationErrors.phone = null

      if (!this.formData.phone) {
        this.validationErrors.phone = 'Phone number is required'
        return false
      }

      // Check if phone contains only digits
      if (!/^\d+$/.test(this.formData.phone)) {
        this.validationErrors.phone = 'Phone number must contain only digits'
        return false
      }

      // Check if phone is exactly 11 digits
      if (this.formData.phone.length !== 11) {
        this.validationErrors.phone = 'Phone number must be exactly 11 digits'
        return false
      }

      return true
    },

    validatePassword() {
      this.validationErrors.password = null

      if (!this.formData.password) {
        this.validationErrors.password = 'Password is required'
        return false
      }

      // Check minimum 8 characters
      if (this.formData.password.length < 8) {
        this.validationErrors.password = 'Password must be at least 8 characters'
        return false
      }

      // Check for initial capital letter
      if (!/^[A-Z]/.test(this.formData.password)) {
        this.validationErrors.password = 'Password must start with a capital letter'
        return false
      }

      // Check for at least one symbol
      if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(this.formData.password)) {
        this.validationErrors.password = 'Password must contain at least one symbol'
        return false
      }

      return true
    },

    validateConfirmPassword() {
      this.validationErrors.confirmPassword = null

      if (!this.formData.confirmPassword) {
        this.validationErrors.confirmPassword = 'Please confirm your password'
        return false
      }

      if (this.formData.password !== this.formData.confirmPassword) {
        this.validationErrors.confirmPassword = 'Passwords do not match'
        return false
      }

      return true
    },

    validateGender() {
      this.validationErrors.gender = null
      if (!this.formData.gender) {
        this.validationErrors.gender = 'Please select a gender'
        return false
      }
      return true
    },

    validateTerms() {
      this.validationErrors.agreeToTerms = null
      if (!this.formData.agreeToTerms) {
        this.validationErrors.agreeToTerms = 'You must agree to the terms and conditions'
        return false
      }
      return true
    },

    validateAllFields() {
      const validations = [
        this.validateFirstName(),
        this.validateLastName(),
        this.validateEmail(),
        this.validatePhone(),
        this.validatePassword(),
        this.validateConfirmPassword(),
        this.validateGender(),
        this.validateTerms(),
      ]

      return validations.every(v => v === true)
    },

    async handleSignUp() {
      this.error = null

      // Validate all fields
      if (!this.validateAllFields()) {
        this.error = 'Please fix all validation errors before submitting'
        return
      }

      this.loading = true

      try {
        // Call the register action from Vuex
        await this.register({
          firstName: this.formData.firstName,
          lastName: this.formData.lastName,
          email: this.formData.email,
          phone: this.formData.phone,
          password: this.formData.password,
          gender: this.formData.gender,
        })

        this.successMessage = 'Account created successfully! Redirecting to login...'

        // Redirect to login page after 2 seconds
        setTimeout(() => {
          this.$router.push('/signin')
        }, 2000)
      } catch (err) {
        this.error = err.message || 'Registration failed. Please try again.'
      } finally {
        this.loading = false
      }
    },
  },
}
</script>

<style scoped>
.signup-page {
  min-height: calc(100vh - 120px);
  display: flex;
  align-items: center;
  padding: 1rem 0;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.signup-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.input-group-text {
  background-color: #f8f9fa;
  border-right: none;
}

.input-group .form-control {
  border-left: none;
}

.input-group .form-control:focus {
  border-color: #dee2e6;
  box-shadow: none;
}

.input-group:focus-within .input-group-text {
  border-color: #dc3545;
  color: #dc3545;
}

.input-group:focus-within .form-control {
  border-color: #dc3545;
}

.form-control.is-invalid,
.form-select.is-invalid {
  border-color: #dc3545;
}

.form-check-input.is-invalid {
  border-color: #dc3545;
}

.btn-primary {
  padding: 0.75rem;
  font-weight: 600;
  transition: all 0.3s ease;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.form-check-input:checked {
  background-color: #dc3545;
  border-color: #dc3545;
}
</style>
