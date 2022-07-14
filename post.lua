local http = game:GetService("HttpService")
function json(tbl) return http:JSONEncode(tbl) end

function makepost(server,embed, ...)
    local extra = {...}
    local msg = (#extra> 0 and "") or nil
    for i,v in pairs(extra) do msg=msg.."\n"..v end
    local g = syn.request{
        Url = server,
        Method = "POST",
        Body = json{content = (msg ~= "" and msg) or nil, embeds = {embed}},
        Headers ={['Content-Type'] = "application/json"}
    }
    return g
end
return makepost
