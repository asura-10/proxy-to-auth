local http = require("resty.http")
local json = require("cjson")


local AuthBeforeProxy = {}

AuthBeforeProxy.PRIORITY = 990
AuthBeforeProxy.VERSION = "0.1"

function AuthBeforeProxy:access(conf)
	ngx.log(ngx.ERR, "AuthServer: " .. conf.authservice)
	-- Get info
	local path = kong.request.get_path()
	local method = kong.request.get_method()
	local body = kong.request.get_body()
	local headers = kong.request.get_headers()
	local httpc = http.new()
	local url = conf.authservice .. path
	local res, err = httpc:request_uri(
		url,
		{
			ssl_verify = false,
			method = method,
			body = body,
			headers = headers,
		}
	)
	ngx.log(ngx.ERR, err)
	if err == nil
	then
		ngx.log(ngx.ERR, json.encode(res.body))
		if (res.status ~= 200)
		then
			kong.response.set_status(403)
			ngx.say(res.body)
		end
	else
		ngx.say(err)
	end
end

return AuthBeforeProxy
