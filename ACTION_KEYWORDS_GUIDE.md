# Action Keywords Guide - Where They're Used

This guide focuses on ACTION keywords - methods and functions that DO something in your code.
Each keyword shows WHICH files use it and HOW.
Array Actions (Most Important!)

  - .filter() - Used in 8 files (MyCompetition/Host, Vote, Projects, News, About)
  - .reduce() - Used in 2 files (MyCompetition/Host for summing totals)
  - .slice() - Used in 5 files (Home, ProjectCard, ProjectTab for limiting items)
  - .find() - Used in 4 files (CompetitionDetail, ProjectDetail for finding by ID)
  - .map() - Used in 3 files (ProjectDetail, SubmitProject for transforming data)
  - .forEach() - Used in 2 files (services/api, SubmitProject for looping)
  - .push() - Used in 5 files (SubmitProject, Vote, store for adding items)

  String Actions

  - .trim() - Used in 12 files (Host, SubmitProject, Header for validation)
  - .toLowerCase() - Used in 5 files (Vote, Projects for case-insensitive search)
  - .split() - Used in 4 files (ProjectDetail for "React, Vue" → ["React", "Vue"])

  Navigation Actions

  - this.$router.push() - Used in 21 files! Every page navigation

  Store Actions (Vuex)

  - this.$store.dispatch() - Used in 5 files (Header, SignIn, SignUp for login/logout)
  - this.$store.getters - Used in 8 files (Header, Host, SubmitProject for getting user/data)

  HTTP Actions

  - fetch() - Used in 17 files (every API call)
  - .json() - Used in 17 files (parsing responses)

  FormData Actions

  - .append() - Used in 3 files (Host, SubmitProject, api.js for file uploads)

  User Interaction

  - alert() - Used in 10 files (Host, SignIn, SignUp for notifications)
  - confirm() - Used in 4 files (Host, SubmitProject, Vote for confirmations)

  Debugging

  - console.log() - Used in 15+ files (everywhere for debugging)
  - console.error() - Used in error handlers

  Utility Actions

  - JSON.stringify() - Used in 4 files (converting objects to JSON)
  - JSON.parse() - Used in 3 files (parsing JSON to objects)
  - Object.keys() - Used in 2 files (getting object keys)
---

## 📊 ARRAY ACTIONS

### `.filter()` - Keep Only Matching Items
**What it does:** Creates a new array containing only items that pass a test

**Used in 8 files:**

#### 1. `MyCompetition/Host.vue` (Line 179)
```javascript
this.hostedCompetitions.filter(c => c.status === 'ongoing' || c.status === 'upcoming')
```
**Purpose:** Count active competitions (ongoing or upcoming)

#### 2. `MyCompetition/Host.vue` (Line 273)
```javascript
this.hostedCompetitions = this.hostedCompetitions.filter(c => c.id !== this.selectedCompetitionId)
```
**Purpose:** Remove deleted competition from list

#### 3. `About.vue` (Line 541)
```javascript
this.platformFeatures.filter(f => f.enabled).length
```
**Purpose:** Count enabled features

#### 4. `Vote.vue` (Line 247)
```javascript
this.filteredProjects = this.projects.filter(project => { /* filtering logic */ })
```
**Purpose:** Filter projects by search/category

#### 5. `Projects.vue` (Line 254)
```javascript
this.filteredProjects = this.projects.filter(project => { /* filtering logic */ })
```
**Purpose:** Search and filter projects

#### 6. `News.vue` (Line 184)
```javascript
this.displayedNews = this.allNews.filter(item => { /* category filter */ })
```
**Purpose:** Filter news by category

**Pattern:** `array.filter(item => condition)`
- Creates NEW array
- Original array unchanged
- Returns empty array `[]` if nothing matches

---

### `.reduce()` - Combine All Items Into One Value
**What it does:** Reduces an array to a single value by combining all items

**Used in 2 files:**

#### 1. `MyCompetition/Host.vue` (Line 182)
```javascript
this.hostedCompetitions.reduce((sum, c) => sum + (c.capacity?.current || 0), 0)
```
**Purpose:** Calculate total participants across all competitions
**How it works:**
- Start with `0`
- For each competition, add its current capacity
- Result: total number of participants

