local http = require('socket.http')
local helpers = require('helpers')
local Constants = require('constants')
local inspect = require('inspect')
local ltn12 = require('ltn12')
local json = require('json')
local xml2lua = require("xml2lua")
local xmlhandler = require("xmlhandler.tree")


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
---@return table
bot.getupdate = function (last_update_id)
    local params = {timeout = 60, limit = 1}
    if not (last_update_id == nil) then
        params.offset = last_update_id + 1
    end

    local query_string = helpers.parameterize(params)
    local url = helpers.join(Constants.TG_BASE_URL, '/getupdates')

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


--- Send telegram message
---@param chat_id number
---@param text string
---@return nil
bot.send_message = function (chat_id, text)
    local params = {chat_id = chat_id, text = text, parse_mode = 'MarkdownV2'}

    local url = helpers.join(Constants.TG_BASE_URL, '/sendmessage')

    local response = {}

    http.request{
        method = 'POST',
        url = url,
        headers = {['Content-Type'] = 'application/json'},
        source = ltn12.source.string(json:encode(params)),
        sink = ltn12.sink.table(response)
    }
end


--- Get currencies from Central Bank API
---@return table
bot.get_currencies = function ()
    local response = {}
    local _, status = http.request{
        method = 'GET',
        url = Constants.CBR_URL,
        sink = ltn12.sink.table(response)
    }
    return response
end


--- Parse required attributes from XML to table
---@param xml string
---@return table
bot.parse_currencies = function (xml)
    local currencies = {}
    local handler = xmlhandler:new()
    local parser = xml2lua.parser(handler)
    parser:parse(xml)
    for _, valute in ipairs(handler.root.ValCurs.Valute) do
        local value = tonumber(valute.Value:gsub(',', '.'):format("%.2f"))
        currencies[valute.CharCode] = {
            name = valute.Name,
            value = string.format("%.2f", (value / tonumber(valute.Nominal)))
        }
    end
    return currencies
end


--- Dispatch message
---@param message table
---@return nil
bot.process_message = function (message)
    if message.text == '/help' then
        bot.send_message(message.chat.id, Constants.CODES)
        return
    end

    local cbr_response = bot.get_currencies()
    if not cbr_response then
        bot.send_message(message.chat.id, 'CBR not responding')
        return
    end

    local currencies = bot.parse_currencies(table.concat(cbr_response))
    local choice = currencies[message.text]
    if not choice then
        bot.send_message(message.chat.id, Constants.CODES)
        return
    end

    local text = string.format('```\n%s\n%.2f\n```', choice.name, choice.value)
    bot.send_message(message.chat.id, text)
end


return bot
