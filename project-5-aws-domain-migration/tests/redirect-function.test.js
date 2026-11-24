// Local behavioral tests for the CloudFront Function handler.
// Run with: node tests/redirect-function.test.js
const fs = require("fs");
const vm = require("vm");
const assert = require("assert");

const source = fs.readFileSync(
  require("path").join(__dirname, "../terraform/functions/old-domain-redirect.js"),
  "utf8"
);
const context = {};
vm.createContext(context);
vm.runInContext(source, context);

function invoke(uri, querystring) {
  return context.handler({
    request: {
      uri,
      querystring: querystring || {}
    }
  });
}

let response = invoke("/");
assert.strictEqual(response.statusCode, 301);
assert.strictEqual(response.headers.location.value, "https://abc.com/");
assert.match(response.headers["cache-control"].value, /max-age=300/);

response = invoke("/products/item", {
  campaign: { value: "spring sale" },
  source: { value: "newsletter" }
});
assert.strictEqual(
  response.headers.location.value,
  "https://abc.com/products/item?campaign=spring%20sale&source=newsletter"
);

response = invoke("/a/b/c", {
  tag: {
    multiValue: [{ value: "one" }, { value: "two" }]
  }
});
assert.strictEqual(
  response.headers.location.value,
  "https://abc.com/a/b/c?tag=one&tag=two"
);

console.log("PASS: root, path, query encoding, multi-value query, and cache header tests.");