#### 2. `MyCompetition/Host.vue` (Line 185)
```javascript
this.hostedCompetitions.reduce((sum, c) => sum + (c.metadata?.views || 0), 0)
```
**Purpose:** Calculate total views across all competitions

**Pattern:** `array.reduce((accumulator, item) => newAccumulator, startValue)`
- `accumulator` = running total
- `item` = current item
- `startValue` = initial value (usually `0` for sums, `[]` for arrays)

---

### `.slice()` - Extract Portion of Array
**What it does:** Returns a shallow copy of a portion of an array

**Used in 5 files:**

#### 1. `Home.vue` (Line 305)
```javascript
this.featuredCompetitions = data.competitions.slice(0, 3)
```
**Purpose:** Get only first 3 competitions for featured section

#### 2. `ProjectListItem.vue` (Line 46)
```javascript
v-for="award in project.awards.slice(0, 1)"
```
**Purpose:** Show only first award in list

#### 3. `ProjectListItem.vue` (Line 80)
```javascript
v-for="(tag, index) in project.tags.slice(0, 5)"
```
**Purpose:** Show only first 5 tags

#### 4. `ProjectTab.vue` (Line 140)
```javascript
v-for="comment in userProject.comments.slice(0, 3)"
```
**Purpose:** Show only first 3 comments

#### 5. `ProjectCard.vue` (Line 61)
```javascript
v-for="(tag, index) in project.tags.slice(0, 3)"
```
**Purpose:** Show only first 3 tags

**Pattern:** `array.slice(start, end)`
- `slice(0, 3)` = items at index 0, 1, 2 (first 3 items)
- Original array unchanged
- Returns new array

---

### `.find()` - Find First Matching Item
**What it does:** Returns first item that matches condition (or `undefined` if not found)

**Used in 4 files:**

#### 1. `CompetitionDetail.vue` (Line 515)
```javascript
this.competition = data.competitions.find(c => c.id === parseInt(competitionId))
```
**Purpose:** Find specific competition by ID

#### 2. `ProjectTab.vue` (Line 231)
```javascript
this.userProject = data.projects.find(p =>
  p.uploader.id === currentUserId &&
  p.competitionId === competitionId
)
```
**Purpose:** Find user's project for specific competition

#### 3. `ProjectDetail.vue` (Line 430)
```javascript
this.project = data.projects.find(p => p.id === parseInt(projectId))
```
**Purpose:** Find specific project by ID

#### 4. `store/modules/auth.js` (Line 33)
```javascript
const user = users.find(u => u.email === credentials.email && u.password === credentials.password)
```
**Purpose:** Find user with matching email and password

**Pattern:** `array.find(item => condition)`
- Returns first match
- Returns `undefined` if not found
- Stops searching after first match

---

### `.map()` - Transform Each Item
**What it does:** Creates new array by transforming each item

**Used in 3 files:**

#### 1. `ProjectDetail.vue` (Line 490)
```javascript
return builtWith.split(',').map(tech => tech.trim())
```
**Purpose:** Convert "React, Vue, Node" → ["React", "Vue", "Node"]
**Process:**
1. Split by comma
2. Trim whitespace from each

#### 2. `SubmitProject.vue` (Line 467)
```javascript
this.tryItOutLinks = this.tryItOutLinks.filter(link => link.trim()).map(link => link.trim())
```
**Purpose:** Clean up links (remove empty and trim spaces)

#### 3. `Vote.vue` (Line 489)
```javascript
this.projectImages = files.map(file => URL.createObjectURL(file))
```
**Purpose:** Convert file objects to preview URLs

**Pattern:** `array.map(item => transformedItem)`
- Creates NEW array
- Same length as original
- Each item transformed

---

### `.forEach()` - Do Something for Each Item
**What it does:** Executes function for each item (no return value)

**Used in 2 files:**

#### 1. `services/api.js` (Line 124)
```javascript
Object.keys(projectData).forEach((key) => {
  formData.append(key, projectData[key]);
})
```
**Purpose:** Add each field to FormData

#### 2. `SubmitProject.vue` (Line 598)
```javascript
projectImages.forEach((file, index) => {
  formData.append('projectImages', file)
})
```
**Purpose:** Add each image file to FormData

**Pattern:** `array.forEach(item => { doSomething })`
- No return value
- Can't break/stop early
- Use for side effects (like appending to FormData)

---

### `.push()` - Add Item to End
**What it does:** Adds one or more items to end of array, returns new length

