-- a quick LUA access script for nginx to check IP addresses against an
-- `ip_blacklist` set in Redis, and if a match is found send a HTTP 403.
--
-- allows for a common blacklist to be shared between a bunch of nginx
-- web servers using a remote redis instance. lookups are cached for a
-- configurable period of time.
--
-- block an ip:
--   redis-cli SADD ip_blacklist 10.1.1.1
-- remove an ip:
--   redis-cli SREM ip_blacklist 10.1.1.1
--
-- also requires lua-resty-redis from:
--   https://github.com/agentzh/lua-resty-redis
--
-- your nginx http context should contain something similar to the
-- below: (assumes resty/redis.lua exists in /etc/nginx/lua/)
--
--   lua_package_path "/etc/nginx/lua/?.lua;;";
--   lua_shared_dict ip_blacklist 1m;
--
-- you can then use the below (adjust path where necessary) to check
-- against the blacklist in a http, server, location, if context:
--
-- access_by_lua_file /etc/nginx/lua/ip_blacklist.lua;
--
-- from https://gist.github.com/chrisboulton/6043871
-- modify by Ceelog

local redis_host    = "127.0.0.1" -- 这里一定是redis的IP地址
local redis_port    = "6379"

-- connection timeout for redis in ms. don't set this too high!
local redis_connection_timeout = 1000

-- check a set with this key for blacklist entries
local redis_key     = "ip_blacklist"

-- cache lookups for this many seconds
local cache_ttl     = 60

-- end configuration

local ip                = ngx.var.remote_addr
local ip_blacklist              = ngx.shared.ip_blacklist
local last_update_time  = ip_blacklist:get("last_update_time");

-- only update ip_blacklist from Redis once every cache_ttl seconds:
if last_update_time == nil or last_update_time < ( ngx.now() - cache_ttl ) then

  local redis = require "resty.redis";
  local red = redis:new();

  red:set_timeout(redis_connect_timeout);

  local ok, err = red:connect(redis_host, redis_port);

  if not ok then
    ngx.say("failed to authenticate: ", err)
    return
    ngx.log(ngx.DEBUG, "Redis connection error while retrieving ip_blacklist: " .. err);
  else
    local res, err = red:auth("123123") -- 配置redis的密码

    if not res then
        ngx.say("failed to authenticate: ", err)
        return
    end
    red:select(2) -- 设置redis的db
    local new_ip_blacklist, err = red:smembers(redis_key);
    if err then
      ngx.log(ngx.DEBUG, "Redis read error while retrieving ip_blacklist: " .. err);
    else
      -- replace the locally stored ip_blacklist with the updated values:
      ip_blacklist:flush_all();
      for index, banned_ip in ipairs(new_ip_blacklist) do
        ip_blacklist:set(banned_ip, true);
      end

      -- update time
      ip_blacklist:set("last_update_time", ngx.now());
    end
  end
end


if ip_blacklist:get(ip) then
  --ngx.say(ip)
  ngx.log(ngx.DEBUG, "Banned IP detected and refused access: " .. ip);
  return ngx.exit(ngx.HTTP_FORBIDDEN);
end