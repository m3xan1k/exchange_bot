---@class Constants
Constants = {}

Constants.CBR_URL = 'http://www.cbr.ru/scripts/XML_daily_eng.asp'
Constants.TG_BASE_URL = string.format('https://api.telegram.org/bot%s',
                                      os.getenv('TG_BOT_TOKEN'))

return Constants
