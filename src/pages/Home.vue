<template>
  <header class="bg-light position-relative" style="background-image: url('https://i.pinimg.com/736x/c7/a3/c8/c7a3c88fd7e1cf3ccb60370b00948f14.jpg'); background-repeat: no-repeat; background-position: right; background-size: contain;">
    <div class="overlay position-absolute top-0 start-0 w-100 h-100 bg-light" style="opacity: 0.55;"></div>
    <div class="container position-relative" style="z-index: 1;">
      <div class="row">
        <div class="col-12">
          <div class="py-5">
            <div class="row">
              <div class="col-12 col-md-7 col-lg-6">
                <h1 class="display-5 fw-bold text-dark mb-3">
                  Log In or Sign Up now to Join Competitions and win Prize
                </h1>
                <h3 class="fs-5 text-dark mb-4">
                  Where students and staffs come together<br />
                  to build a community.
                </h3>
                <div class="d-flex flex-column flex-md-row gap-3">
                  <router-link
                    to="/signin"
                    class="btn btn-primary btn-lg d-flex align-items-center justify-content-between"
                    style="max-width: 200px;"
                  >
                    <span>Sign In</span>
                    <i class="bi bi-arrow-right ms-2"></i>
                  </router-link>
                  <router-link
                    href="/signup"
                    class="btn btn-outline-primary btn-lg d-flex align-items-center justify-content-between"
                    style="max-width: 200px;"
                  >
                    <span>Sign Up</span>
                    <i class="bi bi-arrow-right ms-2"></i>
                  </router-link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>
  <section class="container my-5">
    <h2 class="fw-bold mb-4">Featured Competitions</h2>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
      <div
        class="col"
        v-for="(competition, index) in featuredCompetitions"
        :key="index"
      >
        <CompetitionCard :competition="competition" />
      </div>
    </div>
    <router-link
    to="/competitions"
    class="btn btn-outline-primary btn-lg d-flex align-items-center justify-content-between"
    style="max-width: 400px; margin-top: 30px;"
    >
    <span>Browse Competition</span>
    <i class="bi bi-arrow-right ms-2"></i>
    </router-link>
  </section>
  <section>
    <div class="container px-4 py-5" id="featured-3" bis_skin_checked="1"> <h2 class="pb-2 border-bottom">Competitions Created by</h2> <div class="row g-4 py-5 row-cols-1 row-cols-lg-3" bis_skin_checked="1"> <div class="feature col" bis_skin_checked="1"> <div class="feature-icon d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-2 mb-3" bis_skin_checked="1"> <svg class="bi" width="1em" height="1em" aria-hidden="true"><use xlink:href="#collection"></use></svg> </div> <h3 class="fs-2 text-body-emphasis">Individuals</h3> <p>Paragraph of text beneath the heading to explain the heading. We'll add onto it with another sentence and probably just keep going until we run out of words.</p> <a href="#" class="icon-link">
    See more
    <svg class="bi" aria-hidden="true"><use xlink:href="#chevron-right"></use></svg> </a> </div> <div class="feature col" bis_skin_checked="1"> <div class="feature-icon d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-2 mb-3" bis_skin_checked="1"> <svg class="bi" width="1em" height="1em" aria-hidden="true"><use xlink:href="#people-circle"></use></svg> </div> <h3 class="fs-2 text-body-emphasis">Clubs</h3> <p>Paragraph of text beneath the heading to explain the heading. We'll add onto it with another sentence and probably just keep going until we run out of words.</p> <a href="#" class="icon-link">
    See more
    <svg class="bi" aria-hidden="true"><use xlink:href="#chevron-right"></use></svg> </a> </div> <div class="feature col" bis_skin_checked="1"> <div class="feature-icon d-inline-flex align-items-center justify-content-center text-bg-primary bg-gradient fs-2 mb-3" bis_skin_checked="1"> <svg class="bi" width="1em" height="1em" aria-hidden="true"><use xlink:href="#toggles2"></use></svg> </div> <h3 class="fs-2 text-body-emphasis">Academic Staff</h3> <p>Paragraph of text beneath the heading to explain the heading. We'll add onto it with another sentence and probably just keep going until we run out of words.</p> <a href="#" class="icon-link">
    See more
    <svg class="bi" aria-hidden="true"><use xlink:href="#chevron-right"></use></svg> </a> </div> </div> </div>
    </section>
    <section>
  <div id="myCarousel" class="carousel slide mb-6" data-bs-ride="carousel">
    <!-- Indicators -->
    <div class="carousel-indicators">
      <button 
        type="button" 
        data-bs-target="#myCarousel" 
        data-bs-slide-to="0" 
        class="active" 
        aria-label="Slide 1" 
        aria-current="true"
      ></button>
      <button 
        type="button" 
        data-bs-target="#myCarousel" 
        data-bs-slide-to="1" 
        aria-label="Slide 2"
      ></button>
      <button 
        type="button" 
        data-bs-target="#myCarousel" 
        data-bs-slide-to="2" 
        aria-label="Slide 3"
      ></button>
    </div>

    <!-- Carousel Items -->
    <div class="carousel-inner">
      <!-- Slide 1 -->
      <div class="carousel-item active">
        <img 
          src="https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg" 
          class="d-block w-100 carousel-image" 
          alt="Akathon"
        />
        <div class="carousel-overlay"></div>
        <div class="container">
          <div class="carousel-caption text-start">
            <h1>Akathon</h1>
            <p class="opacity-75">Join the ultimate coding competition and showcase your skills to win amazing prizes.</p>
            <p><a class="btn btn-lg btn-primary" href="#">Sign up today</a></p>
          </div>
        </div>
      </div>

      <!-- Slide 2 -->
      <div class="carousel-item">
        <img 
          src="https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg" 
          class="d-block w-100 carousel-image" 
          alt="SwinBiz Rockstar"
        />
        <div class="carousel-overlay"></div>
        <div class="container">
          <div class="carousel-caption">
            <h1>SwinBiz Rockstar</h1>
            <p>Compete in business challenges and become the next entrepreneurial star.</p>
            <p><a class="btn btn-lg btn-primary" href="#">Learn more</a></p>
          </div>
        </div>
      </div>

      <!-- Slide 3 -->
      <div class="carousel-item">
        <img 
          src="https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg" 
          class="d-block w-100 carousel-image" 
          alt="Swin-Hackathon"
        />
        <div class="carousel-overlay"></div>
        <div class="container">
          <div class="carousel-caption text-end">
            <h1>Swin-Hackathon</h1>
            <p>48 hours of innovation, coding, and creativity. Build something amazing!</p>
            <p><a class="btn btn-lg btn-primary" href="#">Browse gallery</a></p>
          </div>
        </div>
      </div>
    </div>

    <!-- Controls -->
    <button class="carousel-control-prev" type="button" data-bs-target="#myCarousel" data-bs-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#myCarousel" data-bs-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="visually-hidden">Next</span>
    </button>
  </div>
