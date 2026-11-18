/**
 * CityCare – Purple Radial Navigation Menu behaviour
 * ---------------------------------------------------
 * ISOLATION: everything is wrapped in an IIFE, so no global variables or
 * function names are created. Safe to load alongside js/main.js.
 *
 * Behaviour:
 *   - centre button (label + hidden checkbox) opens / closes the menu
 *   - closes when a menu item is chosen
 *   - closes when clicking anywhere outside the menu
 *   - closes on Escape
 *
 * The menu items are plain <a> links, so they navigate to the existing
 * servlet routes of the current role.
 */
(function () {
    'use strict';

    function initRadialMenu(root) {
        if (!root || root.dataset.radialReady === 'true') {
            return;
        }
        root.dataset.radialReady = 'true';

        var toggle = root.querySelector('.radial-toggle');
        if (!toggle) {
            return;
        }

        function isOpen() {
            return toggle.checked === true;
        }

        function close() {
            toggle.checked = false;
        }

        // Centre button is a <label> for the hidden checkbox, so the browser
        // toggles it natively. We only stop the event from reaching the
        // document-level "click outside" handler below (otherwise the menu
        // would immediately close itself again).
        var fab = root.querySelector('.radial-fab');
        if (fab) {
            fab.addEventListener('click', function (e) {
                e.stopPropagation();
            });
        }

        // Close after choosing an item (navigation still happens normally).
        var actions = root.querySelectorAll('.radial-action, .radial-item');
        Array.prototype.forEach.call(actions, function (item) {
            item.addEventListener('click', function () {
                close();
            });
        });

        // Close when clicking outside the menu.
        document.addEventListener('click', function (e) {
            if (isOpen() && !root.contains(e.target)) {
                close();
            }
        });

        // Close on Escape.
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' && isOpen()) {
                close();
                if (fab) {
                    fab.focus();
                }
            }
        });
    }

    function boot() {
        var docks = document.querySelectorAll('.radial-dock');
        Array.prototype.forEach.call(docks, initRadialMenu);
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
