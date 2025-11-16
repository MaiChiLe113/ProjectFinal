<template>
  <div class="login-page">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
          <div class="login-card card-elevated">
            <div class="text-center mb-4">
              <i class="bi bi-compass-fill fs-1 text-primary"></i>
              <h2 class="title-section mt-2">Welcome to SwinCom</h2>
              <p class="text-muted">Please login to continue</p>
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

            <!-- Login Form -->
            <form @submit.prevent="handleLogin">
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
                    v-model="email"
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
                    v-model="password"
                    placeholder="Enter your password"
                    @blur="validatePassword"
                    required
                  />
                  <button
                    class="btn btn-secondary"
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

              <button type="submit" class="btn btn-primary w-100 mb-3" :disabled="loading || !isFormValid">
                <span v-if="loading">
                  <span class="spinner-border spinner-border-sm me-2" role="status"></span>
                  Logging in...
                </span>
                <span v-else>
                  <i class="bi bi-box-arrow-in-right me-2"></i>
                  Login
                </span>
              </button>
            </form>

            <div class="text-center mt-3">
              <p class="text-muted">
                Don't have an account?
                <router-link to="/signup" class="text-primary fw-bold">Sign Up</router-link>
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
  name: 'Signin',
  data() {
    return {
      email: '',
      password: '',
      rememberMe: false,
      showPassword: false,
      error: null,
      successMessage: null,
      loading: false,
      validationErrors: {
        email: null,
        password: null,
      },
    }
  },
  computed: {
    isFormValid() {
      return (
        this.email &&
        this.password &&
        !this.validationErrors.email &&
        !this.validationErrors.password
      )
    },
  },
  mounted() {
    // Check if there's a redirect message
    if (this.$route.query.redirect) {
      this.error = 'Please login to access this page'
    }
  },
  methods: {
    ...mapActions('auth', ['login']),

    validateEmail() {
      this.validationErrors.email = null

      if (!this.email) {
        this.validationErrors.email = 'Email is required'
        return false
      }

      if (!this.email.includes('@')) {
        this.validationErrors.email = 'Email must contain @'
        return false
      }

      // More comprehensive email validation
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(this.email)) {
        this.validationErrors.email = 'Please enter a valid email address'
        return false
      }

      return true
    },

    validatePassword() {
      this.validationErrors.password = null

      if (!this.password) {
        this.validationErrors.password = 'Password is required'
        return false
      }

      // Check minimum 8 characters
      if (this.password.length < 8) {
        this.validationErrors.password = 'Password must be at least 8 characters'
        return false
      }

      // Check for initial capital letter
      if (!/^[A-Z]/.test(this.password)) {
        this.validationErrors.password = 'Password must start with a capital letter'
        return false
      }

      // Check for at least one symbol
      if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(this.password)) {
        this.validationErrors.password = 'Password must contain at least one symbol'
        return false
      }

      return true
    },

    async handleLogin() {
      this.error = null

      // Validate all fields
      const emailValid = this.validateEmail()
      const passwordValid = this.validatePassword()

      if (!emailValid || !passwordValid) {
        this.error = 'Please fix the validation errors before submitting'
        return
      }

      this.loading = true

      try {
        await this.login({
          email: this.email,
          password: this.password,
        })

        this.successMessage = 'Login successful! Redirecting...'

        // Redirect after successful login
        setTimeout(() => {
          const redirectTo = this.$route.query.redirect || '/dashboard'
          this.$router.push(redirectTo)
        }, 1000)
      } catch (err) {
        this.error = err.message || 'Login failed. Please check your credentials.'
      } finally {
        this.loading = false
      }
    },
  },
}
</script>

<style scoped>
.login-page {
  min-height: calc(100vh - 120px);
  display: flex;
  align-items: center;
  padding: 1rem 0;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
}

.login-card {
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

.form-control.is-invalid {
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
