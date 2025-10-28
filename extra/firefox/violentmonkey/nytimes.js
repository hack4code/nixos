// ==UserScript==
// @name             NYTimes
// @namespace        Violentmonkey Scripts
// @version          1.1
// @description      English & Chinese
// @author           Liu Wei
// @match            https://cn.nytimes.com/*
// @icon             https://cn.nytimes.com/favicon.ico
// @require          https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js
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

    function hide_header() {
        $('header.title-bar').hide();
        $('div.setting-bar').hide();
        $('header small').hide();
    }

    function set_article_font() {
        $('div.article-paragraph').css({
            "font-family": "Roboto Flex, Swei Gothic CJK SC, Swei Gothic CJK TC",
            "font-weight": "500"
        });
    }

    function hide_cite() {
        $('figcaption cite').hide();
    }

    select_dual_language();
    set_article_font();
    hide_header();
    hide_cite();
})();


/* vim: set ts=4 sw=4 sts=4 ft=javascript et: */
