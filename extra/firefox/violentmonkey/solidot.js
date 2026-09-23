// ==UserScript==
// @name           奇客
// @namespace      Violentmonkey Scripts
// @version        1.2
// @description    Remove Ads
// @author         Liu Wei
// @match          https://*.solidot.org/*
// @icon           https://www.solidot.org/favicon.ico
// @require        https://cdn.jsdelivr.net/npm/@violentmonkey/dom@2
// @require        https://cdn.jsdelivr.net/npm/@violentmonkey/shortcut@1
// @require        https://code.jquery.com/jquery-4.0.0.min.js
// @grant          none
// @run-at         document-end
// ==/UserScript==


'use strict';


const $ = window.jQuery;
const SITE = window.location.href;


(function() {
    function hide_logobox() {
        console.log("hide_logobox");
        $node = $('.logo_sosobox');
        if ($node.length) {
            $node.hide();
            return true;
        }
        return false;
    }

    function hide_ads() {
        console.log("hide_ads");
        $node = $('#ads');
        if ($node.length) {
            $node.hide();
        }
        else {
            return false;
        }

        $node = $('#ads + div');
        $node.find('a').each(function () {
            const txt = $(this).text();
            if (txt.includes("NVIDIA")) {
                $node.hide();
                const $next = $node.next();
                $next.find('a').each(function () {
                    const txt = $(this).text();
                    if (txt.includes("NVIDIA")) {
                        $next.hide();
                    };
                });
                return true;
            };
        });
        return true;
    }

    function hide_header() {
        console.log("hide_header");
        $node = $('.nav-secondary-wrap');
        if ($node.length) {
            $node.hide();
            return true;
        }
        return false;
    }

    function hide_headbox() {
        console.log("hide_headbox");
        $node = $('.headWraningBox');
        if ($node.length) {
            $node.css("visibility", "hidden");
            return true;
        }
        return false;
    }

    function set_font() {
        $node = $('.p_mainnew,.ct_tittle');
        if ($node.length) {
            $node.css({
                "font-family": "Roboto Flex, MiSans",
                "font-style": "normal"
            });
            return true;
        }
        return false;
    }

    if (!hide_logobox()) {
        VM.observe(document.body, () => {
            if (hide_logobox())
                return true;
        });
    }

    if (!hide_ads()) {
        VM.observe(document.body, () => {
            if (hide_ads())
                return true;
        });
    }

    if (!hide_header()) {
        VM.observe(document.body, () => {
            if (hide_header())
                return true;
        });
    }

    if (!hide_headbox()) {
        VM.observe(document.body, () => {
            if (hide_headbox())
                return true;
        });
    }

    if (!set_font()) {
        VM.observe(document.body, () => {
            if (set_font())
                return true;
        });
    }

})();


/* vim: set ts=4 sw=4 sts=4 ft=javascript et: */
