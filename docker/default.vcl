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

    // Check for ESI acknowledgement and remove Surrogate-Control header
    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        unset beresp.http.Surrogate-Control;
        set beresp.do_esi = true;
    }

    # For static content strip all backend cookies and push to static storage
    if (bereq.url ~ "\.(css|js|png|gif|jp(e?)g)|swf|ico") {
        unset beresp.http.cookie;
        set beresp.storage_hint = "static";
        set beresp.http.x-storage = "static";
    } else {
        set beresp.storage_hint = "default";
        set beresp.http.x-storage = "default";
    }
}

sub vcl_recv {
    if (req.http.X-Forwarded-Proto == "https" ) {
        set req.http.X-Forwarded-Port = "443";
    } else {
        set req.http.X-Forwarded-Port = "80";
    }

    // Remove all cookies except the session ID.
    if (req.http.Cookie) {
        set req.http.Cookie = ";" + req.http.Cookie;
        set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
        set req.http.Cookie = regsuball(req.http.Cookie, ";(PHPSESSID)=", "; \1=");
        set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

        if (req.http.Cookie == "") {
            // If there are no more cookies, remove the header to get page cached.
            unset req.http.Cookie;
        }
    }

    // Add a Surrogate-Capability header to announce ESI support.
    set req.http.Surrogate-Capability = "abc=ESI/1.0";
}
