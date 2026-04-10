// ==UserScript==
// @name             NYTimes
// @namespace        Violentmonkey Scripts
// @version          1.1
// @description      English & Chinese
// @author           Liu Wei
// @match            https://cn.nytimes.com/*
// @icon             https://cn.nytimes.com/favicon.ico
// @require          https://code.jquery.com/jquery-4.0.0.min.js
// @grant            none
// @run-at           document-end
// ==/UserScript==


'use strict';


const $ = window.jQuery;

(function() {
    function select_dual_language() {
        const a = $('ul.dual-btn').children('li:nth-child(2)').children('a:nth-child(1)');
        if (a.attr("class") == "active") {
            return;
        }
        const url = a.attr("href");
        if (url == null) {
            return;
        }
        window.open(url, "_self");
    }


    function set_header() {
        $('header.title-bar').hide();
        $('header h1').css({
            "text-align": "center"
        });
        $('.byline-row').hide();
        $('.setting-bar').hide();
    }


    function set_article() {
        $('div.article-paragraph').css({
            "font-family": "Roboto, MiSans",
            "font-weight": "500",
            "font-size": "18px"
        });
    }


    function set_figcaption() {
        $('figcaption').css({
            "text-align": "center"
        });
        $('figcaption cite').hide();
    }

    select_dual_language();
    set_article();
    set_header();
    set_figcaption();
})();


/* vim: set ts=4 sw=4 sts=4 ft=javascript et: */
