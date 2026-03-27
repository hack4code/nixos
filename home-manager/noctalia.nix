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

        programs.noctalia-shell = {
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
                    backgroundOpacity = 0.6;
                    useSeparateOpacity = false;
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
                            }
                            {
                                id = "Workspace";
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
                                id = "Clock";
                            }
                            {
                                id = "Tray";
                                colorizeIcons = true;
                                drawerEnabled = false;
                                hidePassive = false;
                                pinned = [ ];
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
                    darkMode = true;
                    useWallpaperColors = false;
                    predefinedScheme = "Gruvbox";
                };

                ui = {
                    fontDefault = "Fira Sans";
                    fontFixed = "Fira Mono";
                    fontDefaultScale = 1;
                    fontFixedScale = 1;
                    tooltipsEnabled = true;
                    scrollbarAlwaysVisible = false;
                    boxBorderEnabled = false;
                    panelBackgroundOpacity = 0.9;
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
                    lockOnSuspend = false;
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
                    telemetryEnabled = false;
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
                    useFahrenheit = false;
                    use12hourFormat = false;
                    showWeekNumberInCalendar = false;
                    showCalendarEvents = true;
                    showCalendarWeather = true;
                    analogClockInCalendar = false;
                    firstDayOfWeek = -1;
                    hideWeatherTimezone = false;
                    hideWeatherCityName = false;
                };

                wallpaper = {
                    enabled = true;
                    overviewEnabled = true;
                    directory = "${userHome}/.config/sway/wallpaper";
                    monitorDirectories = [
                        {
                            directory = "${userHome}/.config/sway/wallpaper/dp-3";
                            name = monitorSamsung;
                            wallpaper = "${bgSamsung}";
                        }
                        {
                            directory = "${userHome}/.config/sway/wallpaper/edp-1";
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
                    position = "center";
                    pinnedApps = [ ];
                    sortByMostUsed = true;
                    terminalCommand = "kitty";
                    customLaunchPrefixEnabled = false;
                    customLaunchPrefix = "";
                    viewMode = "list";
                    showCategories = true;
                    iconMode = "native";
                    showIconBackground = false;
                    enableSettingsSearch = false;
                    enableWindowsSearch = true;
                    enableSessionSearch = false;
                    ignoreMouseInput = true;
                    screenshotAnnotationTool = "";
                    overviewLayer = true;
                    density = "comfortable";
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
                    density = "compact";
                    monitors = [
                        monitorSamsung
                    ];
                    location = "top";
                    overlayLayer = true;
                    backgroundOpacity = 0.8;
                    respectExpireTimeout = false;
                    lowUrgencyDuration = 5;
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
                        excludedApps = "firefox,";
                    };
                    enableMediaToast = false;
                    enableBatteryToast = false;
                    enableKeyboardLayoutToast = false;
                };

                idle = {
                    enabled = true;
                    lockTimeout = 300;
                    fadeDuration = 5;
                    suspendTimeout = 3600;
                    screenOffTimeout = 7200;
                    lockCommand = "";
                    resumeLockCommand = "";
                    suspendCommand = "";
                    resumeSuspendCommand = "swayctl resume suspend";
                    screenOffCommand = "";
                    resumeScreenOffCommand = "";
                    customCommands = [ ];
                };

                hooks = {
                    enabled = true;
                    wallpaperChange = "";
                    darkModeChange = "";
                    screenLock = "swayctl lock";
                    screenUnlock = "swayctl resume lock";
                    performanceModeEnabled = "";
                    performanceModeDisabled = "";
                    startup = "";
                    session = "";
                    colorGeneration = "";
                };
            };
        };
    };
}


/* vim: set tabstop=4 shiftwidth=4 filetype=nix expandtab: */