**Used in 5 files:**

#### 1. `SubmitProject.vue` (Line 429)
```javascript
this.tryItOutLinks.push('')
```
**Purpose:** Add empty field for new link

#### 2. `store/modules/project.js` (Line 109)
```javascript
state.projectData.projectImages.push(imageUrl)
```
**Purpose:** Add new image URL to project

#### 3. `Vote.vue` (Line 335)
```javascript
this.selectedProjects.push(projectId)
```
**Purpose:** Add project to selected list for voting

**Pattern:** `array.push(item)`
- Modifies original array
- Returns new length
- Adds to END

---

## 🔤 STRING ACTIONS

### `.trim()` - Remove Whitespace
**What it does:** Removes whitespace from both ends of string

**Used in 12 files:**

#### 1. `Host.vue` (Lines 589, 593, 601, 605, 637, 641, 653, 657, 661)
```javascript
if (!this.formData.title.trim()) {
  this.errors.title = 'Competition title is required'
}
```
**Purpose:** Validate that field isn't just spaces

#### 2. `ProjectDetail.vue` (Line 465)
```javascript
if (!this.newComment.trim()) return
```
**Purpose:** Don't submit empty comments

#### 3. `Header.vue` (Line 260)
```javascript
if (this.searchQuery.trim()) {
  this.$router.push(`/search?q=${encodeURIComponent(this.searchQuery)}`)
}
```
**Purpose:** Only search if query isn't empty

#### 4. `SubmitProject.vue` (Line 467)
```javascript
this.tryItOutLinks = this.tryItOutLinks.filter(link => link.trim())
```
**Purpose:** Remove empty/whitespace-only links

**Pattern:** `string.trim()`
- Returns new string
- Original unchanged
- `"  hello  ".trim()` → `"hello"`

---

### `.toLowerCase()` - Convert to Lowercase
**What it does:** Converts string to lowercase

**Used in 5 files:**

#### 1. `CompetitionDetail.vue` (Line 175)
```javascript
competition.category.toLowerCase()
```
**Purpose:** Display category in lowercase for readability

#### 2. `Vote.vue` (Line 253)
```javascript
project.projectName.toLowerCase().includes(this.searchQuery.toLowerCase())
```
**Purpose:** Case-insensitive search

#### 3. `Projects.vue` (Line 260)
```javascript
project.projectName.toLowerCase().includes(this.searchQuery.toLowerCase())
```
**Purpose:** Case-insensitive search

**Pattern:** `string.toLowerCase()`
- Returns new string
- `"HELLO".toLowerCase()` → `"hello"`
- Use for case-insensitive comparisons

---

### `.split()` - Split String Into Array
**What it does:** Splits string into array based on separator

**Used in 4 files:**

#### 1. `ProjectDetail.vue` (Line 490)
```javascript
builtWith.split(',').map(tech => tech.trim())
```
**Purpose:** "React, Vue, Node" → ["React", "Vue", "Node"]

#### 2. `ProjectDetail.vue` (Line 500)
```javascript
const videoId = url.split('v=')[1] || url.split('/').pop()
```
**Purpose:** Extract video ID from YouTube URL

#### 3. `Vote.vue` (Line 365)
```javascript
project.builtWith.split(',')
```
**Purpose:** Convert comma-separated tech stack to array

**Pattern:** `string.split(separator)`
- `"a,b,c".split(',')` → `['a', 'b', 'c']`
- `"hello".split('')` → `['h', 'e', 'l', 'l', 'o']`
- Returns array

---

## 🧭 NAVIGATION ACTIONS

### `this.$router.push()` - Navigate to New Page
**What it does:** Programmatically navigates to different route

**Used in 21 files:**

#### 1. `Home.vue` - Not used (uses `<router-link>`)

#### 2. `Host.vue` (Lines 685, 754)
```javascript
this.$router.push('/signin')              // If not logged in
this.$router.push('/mycompetition/host')  // After creating competition
```

#### 3. `MyCompetition/Host.vue` (Lines 244, 248, 252)
```javascript
this.$router.push(`/competitions/${competitionId}/edit`)
this.$router.push(`/competitions/${competitionId}/participants`)
this.$router.push(`/competitions/${competitionId}/analytics`)
```

