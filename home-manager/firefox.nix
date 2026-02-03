{ config, ... }:

let
    userName = config.userName;
in
{
    home-manager.users.${userName} = {
        programs.firefox = {
            enable = true;

            languagePacks = [
                "en-US"
                "zh-cn"
            ];

            policies = {
                BlockAboutConfig = false;

                # DisableFirefoxStudies = true;
                DontCheckDefaultBrowser = true;

                AutofillAddressEnabled = false;
                AutofillCreditCardEnabled = false;
                PostQuantumKeyAgreementEnabled = true;

                FirefoxSuggest = {
                    WebSuggestions = false;
                    SponsoredSuggestions = false;
                    ImproveSuggest = false;
                    Locked = true;
                };

                # DisableTelemetry = true;
                EnableTrackingProtection = {
                    Locked = true;
                    Value = true;
                    Cryptomining = true;
                    Fingerprinting = true;
                    EmailTracking = true;
                };

                DisablePocket = true;
                NetworkPrediction = false;

                SanitizeOnShutdown = {
                    Locked = true;
                    Cache = true;
                    Cookies = true;
                    Sessions = true;
                    FormData = true;
                    SiteSettings = true;
                    History = false;
                    Downloads = false;
                };

                /* download */
                DefaultDownloadDirectory = "$HOME/download";

                HttpAllowlist = [
                    "http://localhost"
                    "http://127.0.0.1"
                    "http://10.0.0.1"
                    "http://linode.me"
                ];

                /* cookies */
                Cookies = {
                    Allow = [
                        "http://10.0.0.1:9091"
                        "http://linode.me"
                        /* wikipedia */
                        "https://wikipedia.org"
                        /* github */
                        "https://github.com"
                        /* lwn */
                        "https://lwn.net"
                        /* google */
                        "https://google.com"
                        "https://www.google.com"
                        "https://accounts.google.com"
                        "https://mail.google.com"
                        "https://drive.google.com"
                        "https://youtube.com"
                        "https://www.youtube.com"
                        /* douban */
                        "https://douban.com"
                        /* zhihu */
                        "https://zhihu.com"
                        /* monkeytype */
                        "https://monkeytype.com"
                        /* linode */
                        "https://linode.com"
                        "https://cloud.linode.com"
                        "https://login.linode.com"
                        /* stackoverflow */
                        "https://stackoverflow.com"
                        /* reddit */
                        "https://reddit.com"
                        /* srt */
                        "https://srtku.com"
                        /* zlib */
                        "http://bookszlibb74ugqojhzhg2a63w5i2atv5bqarulgczawnbmsb6s6qead.onion"
                    ];
                };
            };

            profiles = {
                KISS = {
                    isDefault = true;
                    id = 0;
                    name = "KISS";
                    search = {
                        enable = true;
                        force = true;
                        engines = {
                            google = {
                                metaData = {
                                    alias = "@g";
                                };
                            };
                        };
                        order = [
                            "google"
                        ];
                        default = "google";
                        privateDefault = "google";
                    };

                    # containers = {
                    #     self = {
                    #         color = "purple";
                    #         icon = "fingerprint";
                    #         id = 1;
                    #     };

                    #     study = {
                    #         color = "orange";
                    #         icon = "pet";
                    #         id = 2;
                    #     };

                    #     tor = {
                    #         color = "blue";
                    #         icon = "fence";
                    #         id = 3;
                    #     };
                    # };

                    extraConfig = ''
                        /* chrome */
                        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

                        /* warning */
                        user_pref("browser.aboutConfig.showWarning", false);

                        /* compact */
                        user_pref("browser.compactmode.show", true);

                        /* translations */
                        user_pref("browser.translations.enable", false);
                        user_pref("browser.translations.automaticallyPopup", false);

                        /* wayland */
                        user_pref("widget.wayland.fractional-scale.enabled", true);
                        user_pref("widget.wayland.vsync.enabled", true);
                        user_pref("widget.gtk.global-menu.wayland.enabled", true);

                        /* tab */
                        user_pref("browser.tabs.closeTabByDblclick", true);
                        user_pref("browser.tabs.loadBookmarksInTabs", true);
                        user_pref("browser.urlbar.openintab", true);
                        user_pref("browser.sessionstore.restore_on_demand", true);
                        user_pref("browser.sessionstore.restore_tabs_lazily", false);

                        /* http3 */
                        user_pref("network.http.http3.enable", true);
                        user_pref("network.http.http3.enable_0rtt", true);
                        user_pref("network.http.http3.version_negotiation.enabled", true);
                        user_pref("network.http.http3.priority", true);
                        user_pref("network.http.http3.retry_different_ip_family", true);

                        /* https */
                        user_pref("dom.security.https_only_mode", false);
                        user_pref("dom.security.https_first", true);

                        /* local */
                        user_pref("dom.security.https_only_mode.upgrade_local", false);

                        /* libnotify */
                        user_pref("content.notify.interval", 100000);
                        user_pref("dom.webnotifications.enabled", true);
                        user_pref("alerts.useSystemBackend", true);

                        /* ctrl+q */
                        user_pref("browser.quitShortcut.disabled", true);

                        /* alt key shortcut for menubar */
                        user_pref("ui.key.menuAccessKey", 0);
                        user_pref("ui.key.menuAccessKeyFocuses", false);

                        /* tab focus */
                        user_pref("accessibility.tabfocus", 1);

                        /* download popup menu */
                        user_pref("browser.download.alwaysOpenPanel", false);

                        /* pocket */
                        user_pref("extensions.pocket.enabled", false);

                        /* tab animation */
                        user_pref("ui.prefersReducedMotion", 0);

                        /* concurrency */
                        user_pref("dom.maxHardwareConcurrency", 8);

                        /* search */
                        user_pref("browser.search.countryCode", "CN");
                        user_pref("browser.search.region", "CN");
                        user_pref("browser.search.geoip.url", "");

                        /* new tab */
                        user_pref("browser.newtabpage.enabled", false);
                        user_pref("browser.newtab.url", "about:blank");
                        user_pref("browser.link.open_newwindow", 3);
                        user_pref("browser.link.open_newwindow.restriction", 0);
                        user_pref("dom.disable_open_during_load", true);

                        /* home page */
                        user_pref("browser.startup.homepage", "about:blank");

                        /* language */
                        user_pref("intl.accept_languages", "zh-CN, zh, en-US, en");

                        /* javascript local language */
                        user_pref("javascript.use_us_english_locale", true);

                        /* dns */
                        user_pref("network.proxy.socks_remote_dns", true);
                        user_pref("network.dns.disableIPv6", false);
                        user_pref("network.dns.preferIPv6", true);

                        /* onion */
                        user_pref("network.dns.blockDotOnion",	false);
                        user_pref("dom.security.https_only_mode.upgrade_onion", false);
                        user_pref("dom.securecontext.allowlist_onions", false);

                        /* pdf viewer */
                        user_pref("pdfjs.disabled", true);

                        /* update */
                        user_pref("app.update.enabled", false);

                        /* blocklist update */
                        user_pref("extensions.blocklist.enabled",	true);
                        user_pref("services.blocklist.update_enabled", true);

                        /* safe browsing */
                        user_pref("browser.safebrowsing.phishing.enabled", true);
                        user_pref("browser.safebrowsing.malware.enabled", true);
                        user_pref("browser.safebrowsing.downloads.remote.enabled", false);
                        user_pref("browser.safebrowsing.blockedURIs.enabled", true);

                        /* autoplay */
                        user_pref("media.autoplay.enabled", false);

                        /* geolocation */
                        user_pref("geo.enabled", false);
                        user_pref("geo.provider.use_gpsd", false);

                        /* form fill */
                        user_pref("browser.formfill.enable", true);

                        /* sensor api */
                        user_pref("device.sensors.enabled", false);

                        /* vr api */
                        user_pref("dom.vr.enabled", false);

                        /* webgl api */
                        user_pref("webgl.disabled", false);

                        /* WebAssembly */
                        user_pref("javascript.options.wasm", true);

                        /* camer */
                        user_pref("permissions.default.camera", 2);
                        user_pref("camera.control.face_detection.enabled", false);

                        /* microphone */
                        user_pref("permissions.default.microphone", 2);

                        /* privacy */
                        user_pref("privacy.resistFingerprinting", false);
                        user_pref("privacy.firstparty.isolate", true);
                        user_pref("privacy.userContext.enabled", true);
                        user_pref("privacy.trackingprotection.enabled",	true);
                        user_pref("privacy.trackingprotection.pbmode.enabled", true);
                        user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
                        user_pref("privacy.trackingprotection.cryptomining.enabled", true);

                        /* TLS OCSP */
                        user_pref("security.tls.version.min", 3);
                        user_pref("security.tls.version.fallback-limit", 4);
                        user_pref("security.ssl.disable_session_identifiers", false);
                        user_pref("security.tls.enable_0rtt_data", true);
                        user_pref("security.ssl.require_safe_negotiation", true);
                        user_pref("security.OCSP.enabled", 1);
                        user_pref("security.ssl.enable_ocsp_stapling", true);
                        user_pref("security.ssl.enable_ocsp_must_staple", true);
                        user_pref("security.OCSP.require", true);
                        user_pref("browser.xul.error_pages.expert_bad_cert", true);
                        user_pref("security.insecure_connection_icon.enabled", true);
                        user_pref("security.insecure_connection_text.enabled", true);

                        /* WebAssembly */
                        user_pref("javascript.options.wasm", true);

                        /* battery api */
                        user_pref("dom.battery.enabled", false);

                        /* HSTS */
                        user_pref("network.stricttransportsecurity.preloadlist", true);

                        /* webrtc */
                        user_pref("media.peerconnection.enabled", false);
                        user_pref("media.peerconnection.turn.disable", false);
                        user_pref("media.peerconnection.use_document_iceservers", false);
                        user_pref("media.peerconnection.video.enabled", false);

                        /* picture in picture */
                        user_pref("media.videocontrols.picture-in-picture.enabled", false);
                        user_pref("media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled", false);

                        /* */
                        user_pref("devtools.f12_enabled", false);
                        user_pref("accessibility.force_disabled", 1);

                        /* Default Browser Check */
                        user_pref("browser.shell.checkDefaultBrowser", false);

                        /* Profiles */
                        user_pref("browser.profiles.enabled", true);

                        /** Cookie Banner ***/
                        user_pref("cookiebanners.service.mode", 1);
                        user_pref("cookiebanners.service.mode.privateBrowsing", 1);

                        /* Smooth Scroll */
                        /* user_pref("general.smoothScroll", true); */
                        /* user_pref("general.smoothScroll.msdPhysics.enabled", true); */

                        /* disable onboarding junk */
                        user_pref("browser.onboarding.enabled", false);

                        /* */
                        user_pref("browser.contentblocking.category", "strict");

                        /* cache */
                        user_pref("browser.cache.disk.enable", false);
                        user_pref("browser.cache.memory.enable", true);
                        user_pref("browser.cache.memory.capacity", -1);
                        user_pref("browser.cache.memory.max_entry_size", 655360);
                        user_pref("media.memory_cache_max_size", 131072);
                        user_pref("media.cache_readahead_limit", 14400);
                        user_pref("media.cache_resume_threshold", 7200);
                        user_pref("image.cache.size", 20971520);

                        /* webrender */
                        user_pref("media.ffmpeg.vaapi.enabled", true);
                        user_pref("media.hardware-video-decoding.force-enabled", true);
                        user_pref("gfx.wayland.hdr", true);
                        user_pref("gfx.canvas.accelerated", true);
                        user_pref("gfx.canvas.accelerated.cache-items", 4096);
                        user_pref("gfx.canvas.accelerated.cache-size", 512);
                        user_pref("gfx.content.skia-font-cache-size", 24);
                        user_pref("gfx.webrender.all", true);
                        user_pref("gfx.webrender.compositor", true);
                        user_pref("gfx.webrender.compositor.force-enabled", true);
                        user_pref("gfx.webrender.enabled", true);
                        user_pref("gfx.webrender.precache-shaders", true);
                        user_pref("gfx.webrender.program-binary-disk", true);
                        user_pref("gfx.webrender.layer-compositor", true);
                        user_pref("layers.gpu-process.enabled", true);
                        user_pref("layers.gpu-process.force-enabled", true);
                        user_pref("layers.acceleration.force-enabled", true);
                        user_pref("image.mem.decode_bytes_at_a_time", 65536);
                        user_pref("media.wmf.zero-copy-nv12-textures-force-enabled", true);
                        user_pref("media.av1.enabled", false);

                        /* network */
                        user_pref("network.http.max-connections", 900);
                        user_pref("network.http.max-persistent-connections-per-server", 8);
                        user_pref("network.http.max-urgent-start-excessive-connections-per-host", 6);
                        user_pref("network.http.pacing.requests.enabled", false);
                        user_pref("network.dnsCacheExpiration", 3600);
                        user_pref("network.ssl_tokens_cache_capacity", 32768);
                        user_pref("network.dns.disablePrefetchFromHTTPS", false);
                        user_pref("network.dnsCacheEntries", 20000);
                        user_pref("network.dnsCacheExpiration", 3600);
                        user_pref("network.dnsCacheExpirationGracePeriod", 240);
                        user_pref("network.predictor.enable-hover-on-ssl", true);
                        user_pref("network.predictor.enable-prefetch", true);
                        user_pref("network.predictor.preconnect-min-confidence", 20);
                        user_pref("network.predictor.prefetch-force-valid-for", 3600);
                        user_pref("network.predictor.prefetch-min-confidence", 30);
                        user_pref("network.predictor.prefetch-rolling-load-count", 120);
                        user_pref("network.predictor.preresolve-min-confidence", 10);

                        /* */
                        user_pref("fission.autostart", false);
                        user_pref("privacy.partition.network_state", false);
                        user_pref("content.notify.backoffcount", 0);

                        /* urlbar */
                        user_pref("browser.urlbar.showSearchTerms.enabled", false);
                        user_pref("browser.urlbar.suggest.quicksuggest", false);
                        user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
                        user_pref("browser.urlbar.showSearchTerms.enabled", false);
                        user_pref("browser.urlbar.suggest.engines", false);
                        user_pref("browser.urlbar.trending.featureGate", false);
                        user_pref("browser.urlbar.groupLabels.enabled", false);
                        user_pref("browser.urlbar.quicksuggest.enabled", false);
                        user_pref("browser.urlbar.filter.javascript", true);
                        user_pref("browser.urlbar.trimURLs", false);
                        user_pref("browser.urlbar.scotchBonnet.enableOverride", false);
                        user_pref("browser.urlbar.shortcuts.bookmarks", false);
                        user_pref("browser.urlbar.shortcuts.history", false);
                        user_pref("browser.urlbar.shortcuts.tabs", false);
                        user_pref("browser.urlbar.suggest.addons", false);
                        user_pref("browser.urlbar.suggest.quickactions", false);
                        user_pref("browser.urlbar.suggest.mdn", false);
                        user_pref("browser.urlbar.suggest.fakespot", false);
                        user_pref("browser.urlbar.suggest.pocket", false);
                        user_pref("browser.urlbar.suggest.remotetab", false);
                        user_pref("browser.urlbar.accessibility.tabToSearch.announceResults", false);
                        user_pref("browser.urlbar.contextualSearch.enabled", false);
                        user_pref("browser.urlbar.quicksuggest.allowPositionInSuggestions", false);
                        user_pref("browser.urlbar.quicksuggest.rustEnabled", false);

                        /* dbus */
                        user_pref("media.hardwaremediakeys.enabled", true);

                        /* mkv */
                        user_pref("media.mkv.enabled", true);

                        /* ai */
                        user_pref("browser.ml.enable", false);

                        /* file picker */
                        user_pref("widget.use-xdg-desktop-portal.file-picker", 0);

                        /* security level */
                        user_pref("security.sandbox.content.level", 9);
                        user_pref("security.sandbox.socket.process.level", 2);
                        user_pref("security.sandbox.gpu.level", 2);
                    '';

                    userChrome = ''
                        @media not -moz-pref("sidebar.verticalTabs") {
                            .tabbrowser-tab[fadein] {
                                min-width: 16px !important;
                            }

                            .tab-icon-image {
                                margin-inline-end: 2px !important;
                            }

                            .tab-content {
                                margin-inline-start: 1px;
                            }

                            .tabbrowser-tab {
                                min-width: 24px;
                            }

                            .toolbar-items {
                                align: center !important;
                                padding-right: 2px !important;
                            }

                            .tabbrowser-tab[fadein]:not([pinned]):not([style*="max-width"])
                            {
                                max-width: 128px !important;
                            }

                            .tab-content {
                                overflow: hidden;
                            }

                            :root {
                                --tab-min-height: 32px !important;
                            }

                            #tabbrowser-tabs {
                                border-inline-start: 0px !important;
                                margin-inline-start: 0px !important;
                            }

                            #tabbrowser-tabs .tab-context-line:not([selected]) {
                                display: none;
                            }

                            .tab-background:not([selected]) {
                                border: 1px solid #a89984;
                            }

                            .tab-background[selected] {
                                background: #282828;
                            }

                            #tabbrowser-tabs .tab-background:not([selected]) {
                                border: solid 1px var(--identity-icon-color, #ccc) !important;
                            }

                            #tabbrowser-tabs .tab-background[selected] {
                                border-top: solid 1px var(--identity-icon-color, #fff) !important;
                            }

                            #tabbrowser-tabs {
                                border: 0 !important;
                            }

                            .tabbrowser-tab .tab-label {
                                font-family: MiSans !important;
                                font-size: 12px;
                            }
                        }

                        .urlbar-input-container {
                            height: 32px !important;
                            margin-top: 4px !important;
                        }

                        #urlbar-input {
                            font-size: 15px !important;
                            padding-bottom: 2px !important;
                        }

                        .titlebar-spacer {
                            display: none;
                        }

                        #toolbar .toolbarbutton-1.animate-out {
                            animation-duration: 0s !important;
                        }

                        /* status */
                        #statuspanel #statuspanel-label {
                            display: none !important;
                        }

                        #mainPopupSet menupopup, #appMenu-popup {
                            font-family: Roboto Flex, MiSans !important;
                            font-size: 12px;
                        }

                        .urlbar-input-box {
                            font-family: Roboto Flex, MiSans !important;
                        }

                        .titlebar-buttonbox-container {
                            display: none;
                        }

                        #pageAction-urlbar-_testpilot-containers {
                            display: none;
                        }

                        #userContext-icons #userContext-label {
                            display: none;
                        }

                        #reader-mode-button {
                            display: none;
                        }

                        .tab-close-button {
                            display: none;
                        }

                        .titlebar-close {
                            display: none;
                        }

                        #back-button {
                            display: none;
                        }

                        #forward-button {
                            display: none;
                        }

                        #stop-reload-button {
                            display: none;
                        }

                        #alltabs-button {
                            display: none;
                        }

                        #tabs-newtab-button {
                            display: none;
                        }

                        #new-tab-button {
                            display: none;
                        }

                        #firefox-view-button {
                            display: none;
                        }

                        #fxa-toolbar-menu-button {
                            display: none;
                        }

                        #navigator-toolbox #nav-bar {
                            order: 1 !important;
                        }

                        #TabsToolbar {
                            order: 2 !important;
                        }

                        #PersonalToolbar {
                            display: none;
                        }
                    '';

                    userContent = ''
                        :root {
                          scrollbar-width: none !important;
                        }

                        moz-vpn-container-ui {
                          display: none !important;
                        }
                    '';
                };

                TOR = {
                    isDefault = false;
                    name = "TOR";
                    id = 1;
                    search = {
                        enable = true;
                        force = true;
                        default = "ddg";
                        privateDefault = "ddg";
                    };
                };
            };
        };
    };
}


# vim: ts=4 sw=4 sts=4 ft=nix et:
