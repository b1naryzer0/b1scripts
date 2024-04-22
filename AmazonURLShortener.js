// ==UserScript==
// @name         Amazon URL Shortener
// @namespace    https://github.com/b1naryzer0/b1scripts/blob/main/AmazonURLShortener.js
// @version      0.2.0
// @description  automatically shorten Amazon product URLs
// @author       forked & modified by Fritz R., original by r7kamura
// @match      https://smile.amazon.com/*
// @match      https://www.amazon.ae/*
// @match      https://www.amazon.au/*
// @match      https://www.amazon.ca/*
// @match      https://www.amazon.cn/*
// @match      https://www.amazon.co.jp/*
// @match      https://www.amazon.co.uk/*
// @match      https://www.amazon.com/*
// @match      https://www.amazon.com.br/*
// @match      https://www.amazon.com.mx/*
// @match      https://www.amazon.com.tr/*
// @match      https://www.amazon.de/*
// @match      https://www.amazon.es/*
// @match      https://www.amazon.fr/*
// @match      https://www.amazon.in/*
// @match      https://www.amazon.it/*
// @match      https://www.amazon.nl/*
// @match      https://www.amazon.sa/*
// @match      https://www.amazon.se/*
// @match      https://www.amazon.sg/*
// ==/UserScript==

(function () {
  function replaceState(path) {
    window.history.replaceState({}, "", path);
  }

  const asinElement = document.querySelector(
    '#ASIN, input[name="idx.asin"], input[name="ASIN.0"], input[name="titleID"]'
  );

  if (asinElement) {
    replaceState(`/dp/${asinElement.value}`);
  } else {
    const href = window.location.href;
    const match = href.match(/\/(?:dp|gp\/product)\/([A-Z0-9]{10})[/?]?/);
    if (match) {
      replaceState(`/dp/${match[1]}`);
    }
  }
})();
