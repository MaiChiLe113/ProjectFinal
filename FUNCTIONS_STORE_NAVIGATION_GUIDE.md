# Functions, Computed, Store & Navigation Keywords Guide

This guide focuses on:
- **Function calls** (methods you call)
- **Computed properties** (auto-calculated values)
- **Keywords in functions** (`async`, `await`, `try`, `catch`, `if`, `return`)
- **Vuex Store** (`dispatch`, `getters`, `state`, `commit`)
- **Navigation** (`$router`, `$route`)

---

## 🔧 CALLING FUNCTIONS (METHODS)

### What are Methods?
Methods are functions defined in the `methods` section that you can call to perform actions.

### Pattern in Vue Components:
```javascript
methods: {
  // Define function
  functionName() {
    // do something
  },

  // Call function
  anotherFunction() {
    this.functionName()  // Call with 'this.'
  }
}
```

---

### 📍 Common Function Calls in Your Code

#### **1. Load Data Functions** - Called in `mounted()`

##### `loadCompetitions()`
**Files:** Home.vue, Competition.vue, MyCompetition/Host.vue

**Home.vue (Line 301-309)**
```javascript
async loadCompetitions() {
  try {
    const response = await fetch('/api/competitions?limit=10')
    const data = await response.json()
    this.featuredCompetitions = data.competitions.slice(0, 3)
  } catch (error) {
    console.error('Error loading competitions:', error)
  }
  
}

// Called here:
mounted() {
  this.loadCompetitions()  // ← Function call
}
```
**Purpose:** Load competitions when page loads

**Keywords in this function:**
- `async` - Function can use `await`
- `try` - Attempt to run code
- `await` - Wait for promise to complete
- `catch` - Handle errors
- `this.` - Access component data

---

##### `loadHostedCompetitions()`
**Files:** MyCompetition/Host.vue

**MyCompetition/Host.vue (Line 189-222)**
```javascript
async loadHostedCompetitions() {
  this.isLoading = true
  try {
    const currentUser = this.$store.getters['auth/currentUser']

    if (!currentUser) {
      console.log('No user logged in')
      this.hostedCompetitions = []
      this.isLoading = false
      return  // ← Exit function early
    }

    const response = await fetch(`/api/competitions/my-hosted?organizer_id=${currentUser.id}`)

    if (!response.ok) {
      throw new Error('Failed to load hosted competitions')
    }

    const data = await response.json()
    this.hostedCompetitions = data.competitions || []

  } catch (error) {
    console.error('Error loading competitions:', error)
    this.hostedCompetitions = []
  } finally {
    this.isLoading = false  // ← Always runs
  }
}

// Called here:
mounted() {
  this.loadHostedCompetitions()
}
```

**Keywords explained:**
- `this.$store.getters['auth/currentUser']` - Get data from Vuex store
- `if (!currentUser)` - Check if user exists (! means NOT)
- `return` - Exit function immediately
- `throw new Error()` - Create and throw error
- `finally` - Always runs after try/catch

---

#### **2. Form Submission Functions**

##### `handleSubmit()`
**Files:** Host.vue, SubmitProject.vue, SignIn.vue, SignUp.vue

**Host.vue (Line 676-760)**
```javascript
async handleSubmit() {
  if (!this.validateForm()) {  // ← Call another function
    window.scrollTo({ top: 0, behavior: 'smooth' })
    return  // Stop if validation fails
  }

  const currentUser = this.$store.getters['auth/currentUser']
  if (!currentUser) {
    alert('You must be logged in to create a competition')
    this.$router.push('/signin')  // ← Navigate
    return
  }

  this.isLoading = true

  try {
    const formData = new FormData()

    // Add fields to formData
    formData.append('title', this.formData.title)
    formData.append('organizer_id', currentUser.id)
    // ... more fields

    const response = await fetch('/api/competitions', {
      method: 'POST',
      body: formData
    })

    const result = await response.json()

    if (!response.ok) {
      throw new Error(result.detail || 'Failed to create competition')
    }

    alert('Competition created successfully!')
    this.$router.push('/mycompetition/host')  // ← Navigate after success

  } catch (error) {
    console.error('Error creating competition:', error)
    this.errors.submit = error.message
    alert(`Failed to create competition: ${error.message}`)
  } finally {
    this.isLoading = false
  }
}
```

**Function calls inside:**
- `this.validateForm()` - Calls validation function
- `this.$store.getters['auth/currentUser']` - Gets current user
- `this.$router.push('/signin')` - Navigates to signin page

