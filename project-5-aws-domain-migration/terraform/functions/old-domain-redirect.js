// CloudFront Functions runtime: cloudfront-js-2.0
// Redirect old hostnames to the canonical new hostname.
// URI and query string are preserved. The destination is intentionally fixed;
// never build a redirect destination from an untrusted Host header.

function serializeQueryString(querystring) {
    var parts = [];
    for (var key in querystring) {
        if (!Object.prototype.hasOwnProperty.call(querystring, key)) {
            continue;
        }

        var item = querystring[key];
        if (item.multiValue && item.multiValue.length > 0) {
            for (var i = 0; i < item.multiValue.length; i++) {
                parts.push(encodeURIComponent(key) + "=" + encodeURIComponent(item.multiValue[i].value || ""));
            }
        } else {
            parts.push(encodeURIComponent(key) + "=" + encodeURIComponent(item.value || ""));
        }
    }
    return parts.length ? "?" + parts.join("&") : "";
}

function handler(event) {
    var request = event.request;
    var destination = "https://abc.com";
    var location = destination + request.uri + serializeQueryString(request.querystring || {});

    return {
        statusCode: 301,
        statusDescription: "Moved Permanently",
        headers: {
            location: { value: location },
            "cache-control": { value: "public, max-age=300, s-maxage=300" },
            "strict-transport-security": { value: "max-age=31536000; includeSubDomains" }
        }
    };
}
