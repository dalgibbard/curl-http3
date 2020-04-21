# curl-http3
Curl Docker container compiled with HTTP/3 (h3/quic) support.

## To Use
The Docker entrypoint is "curl", so simply pass any args to the docker command as you would curl. For example:
```
docker run dalgibbard/curl-http3 --connect-timeout 5 -m 5 -v --http3 https://cloudflare.com
```

## Options to enable HTTP3 in Servers
At the time of writing, HTTP3 support in browsers is not enabled by default. However, multiple servers are adding support for it. For example:
* Caddy2
* NGinX
* Quiche/Cloudflare

For more information: https://en.wikipedia.org/wiki/HTTP/3