**Keywords:**
- `if (!this.validateForm())` - Call function and check result
- `return` - Exit early if validation fails
- `const formData = new FormData()` - Create new FormData object
- `throw new Error()` - Throw error if response not OK
- `finally` - Always set isLoading to false

---

#### **3. Validation Functions**

##### `validateForm()`
**Files:** Host.vue, SubmitProject.vue

**Host.vue (Line 587-673)**
```javascript
validateForm() {
  this.errors = {}  // Clear previous errors

  // Validate title
  if (!this.formData.title.trim()) {
    this.errors.title = 'Competition title is required'
  }

  // Validate description
  if (!this.formData.description.trim()) {
    this.errors.description = 'Description is required'
  }

  // ... more validations

  // Return true if no errors
  return Object.keys(this.errors).length === 0
}

// Called here:
async handleSubmit() {
  if (!this.validateForm()) {  // ← Function call
    return
  }
  // continue submission...
}
```

**Keywords:**
- `if (!condition)` - If condition is false
- `return` - Send back true or false
- `this.errors = {}` - Clear object

**Pattern:**
```javascript
// Define validation
validateForm() {
  // check things
  return true or false
}

// Call validation
if (!this.validateForm()) {
  return  // Stop if invalid
}
```

---

#### **4. Navigation Functions**

##### `editCompetition(competitionId)`
**Files:** MyCompetition/Host.vue

**MyCompetition/Host.vue (Line 242-244)**
```javascript
editCompetition(competitionId) {
  this.$router.push(`/competitions/${competitionId}/edit`)
}

// Called from template:
// <button @click="editCompetition(competition.id)">Edit</button>
```

**Keywords:**
- `competitionId` - Parameter passed to function
- `this.$router.push()` - Navigate to new page
- Template literal with `${competitionId}` - Dynamic URL

---

##### `goBack()`
**Files:** NewsDetail.vue, Host.vue

**NewsDetail.vue (Line 96-98)**
```javascript
goBack() {
  this.$router.push('/news')
}

// Called from template:
// <button @click="goBack">← Back</button>
```

---

#### **5. User Action Functions**

##### `handleLogout()`
**Files:** Header.vue

**Header.vue (Line 254-258)**
```javascript
handleLogout() {
  this.$store.dispatch('auth/logout')  // ← Call store action
  this.$router.push('/')  // ← Navigate to home
  this.showNotification('Logged out successfully', 'success')
}

// Called from template:
// <button @click="handleLogout">Logout</button>
```

**Keywords:**
- `this.$store.dispatch('auth/logout')` - Call Vuex action
- `this.$router.push('/')` - Navigate
- `this.showNotification()` - Call another method

---

##### `deleteCompetition(competitionId)`
**Files:** MyCompetition/Host.vue

**MyCompetition/Host.vue (Line 254-258)**
```javascript
deleteCompetition(competitionId) {
  this.selectedCompetitionId = competitionId  // Store ID
  const modal = new bootstrap.Modal(this.$refs.deleteModal)
  modal.show()  // ← Show modal
}
```

**Keywords:**
- `this.selectedCompetitionId = competitionId` - Store for later use
- `this.$refs.deleteModal` - Access template element
- `new bootstrap.Modal()` - Create Bootstrap modal
- `.show()` - Method on modal object

---

## 💡 COMPUTED PROPERTIES

### What are Computed?
Computed properties are values that auto-calculate based on other data. They update automatically when dependencies change.

### Pattern:
```javascript
computed: {
  computedName() {
    return calculation based on this.data
  }
}

// Use in template or methods:
this.computedName  // Don't use () for computed!
```

---

### 📍 Computed Examples in Your Code

#### **1. Count Active Items**

##### `activeCompetitions()`
**File:** MyCompetition/Host.vue (Line 178-180)

```javascript
computed: {
  activeCompetitions() {
    return this.hostedCompetitions.filter(c => c.status === 'ongoing' || c.status === 'upcoming').length
  }
}

// Used in template:
// <h3>{{ activeCompetitions }}</h3>
```

**How it works:**
1. Reads `this.hostedCompetitions` (dependency)
2. Filters for active ones
3. Counts them
4. **Auto-updates** when `hostedCompetitions` changes!

---

#### **2. Sum Totals**

##### `totalParticipants()`
**File:** MyCompetition/Host.vue (Line 181-183)

