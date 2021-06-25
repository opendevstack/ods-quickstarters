local cjson = require("cjson")

local _M = {}

-- https://www.nginx.com/resources/wiki/extending/api/http/
function _M.make_error (err_type)
    if err_type == '40x' then
        ngx.status = ngx.HTTP_BAD_REQUEST
    else
        ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    end
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say(cjson.encode({ timestamp = os.time(os.date("!*t")), status = ngx.status }))
    return ngx.exit(ngx.status)
end

return _M
