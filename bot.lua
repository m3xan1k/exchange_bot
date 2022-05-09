local http = require('socket.http')
local helpers = require('helpers')
local Constants = require('constants')
local inspect = require('inspect')
local ltn12 = require('ltn12')
local json = require('json')

---@class bot
bot = {}


--- Check if response is OK
---@param status number
---@param response_json table
---@return boolean
local function response_ok(status, response_json)
    return status == 200 and response_json.ok
end


--- Requests single update from telegram api
---@param last_update_id number
---@return any
bot.getupdate = function (last_update_id)
   local params = {timeout = 60, limit = 1}
   if not last_update_id == nil then
       params.last_update_id = last_update_id
   end

   local query_string = helpers.parameterize(params)
   print(query_string)
   local url = helpers.join(Constants.TG_BASE_URL, '/getupdates')
   print(url)

   local response = {}
   local _, status = http.request{
        method = 'GET',
        url = url .. query_string,
        sink = ltn12.sink.table(response)
   }

   local response_json = json:decode(table.concat(response))
   if not response_ok(status, response_json) then
       return nil
   end
   
   local update = response_json.result[1]
   return update
end


bot.getupdate()