#### 4. `CompetitionCard.vue` (Line 218)
```javascript
this.$router.push(`/competitions/${this.competition.id}`)
```

#### 5. `CompetitionDetail.vue` (Lines 518, 551)
```javascript
this.$router.push('/competitions')  // If competition not found
this.$router.push(`/competitions/${this.competition.id}/join`)  // Join button
```

#### 6. `Header.vue` (Lines 256, 261, 266)
```javascript
this.$router.push('/')  // After logout
this.$router.push(`/search?q=${encodeURIComponent(this.searchQuery)}`)
this.$router.push(`/${action}?redirect=${this.$route.fullPath}`)
```

#### 7. `ProjectCard.vue` (Line 129)
```javascript
this.$router.push(`/projects/${this.project.id}`)
```

#### 8. `ProjectListItem.vue` (Line 141)
```javascript
this.$router.push(`/projects/${this.project.id}`)
```

#### 9. `ProjectTab.vue` (Line 254)
```javascript
this.$router.push(`/submit?projectId=${this.userProject.id}`)
```

#### 10. `NewsCard.vue` (Line 58)
```javascript
this.$router.push({ name: 'NewsDetail', params: { id: this.newsItem.id } })
```

#### 11. `NewsDetail.vue` (Line 97)
```javascript
this.$router.push('/news')
```

#### 12. `ProjectDetail.vue` (Line 433)
```javascript
this.$router.push('/projects')  // If project not found
```

#### 13. `SignIn.vue` (Line 220)
```javascript
this.$router.push(redirectTo)  // After successful login
```

**Pattern:** `this.$router.push(path)`
- Adds to browser history (can press back)
- Use string for simple paths: `'/home'`
- Use template literals for dynamic: `` `/competitions/${id}` ``
- Use object for complex: `{ name: 'Detail', params: { id: 5 } }`

---

## 💾 STORE ACTIONS (Vuex)

### `this.$store.dispatch()` - Call Vuex Action
**What it does:** Triggers action in Vuex store (usually async operations)

**Used in 5 files:**

#### 1. `Header.vue` (Line 255)
```javascript
this.$store.dispatch('auth/logout')
```
**Purpose:** Logout user (clear auth state)

#### 2. `SignIn.vue` (Line 208)
```javascript
await this.$store.dispatch('auth/login', {
  email: this.form.email,
  password: this.form.password
})
```
**Purpose:** Login user (async - waits for server)

#### 3. `SignUp.vue` (Line 282)
```javascript
await this.$store.dispatch('auth/register', this.form)
```
**Purpose:** Register new user

#### 4. `SubmitProject.vue` (Line 561)
```javascript
await this.$store.dispatch('project/submitProject', projectData)
```
**Purpose:** Submit project to server

**Pattern:** `this.$store.dispatch('module/actionName', data)`
- Returns Promise (can use `await`)
- For async operations (API calls)
- Can access with `this.$store.state.module.data`

---

### `this.$store.getters` - Get Data from Store
**What it does:** Retrieves computed values from Vuex store

**Used in 8 files:**

#### 1. `Host.vue` (Line 683)
```javascript
const currentUser = this.$store.getters['auth/currentUser']
```
**Purpose:** Get logged-in user

#### 2. `MyCompetition/Host.vue` (Line 193)
```javascript
const currentUser = this.$store.getters['auth/currentUser']
```
**Purpose:** Get user ID for filtering competitions

#### 3. `Header.vue` (Line 173)
```javascript
isLoggedIn() {
  return this.$store.getters['auth/isAuthenticated']
}
```
**Purpose:** Check if user is logged in

#### 4. `SubmitProject.vue` (Multiple lines)
```javascript
this.$store.getters['project/getProjectName']
this.$store.getters['project/getElevatorPitch']
this.$store.getters['project/getThumbnailPreview']
```
**Purpose:** Get project data for form

**Pattern:** `this.$store.getters['module/getterName']`
- Read-only access
- Returns computed value
- Cached (efficient)

---

## 🌐 HTTP ACTIONS

### `fetch()` - Make HTTP Request
**What it does:** Makes network request to server

**Used in 17 files:**

#### 1. `Home.vue` (Line 303)
```javascript
const response = await fetch('/api/competitions?limit=10')
```
**Purpose:** Load 10 competitions for featured section