</section>
<div class="container marketing my-5">
  <!-- Three columns of text below the carousel -->
  <div class="row text-center">
    <div class="col-lg-4">
      <img 
        src="https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg" 
        class="rounded-circle mb-3" 
        width="140" 
        height="140" 
        alt="Competitions"
        style="object-fit: cover;"
      />
      <h2 class="fw-normal">Competitions</h2>
      <p>Participate in exciting coding challenges, hackathons, and innovation contests. Test your skills and win amazing prizes.</p>
      <p><a class="btn btn-secondary" href="#">View details »</a></p>
    </div>

    <div class="col-lg-4">
      <img 
        src="https://i.pinimg.com/1200x/a1/58/be/a158bedb7cde3727aba96a605b1cc5cc.jpg" 
        class="rounded-circle mb-3" 
        width="140" 
        height="140" 
        alt="Workshops"
        style="object-fit: cover;"
      />
      <h2 class="fw-normal">Workshops</h2>
      <p>Join hands-on workshops led by industry experts. Learn new technologies and enhance your professional skills.</p>
      <p><a class="btn btn-secondary" href="#">View details »</a></p>
    </div>

    <div class="col-lg-4">
      <img 
        src="https://i.pinimg.com/736x/f8/42/9a/f8429a0e5783b6365d8f4270fa01252a.jpg" 
        class="rounded-circle mb-3" 
        width="140" 
        height="140" 
        alt="Community"
        style="object-fit: cover;"
      />
      <h2 class="fw-normal">Community</h2>
      <p>Connect with fellow students and professionals. Build networks, share knowledge, and grow together.</p>
      <p><a class="btn btn-secondary" href="#">View details »</a></p>
    </div>
  </div>

  <!-- START THE FEATURETTES -->
  <hr class="featurette-divider my-5">

  <div class="row featurette align-items-center">
    <div class="col-md-7">
      <h2 class="featurette-heading fw-normal lh-1">
        Showcase Your Skills. 
        <span class="text-body-secondary">Compete to Win.</span>
      </h2>
      <p class="lead">
        Join our premier coding competitions where innovation meets opportunity. 
        Solve real-world challenges, collaborate with peers, and get recognized by top tech companies.
      </p>
    </div>
    <div class="col-md-5">
      <img 
        src="https://i.pinimg.com/736x/4a/89/60/4a89609b9fa86e607ddb5eb94c8143b5.jpg" 
        class="featurette-image img-fluid mx-auto rounded shadow" 
        alt="Competitions"
        style="max-width: 100%; height: auto;"
      />
    </div>
  </div>

  <hr class="featurette-divider my-5">

  <div class="row featurette align-items-center">
    <div class="col-md-7 order-md-2">
      <h2 class="featurette-heading fw-normal lh-1">
        Learn From the Best. 
        <span class="text-body-secondary">Grow Your Career.</span>
      </h2>
      <p class="lead">
        Access exclusive workshops and training sessions led by industry professionals. 
        From AI and machine learning to web development and cloud computing - we've got you covered.
      </p>
    </div>
    <div class="col-md-5 order-md-1">
      <img 
        src="https://i.pinimg.com/1200x/9e/43/80/9e438001e43ef2f66c66549945f24b67.jpg" 
        class="featurette-image img-fluid mx-auto rounded shadow" 
        alt="Workshops"
        style="max-width: 100%; height: auto;"
      />
    </div>
  </div>

  <hr class="featurette-divider my-5">

  <div class="row featurette align-items-center">
    <div class="col-md-7">
      <h2 class="featurette-heading fw-normal lh-1">
        Build Your Network. 
        <span class="text-body-secondary">Join the Community.</span>
      </h2>
      <p class="lead">
        Connect with like-minded students, alumni, and industry professionals. 
        Share ideas, collaborate on projects, and build relationships that last beyond graduation.
      </p>
    </div>
    <div class="col-md-5">
      <img 
        src="https://i.pinimg.com/736x/33/28/56/3328562d8cb937e5f833ef1f79d5f7b8.jpg" 
        class="featurette-image img-fluid mx-auto rounded shadow" 
        alt="Community"
        style="max-width: 100%; height: auto;"
      />
    </div>
  </div>

  <hr class="featurette-divider my-5">
