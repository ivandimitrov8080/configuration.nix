local servers = {}

local addServers = function(srv)
    servers = vim.tbl_deep_extend("force", servers, srv)
end

local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

local function log(o)
    local file = io.open("./.nvim.log", "a+")
    if file then
        file:write(os.date("%Y/%m/%d %H:%M:%S") .. " || " .. dump(o) .. "\n")
        file:write("---\n")
        file:close()
    end
end