#### 2. `MyCompetition/Host.vue` (Line 203)
```javascript
const response = await fetch(`/api/competitions/my-hosted?organizer_id=${currentUser.id}`)
```
**Purpose:** Load user's hosted competitions

#### 3. `Host.vue` (Line 741)
```javascript
const response = await fetch('/api/competitions', {
  method: 'POST',
  body: formData
})
```
**Purpose:** Create new competition

#### 4. `Competition.vue` (Line 169)
```javascript
const response = await fetch('/api/competitions')
```
**Purpose:** Load all competitions

#### 5. `Projects.vue` (Line 236)
```javascript
const response = await fetch('/api/projects')
```
**Purpose:** Load all projects

#### 6. `Vote.vue` (Line 224)
```javascript
const response = await fetch('/api/projects?status=approved')
```
**Purpose:** Load approved projects for voting

**Pattern:**
```javascript
// GET request (default)
const response = await fetch(url)

// POST request
const response = await fetch(url, {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(data)
})

// With FormData
const response = await fetch(url, {
  method: 'POST',
  body: formData  // No headers needed!
})
```

---

### `.json()` - Parse JSON Response
**What it does:** Parses response body as JSON

**Used in 17 files (everywhere `fetch` is used):**

#### 1. `Home.vue` (Line 304)
```javascript
const data = await response.json()
this.featuredCompetitions = data.competitions.slice(0, 3)
```

#### 2. `MyCompetition/Host.vue` (Line 209)
```javascript
const data = await response.json()
this.hostedCompetitions = data.competitions || []
```

#### 3. `Host.vue` (Line 745)
```javascript
const result = await response.json()
if (!response.ok) {
  throw new Error(result.detail || 'Failed')
}
```

**Pattern:**
```javascript
const response = await fetch(url)
const data = await response.json()  // Returns JavaScript object

// Check if successful
if (!response.ok) {
  throw new Error('Request failed')
}
```

---

## 📋 FORMDATA ACTIONS

### `.append()` - Add Field to FormData
**What it does:** Adds key-value pair to FormData object

**Used in 3 files:**

#### 1. `Host.vue` (Lines 696-736)
```javascript
const formData = new FormData()
formData.append('title', this.formData.title)
formData.append('description', this.formData.description)
formData.append('organizer_id', currentUser.id)
// ... 20+ more fields
```
**Purpose:** Build form data for creating competition

#### 2. `services/api.js` (Lines 127, 130, 132)
```javascript
formData.append('try_it_out_links', JSON.stringify(projectData[key]))
formData.append('thumbnail', projectData[key])  // File
formData.append(key, projectData[key])
```
**Purpose:** Build FormData for project submission

#### 3. `SubmitProject.vue` (Line 600)
```javascript
projectImages.forEach((file, index) => {
  formData.append('projectImages', file)
})
```
**Purpose:** Add multiple image files

**Pattern:**
```javascript
const formData = new FormData()

// Text field
formData.append('title', 'My Competition')

// Number
formData.append('max_capacity', 100)

// Boolean
formData.append('allow_teams', true)

// File
formData.append('banner_image', fileObject)

// Array as JSON
formData.append('links', JSON.stringify(['url1', 'url2']))
```

**Why FormData?**
- Needed for file uploads
- Can mix text and files
- Automatically sets `Content-Type: multipart/form-data`

---

## 🎬 USER INTERACTION ACTIONS

### `alert()` - Show Alert Dialog
**What it does:** Displays message box to user

**Used in 10 files:**

#### 1. `Host.vue` (Lines 613, 751, 757)
```javascript
alert('Form auto-filled with sample data!')
alert('Competition created successfully!')
alert(`Failed to create competition: ${error.message}`)
```

#### 2. `MyCompetition/Host.vue` (Lines 280, 283)
```javascript
alert('Competition deleted successfully!')
alert('Failed to delete competition. Please try again.')
```

#### 3. `SignIn.vue` (Line 218)
```javascript
alert('Login successful! Redirecting...')
```

#### 4. `SignUp.vue` (Line 290)
```javascript
alert('Registration successful! Please sign in.')
```

**Pattern:** `alert(message)`
- Blocks page until user clicks OK
- Cannot be styled
- Use for simple notifications
- Consider using toast/modal for better UX

---

### `confirm()` - Show Confirmation Dialog
**What it does:** Shows OK/Cancel dialog, returns `true` if OK clicked

