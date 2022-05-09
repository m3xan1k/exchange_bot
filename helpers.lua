---@class helpers
helpers = {}

--- Joins base url and path
---@param base string
---@param path string
---@return string
helpers.join = function(base, path)
    if path:sub(1, 1) == '/' then
        path = path:sub(2)
    end
    local url = base .. '/' .. path
    return url
end

--- Makes query string from table
---@param t table Table of params
---@return string
helpers.parameterize = function (t)
    local query_string = ''
    for param, value in pairs(t) do
        if query_string == '' then
            query_string = query_string .. '?'
        else
            query_string = query_string .. '&'
        end
        local query_param = string.format("%s=%s", param, value)
        query_string = query_string .. query_param
    end
    return query_string
end

return helpers
