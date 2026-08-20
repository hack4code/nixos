{ config, ... }:

let
    userName = config.userName;
    ffNoticationsAllow = config.ffNoticationsAllow;
    ffHttpAllow = config.ffHttpAllow;
    ffCookiesAllow = config.ffCookiesAllow;
    ffProxyPort = config.ffProxyPort;
    wgServerIp4Address = config.wgServerIp4Address;
in
{
    home-manager.users.${userName} = {
        programs.firefox = {
            enable = true;
            # package = pkgs.firefox-bin;

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

                DefaultDownloadDirectory = "$HOME/download";

                Permissions = {
                    Notifications = {
                        Allow = ffNoticationsAllow;
                        BlockNewRequests = true;
                        Locked = false;
                    };
                };

                HttpAllowlist = ffHttpAllow;

                Cookies = {
                    Allow = ffCookiesAllow;
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

                    settings = { };

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

                        /* ctrl+q */
                        user_pref("browser.quitShortcut.disabled", true);

                        /* alt key shortcut for menubar */
                        user_pref("ui.key.menuAccessKey", 0);
                        user_pref("ui.key.menuAccessKeyFocuses", false);

                        /* download popup menu */
                        user_pref("browser.download.alwaysOpenPanel", false);

                        /* pocket */
                        user_pref("extensions.pocket.enabled", false);

                        /* pdf viewer */
                        user_pref("pdfjs.disabled", true);

                        /* language */
                        user_pref("intl.accept_languages", "zh-CN, zh, en-US, en");

                        /* split view */
                        user_pref("browser.tabs.splitView.enabled", true);

                        /* home page */
                        user_pref("browser.startup.homepage", "about:blank");

                        /* geolocation */
                        user_pref("geo.enabled", false);
                        user_pref("geo.provider.use_gpsd", false);

                        /* file picker */
                        user_pref("widget.use-xdg-desktop-portal.file-picker", 0);

                        /* form fill */
                        user_pref("browser.formfill.enable", true);

                        /* sensor */
                        user_pref("device.sensors.enabled", false);

                        /* vr */
                        user_pref("dom.vr.enabled", false);

                        /* camer */
                        user_pref("permissions.default.camera", 2);
                        user_pref("camera.control.face_detection.enabled", false);

                        /* microphone */
                        user_pref("permissions.default.microphone", 2);

                        /* battery */
                        user_pref("dom.battery.enabled", false);

                        /* default browser check */
                        user_pref("browser.shell.checkDefaultBrowser", false);

                        /* profiles */
                        user_pref("browser.profiles.enabled", true);

                        /* cookie banner */
                        user_pref("cookiebanners.service.mode", 1);
                        user_pref("cookiebanners.service.mode.privateBrowsing", 1);

                        /* smooth scroll */
                        user_pref("general.smoothScroll", true);
                        user_pref("general.smoothScroll.msdPhysics.enabled", true);

                        /* disable onboarding junk */
                        user_pref("browser.onboarding.enabled", false);
                        /* translations */
                        user_pref("browser.translations.enable", false);
                        user_pref("browser.translations.automaticallyPopup", false);

                        /* concurrency */
                        user_pref("dom.maxHardwareConcurrency", 6);

                        /* wayland */
                        user_pref("widget.wayland.fractional-scale.enabled", true);
                        user_pref("widget.wayland.vsync.enabled", true);
                        user_pref("widget.gtk.global-menu.wayland.enabled", true);

                        /* network */
                        user_pref("network.proxy.socks_remote_dns", true);
                        user_pref("network.dns.disableIPv6", false);
                        user_pref("network.dns.preferIPv6", true);
                        user_pref("network.http.http3.enable", true);
                        user_pref("network.http.http3.enable_0rtt", true);
                        user_pref("network.http.http3.version_negotiation.enabled", true);
                        user_pref("network.http.http3.priority", true);
                        user_pref("network.http.http3.retry_different_ip_family", true);
                        user_pref("network.dns.blockDotOnion", false);

                        /* tab */
                        user_pref("accessibility.tabfocus", 1);
                        user_pref("ui.prefersReducedMotion", 0);
                        user_pref("browser.newtabpage.enabled", false);
                        user_pref("browser.tabs.insertAfterCurrent", false);
                        user_pref("browser.tabs.insertRelatedAfterCurrent", false);
                        user_pref("browser.newtab.url", "about:blank");
                        user_pref("browser.link.open_newwindow", 3);
                        user_pref("browser.link.open_newwindow.restriction", 0);
                        user_pref("dom.disable_open_during_load", false);
                        user_pref("browser.tabs.closeTabByDblclick", true);
                        user_pref("browser.tabs.loadDivertedInBackground", true);
                        user_pref("browser.urlbar.openintab", true);
                        user_pref("browser.sessionstore.restore_on_demand", true);
                        user_pref("browser.sessionstore.restore_tabs_lazily", false);

                        /* blocklist update */
                        user_pref("extensions.blocklist.enabled", true);
                        user_pref("services.blocklist.update_enabled", true);

                        /* safe browsing */
                        user_pref("browser.safebrowsing.phishing.enabled", true);
                        user_pref("browser.safebrowsing.malware.enabled", true);
                        user_pref("browser.safebrowsing.downloads.remote.enabled", false);
                        user_pref("browser.safebrowsing.blockedURIs.enabled", true);

                        /* privacy */
                        user_pref("privacy.resistFingerprinting", false);
                        user_pref("privacy.firstparty.isolate", true);
                        user_pref("privacy.userContext.enabled", true);
                        user_pref("privacy.trackingprotection.enabled", true);
                        user_pref("privacy.trackingprotection.pbmode.enabled", true);
                        user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
                        user_pref("privacy.trackingprotection.cryptomining.enabled", true);

                        /* cache */
                        user_pref("browser.cache.disk.enable", false);
                        user_pref("browser.cache.memory.enable", true);
                        user_pref("browser.cache.memory.capacity", -1);

                        /* media */
                        user_pref("media.ffmpeg.vaapi.enabled", true);
                        user_pref("media.hardwaremediakeys.enabled", true);
                        user_pref("media.hardware-video-decoding.force-enabled", true);
                        user_pref("gfx.wayland.hdr", true);
                        user_pref("gfx.webrender.enabled", true);
                        user_pref("gfx.webrender.all", true);
                        user_pref("gfx.webrender.compositor", true);
                        user_pref("gfx.webrender.compositor.force-enabled", true);
                        user_pref("gfx.webrender.layer-compositor", true);
                        user_pref("layers.gpu-process.enabled", true);
                        user_pref("media.av1.enabled", true);
                        user_pref("media.mkv.enabled", true);
                        user_pref("media.autoplay.enabled", false);
                        user_pref("media.videocontrols.picture-in-picture.enabled", false);
                        user_pref("media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled", false);
                        user_pref("media.peerconnection.enabled", false);
                        user_pref("media.peerconnection.turn.disable", false);
                        user_pref("media.peerconnection.use_document_iceservers", false);
                        user_pref("media.peerconnection.video.enabled", false);

                        /* security */
                        user_pref("security.sandbox.content.level", 9);
                        user_pref("security.sandbox.socket.process.level", 2);
                        user_pref("security.sandbox.gpu.level", 2);
                        user_pref("security.tls.version.min", 3);
                        user_pref("security.tls.version.fallback-limit", 4);
                        user_pref("security.ssl.require_safe_negotiation", true);
                        user_pref("security.OCSP.enabled", 1);
                        user_pref("security.OCSP.require", true);
                        user_pref("security.ssl.enable_ocsp_stapling", true);
                        user_pref("security.ssl.enable_ocsp_must_staple", true);

                        /* notification */
                        user_pref("content.notify.interval", 100000);
                        user_pref("dom.webnotifications.enabled", true);
                        user_pref("alerts.useSystemBackend", true);

                        /* ai */
                        user_pref("browser.ai.control.default", "blocked");
                        user_pref("browser.ai.control.linkPreviewKeyPoints", "blocked");
                        user_pref("browser.ai.control.pdfjsAltText", "blocked");
                        user_pref("browser.ai.control.sidebarChatbot", "blocked");
                        user_pref("browser.ai.control.smartTabGroups", "blocked");
                        user_pref("browser.ai.control.translations", "blocked");
                        user_pref("browser.ml.enable", false);

                        /* font */
                        user_pref("font.default.x-unicode", "sans-serif");
                        user_pref("font.default.x-western", "sans-serif");
                        user_pref("font.default.zh-CN", "Sans Serif");
                        user_pref("font.default.zh-TW", "Sans Serif");
                        user_pref("font.default.zh-HK", "Sans Serif");
                        user_pref("font.name.sans-serif.x-western", "Noto Sans");
                        user_pref("font.name.sans-serif.zh-CN", "MiSans");
                        user_pref("font.name.sans-serif.zh-TW", "Source Han Sans TC");
                        user_pref("font.name.sans-serif.zh-HK", "Source Han Sans HC");
                        user_pref("font.name.serif.x-western", "Noto Serif");
                        user_pref("font.name.serif.zh-CN", "Noto Serif SC");
                        user_pref("font.name.serif.zh-TW", "Source Han Serif TC");
                        user_pref("font.name.serif.zh-HK", "Source Han Serif HC");
                        user_pref("font.name.monospace.x-western", "JetBrains Mono");
                        user_pref("font.name.monospace.zh-CN", "MiSans");
                        user_pref("font.name.monospace.zh-TW", "Source Han Mono TC");
                        user_pref("font.name.monospace.zh-HK", "Source Han Mono HC");
                        user_pref("font.minimum-size.x-western", 12);
                        user_pref("font.minimum-size.zh-CN", 12);
                        user_pref("font.minimum-size.zh-TW", 12);
                        user_pref("font.minimum-size.zh-HK", 12);
                        user_pref("font.size.monospace.x-western", 16);
                        user_pref("font.size.monospace.zh-CN", 16);
                        user_pref("font.size.monospace.zh-TW", 16);
                        user_pref("font.size.monospace.zh-HK", 16);
                        user_pref("font.size.variable.x-western", 16);
                        user_pref("font.size.variable.zh-CN", 16);
                        user_pref("font.size.variable.zh-TW", 16);
                        user_pref("font.size.variable.zh-HK", 16);
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

                        #sidebar-button {
                            display: none;
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

                    settings = {
                        "network.proxy.socks" = wgServerIp4Address;
                        "network.proxy.socks_port" = ffProxyPort;
                        "network.proxy.socks_version" = 5;
                        "network.proxy.socks5_remote_dns" = true;
                    };
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