**Used in 4 files:**

#### 1. `Host.vue` (Line 767)
```javascript
if (confirm('Are you sure you want to cancel? Your changes will not be saved.')) {
  this.$router.back()
}
```
**Purpose:** Confirm before discarding changes

#### 2. `SubmitProject.vue` (Line 538)
```javascript
if (confirm('Are you sure you want to remove this link?')) {
  this.tryItOutLinks.splice(index, 1)
}
```
**Purpose:** Confirm before deleting link

#### 3. `Vote.vue` (Line 386)
```javascript
if (confirm(`Vote for "${project.projectName}"?`)) {
  // Submit vote
}
```
**Purpose:** Confirm vote choice

**Pattern:**
```javascript
if (confirm('Are you sure?')) {
  // User clicked OK
  doAction()
} else {
  // User clicked Cancel
  // Or just:
  // return
}
```

---

## 🐛 DEBUGGING ACTIONS

### `console.log()` - Log to Console
**What it does:** Prints message/data to browser console

**Used in 15+ files:**

#### 1. `Home.vue` (Line 307)
```javascript
console.error('Error loading competitions:', error)
```

#### 2. `MyCompetition/Host.vue` (Lines 196, 214, 217)
```javascript
console.log('No user logged in')
console.log('Loaded hosted competitions:', this.hostedCompetitions)
console.error('Error loading competitions:', error)
```

#### 3. `Host.vue` (Line 756)
```javascript
console.error('Error creating competition:', error)
```

**Pattern:**
```javascript
// Log regular message
console.log('Debug message', variable)

// Log error (red in console)
console.error('Error:', error)

// Log warning (yellow in console)
console.warn('Warning message')

// Log object/array nicely formatted
console.log('User:', user)
console.table(arrayOfObjects)  // Shows as table
```

**When to use:**
- `console.log()` - General debugging
- `console.error()` - Errors (shows in red)
- `console.warn()` - Warnings (shows in yellow)
- Remove before production!

---

## 🔧 UTILITY ACTIONS

### `JSON.stringify()` - Convert to JSON String
**What it does:** Converts JavaScript object to JSON string

**Used in 4 files:**

#### 1. `Host.vue` (Line 577)
```javascript
this.formData = JSON.parse(JSON.stringify(this.sampleData))
```
**Purpose:** Deep copy object (clone)

#### 2. `services/api.js` (Line 127)
```javascript
formData.append('try_it_out_links', JSON.stringify(projectData[key]))
```
**Purpose:** Send array as JSON string

#### 3. `store/modules/project.js` (Line 251)
```javascript
formData.append('tags', JSON.stringify(state.projectData.tags))
```
**Purpose:** Send tags array as string

**Pattern:**
```javascript
const obj = { name: 'John', age: 30 }
const jsonString = JSON.stringify(obj)
// Result: '{"name":"John","age":30}'

// Deep copy object
const copy = JSON.parse(JSON.stringify(original))
```

---

### `JSON.parse()` - Convert from JSON String
**What it does:** Converts JSON string to JavaScript object

**Used in 3 files:**

#### 1. `Host.vue` (Line 577)
```javascript
this.formData = JSON.parse(JSON.stringify(this.sampleData))
```
**Purpose:** Deep copy (parse after stringify)

#### 2. `store/modules/auth.js` (Line 17)
```javascript
const savedUser = JSON.parse(localStorage.getItem('swincom_user'))
```
**Purpose:** Get user object from localStorage

**Pattern:**
```javascript
const jsonString = '{"name":"John","age":30}'
const obj = JSON.parse(jsonString)
// Result: { name: 'John', age: 30 }

// From localStorage
const saved = localStorage.getItem('key')
const data = JSON.parse(saved)
```

---

### `Object.keys()` - Get Object's Keys
**What it does:** Returns array of object's property names

**Used in 2 files:**

#### 1. `services/api.js` (Line 124)
```javascript
Object.keys(projectData).forEach((key) => {
  formData.append(key, projectData[key])
})
```
**Purpose:** Loop through all object properties

#### 2. `Host.vue` (Line 666)
```javascript
return Object.keys(this.errors).length === 0
```
**Purpose:** Check if errors object is empty

