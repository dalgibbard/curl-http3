# curl-http3
Curl Docker container compiled with HTTP/3 (h3/quic) support.

## To use
The Docker entrypoint is "curl", so simply pass any args to the docker command as you would curl. For example:
```
docker run dalgibbard/curl-http3 --connect-timeout 5 -m 5 -v --http3 https://cloudflare.com
```
