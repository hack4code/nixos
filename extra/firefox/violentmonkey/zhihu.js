// ==UserScript==
// @name           知乎
// @namespace      Violentmonkey Scripts
// @version        1.2
// @description    Adjust content width
// @author         Liu Wei
// @match          https://*.zhihu.com/*
// @icon           https://zhihu.com/favicon.ico
// @require        https://code.jquery.com/jquery-4.0.0.min.js
// @inject-into    auto
// @grant          none
// @run-at         document-end
// ==/UserScript==


'use strict';


const $ = window.jQuery;
const SITE = window.location.href;

(function() {
    if (SITE.endsWith("zhihu.com/")) {
        /* advertise */
        $('.Topstory').children().not('.Topstory-container').hide();
        /* sidebar */
        $('.Topstory-container:first').children(':nth-child(2)').hide();
        /* screen width */
        $('.Topstory-container').css("width", "800px");
        $('.Topstory-mainColumn:first').css("width", "800px");
        /* header */
        $('header.AppHeader').css("visibility", "hidden");
        /* write area */
        $('div.WriteArea').hide();
    }
    else if (SITE.includes("question/")) {
        /* header */
        $('.AppHeader').hide();
        /* sidebar */
        $('div.Question-main').children(':nth-child(2)').hide();
        /* screen width */
        $('div.Question-main').children(':nth-child(1)').css("width", "900px");
        $('div.Question-mainColumn').css("width", "900px");
        /* header */
        $('header.Sticky').css("visibility", "hidden");
    }
    else if (SITE.includes("/p/")) {
        $('.Post-Row-Content-right').hide();
        $('.Post-SideActions').hide();
        $('.ColumnPageHeader-Wrapper').css("visibility", "hidden");
        $('.Post-Row-Content-left').css("width", "900px");
    }

    /* UP Button */
    $('.CornerButtons').hide();
})();


/* vim: set ts=4 sw=4 sts=4 ft=javascript et: */
