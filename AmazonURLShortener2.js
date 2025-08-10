// ==UserScript==
// @name         Amazon URL Shortener
// @namespace    https://github.com/b1naryzer0/b1scripts/blob/main/AmazonURLShortener2.js
// @version      0.0.1
// @author       
// @description Adds a button to copy the short link of Amazon products and optionally modifies the URL in the address bar
// @include      *://*.amazon.*/*
// @include       https://*.amazon.co.jp/*
// @include       https://*.amazon.com/*
// @include       https://*.amazon.ae/*
// @include       https://*.amazon.co.uk/*
// @include       https://*.amazon.it/*
// @include       https://*.amazon.in/*
// @include       https://*.amazon.eg/*
// @include       https://*.amazon.com.au/*
// @include       https://*.amazon.nl/*
// @include       https://*.amazon.ca/*
// @include       https://*.amazon.sa/*
// @include       https://*.amazon.sg/*
// @include       https://*.amazon.se/*
// @include       https://*.amazon.de/*
// @include       https://*.amazon.com.tr/*
// @include       https://*.amazon.com.br/*
// @include       https://*.amazon.fr/*
// @include       https://*.amazon.com.be/*
// @include       https://*.amazon.pl/*
// @include       https://*.amazon.com.mx/*
// @include       https://*.amazon.cn/*
// @license      GPL v2
// ==/UserScript==

(function () {
	'use strict';

// Configuration: Enable or disable features
	const enableButton = true; // true to add the copy button, false to disable it
	const modifyUrl = true; // true to modify the browser URL, false to leave it unchanged
	const popupDuration = 1500; // Popup duration in milliseconds (1.5 seconds)

// Function to generate the short link
	function generateShortLink() {
		const currentUrl = window.location.href;
		let match = currentUrl.match(/\/dp\/([A-Z0-9]{10})/); // Find the ASIN in /dp/
		if (!match) {
			match = currentUrl.match(/\/gp\/product\/([A-Z0-9]{10})/); // Find the ASIN in /gp/product/
			if (match) {
				return `${window.location.origin}/dp/${match[1]}`;
			}
		} else {
			return `${window.location.origin}/dp/${match[1]}`;
		}
		return null;
	}

// Function to copy text to clipboard
	function copyToClipboard(text) {
		const tempInput = document.createElement('input');
		document.body.appendChild(tempInput);
		tempInput.value = text;
		tempInput.select();
		document.execCommand('copy');
		document.body.removeChild(tempInput);
		showPopup(text);
	}

// Function to show popup
	function showPopup(text) {
		const lang = navigator.language || navigator.userLanguage;
		const message = 'Link copied to clipboard';

		const popup = document.createElement('div');
		const line1 = document.createElement('div');
		const line2 = document.createElement('div');

	// Line 1: "Link copied"
		line1.textContent = message;
		line1.style.marginBottom = '8px';
		line1.style.fontWeight = 'bold';

	// Line 2: Shorten link
		line2.textContent = text;
		line2.style.wordBreak = 'break-all'; // Prevent text overflow

	// Popup container
		popup.appendChild(line1);
		popup.appendChild(line2);
		popup.style.position = 'fixed';
		popup.style.top = '50%';
		popup.style.left = '50%';
		popup.style.transform = 'translate(-50%, -50%)';
		popup.style.padding = '20px 40px';
		popup.style.backgroundColor = '#ffa41c';
		popup.style.color = '#111';
		popup.style.borderRadius = '12px';
		popup.style.fontSize = '16px';
		popup.style.textAlign = 'center';
		popup.style.boxShadow = '0 8px 15px rgba(0, 0, 0, 0.3)'; // Shadow around the popup
		popup.style.zIndex = '9999';
		popup.style.opacity = '0'; // Start hidden
		popup.style.transition = 'opacity 0.4s'; // Fade effect

		document.body.appendChild(popup);

	// Fade in
		setTimeout(() => {
			popup.style.opacity = '1';
		}, 10);

	// Fade out and remove
		setTimeout(() => {
			popup.style.opacity = '0';
			setTimeout(() => popup.remove(), 400); // Ensure it is removed after fade-out
		}, popupDuration);
	}

// Modify the URL in the address bar if enabled
	if (modifyUrl) {
		const shortLink = generateShortLink();
		if (shortLink) {
			window.history.replaceState(null, '', shortLink);
		}
	}

// Add the copy button if enabled
	if (enableButton) {
	// Find the product title
		const productTitleElement = document.getElementById('productTitle');
		if (productTitleElement) {
			const buttonText = 'Copy Short Link';

		// Create the button
			const copyButton = document.createElement('button');
			copyButton.textContent = buttonText;
			copyButton.style.marginTop = '10px';
			copyButton.style.marginBottom = '4px'; // Add spacing below the button
			copyButton.style.padding = '8px 16px';
			copyButton.style.backgroundColor = '#ffa41c';
			copyButton.style.color = '#111';
			copyButton.style.border = '1px solid #ffa41c';
			copyButton.style.cursor = 'pointer';
			copyButton.style.borderRadius = '20px';
			copyButton.style.display = 'block'; // Ensure the button is on a new line
			copyButton.style.fontSize = '14px';
			copyButton.style.textAlign = 'center';
			copyButton.style.textDecoration = 'none';
			copyButton.style.boxShadow = '0 2px 5px rgba(0, 0, 0, 0.15)';

		// Add click event to the button
			copyButton.addEventListener('click', () => {
				const shortLink = generateShortLink();
				if (shortLink) {
					copyToClipboard(shortLink);
				} else {
					const errorText = 'Error: Unable to generate the short link.';
					alert(errorText);
				}
			});

		// Insert the button below the product title
			productTitleElement.parentNode.insertBefore(copyButton, productTitleElement.nextSibling);
		}
	}
})();

