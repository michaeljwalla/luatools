local info = {
    [1] = 14,
    [2] = 26,
    [3] = 7,
    [4] = 8,
    e = 18, --entry
    n = 30, --num
    s = 27, --string
    ee = 22, --un-entry
    u = 25, --lowercase,
    ne = 3 --next
}
local tree = {{{{{53,52,72},{nil,51,86},83}, {{nil, nil, 70},{nil, 50, nil},85}, 73},{{{nil,nil,76},{43,nil,nil},82},{{nil,nil,80}, {nil,49,74}, 87}, 65}, 69}, {{{{54,61,66}, {47,nil,88}, 68}, {{nil,nil,67}, {nil,nil,89}, 75}, 78},{{{55,nil,90}, {nil,nil,81}, 71}, {{56},{57,48},79}, 77}, 84}, 32}
local arctree = {[32] = 3,[69] = 13,[84] = 23,[73] = 113,[65] = 123,[78] = 213,[77] = 223,[83] = 1113,[85] = 1123,[82] = 1213,[87] = 1223,[68] = 2113,[75] = 2123,[71] = 2213,[79] = 2223,[72] = 11113,[86] = 11123,[70] = 11213,[76] = 12113,[80] = 12213,[74] = 12223,[66] = 21113,[88] = 21123,[67] = 21213,[89] = 21223,[90] = 22113,[81] = 22123,[53] = 11111,[52] = 11112,[51] = 11122,[50] = 11222,[43] = 12121,[49] = 12222,[54] = 21111,[61] = 21112,[47] = 21121,[55] = 22111,[56] = 22211,[57] = 22221,[48] = 22222}
local c, b = string.char, string.byte
local function tf(tbl, item)
    for i,v in next, tbl do
        if v == item then return i end
    end
   return 
end
local function split (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        local s = "([^"..sep.."]+)"
        for str in string.gmatch(inputstr, s) do
            table.insert(t, str)
        end
        return t
end
local function totalsplit(str)
    local n = {}
    for i = 1, #str do table.insert(n, str:sub(i,i)) end
    return n
end
local function let(str)
    str = totalsplit(tostring(str))
    local res
    pcall(function()
        local st = tree
        
        
        for i = 1, #str do
            local s = tonumber(tf(info, b(str[i])))
            local off = 0
            if (s == 4) then s = s - 1 off = 32 end
            st = st[s]
            if (type(st) == 'number') then st = st + off end
        end
        assert(st and type(st) == 'number')
        res = c(st)
    end)
    return res
end
local function parse(tbl, cc)
    if (type(tbl) == 'string') then
        tbl = split(tbl:reverse():gsub("\n.*$", ""):reverse(), "\3")
    end
    local result = ''
    for i,v in next, tbl do result = result..let(v) end
    return result
end
local function aparse(num)
    num = tostring(num)
    local res = ""
    for i = 1, #num do
        local n = tonumber(num:sub(i,i))
        if (n and info[n]) then
            res = res..c(info[n])
        end
    end
    return res
end
local function to(str)
    local res = ""
    for i = 1, #str do
        local s, lw = str:sub(i,i), 0
        local ce = b(s)
        if (s:upper() ~= s) then lw = 1 ce = ce - 32 end 
        if arctree[ce] then
            res = res.."\3"..aparse(arctree[ce] + lw)
        end
    end
    return res:sub(2)
end
local module = {
    Read = parse,
    Convert = function(a)
        local n, res = pcall(to, a)
        assert(n, "Invalid conversion format. Did you forget a [ \\n / .Convert() ]?")
        return res
    end
}
return module, info