</div>
</template>

<script>
import router from '../router';
import CompetitionCard from '../components/CompetitionCard.vue';

export default {
  name: 'Home',
  data() {
    return {
      featuredCompetitions: []
    }
  },
  components: {
    CompetitionCard
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' }
      return new Date(dateString).toLocaleDateString('en-US', options)
    },
    async loadCompetitions() {
      try {
        const response = await fetch('/src/data/competitions.json')
        const data = await response.json()
        // Get first 3 competitions for carousel
        this.featuredCompetitions = data.competitions.slice(0, 3)
      } catch (error) {
        console.error('Error loading competitions:', error)
      }
    }
  },
  mounted() {
    this.loadCompetitions()
  }
}
</script>

<style scoped>
@media (min-width: 768px) {
  header {
    min-height: 400px;
  }
}

@media (max-width: 767px) {
  header {
    background-image: none !important;
  }
  
  .overlay {
    display: none;
  }
}
.carousel-image {
  height: 500px;
  object-fit: cover;
  object-position: center;
}

.carousel-item {
  position: relative;
}

.carousel-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to bottom, rgba(0,0,0,0.3), rgba(0,0,0,0.6));
  z-index: 1;
}

.carousel-caption {
  position: relative;
  z-index: 2;
}

.carousel-caption h1 {
  font-size: 3rem;
  font-weight: bold;
  text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
}

.carousel-caption p {
  font-size: 1.25rem;
  text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
}

@media (max-width: 768px) {
  .carousel-image {
    height: 400px;
  }
  
  .carousel-caption h1 {
    font-size: 2rem;
  }
  
  .carousel-caption p {
    font-size: 1rem;
  }
}
</style>