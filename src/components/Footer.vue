<template>
  <footer class="bg-dark text-white py-5 mt-auto">
    <div class="container">
      <div class="row g-4">
        <!-- Company Info -->
        <div class="col-md-4">
          <h5 class="fw-semibold mb-3">SwinCom</h5>
          <p class="text-white-50">
            Connecting competitors and managing competitions efficiently.
          </p>
        </div>

        <!-- Contact Info -->
        <div class="col-md-4">
          <h5 class="fw-semibold mb-3">Contact Us</h5>
          <ul class="list-unstyled text-white-50">
            <li class="mb-2">
              <i class="bi bi-envelope-fill me-2"></i>
              <a href="mailto:info@swincom.com" class="text-white-50 text-decoration-none">info@swincom.com</a>
            </li>
            <li class="mb-2">
              <i class="bi bi-telephone-fill me-2"></i>
              <a href="tel:+61123456789" class="text-white-50 text-decoration-none">+61 1 2345 6789</a>
            </li>
            <li>
              <i class="bi bi-geo-alt-fill me-2"></i>
              <span>Swinburne Vietnam, Hanoi</span>
            </li>
          </ul>
        </div>
      </div>

      <hr class="bg-secondary my-4 opacity-25" />

      <!-- Bottom Section -->
      <div class="row align-items-center">
        <div class="col-md-6 text-center text-md-start">
          <p class="text-white-50 mb-0">&copy; 2025 SwinCom. All rights reserved.</p>
        </div>
        <div class="col-md-6 text-center text-md-end mt-3 mt-md-0">
          <div class="d-flex justify-content-center justify-content-md-end gap-3">
            <a href="#" class="text-white-50 fs-5"><i class="bi bi-facebook"></i></a>
            <a href="#" class="text-white-50 fs-5"><i class="bi bi-twitter"></i></a>
            <a href="#" class="text-white-50 fs-5"><i class="bi bi-linkedin"></i></a>
            <a href="#" class="text-white-50 fs-5"><i class="bi bi-instagram"></i></a>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<script>
export default {
  name: 'Footer'
};
</script>