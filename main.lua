local bot = require('bot')

local function main()
    local last_update_id = nil
    while true do
        repeat
            local update = bot.getupdate(last_update_id)
            if not update then break end

            last_update_id = update.update_id

            local message = update.message or update.edited_message
            bot.process_message(message)
        until true
    end
end

main()
