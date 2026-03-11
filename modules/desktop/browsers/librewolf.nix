# modules/desktop/browsers/librewolf.nix
{ config, lib, pkgs, ... }:
let
  user        = config.user.name;
  profileName = user;
  localDir    = "${config.home.fakeDir}/.librewolf";
in {
  options.modules.desktop.browsers.librewolf = {
    enable      = lib.mkEnableOption "librewolf";
    userChrome  = lib.mkOption { type = lib.types.lines; default = ""; };
    userContent = lib.mkOption { type = lib.types.lines; default = ""; };
    extraConfig = lib.mkOption { type = lib.types.lines; default = ""; };
  };

  config = lib.mkIf config.modules.desktop.browsers.librewolf.enable {
    home-manager.users.${user} = { pkgs, osConfig, lib, ... }: {

      # ── Profile jail ──────────────────────────────────────────────
      # Force profile into fakeDir so ~/.librewolf never appears
      home.file = {
        "${localDir}/profiles.ini".text = ''
          [Profile0]
          Name=default
          IsRelative=1
          Path=${profileName}.default
          Default=1

          [General]
          StartWithLastProfile=1
          Version=2
        '';
      } // lib.optionalAttrs (config.modules.desktop.browsers.librewolf.userChrome != "") {
        "${localDir}/${profileName}.default/chrome/userChrome.css".text =
          config.modules.desktop.browsers.librewolf.userChrome;
      } // lib.optionalAttrs (config.modules.desktop.browsers.librewolf.userContent != "") {
        "${localDir}/${profileName}.default/chrome/userContent.css".text =
          config.modules.desktop.browsers.librewolf.userContent;
      };

      # ── XDG wrapper — obey or be jailed ───────────────────────────
      home.packages = [
        (pkgs.writeShellScriptBin "librewolf" ''
          export HOME="$XDG_FAKE_HOME"
          exec "${osConfig.programs.firefox.package}/bin/librewolf" "$@"
        '')
      ];

      # ── Default apps ──────────────────────────────────────────────
      xdg.mimeApps.defaultApplications = {
        "application/pdf"  = "librewolf.desktop";
        "text/html"        = "librewolf.desktop";
        "x-scheme-handler/http"  = "librewolf.desktop";
        "x-scheme-handler/https" = "librewolf.desktop";
      };

      # ── Browser config ────────────────────────────────────────────
      programs.firefox = {
        enable  = true;
        package = pkgs.librewolf;

        policies = {
          DontCheckDefaultBrowser = true;
          DisablePocket           = true;
          DisableAppUpdate        = true;
          DisableTelemetry        = true;
          DisableFirefoxStudies   = true;

          # Force-install extensions (can't be disabled by user)
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              install_url       = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
            "jid1-ZAdIEUB7XOzOJw@jetpack" = {
              install_url       = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
              installation_mode = "force_installed";
            };
          };

          Preferences = {
            # ── XDG / Home cleanliness ─────────────────────────────
            # Stop creating ~/Downloads — use our lowercase xdg dir
            "browser.download.dir"              = "${config.user.home}/downloads";
            "browser.download.folderList"       = 2; # custom dir, not Desktop

            # ── UI declutter ───────────────────────────────────────
            "svg.context-properties.content.enabled"                = true;
            "browser.toolbars.keyboard_navigation"                  = false;
            "browser.translations.automaticallyPopup"               = false;
            "browser.disableResetPrompt"                            = true;
            "browser.onboarding.enabled"                            = false;
            "browser.aboutConfig.showWarning"                       = false;
            "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
            "reader.parse-on-load.enabled"                          = false;
            "extensions.pocket.enabled"                             = false;
            "extensions.unifiedExtensions.enabled"                  = false;
            "extensions.shield-recipe-client.enabled"               = false;

            # ── New tab / startup ──────────────────────────────────
            "browser.newtabpage.enabled"                            = false;
            "browser.newtab.url"                                    = "about:blank";
            "browser.newtab.preload"                                = false;
            "browser.newtabpage.activity-stream.enabled"            = false;
            "browser.newtabpage.activity-stream.telemetry"          = false;
            "browser.newtabpage.enhanced"                           = false;
            "browser.newtabpage.introShown"                         = true;
            "browser.newtabpage.directory.ping"                     = "";
            "browser.newtabpage.directory.source"                   = "data:text/plain,{}";
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr"          = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons"   = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

            # ── URL bar ────────────────────────────────────────────
            "browser.urlbar.suggest.searches"                       = false;
            "browser.urlbar.shortcuts.bookmarks"                    = false;
            "browser.urlbar.shortcuts.history"                      = false;
            "browser.urlbar.shortcuts.tabs"                         = false;
            "browser.urlbar.showSearchSuggestionsFirst"             = false;
            "browser.urlbar.speculativeConnect.enabled"             = false;
            "browser.urlbar.resultMenu.keyboardAccessible"          = false;
            "browser.urlbar.dnsResolveSingleWordsAfterSearch"       = 0;
            "browser.urlbar.suggest.quicksuggest.nonsponsored"      = false;
            "browser.urlbar.suggest.quicksuggest.sponsored"         = false;
            "browser.urlbar.trimURLs"                               = false;

            # ── Privacy & tracking ─────────────────────────────────
            "browser.contentblocking.category"                      = "strict";
            "privacy.donottrackheader.enabled"                      = true;
            "privacy.donottrackheader.value"                        = 1;
            "privacy.purge_trackers.enabled"                        = true;
            "privacy.fingerprintingProtection"                      = true;
            "privacy.resistFingerprinting"                          = true;
            "privacy.trackingprotection.enabled"                    = true;
            "privacy.trackingprotection.emailtracking.enabled"      = true;
            "privacy.trackingprotection.fingerprinting.enabled"     = true;
            "privacy.trackingprotection.socialtracking.enabled"     = true;
            # Lissner: sanitise on shutdown
            "privacy.sanitize.sanitizeOnShutdown"                   = true;
            "privacy.clearOnShutdown.cache"                         = true;
            "privacy.clearOnShutdown.cookies"                       = false; # keep logins
            "privacy.clearOnShutdown.history"                       = false; # keep history
            "privacy.clearOnShutdown.downloads"                     = false;
            "privacy.clearOnShutdown.formdata"                      = true;

            # ── Security ───────────────────────────────────────────
            "security.family_safety.mode"                           = 0;
            "security.pki.sha1_enforcement_level"                   = 1;
            "security.tls.enable_0rtt_data"                         = false;
            # Lissner: HTTPS-only mode
            "dom.security.https_only_mode"                          = true;
            "dom.security.https_only_mode_ever_enabled"             = true;
            # Lissner: disable dangerous APIs
            "dom.battery.enabled"                                    = false;
            "dom.gamepad.enabled"                                    = false;
            "beacon.enabled"                                        = false;
            "browser.send_pings"                                    = false;
            "browser.fixup.alternate.enabled"                       = false;
            # Lissner: OCSP for certificate validation
            "security.OCSP.enabled"                                 = 1;
            "security.OCSP.require"                                 = true;

            # ── Geolocation ────────────────────────────────────────
            # Use Mozilla's service instead of Google
            "geo.provider.network.url"                              = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
            "geo.provider.use_gpsd"                                 = false;

            # ── Password / form ────────────────────────────────────
            "signon.rememberSignons"                                = false;
            "browser.formfill.enable"                               = false;
            "extensions.formautofill.addresses.enabled"             = false;
            "extensions.formautofill.available"                     = "off";
            "extensions.formautofill.creditCards.available"         = false;
            "extensions.formautofill.creditCards.enabled"           = false;
            "extensions.formautofill.heuristics.enabled"            = false;

            # ── Performance / SSD ──────────────────────────────────
            # Write session every 30min not 15sec — kinder to SSDs
            "browser.sessionstore.interval"                         = "1800000";
            # Lissner: reduce session history entries
            "browser.sessionhistory.max_entries"                    = 25;

            # ── Sync ───────────────────────────────────────────────
            "services.sync.prefs.sync.browser.uiCustomization.state" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets"   = true;

            # ── Crash / telemetry / reporting ──────────────────────
            "toolkit.telemetry.unified"                             = false;
            "toolkit.telemetry.enabled"                             = false;
            "toolkit.telemetry.server"                              = "data:,";
            "toolkit.telemetry.archive.enabled"                     = false;
            "toolkit.telemetry.coverage.opt-out"                    = true;
            "toolkit.coverage.opt-out"                              = true;
            "toolkit.coverage.endpoint.base"                        = "";
            "experiments.supported"                                 = false;
            "experiments.enabled"                                   = false;
            "experiments.manifest.uri"                              = "";
            "browser.ping-centre.telemetry"                         = false;
            "app.normandy.enabled"                                  = false;
            "app.normandy.api_url"                                  = "";
            "app.shield.optoutstudies.enabled"                      = false;
            "datareporting.healthreport.uploadEnabled"              = false;
            "datareporting.healthreport.service.enabled"            = false;
            "datareporting.policy.dataSubmissionEnabled"            = false;
            "breakpad.reportURL"                                    = "";
            "browser.tabs.crashReporting.sendReport"                = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2"     = false;
            "extensions.htmlaboutaddons.recommendations.enabled"    = false;
            "extensions.htmlaboutaddons.discover.enabled"           = false;
            "extensions.getAddons.showPane"                         = false;
            "browser.discovery.enabled"                             = false;
            "browser.shell.checkDefaultBrowser"                     = false;
          };
        };
      };
    };
  };
}
