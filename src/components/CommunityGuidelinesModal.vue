<template>

    <!-- Community Guidelines Modal -->
    <div 
      class="modal fade" 
      :class="{ show: true, 'd-block': true }"
      tabindex="-1"
      @click.self="$emit('close')">
      <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold">
              <i class="bi bi-shield-check text-primary me-2"></i>
              Community Guidelines
            </h5>
            <button 
              type="button" 
              class="btn-close" 
              @click="$emit('close')"></button>
          </div>
          <div class="modal-body">
            <p class="lead">
              SwinCom is a place for students and staff to showcase what they've created, 
              discover projects made by their peers, find great teams to work with, and 
              discover opportunities through competitions.
            </p>
            <p>
              Help us maintain a high quality and engaging community by following the guidelines below. 
              If you see something that's out of line, please report it or notify us at 
              <a href="mailto:support@swinburne.edu.vn">support@swinburne.edu.vn</a>.
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-hand-thumbs-up text-primary me-2"></i>Be Honest
            </h6>
            <p>
              Our community values integrity, so represent yourself, your work, and your team 
              accurately on your SwinCom profile.
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-file-earmark-code text-primary me-2"></i>Only Add Your Own Work
            </h6>
            <p>
              Don't submit projects that you did not create or work on. If you know of great 
              projects that should be here but aren't, ask the creators to add them!
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-award text-primary me-2"></i>Give Credit
            </h6>
            <p>
              If someone helped you or contributed to your project, add them as a teammate 
              so they get credit too.
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-copyright text-primary me-2"></i>Respect Others' Rights
            </h6>
            <p>
              Only upload materials which you created or have the right to use. Make sure 
              content you upload (including images and demo videos) does not include music, 
              footage, images, or trademarks that are someone else's property -- unless you 
              have permission to use it.
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-heart text-primary me-2"></i>Be Nice
            </h6>
            <p>
              We like to celebrate innovation and help each other improve our skills. Please 
              stick to constructive feedback and leave any snark / sarcasm / ego at home. 
              Any content that is abusive, threatening, expresses hatred, or is likely to 
              offend others is unacceptable and may result in the content being removed or 
              the suspension or termination of your account. When in doubt, remember the Golden Rule.
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-shield-check text-primary me-2"></i>Keep It Clean
            </h6>
            <p>
              The SwinCom community includes minors (13 years of age and older) and people 
              from countries all over the world. Please respect the diversity of our community. 
              Content containing illegal or excessive obscene or foul language, excessive violence, 
              nudity, or sexual activity will be flagged and removed. Content that is abusive or 
              likely to be offensive to others may also be flagged and removed. 
              <strong>Bottomline:</strong> If you wouldn't show it to your grandmother, it doesn't 
              belong on SwinCom!
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-lock text-primary me-2"></i>Respect Others' Privacy
            </h6>
            <p>
              Do not post personal or private information about others such as photos (unless 
              you have permission), telephone numbers, or email / physical addresses.
            </p>

            <h6 class="fw-bold mt-4 mb-3">
              <i class="bi bi-x-circle text-primary me-2"></i>No Spam
            </h6>
            <p>
              SwinCom is a place to showcase projects, participate in competitions, and share 
              your related questions, ideas, feedback, and encouragement. Do not use our site 
              to upload or post content that's not relevant, repeatedly post the same thing, 
              or send excessive, unsolicited messages to other users.
            </p>

            <div class="alert alert-warning mt-4">
              <strong>Important:</strong> SwinCom reserves the right to remove your content 
              and/or block or remove your account if we believe you have violated the guidelines 
              above. Please read our Terms of Service for complete terms and conditions related 
              to your use of our site.
            </div>
          </div>
          <div class="modal-footer">
            <button 
              type="button" 
              class="btn btn-primary" 
              @click="$emit('close')">
              I Understand
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Backdrop -->
    <div class="modal-backdrop fade show">
    </div>
</template>

<script>
export default {
  name: 'CommunityGuidelinesModal',
  emits: ['close']
}
</script>

<style scoped>
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
</style>