def setup_sweetalert
  custom_sweetalert
  append_file 'app/frontend/javascripts/libs.js' do
    <<~JAVASCRIPT
      import "libs/sweetalert";
    JAVASCRIPT
  end

  append_file 'app/frontend/stylesheets/libs.scss' do
    <<~CSS
      @import '~@sweetalert2/theme-bootstrap-4/bootstrap-4.scss';
    CSS
  end
end

def custom_sweetalert
  file 'app/frontend/libs/sweetalert.js' do
    <<~JAVASCRIPT
      // https://diserve-it.com/post/using-sweet-alert-as-confirm-in-ruby-on-rails-6
      import Swal from "sweetalert2";
      import Rails from "@rails/ujs";
      const elements = ['a[data-confirm]', 'button[data-confirm]', 'input[type=submit][data-confirm]']

      // Behavior after click to confirm button
      const confirmed = (element, result) => {
        if (result.value) {
          // ajax call
          if (!!element.getAttribute("data-remote")) {
            let reloadAfterSuccess = !!element.getAttribute("data-reload");

            Rails.ajax({
              type: element.getAttribute("data-method") || "GET",
              url: element.getAttribute("href"),
              success: (result) => {
                Swal.fire("Success!", result.message || "", "success").then(
                  (_result) => {
                    if (reloadAfterSuccess) {
                      window.location.reload();
                    }
                  }
                );
              },
              error: (xhr) => {
                let title = I18n.t('error');
                let message = "Something went wrong. Please try again later.";

                if (xhr.responseJSON && xhr.responseJSON.message) {
                  message = xhr.responseJSON.message;
                }

                Swal.fire(title, message, "error");
              },
            });
          } else {
                  // Removing attribute for unbinding JS event.
                  element.removeAttribute("data-confirm");
                  // Following a destination link
                  element.click();
                }
        }
      };
      // Display the confirmation dialog
      const showConfirmationDialog = (element) => {
        const message = element.getAttribute("data-confirm");

        Swal.fire({
          title: message || I18n.t("confirm_action"),
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: I18n.t("true"),
          cancelButtonText: I18n.t("cancel"),
          reverseButtons: true,
          focusConfirm: false,
          focusCancel: true
        }).then((result) => confirmed(element, result));
      };

      const allowAction = (element) => {
          if (element.getAttribute('data-confirm') === null) {
              return true;
          }

          showConfirmationDialog(element);
          return false;
      };

      const handleConfirm = (element) => {
          if (!allowAction(this)) {
              Rails.stopEverything(element);
          }
      }
      // Add event listener before the other Rails event listeners like the one
      // for `method: :delete`
      Rails.delegate(document, elements.join(', '), 'click', handleConfirm);
    JAVASCRIPT
  end
end
