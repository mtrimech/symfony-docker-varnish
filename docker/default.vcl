vcl 4.0;
backend default {
  .host = "162.11.1.102";
  .port = "80";
}

# If you don't include below, header Age in response to client always be 0

sub vcl_deliver {
  # Display hit/miss info
  if (obj.hits > 0) {
    set resp.http.V-Cache = "HIT";
  }
  else {
    set resp.http.V-Cache = "MISS";
  }
  set resp.http.Access-Control-Allow-Origin = "*";
  set resp.http.Access-Control-Allow-Headers = "Accept,Authorization,Cache-Control,Content-Type,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Mx-ReqToken,X-Requested-With";
  set resp.http.Allow = "GET, POST";
  set resp.http.Access-Control-Allow-Credentials = "true";
  set resp.http.Access-Control-Allow-Methods = "GET, POST, PUT, DELETE, OPTIONS, PATCH";
  set resp.http.Access-Control-Expose-Headers = "X-Pagination-Total, X-Pagination-Page, X-Pagination-Limit";
}
sub vcl_backend_response {
  if (beresp.status == 200) {
    unset beresp.http.Cache-Control;
    set beresp.http.Cache-Control = "public; max-age=200";
    set beresp.ttl = 200s;
  }
  set beresp.http.Served-By = beresp.backend.name;
  set beresp.http.V-Cache-TTL = beresp.ttl;
  set beresp.http.V-Cache-Grace = beresp.grace;
}