```javascript
computed: {
  totalParticipants() {
    return this.hostedCompetitions.reduce((sum, c) => sum + (c.capacity?.current || 0), 0)
  }
}

// Used in template:
// <h3>{{ totalParticipants }}</h3>
```

**Keywords:**
- `return` - Send back calculated value
- Uses `this.hostedCompetitions` as dependency
- Recalculates when competitions change

---

##### `totalViews()`
**File:** MyCompetition/Host.vue (Line 184-186)

```javascript
computed: {
  totalViews() {
    return this.hostedCompetitions.reduce((sum, c) => sum + (c.metadata?.views || 0), 0)
  }
}
```

---

#### **3. Check Authentication**

##### `isLoggedIn()`
**File:** Header.vue (Line 173)

```javascript
computed: {
  isLoggedIn() {
    return this.$store.getters['auth/isAuthenticated']
  }
}

// Used in template:
// <div v-if="isLoggedIn">...</div>
```

**Keywords:**
- `this.$store.getters['auth/isAuthenticated']` - Read from store
- Auto-updates when auth state changes!

---

##### `currentUser()`
**File:** Header.vue (Line 176)

```javascript
computed: {
  currentUser() {
    return this.$store.getters['auth/currentUser']
  }
}

// Used in template:
// <span>{{ currentUser.first_name }}</span>
```

---

#### **4. Filter/Transform Data**

##### `enabledFeaturesCount()`
**File:** About.vue (Line 540-542)

```javascript
computed: {
  enabledFeaturesCount() {
    return this.platformFeatures.filter(f => f.enabled).length
  }
}
```

---

### 🆚 Computed vs Methods

| Computed | Methods |
|----------|---------|
| **No `()`** - `this.activeCompetitions` | **Needs `()`** - `this.loadData()` |
| **Cached** - Only recalculates when dependencies change | **Always runs** when called |
| **For values** - Return a value to display | **For actions** - Do something (save, navigate, etc.) |
| **Auto-updates** in template | **Must call** manually |

**Example:**
```javascript
computed: {
  fullName() {
    return this.firstName + ' ' + this.lastName
  }
},
methods: {
  saveUser() {
    fetch('/api/users', { method: 'POST' })
  }
}

// In template:
// {{ fullName }}  ← No () for computed
// <button @click="saveUser">Save</button>  ← () not needed in @click
```

---

## 🏪 VUEX STORE KEYWORDS

### Store Structure in Your App

```
src/store/
  ├── index.js              (Main store)
  └── modules/
      ├── auth.js           (Authentication)
      └── project.js        (Project submission)
```

---

### 1. `this.$store.getters` - Read Data from Store

#### What it does:
Gets computed values from Vuex store (read-only).

#### Pattern:
```javascript
this.$store.getters['moduleName/getterName']
```

#### Examples in Your Code:

##### Get Current User
**Files:** Host.vue, MyCompetition/Host.vue, Header.vue, SubmitProject.vue

```javascript
// In methods:
const currentUser = this.$store.getters['auth/currentUser']

// In computed:
computed: {
  currentUser() {
    return this.$store.getters['auth/currentUser']
  }
}

// Result: { id: 1, first_name: 'John', last_name: 'Doe', email: '...' }
```

**Available getters in auth module:**
- `this.$store.getters['auth/isAuthenticated']` - Returns `true/false`
- `this.$store.getters['auth/currentUser']` - Returns user object or `null`
- `this.$store.getters['auth/userLastName']` - Returns last name

---

##### Get Project Data
**Files:** SubmitProject.vue, PreviewProject.vue

```javascript
// Get project name
this.$store.getters['project/getProjectName']

// Get elevator pitch
this.$store.getters['project/getElevatorPitch']

// Get thumbnail preview
this.$store.getters['project/getThumbnailPreview']

// Get all project data
this.$store.getters['project/getProjectData']
```

**Available project getters:**
- `project/getProjectName`
- `project/getElevatorPitch`
- `project/getThumbnailPreview`
- `project/getAboutProject`
- `project/getBuiltWith`
- `project/getProjectData` - Returns entire project object

---

### 2. `this.$store.dispatch()` - Call Store Action

#### What it does:
Triggers an action in Vuex store (usually async operations like API calls).

#### Pattern:
```javascript
await this.$store.dispatch('moduleName/actionName', data)
```

#### Examples in Your Code:

##### Login User
**File:** SignIn.vue (Line 208)

