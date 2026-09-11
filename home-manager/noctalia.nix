{ config, pkgs, inputs, ... }:

let
    userName = config.userName;
    userHome = config.userHome;
    userLocation = config.userLocation;
    monitorSamsung = config.monitorSamsung;
    monitorThinkpad = config.monitorThinkpad;
    bgThinkpad = config.bgThinkpad;
    bgSamsung = config.bgSamsung;
in
{
    home-manager.users.${userName} = {
        imports = [
            inputs.noctalia.homeModules.default
        ];

        programs.noctalia = {
            enable = true;

            settings = {
                settingsVersion = 0;

                bar = {
                    barType = "floating";
                    position = "top";
                    monitors = [
                        monitorSamsung
                    ];
                    density = "comfortable";
                    showOutline = true;
                    showCapsule = true;
                    capsuleOpacity = 1;
                    capsuleColorKey = "none";
                    widgetSpacing = 8;
                    contentPadding = 4;
                    fontScale = 1;
                    enableExclusionZoneInset = true;
                    backgroundOpacity = 0.8;
                    useSeparateOpacity = true;
                    floating = true;
                    marginVertical = 12;
                    marginHorizontal = 20;
                    frameThickness = 8;
                    frameRadius = 6;
                    outerCorners = true;
                    hideOnOverview = false;
                    displayMode = "always_visible";
                    autoHideDelay = 500;
                    autoShowDelay = 150;
                    showOnWorkspaceSwitch = true;
                    widgets = {
                        left = [
                            {
                                id = "Launcher";
                                colorizeSystemIcon = "tertiary";
                                customIconPath = "";
                                enableColorization = true;
                                icon = "rocket";
                                iconColor = "none";
                                useDistroLogo = false;
                            }
                            {
                                id = "Workspace";
                                characterCount = 2;
                                colorizeIcons = false;
                                emptyColor = "none";
                                enableScrollWheel = false;
                                focusedColor = "primary";
                                followFocusedScreen = false;
                                fontWeight = "bold";
                                groupedBorderOpacity = 1;
                                hideUnoccupied = false;
                                iconScale = 0.8;
                                labelMode = "index";
                                occupiedColor = "secondary";
                                pillSize = 0.62;
                                showApplications = false;
                                showApplicationsHover = false;
                                showBadge = false;
                                showLabelsOnlyWhenOccupied = false;
                                unfocusedIconsOpacity = 1;
                            }
                        ];
                        center = [
                            {
                                id = "ActiveWindow";
                                colorizeIcons = false;
                                hideMode = "hidden";
                                maxWidth = 500;
                                scrollingMode = "hover";
                                showIcon = true;
                                textColor = "blue";
                                useFixedWidth = false;
                            }
                        ];
                        right = [
                            # {
                            #   id = "plugin:slowbongo";
                            # }
                            {
                                id = "Network";
                            }
                            {
                                id = "Bluetooth";
                            }
                            {
                                id = "Volume";
                            }
                            {
                                id = "NotificationHistory";
                            }
                            {
                                id = "KeepAwake";
                            }
                            {
                                id = "Clock";
                                clockColor = "none";
                                customFont = "Fira Sans Medium";
                                formatHorizontal = "HH:mm ddd MMM d";
                                formatVertical = "";
                                tooltipFormat = "HH:mm:ss yyyy-MM-dd";
                                useCustomFont = true;
                            }
                            {
                                id = "Tray";
                                drawerEnabled = true;
                                detachedPanel = false;
                                colorizeIcons = true;
                                hidePassive = false;
                                pinned = [
                                    "Fcitx*"
                                    "Keyboard*"
                                    "Input*"
                                ];
                                blacklist = [ ];
                            }
                        ];
                    };
                    mouseWheelAction = "none";
                    reverseScroll = false;
                    mouseWheelWrap = true;
                    middleClickAction = "none";
                    middleClickFollowMouse = false;
                    middleClickCommand = "";
                    rightClickAction = "controlCenter";
                    rightClickFollowMouse = true;
                    rightClickCommand = "";
                    screenOverrides = [ ];
                };

                colorSchemes = {
                    useWallpaperColors = false;
                    predefinedScheme = "Gruvbox";
                    darkMode = true;
                    schedulingMode = "off";
                    manualSunrise = "08:30";
                    manualSunset = "18:30";
                    generationMethod = "tonal-spot";
                    monitorForColors = "";
                    syncGsettings = true;
                };

                ui = {
                    fontDefault = "Adwaita Sans";
                    fontFixed = "Adwaita Mono";
                    fontDefaultScale = 1;
                    fontFixedScale = 1;
                    tooltipsEnabled = true;
                    scrollbarAlwaysVisible = false;
                    boxBorderEnabled = false;
                    panelBackgroundOpacity = 0.98;
                    translucentWidgets = false;
                    panelsAttachedToBar = true;
                    settingsPanelMode = "attached";
                    settingsPanelSideBarCardStyle = false;
                };

                general = {
                    avatarImage = "${userHome}/.config/sway/avatar/fly.jpg";
                    dimmerOpacity = 0.2;
                    showScreenCorners = false;
                    forceBlackScreenCorners = false;
                    scaleRatio = 1;
                    radiusRatio = 1.6;
                    iRadiusRatio = 1;
                    boxRadiusRatio = 1;
                    screenRadiusRatio = 1;
                    animationSpeed = 3;
                    animationDisabled = false;
                    compactLockScreen = true;
                    lockScreenAnimations = true;
                    lockOnSuspend = true;
                    showSessionButtonsOnLockScreen = false;
                    showHibernateOnLockScreen = false;
                    enableLockScreenMediaControls = false;
                    enableShadows = true;
                    enableBlurBehind = false;
                    shadowDirection = "bottom";
                    shadowOffsetX = 2;
                    shadowOffsetY = 3;
                    language = "en";
                    allowPanelsOnScreenWithoutBar = true;
                    showChangelogOnStartup = true;
                    telemetryEnabled = true;
                    enableLockScreenCountdown = false;
                    lockScreenCountdownDuration = 10000;
                    autoStartAuth = true;
                    allowPasswordWithFprintd = true;
                    clockStyle = "digital";
                    clockFormat = "hh:mm";
                    passwordChars = true;
                    lockScreenMonitors = [
                        monitorThinkpad
                    ];
                    lockScreenBlur = 0;
                    lockScreenTint = 0;
                    keybinds = {
                        keyUp = [
                            "Up"
                            "Ctrl+P"
                        ];
                        keyDown = [
                            "Down"
                            "Ctrl+N"
                        ];
                        keyLeft = [
                            "Left"
                            "Ctrl+L"
                        ];
                        keyRight = [
                            "Right"
                            "Ctrl+H"
                        ];
                        keyEnter = [
                            "Return"
                            "Enter"
                        ];
                        keyEscape = [
                            "Esc"
                        ];
                        keyRemove = [
                            "Del"
                            "Ctrl+D"
                        ];
                    };
                    reverseScroll = false;
                };

                location = {
                    name = userLocation;
                    weatherEnabled = true;
                    weatherShowEffects = true;
                    weatherTaliaMascotAlways = false;
                    useFahrenheit = false;
                    use12hourFormat = false;
                    showWeekNumberInCalendar = true;
                    showCalendarEvents = false;
                    showCalendarWeather = true;
                    analogClockInCalendar = false;
                    firstDayOfWeek = 1;
                    hideWeatherTimezone = true;
                    hideWeatherCityName = true;
                    autoLocate = false;
                };

                network = {
                    bluetoothRssiPollingEnabled = false;
                    bluetoothRssiPollIntervalMs = 60000;
                    networkPanelView = "wifi";
                    wifiDetailsViewMode = "grid";
                    bluetoothDetailsViewMode = "grid";
                    bluetoothHideUnnamedDevices = false;
                    disableDiscoverability = false;
                    bluetoothAutoConnect = false;
                };

                wallpaper = {
                    enabled = true;
                    overviewEnabled = true;
                    directory = "~/.config/sway/wallpaper";
                    monitorDirectories = [
                        {
                            directory = "~/.config/sway/wallpaper/dp-3";
                            name = monitorSamsung;
                            wallpaper = "${bgSamsung}";
                        }
                        {
                            directory = "~/.config/sway/wallpaper/edp-1";
                            name = monitorThinkpad;
                            wallpaper = "${bgThinkpad}";
                        }
                    ];
                    enableMultiMonitorDirectories = true;
                    showHiddenFiles = false;
                    viewMode = "single";
                    setWallpaperOnAllMonitors = false;
                    fillMode = "crop";
                    fillColor = "#000000";
                    useSolidColor = false;
                    solidColor = "#1a1a2e";
                    automationEnabled = false;
                    wallpaperChangeMode = "random";
                    randomIntervalSec = 300;
                    transitionDuration = 6000;
                    transitionType = [
                        "fade"
                        "disc"
                        "stripes"
                        "wipe"
                        "pixelate"
                        "honeycomb"
                    ];
                    skipStartupTransition = false;
                    transitionEdgeSmoothness = 0.15;
                    panelPosition = "follow_bar";
                    hideWallpaperFilenames = false;
                    overviewBlur = 0.4;
                    overviewTint = 0.6;
                    useWallhaven = false;
                    wallhavenQuery = "";
                    wallhavenSorting = "relevance";
                    wallhavenOrder = "desc";
                    wallhavenCategories = "111";
                    wallhavenPurity = "100";
                    wallhavenRatios = "";
                    wallhavenApiKey = "";
                    wallhavenResolutionMode = "atleast";
                    wallhavenResolutionWidth = "";
                    wallhavenResolutionHeight = "";
                    sortOrder = "name";
                    favorites = [ ];
                };

                appLauncher =
                let
                    wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
                in
                {
                    enableClipboardHistory = true;
                    autoPasteClipboard = true;
                    enableClipPreview = true;
                    clipboardWrapText = true;
                    enableClipboardSmartIcons = true;
                    enableClipboardChips = true;
                    clipboardWatchTextCommand = "${wl-paste} --type text --watch cliphist store";
                    clipboardWatchImageCommand = "${wl-paste} --type image --watch cliphist store";
                    position = "follow_bar";
                    pinnedApps = [ ];
                    sortByMostUsed = false;
                    terminalCommand = "${pkgs.kitty}/bin/kitty";
                    customLaunchPrefixEnabled = false;
                    customLaunchPrefix = "";
                    viewMode = "grid";
                    showCategories = true;
                    iconMode = "native";
                    showIconBackground = false;
                    enableSettingsSearch = false;
                    enableWindowsSearch = false;
                    enableSessionSearch = false;
                    ignoreMouseInput = true;
                    screenshotAnnotationTool = "";
                    overviewLayer = true;
                    density = "compact";
                };

                dock = {
                    enabled = false;
                    position = "bottom";
                    displayMode = "auto_hide";
                    dockType = "floating";
                    backgroundOpacity = 1;
                    floatingRatio = 1;
                    size = 1;
                    onlySameOutput = true;
                    monitors = [];
                    pinnedApps = [];
                    colorizeIcons = false;
                    showLauncherIcon = false;
                    launcherPosition = "end";
                    launcherIconColor = "none";
                    pinnedStatic = false;
                    inactiveIndicators = false;
                    groupApps = false;
                    groupContextMenuMode = "extended";
                    groupClickAction = "cycle";
                    groupIndicatorStyle = "dots";
                    deadOpacity = 0.6;
                    animationSpeed = 1;
                    sitOnFrame = false;
                    showDockIndicator = false;
                    indicatorThickness = 3;
                    indicatorColor = "primary";
                    indicatorOpacity = 0.6;
                };

                notifications = {
                    enabled = true;
                    enableMarkdown = true;
                    density = "default";
                    monitors = [
                        monitorSamsung
                    ];
                    location = "top";
                    overlayLayer = true;
                    backgroundOpacity = 0.98;
                    respectExpireTimeout = false;
                    lowUrgencyDuration = 4;
                    normalUrgencyDuration = 7;
                    criticalUrgencyDuration = 12;
                    clearDismissed = false;
                    saveToHistory = {
                        low = true;
                        normal = true;
                        critical = true;
                    };
                    sounds = {
                        enabled = false;
                        volume = 0.4;
                        separateSounds = false;
                        criticalSoundFile = "";
                        normalSoundFile = "";
                        lowSoundFile = "";
                        excludedApps = "";
                    };
                    enableMediaToast = false;
                    enableBatteryToast = false;
                    enableKeyboardLayoutToast = false;
                };

                idle = {
                    enabled = true;
                    screenOffTimeout = 900;
                    lockTimeout = 300;
                    suspendTimeout = 10800;
                    fadeDuration = 5;
                    screenOffCommand = "";
                    lockCommand = "swayctl lock";
                    suspendCommand = "";
                    resumeScreenOffCommand = "";
                    resumeLockCommand = "swayctl resume lock";
                    resumeSuspendCommand = "swayctl resume suspend";
                    customCommands = [ ];
                };

                noctaliaPerformance = {
                    disableWallpaper = false;
                    disableDesktopWidgets = false;
                };

                hooks = {
                    enabled = true;
                    wallpaperChange = "";
                    darkModeChange = "";
                    screenLock = "";
                    screenUnlock = "";
                    performanceModeEnabled = "";
                    performanceModeDisabled = "";
                    startup = "";
                    session = "";
                    colorGeneration = "";
                };

                brightness = {
                    brightnessStep = 5;
                    enableDdcutil = true;
                    minimumBrightness = 0.1;
                    syncAllMonitors = false;
                    monitor = {
                        monitorThinkpad = {
                            brightness = 0.7;
                            backend = "backlight";
                            backlightDevice = "intel_backlight";
                        };
                        monitorSamsung = {
                            backend = "ddcutil";
                        };
                    };
                };

                plugins = {
                    autoUpdate = true;
                    notifyUpdates = true;
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