**Pattern:**
```javascript
const user = { name: 'John', age: 30, city: 'NYC' }
const keys = Object.keys(user)
// Returns: ['name', 'age', 'city']

// Check if empty
if (Object.keys(obj).length === 0) {
  console.log('Object is empty')
}
```

---

## 📱 SPECIAL ACTIONS

### `parseInt()` - Convert String to Integer
**What it does:** Parses string and returns integer

**Used in 5 files:**

#### 1. `CompetitionDetail.vue` (Line 515)
```javascript
this.competition = data.competitions.find(c => c.id === parseInt(competitionId))
```
**Purpose:** Convert URL param (string) to number for comparison

#### 2. `ProjectDetail.vue` (Line 430)
```javascript
this.project = data.projects.find(p => p.id === parseInt(projectId))
```

**Pattern:**
```javascript
parseInt('42')      // 42
parseInt('42.99')   // 42 (no decimals)
parseInt('abc')     // NaN (Not a Number)

// URL params are always strings!
const id = parseInt(this.$route.params.id)
```

---

### `encodeURIComponent()` - Encode for URL
**What it does:** Encodes string to be safe for URL

**Used in 2 files:**

#### 1. `Header.vue` (Line 261)
```javascript
this.$router.push(`/search?q=${encodeURIComponent(this.searchQuery)}`)
```
**Purpose:** Safely include search query in URL

**Pattern:**
```javascript
encodeURIComponent('hello world')  // 'hello%20world'
encodeURIComponent('user@email.com')  // 'user%40email.com'

// Use in URLs
const url = `/search?q=${encodeURIComponent(query)}`
```

---

## 🎯 QUICK REFERENCE TABLE

| Action | Category | Most Used In | Purpose |
|--------|----------|--------------|---------|
| `.filter()` | Array | MyCompetition/Host, Vote, Projects | Keep matching items |
| `.reduce()` | Array | MyCompetition/Host | Sum/combine values |
| `.slice()` | Array | Home, ProjectCard, ProjectTab | Get portion of array |
| `.find()` | Array | CompetitionDetail, ProjectDetail | Find one item |
| `.map()` | Array | ProjectDetail, SubmitProject | Transform items |
| `.forEach()` | Array | services/api, SubmitProject | Do action for each |
| `.push()` | Array | SubmitProject, Vote, store | Add to end |
| `.trim()` | String | Host, SubmitProject, Header | Remove spaces |
| `.toLowerCase()` | String | Vote, Projects, CompetitionDetail | Case-insensitive |
| `.split()` | String | ProjectDetail, Vote | String to array |
| `$router.push()` | Navigation | All pages | Navigate to page |
| `$store.dispatch()` | Store | SignIn, SignUp, Header | Call async action |
| `$store.getters` | Store | Header, Host, SubmitProject | Get store data |
| `fetch()` | HTTP | All pages | API request |
| `.json()` | HTTP | All pages | Parse response |
| `.append()` | FormData | Host, SubmitProject, api.js | Add form field |
| `alert()` | UI | Host, SignIn, SignUp | Show message |
| `confirm()` | UI | Host, SubmitProject, Vote | Confirm action |
| `console.log()` | Debug | All files | Debug output |
| `JSON.stringify()` | Utility | services/api, store | Object to JSON |
| `JSON.parse()` | Utility | store/auth, Host | JSON to object |
| `Object.keys()` | Utility | services/api, Host | Get keys array |

---

## 💡 Common Patterns

### Pattern 1: Filter → Count
```javascript
// Used in: MyCompetition/Host.vue, About.vue
this.items.filter(item => item.active).length
```

### Pattern 2: Reduce → Sum
```javascript
// Used in: MyCompetition/Host.vue
this.items.reduce((sum, item) => sum + item.value, 0)
```

### Pattern 3: Fetch → Parse → Store
```javascript
// Used in: All pages with API calls
const response = await fetch('/api/data')
const data = await response.json()
this.items = data.items
```

### Pattern 4: FormData → Append → Send
```javascript
// Used in: Host.vue, SubmitProject.vue
const formData = new FormData()
formData.append('field', value)
await fetch('/api/endpoint', { method: 'POST', body: formData })
```

### Pattern 5: Trim → Validate
```javascript
// Used in: Host.vue, SubmitProject.vue
if (!this.form.field.trim()) {
  this.errors.field = 'Field is required'
}
```

---

Need details on a specific action? Want to see more examples? Just ask!