```javascript
async handleLogin() {
  try {
    await this.$store.dispatch('auth/login', {
      email: this.form.email,
      password: this.form.password
    })

    // After success:
    this.$router.push('/dashboard')
  } catch (error) {
    console.error('Login failed:', error)
  }
}
```

**What happens:**
1. Calls `login` action in `auth` module
2. Passes email and password
3. Waits for result (can `await` it)
4. Action makes API call
5. If success, user is stored
6. If error, throws exception

---

##### Register User
**File:** SignUp.vue (Line 282)

```javascript
async handleRegister() {
  try {
    await this.$store.dispatch('auth/register', this.form)
    alert('Registration successful!')
    this.$router.push('/signin')
  } catch (error) {
    console.error('Registration failed:', error)
  }
}
```

---

##### Logout User
**File:** Header.vue (Line 255)

```javascript
handleLogout() {
  this.$store.dispatch('auth/logout')
  this.$router.push('/')
}
```

**What happens:**
1. Clears user from store
2. Removes from localStorage
3. User logged out

---

##### Submit Project
**File:** SubmitProject.vue (Line 561)

```javascript
async submitProject() {
  try {
    await this.$store.dispatch('project/submitProject', projectData)
    alert('Project submitted successfully!')
    this.$router.push('/projects')
  } catch (error) {
    console.error('Submission failed:', error)
  }
}
```

---

### 3. `this.$store.commit()` - Direct State Mutation

#### What it does:
Directly updates state in store (synchronous only).

#### Pattern:
```javascript
this.$store.commit('moduleName/MUTATION_NAME', value)
```

#### Examples in Your Code:

**Note:** In your code, `commit` is mainly used INSIDE store actions, not in components.

**Inside store/modules/auth.js:**
```javascript
actions: {
  login({ commit }, credentials) {
    const user = findUser(credentials)
    commit('SET_USER', user)  // ← Called inside action
  }
}
```

**Mutations are uppercase by convention:**
- `SET_USER`
- `CLEAR_USER`
- `UPDATE_PROJECT_NAME`

---

### 4. `this.$store.state` - Direct State Access

#### What it does:
Directly accesses state (not recommended - use getters instead).

#### Pattern:
```javascript
this.$store.state.moduleName.property
```

#### In Your Code:
You use **getters** instead of direct state access (best practice! ✅)

**Good (Your way):**
```javascript
this.$store.getters['auth/currentUser']
```

