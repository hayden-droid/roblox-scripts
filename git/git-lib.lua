local git = {}
if not syn then
    syn = {}
    if http.request then syn.request = http.request elseif SENTINEL_V2 then syn.request = request else syn.request = function(tbl) b = {}; b.Body = game:HttpGet(tbl['Url']); return b end end
end
git.clone = function(xdd) 
a = syn.request({
	Url = xdd,
	Method = 'GET'
})
local struct = {}
for i = 2, #a.Body:split([[<div role="rowheader" class="flex-auto min-width-0 col-md-2 mr-3">]]) do
	table.insert(struct, a.Body:split([[<div role="rowheader" class="flex-auto min-width-0 col-md-2 mr-3">]])[i]:split('href')[2]:split('="')[2]:split('"')[1])
end
local function spider(struct)
	local st = os.clock()
	warn('------------------')
	local treestrct = {}
	for i, v in pairs(struct) do
		a = v:split('/')
		makefolder(a[2] .. '/' .. a[3] .. '/main')
		if a[4] == 'tree' then
			print(v .. ' tree found')
			local b = syn.request({
				Url = 'https://github.com' .. v,
				Method = 'GET'
			})
			for i = 2, #b.Body:split([[<div role="rowheader" class="flex-auto min-width-0 col-md-2 mr-3">]]) do
				table.insert(treestrct, b.Body:split([[<div role="rowheader" class="flex-auto min-width-0 col-md-2 mr-3">]])[i]:split('href')[2]:split('="')[2]:split('"')[1])
				wait()
			end
			prev = ''
			for i, vv in pairs(a) do
				warn(vv)
				if true then
					prev = prev .. '/' .. vv:gsub('/tree/', '')
					warn(vv, prev)
					makefolder(prev:gsub('/tree/', '/'))
				end
			end
		end
		if a[4] == 'blob' then
			print(v .. ' blob found')
			local rawst = v:split('blob/')
			if not isfolder(rawst[1]:gsub('', '')) then
				makefolder(rawst[1]:gsub('', ''))
			end
			e = rawst[1] .. '' .. rawst[2]
			print('https://raw.githubusercontent.com' .. e)
			a = game:HttpGet('https://raw.githubusercontent.com' .. e)
			warn(rawst[1]:gsub('', '') .. '' .. rawst[2])
			writefile(rawst[1]:gsub('', '') .. '' .. rawst[2], a)
		end
		wait()
	end
	local en = os.clock()
	warn('---------[Time elapsed: ' .. tostring(os.clock() - st) .. ']---------')
	wait(.1)
	if treestrct[1] then
		spider(treestrct)
	end
end

print(#struct)
spider(struct)
end
return git
--// usage : git.clone('https://github.com/tonumber/roblox-scripts') - outputs to tonumber/roblox-scripts in workspace folder
