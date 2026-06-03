// ==UserScript==
// @name            YouTube
// @namespace       Violentmonkey Scripts
// @version         6.3
// @description     YouTube
// @author          Liu Wei
// @match           https://www.youtube.com/*
// @icon            https://youtube.com/favicon.ico
// @run-at          document-end
// @inject-into     auto
// @grant           GM_xmlhttpRequest
// @require         https://cdn.jsdelivr.net/npm/@violentmonkey/dom@2
// @require         https://cdn.jsdelivr.net/npm/@violentmonkey/shortcut@1
// @require         https://code.jquery.com/jquery-4.0.0.min.js
// ==/UserScript==


'use strict';


const $ = window.jQuery;
const SITE = window.location.href;


(function() {
    function download_youtube_song() {
        console.log("download_youtube_song");
        GM_xmlhttpRequest({
            method: "POST",
            url: "http://127.0.0.1:8080/youtube/download/song",
            headers: {"Content-Type": "application/json"},
            data: JSON.stringify({"url": window.location.href}),
            onload: function(response) {
                const result = JSON.parse(response["responseText"]);
                switch (response.status) {
                    case 200:
                        console.log("download_youtube_song: ", result.status);
                        break;

                    default:
                        console.log("download_youtube_song: status = ", response.status);
                        console.log("download_youtube_song: ", result.detail);
                }
            }
        });
    }


    function play_youtube_video() {
        console.log("play_youtube_video");
        GM_xmlhttpRequest({
            method: "POST",
            url: "http://127.0.0.1:8080/youtube/play/video",
            headers: {"Content-Type": "application/json"},
            data: JSON.stringify({"url": window.location.href}),
            onload: function(response) {
                const result = JSON.parse(response["responseText"]);
                switch (response.status) {
                    case 200:
                        console.log("play_youtube_video: ", result.status);
                        break;

                    default:
                        console.log("play_youtube_video: status = ", response.status);
                        console.log("play_youtube_video: ", result.detail);
                }
            }
        });
    }


    function download_youtube_video() {
        console.log("download_youtube_video");
        GM_xmlhttpRequest({
            method: "POST",
            url: "http://127.0.0.1:8080/youtube/download/video",
            headers: {"Content-Type": "application/json"},
            data: JSON.stringify({"url": window.location.href}),
            onload: function(response) {
                const result = JSON.parse(response["responseText"]);
                switch (response.status) {
                    case 200:
                        console.log("download_youtube_video: ", result.status);
                        break;

                    default:
                        console.log("download_youtube_video: status = ", response.status);
                        console.log("download_youtube_video: ", result.detail);
                }
            }
        });
    }


    function adjust_css() {
        console.log("adjust_css");
        const $node = $("#title h1");
        if ($node.length) {
            $node.css({
                "font-family": "MiSans",
                "font-size": "22px",
                "font-weight": "400",
                "text-align": "center",
                "margin": "24px 0 32px 0"
            });
            return true;
        }
        return false;
    }


    function hide_head_container() {
        console.log("hide_head_container");
        const $node = $("#masthead-container");
        if ($node.length) {
            $node.hide();
            return true;
        }
        return false;
    }


    function hide_guide_renderer() {
        console.log("hide_guide_renderer");
        const $node = $("ytd-mini-guide-renderer");
        if ($node.length) {
            $node.hide();
            return true;
        }
        return false;
    }


    function click_like_button() {
        console.log("click_like_button");
        $("like-button-view-model button-view-model > button:nth-child(1)").click();
    }


    function hide_ai_comment() {
        console.log("hide_ai_comment");
        const $node = $("#expandable-metadata");
        if ($node.length) {
            $node.hide();
            return true;
        }
        return false;
    }


    function hide_badge() {
        console.log("hide_badge");
        const $node = $("#title > ytd-badge-supported-renderer");
        if ($node.length) {
            $node.hide();
            return true;
        }
        return false;
    }


    function adjust_sub_position() {
        function adjust() {
            const video = document.querySelector('video');
            const track = video.textTracks;
            for (var i=0; i<track.length; i++)
                for (var j=0; j<track[i].cues.length; j++)
                    track[i].cues[j].line = 4;
        }

        const track_elem = document.querySelector('track');
        track_elem.addEventListener('loaded', adjust, false);
        track_elem.addEventListener('load', adjust, false);
    }


    /* */
    if (!hide_head_container()) {
        VM.observe(document.body, () => {
            if (hide_head_container())
                return true;
        });
    }

    if (SITE.includes('/@') || SITE.includes('results?search') || SITE.includes('playlist?')) {
        if (!hide_guide_renderer()) {
            VM.observe(document.body, () => {
                if (hide_guide_renderer())
                    return true;
            });
        }
    }

    if (SITE.includes('watch?')) {
        VM.shortcut.register('a-a', () => {
            click_like_button();
        });

        VM.shortcut.register('a-s', () => {
            download_youtube_song();
        });

        VM.shortcut.register('a-d', () => {
            play_youtube_video();
        });

        VM.shortcut.register('a-x', () => {
            download_youtube_video();
        });

        if (!hide_badge()) {
            VM.observe(document.body, () => {
                if (hide_badge())
                    return true
            });
        }

        /*
        if (!hide_ai_comment()) {
            VM.observe(document.body, () => {
                if (hide_ai_comment())
                    return true
            });
        }
        */

        if (!adjust_css()) {
            VM.observe(document.body, () => {
                if (adjust_css())
                    return true;
            });
        }
    }
})();


/* vim: set ts=4 sw=4 sts=4 ft=javascript et: */
