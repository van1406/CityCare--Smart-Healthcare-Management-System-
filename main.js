/**
 * CityCare: Smart City Complaint Management System
 * Client-Side Interactivity, Validation & Helpers
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Auto-dismiss alerts after 6 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(function () {
                if (alert.parentNode) {
                    alert.parentNode.removeChild(alert);
                }
            }, 400);
        }, 6000);
    });

    // 2. Alert close buttons
    const closeBtns = document.querySelectorAll('.alert-close');
    closeBtns.forEach(function (btn) {
        btn.addEventListener('click', function () {
            const alert = this.closest('.alert');
            if (alert) {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            }
        });
    });

    // 3. Client-side Form Validation for Registration
    const registerForm = document.querySelector('form#registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            const password = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            const phone = document.getElementById('phone').value;

            if (password !== confirm) {
                e.preventDefault();
                alert('Passwords do not match. Please verify.');
                return false;
            }

            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long.');
                return false;
            }

            // Indian 10-digit mobile check
            const phonePattern = /^[6-9]\d{9}$/;
            if (!phonePattern.test(phone.replace(/\D/g, ''))) {
                e.preventDefault();
                alert('Please enter a valid 10-digit mobile number.');
                return false;
            }
        });
    }

    // 4. Image Upload Preview & Size Validation
    const imageInput = document.getElementById('imageInput');
    const imagePreviewContainer = document.getElementById('imagePreviewContainer');
    const imagePreview = document.getElementById('imagePreview');

    if (imageInput && imagePreviewContainer && imagePreview) {
        imageInput.addEventListener('change', function () {
            const file = this.files[0];
            if (file) {
                if (file.size > 10 * 1024 * 1024) {
                    alert('File size exceeds 10 MB limit. Please select a smaller image.');
                    this.value = '';
                    imagePreviewContainer.style.display = 'none';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function (e) {
                    imagePreview.src = e.target.result;
                    imagePreviewContainer.style.display = 'block';
                };
                reader.readAsDataURL(file);
            } else {
                imagePreviewContainer.style.display = 'none';
            }
        });
    }

    // 5. Realtime Character Counter for Complaint Description
    const descTextarea = document.getElementById('descriptionTextarea');
    const charCountEl = document.getElementById('charCount');
    if (descTextarea && charCountEl) {
        descTextarea.addEventListener('input', function () {
            charCountEl.textContent = this.value.length;
        });
    }
});

// Demo account fill helper for login.jsp
function fillDemoAccount(role, email, pass) {
    const emailField = document.getElementById('email');
    const passField = document.getElementById('password');
    const roleSelect = document.getElementById('role');

    if (emailField) emailField.value = email;
    if (passField) passField.value = pass;
    if (roleSelect) roleSelect.value = role;

    // Highlight tab if tabs exist
    const tabs = document.querySelectorAll('.role-tab-btn');
    tabs.forEach(tab => {
        if (tab.getAttribute('data-role') === role) {
            tab.classList.add('active');
        } else {
            tab.classList.remove('active');
        }
    });
}