**Bad (Don't do):**
```javascript
this.$store.state.auth.user  // Direct access - avoid!
```

---

## 🧭 NAVIGATION KEYWORDS

### 1. `this.$router.push()` - Navigate to Page

#### What it does:
Programmatically changes the current route (page).

#### Patterns:

##### Simple Path
```javascript
this.$router.push('/home')
```

##### Dynamic Path (Template Literals)
```javascript
this.$router.push(`/competitions/${competitionId}`)
```

##### With Query Parameters
```javascript
this.$router.push(`/search?q=${query}`)
this.$router.push(`/signin?redirect=${this.$route.fullPath}`)
```

##### Named Routes with Params
```javascript
this.$router.push({
  name: 'CompetitionDetail',
  params: { id: competitionId }
})
```

---

#### Examples in Your Code:

**Navigate after form submission:**
```javascript
// Host.vue (Line 754)
this.$router.push('/mycompetition/host')
```

**Navigate to signin if not logged in:**
```javascript
// Host.vue (Line 685)
if (!currentUser) {
  this.$router.push('/signin')
  return
}
```

**Navigate with competition ID:**
```javascript
// CompetitionCard.vue (Line 218)
this.$router.push(`/competitions/${this.competition.id}`)
```

**Navigate after login:**
```javascript
// SignIn.vue (Line 220)
const redirectTo = this.$route.query.redirect || '/dashboard'
this.$router.push(redirectTo)
```

**Navigate to edit page:**
```javascript
// MyCompetition/Host.vue (Line 244)
this.$router.push(`/competitions/${competitionId}/edit`)
```

---

### 2. `this.$router.back()` - Go Back

#### What it does:
Goes back to previous page (like browser back button).

#### Examples:

```javascript
// Host.vue (Line 768)
handleCancel() {
  if (confirm('Are you sure?')) {
    this.$router.back()  // ← Go to previous page
  }
}
```

---

### 3. `this.$route` - Current Route Info

#### What it does:
Accesses information about current route.

#### Common Properties:

##### `this.$route.params` - URL Parameters
```javascript
// URL: /competitions/123
// Route: /competitions/:id

this.$route.params.id  // "123"
```

**Example:**
```javascript
// CompetitionDetail.vue
mounted() {
  const competitionId = this.$route.params.id  // Get ID from URL
  this.loadCompetition(competitionId)
}
```

---

##### `this.$route.query` - Query Parameters
```javascript
// URL: /search?q=hello&limit=10

this.$route.query.q      // "hello"
this.$route.query.limit  // "10"
```

**Example:**
```javascript
// SignIn.vue (Line 219)
const redirectTo = this.$route.query.redirect || '/dashboard'
```

---

##### `this.$route.fullPath` - Full URL Path
```javascript
// Current URL: /competitions/123?tab=overview

this.$route.fullPath  // "/competitions/123?tab=overview"
```

**Example:**
```javascript
// Header.vue (Line 266)
this.$router.push(`/signin?redirect=${this.$route.fullPath}`)
// Saves current page to redirect back after login
```

---

### 4. `this.$route.name` - Route Name
```javascript
this.$route.name  // "CompetitionDetail"
```

---

## ⚙️ FUNCTION KEYWORDS

### 1. `async` - Asynchronous Function

#### What it does:
Marks function as async - allows using `await` inside.

#### Pattern:
```javascript
async functionName() {
  const result = await something()
  return result
}
```

#### In Your Code:
```javascript
// Home.vue (Line 301)
async loadCompetitions() {
  const response = await fetch('/api/competitions')
  const data = await response.json()
  this.featuredCompetitions = data.competitions
}

// Host.vue (Line 676)
async handleSubmit() {
  const response = await fetch('/api/competitions', { method: 'POST' })
  const result = await response.json()
}
```

**Every function that uses `await` MUST be marked `async`!**

---

### 2. `await` - Wait for Promise

#### What it does:
Pauses function execution until promise resolves.

#### Pattern:
```javascript
const result = await promise
```

#### Examples:
```javascript
// Wait for fetch
const response = await fetch('/api/data')

// Wait for JSON parsing
const data = await response.json()

// Wait for store action
await this.$store.dispatch('auth/login', credentials)
```

**Can only use `await` inside `async` functions!**

---

### 3. `try...catch...finally`

#### What it does:
Handles errors gracefully.

#### Pattern:
```javascript
try {
  // Try to do something
  const result = await riskyOperation()
} catch (error) {
  // Handle error if try fails
  console.error('Failed:', error)
} finally {
  // Always runs (success or fail)
  this.isLoading = false
}
```

#### Example in Your Code:
```javascript
// MyCompetition/Host.vue (Line 190-221)
async loadHostedCompetitions() {
  this.isLoading = true
  try {
    const response = await fetch('/api/competitions/my-hosted')
    const data = await response.json()
    this.hostedCompetitions = data.competitions
  } catch (error) {
    console.error('Error:', error)
    this.hostedCompetitions = []
  } finally {
    this.isLoading = false  // Always runs!
  }
}
```

---

### 4. `if` - Conditional Execution

#### Patterns:

##### Simple If
```javascript
if (condition) {
  // Do this if true
}
```

##### If-Else
```javascript
if (condition) {
  // If true
} else {
  // If false
}
```

##### If-Else If-Else
```javascript
if (condition1) {
  // If condition1 true
} else if (condition2) {
  // If condition2 true
} else {
  // If all false
}
```

#### Examples in Your Code:

##### Check if logged in:
```javascript
// Host.vue (Line 683-687)
const currentUser = this.$store.getters['auth/currentUser']
if (!currentUser) {
  alert('You must be logged in')
  this.$router.push('/signin')
  return
}
```

##### Check response status:
```javascript
// MyCompetition/Host.vue (Line 205-207)
if (!response.ok) {
  throw new Error('Failed to load')
}
```

##### Early return if invalid:
```javascript
// Host.vue (Line 677-680)
if (!this.validateForm()) {
  window.scrollTo({ top: 0 })
  return  // Stop execution
}
```

---

### 5. `return` - Exit Function

#### What it does:
Exits function and optionally sends back a value.

#### Patterns:

##### Return Value
```javascript
validateForm() {
  return Object.keys(this.errors).length === 0  // true or false
}
```

##### Early Return (Exit Early)
```javascript
async loadData() {
  if (!this.isLoggedIn) {
    return  // Stop here, don't continue
  }
  // Continue only if logged in
  const data = await fetch('/api/data')
}
```

##### Return in Computed
```javascript
computed: {
  activeCount() {
    return this.items.filter(i => i.active).length
  }
}
```

---

### 6. `throw` - Throw Error

#### What it does:
Creates and throws an error, jumping to `catch` block.

#### Pattern:
```javascript
if (somethingWrong) {
  throw new Error('Error message')
}
```

#### Example:
```javascript
// MyCompetition/Host.vue (Line 206)
if (!response.ok) {
  throw new Error('Failed to load hosted competitions')
}

// Jumps to catch block:
catch (error) {
  console.error('Error:', error)  // Error printed here
}
```

---

## 📋 COMPLETE FLOW EXAMPLE

### Creating a Competition (Host.vue)

```javascript
// 1. USER CLICKS SUBMIT BUTTON
// <button @click="handleSubmit">Create</button>

// 2. FUNCTION CALLED
async handleSubmit() {

  // 3. VALIDATE FORM
  if (!this.validateForm()) {  // ← Call validation function
    return  // ← Exit if invalid
  }

  // 4. CHECK AUTHENTICATION
  const currentUser = this.$store.getters['auth/currentUser']  // ← Get from store
  if (!currentUser) {  // ← Check if logged in
    this.$router.push('/signin')  // ← Navigate to login
    return  // ← Exit
  }

  // 5. PREPARE DATA
  this.isLoading = true
  const formData = new FormData()
  formData.append('title', this.formData.title)

  // 6. TRY TO SUBMIT
  try {
    const response = await fetch('/api/competitions', {  // ← API call
      method: 'POST',
      body: formData
    })

    const result = await response.json()  // ← Parse response

    if (!response.ok) {  // ← Check if failed
      throw new Error(result.detail)  // ← Throw error
    }

    // 7. SUCCESS
    alert('Competition created successfully!')
    this.$router.push('/mycompetition/host')  // ← Navigate to list

  } catch (error) {  // ← Catch errors
    console.error('Error:', error)
    alert(`Failed: ${error.message}`)
  } finally {  // ← Always runs
    this.isLoading = false
  }
}
```

**Keywords used:**
- `async` - Function can use await
- `if` - Check conditions
- `!` - NOT operator
- `return` - Exit early
- `this.$store.getters` - Get user from store
- `this.$router.push()` - Navigate
- `const` - Declare variable
- `new FormData()` - Create FormData
- `try` - Attempt code
- `await` - Wait for promise
- `throw` - Create error
- `catch` - Handle error
- `finally` - Always execute

---

## 🎯 QUICK REFERENCE

### Function Calls
| Call | Purpose | File |
|------|---------|------|
| `this.loadCompetitions()` | Load data | Home.vue, Competition.vue |
| `this.validateForm()` | Check form valid | Host.vue, SubmitProject.vue |
| `this.handleSubmit()` | Submit form | Host.vue, SignIn.vue |
| `this.$router.push()` | Navigate | All pages |
| `this.$store.dispatch()` | Call store action | SignIn, SignUp, Header |

### Computed Properties
| Computed | Returns | File |
|----------|---------|------|
| `activeCompetitions()` | Count of active | MyCompetition/Host.vue |
| `totalParticipants()` | Sum of participants | MyCompetition/Host.vue |
| `isLoggedIn()` | true/false | Header.vue |
| `currentUser()` | User object | Header.vue |

### Store Access
| Access | Purpose |
|--------|---------|
| `$store.getters['auth/currentUser']` | Get current user |
| `$store.getters['auth/isAuthenticated']` | Check if logged in |
| `$store.dispatch('auth/login', data)` | Login user |
| `$store.dispatch('auth/logout')` | Logout user |

### Navigation
| Method | Purpose |
|--------|---------|
| `$router.push('/path')` | Go to page |
| `$router.push(\`/competitions/${id}\`)` | Dynamic route |
| `$router.back()` | Go back |
| `$route.params.id` | Get URL param |
| `$route.query.search` | Get query param |

### Keywords in Functions
| Keyword | Purpose |
|---------|---------|
| `async` | Mark function as async |
| `await` | Wait for promise |
| `try` | Attempt code |
| `catch` | Handle errors |
| `finally` | Always run |
| `if` | Check condition |
| `return` | Exit function |
| `throw` | Create error |

---

Need more details on any specific part? Just ask!
