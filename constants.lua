---@class Constants
Constants = {}

Constants.CBR_URL = 'http://www.cbr.ru/scripts/XML_daily_eng.asp'
Constants.TG_BASE_URL = string.format('https://api.telegram.org/bot%s',
                                      os.getenv('TG_BOT_TOKEN'))
Constants.CODES = [[
```
AMD — Armenia Dram
AUD — Australian Dollar
AZN — Azerbaijan Manat
BGN — Bulgarian lev
BRL — Brazil Real
BYN — Belarussian Ruble
CAD — Canadian Dollar
CHF — Swiss Franc
CNY — China Yuan
CZK — Czech Koruna
DKK — Danish Krone
EUR — Euro
GBP — British Pound Sterling
HKD — Hong Kong Dollar
HUF — Hungarian Forint
INR — Indian Rupee
JPY — Japanese Yen
KGS — Kyrgyzstan Som
KRW — South Korean Won
KZT — Kazakhstan Tenge
MDL — Moldova Lei
NOK — Norwegian Krone
PLN — Polish Zloty
RON — Romanian Leu
SEK — Swedish Krona
SGD — Singapore Dollar
TJS — Tajikistan Ruble
TMT — New Turkmenistan Manat
TRY — Turkish Lira
UAH — Ukrainian Hryvnia
USD — US Dollar
UZS — Uzbekistan Sum
XDR — SDR
ZAR — S.African Rand
```
]]

return Constants
