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
    ne = 3, --next
    ne2 = 4, --
}
local tree = {
    {
        {
            {
                {53,52,72},
                {46,51,86},
                83
            },
            {
                {nil, nil, 70},
                {nil, 50, nil},
                85
            },
            73
        },
        {
            {
                {nil,nil,76},
                {43,nil,nil},
                82
            },
            {{nil,nil,80}, {nil,49,74}, 87}, 65}, 69}, {{{{54,61,66}, {47,nil,88}, 68}, {{nil,nil,67}, {nil,nil,89}, 75}, 78},{{{55,nil,90}, {nil,nil,81}, 71}, {{56},{57,48},79}, 77}, 84}, 32}
local arctree = {[46] = 11121, [32] = 3,[69] = 13,[84] = 23,[73] = 113,[65] = 123,[78] = 213,[77] = 223,[83] = 1113,[85] = 1123,[82] = 1213,[87] = 1223,[68] = 2113,[75] = 2123,[71] = 2213,[79] = 2223,[72] = 11113,[86] = 11123,[70] = 11213,[76] = 12113,[80] = 12213,[74] = 12223,[66] = 21113,[88] = 21123,[67] = 21213,[89] = 21223,[90] = 22113,[81] = 22123,[53] = 11111,[52] = 11112,[51] = 11122,[50] = 11222,[43] = 12121,[49] = 12222,[54] = 21111,[61] = 21112,[47] = 21121,[55] = 22111,[56] = 22211,[57] = 22221,[48] = 22222}
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
    str = tostring(str)
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

local tableencode,tabledecode = (function() 
    local types = {
        k = 17, --key: before, value: after
        e = 18, --table
        ee = 22, --exit table scope
        ea = 23, --exit value-read (non table)
        n = 30, --num
        s = 27, --string
        c = 4, --comma (table values)
    }
    local function split(str, splt)
        local new = {}
        for v in str:gmatch(("([^%s]*)"):format(splt)) do table.insert(new, v) end
        return new
    end
    local function countscope(line)
        if true then return 0, line end
        local i = 0
        line = line:gsub("\t", function() i = i + 1 return "" end)
        return i, line
    end
    local function find(tbl, val)
        for i,v in next, tbl do if v == val then return i end end
        return
    end
    local ch, by = string.char, string.byte
    local function isescape(str)
        local ind = find(types, by(str))
        return ind and type(ind) == 'string' and ind
    end
    local function csplit(str)
        local x = {}
        local spillover = ""
        local scope = 0
        for i in str:gmatch("[^"..ch(types.c).."]+") do
            local a1, a2 = #spillover > 0, i:find("^"..ch(types.e))
            if a1 or a2 then
                if a2 then scope = scope + 1 end
                spillover = spillover..(a1 and ch(types.c) or "")..i
                if i:reverse():find("^"..ch(types.ee)) then
                    scope = scope - 1
                    if (scope == 0) then
                        i = spillover
                        spillover = ""
                    end
                end
            end
            table.insert(x, i)
        end
        return x
    end
    local comma = ch(types.c)
    local function decode(str, recursed)
        local str = type(str) == 'table' and str or csplit(str) --FOUND ISSUE: SPLITTING INSIDE OF NESTED TABLES!! FIX REGEX
        --probably will need to write own.
        local new = {}
        inscope = inscope or {open = 1, closed = 0}
        for i,v in next, str do
            local scope, data = countscope(v)
            assert(scope + inscope.open <= inscope.closed + 1, 'Invalid scope.')
            --inscope.open = inscope.open + 1 --tables not supported yet
            local type = isescape(data)
            data = data:sub(2,-1) --remove identifier
            if rawequal(type, "n") then
                local _start, _end = data:find(ch(types.k))
                assert(_start, "Invalid key.")
                local key = parse(data:sub(1, _end-1))
                local ending = data:find(ch(types.ea))
                assert(ending, "Read left open for key: "..key)
                local value = tonumber(parse(data:sub(_end+1, ending - 1)))
                assert(value, "Invalid double for key: "..key)

                new[
                    tonumber(key) and tonumber(key) or key
                    ] = value
            elseif rawequal(type, "s") then
                local _start, _end = data:find(ch(types.k))
                assert(_start, "Invalid key.")
                local key = parse(data:sub(1, _end-1))
                local ending = data:find(ch(types.ea))
                assert(ending, "Read left open for key: "..key)
                local value = parse(data:sub(_end+1, ending - 1))
                new[
                    tonumber(key) and tonumber(key) or key
                    ] = value
            elseif rawequal(type, "e") then
                local _start, _end = data:find(ch(types.k))
                assert(_start, "Invalid key.")
                local key = parse(data:sub(1, _end-1))
                local ending = data:reverse():find(ch(types.ee)) --last index of closetbl
                assert(ending, "Unclosed table for key: "..key)
                ending = #data - ending
                local newtblstr = data:sub(_end+1, ending)
                if #newtblstr ~= 0 then
                    local value = decode(newtblstr, true)
                    new[
                        tonumber(key) and tonumber(key) or key
                        ] = value
                end
            else
                error"Invalid decode format."
            end
        end
        return new
    end
    local function encode(tbl, nocycles, recursed)
        recursed = (recursed or 0) + 1
        nocycles = nocycles or {}
        local str = ""
        local ctr = 0
        for i,v in next, tbl do
            if ctr > 0 then str = str..ch(types.c) end
            local type = type(v)
            type = (type == 'number' and 'n') or (type == 'string' and 's') or (type == 'table' and 'e') or error"unsupported type: "..type
            if type ~= 'e' then
                str = str..ch(types[type])
                ..to(i)..ch(types.k)
                ..to(v)..ch(types.ea)--..ch(types.c)
            else
                assert(not tf(nocycles, v), "Cyclic table detected.")
                local data = encode(v, nocycles, recursed)
                table.insert(nocycles, v) --no cyclic detection = stack overflow
                str = str..ch(types[type])..to(i)..ch(types.k)
                ..data..ch(types.ee)
            end
    --append to old:   [datatype],      [keyname],   [key-value separator], [value], [END OF READ], [comma]
            ctr = ctr + 1
        end
        return str, ctr, recursed
    end
    return encode, decode
end)()
local module = {
    DecodeText = parse,
    EncodeText = to,
    EncodeTable = tableencode,
    DecodeTable = tabledecode
}
