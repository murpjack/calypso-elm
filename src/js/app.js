const REFRESH_TOKEN = "REFRESH_TOKEN";
const SUCCESS_URI_MATCH = "https://murphyme.co.uk/calypso/success*";

// chrome.storage.local.set({ [REFRESH_TOKEN]: "123456789AB" });

var app = Elm.Main.init({
    node: document.getElementById("elm"),
});

/** Look for success page in current tabs. */
chrome.tabs.query({ url: SUCCESS_URI_MATCH }, (tabs) => {
    /** Find the url with the most recent timestamp */
    const recentTab = tabs.reduce((a, b) => {
        const posixA = paramByName(a.url, 'timestamp');
        const posixB = paramByName(b.url, 'timestamp');
        return (posixA > posixB) ? a : b;
    });

    if (typeof recentTab === 'object' &&
        recentTab.hasOwnProperty("url")) {

        const recentTabUrl = new URL(recentTab.url);
        const ott = paramByName(recentTabUrl, "ott") || "nothing";
        app.ports.getCoinbaseTemporaryToken.send(ott);
    }
});

function paramByName(urlString, name) {
    const url = new URL(urlString);
    const urlParams = new URLSearchParams(url.search);
    return urlParams.get(name);
}


/** Refresh Token Ports */
chrome.storage.local.get(null, (items) => {
    if (chrome.runtime.lastError) {
        return chrome.runtime.lastError;
    }
    const token = items[REFRESH_TOKEN] ? items[REFRESH_TOKEN] : "nothing";
    app.ports.getCoinbaseRefreshToken.send(token);
});

app.ports.clearCoinbaseRefreshToken
    .subscribe(() => chrome.storage.local.remove(REFRESH_TOKEN));