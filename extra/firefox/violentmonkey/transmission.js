// ==UserScript==
// @name            Transmission
// @namespace       Violentmonkey Scripts
// @version         4.3
// @description     Add a button in torrent sites to support adding torrent to Transmission directly
// @author          Liu Wei
// @match           https://thepiratebay.org/*
// @match           http://piratebay*.onion/*
// @match           https://anybt.eth.limo/*
// @match           https://torrentgalaxy.mx/*
// @match           https://nyaa.si/*
// @match           https://www.xl720.com/*
// @match           https://rutracker.org/*
// @match           https://uindex.org/*
// @icon            https://transmissionbt.com/favicon.ico
// @require         https://cdn.jsdelivr.net/npm/@violentmonkey/dom@2
// @require         https://code.jquery.com/jquery-4.0.0.min.js
// @run-at          document-end
// @inject-into     auto
// @grant           GM_xmlhttpRequest
// ==/UserScript==


'use strict';


const $ = window.jQuery;
const SITE = window.location.href;

const RE_PIRA = /thepiratebay.org|piratebay.*\.onion/i;
const RE_ANYBT = /anybt.eth.limo/i;
const RE_TORRENT_GALAXY = /torrentgalaxy.mx/i;
const RE_NYAA = /nyaa.si/i;
const RE_THUNDER = /xl720.com/i;
const RE_RUTRACKER = /rutracker.org/i;
const RE_UINDEX = /uindex.org/i;

const CSS_BUTTON_TRANSMISSION = {
    "margin": "1px 2px 1px 4px",
    "display": "inline-block",
    "font-family": "Twitter Color Emoji"
};

const CSS_BUTTON_RTORRENT = {
    "margin": "1px 2px 1px 2px",
    "display": "inline-block",
    "font-family": "Twitter Color Emoji"
};

function send_torrent(button, app, magnet) {
    function ok() {
        button.text("✔️");
    }

    function error() {
        button.text("❌");
    }

    GM_xmlhttpRequest({
        method: "POST",
        url: "http://127.0.0.1:8080/" + app + "/torrent",
        data: JSON.stringify({"magnet": magnet}),
        headers: {"Content-Type": "application/json"},
        timeout: 8000,
        onload: function (response) {
            const code = response.status;
            switch (code) {
                case 200:
                    ok()
                    break;

                default:
                    error();
                    const result = JSON.parse(response.responseText);
                    console.log(app + ": status_code=", code, "\n", result.detail);
            }
        },
        ontimeout: function (response) {
            console.log(app + ": timeout");
            error();
        }
    });
}


function add_app_button(app, e, ind, magnet) {
    const id = app + "_" + ind;
    const text = app === "transmission" ? "🕷️" : "🐝";
    const css = app === "transmission" ? CSS_BUTTON_TRANSMISSION : CSS_BUTTON_RTORRENT;
    const selector = 'a[id^="' + app + '_"]';

    const button = $("<a>", {
        "id": id,
        "text": text,
        "data-magnet": magnet
    });
    button.css(css);
    button.click(function() {
        const magnet = $(this).data("magnet");
        send_torrent($(this), app, magnet);
    });

    if (e.parent().find(selector).length === 0) {
        e.parent().append(button);
    };
}


function add_buttons() {
    var is_anybt = false;
    var elements = null;
    if (RE_ANYBT.test(SITE)) {
        is_anybt = true;
        elements = $('div.search-result-item');
    }
    else if (RE_PIRA.test(SITE)) {
        if (SITE.includes("/search")) {
            elements = $('span.item-icons');
        }
        else if (SITE.includes("/description.php?id=")) {
            elements = $('div.links');
        }
    }
    else if (RE_TORRENT_GALAXY.test(SITE)) {
        elements = $('div.tgxtablerow');
    }
    else if (RE_NYAA.test(SITE)) {
        if (SITE.endsWith("nyaa.si/") || SITE.includes("?")) {
            elements = $('tr.default').add('tr.success').add('tr.danger');
        }
        else if (SITE.includes("/view/")) {
            elements = $('div.panel-footer');
        }
    }
    else if (RE_THUNDER.test(SITE)) {
        elements = $('div.down_btn_cl');
    }
    else if (RE_RUTRACKER.test(SITE)) {
        elements = $('li:has(> a.magnet-link)');
    }
    else if (RE_UINDEX.test(SITE)) {
        if (SITE.endsWith('uindex.org') || SITE.endsWith('uindex.org/')) {
            elements = $('td.hp-td-name');
        }
        else if (SITE.includes("search=")) {
            elements = $('td.sr-col-name');
        }
        else if (SITE.includes("id=")) {
            elements = $('div.dt-download-box');
        }
    }

    if (elements == null || elements.length === 0) {
        return;
    }

    elements.each(function (ind) {
        var e = null;
        var magnet = null;
        if (is_anybt) {
            e = $(this).find('div.copy-container:first');
            magnet = e.text();
        }
        else {
            e = $(this).find('a[href^="magnet:"]:first');
            magnet = e.attr("href");
        }
        if (magnet == null || !magnet.startsWith("magnet:")) {
            return;
        }

        add_app_button("transmission", e, ind, magnet);
        add_app_button("rtorrent", e, ind, magnet);
    });
}


(function () {
    if (RE_THUNDER.test(SITE)) {
        $('div.down_btn_xl').hide();
        add_buttons();
    }
    else if (RE_UINDEX.test(SITE)) {
        add_buttons();
    }
    else {
        VM.observe(document.body, () => {
            add_buttons();
        });
    };
})();


/* vim: set ts=4 sw=4 sts=4 ft=javascript et: */
