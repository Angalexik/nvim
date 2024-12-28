local strings = require("plenary.strings")
local utils = require("alpha.utils")

local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable

-- From vim-startify
local quotes = {
	{
		"Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it.",
		"",
		"- Brian Kernighan",
	},
	{ "If you don't finish then you're just busy, not productive." },
	{
		"Adapting old programs to fit new machines usually means adapting new machines to behave like old ones.",
		"",
		"- Alan Perlis",
	},
	{
		"There is nothing quite so useless as doing with great efficiency something that should not be done at all.",
		"",
		"- Peter Drucker",
	},
	{ "If you don't fail at least 90% of the time, you're not aiming high enough.", "", "- Alan Kay" },
	{
		"I think a lot of new programmers like to use advanced data structures and advanced language features as a way of demonstrating their ability. I call it the lion-tamer syndrome. Such demonstrations are impressive, but unless they actually translate into real wins for the project, avoid them.",
		"",
		"- Glyn Williams",
	},
	{ "I would rather die of passion than of boredom.", "", "- Vincent Van Gogh" },
	{
		"The computing scientist's main challenge is not to get confused by the complexities of his own making.",
		"",
		"- Edsger W. Dijkstra",
	},
	{
		"The essence of XML is this: the problem it solves is not hard, and it does not solve the problem well.",
		"",
		"- Phil Wadler",
	},
	{
		"A good programmer is someone who always looks both ways before crossing a one-way street.",
		"",
		"- Doug Linder",
	},
	{
		"Always code as if the person who ends up maintaining your code is a violent psychopath who knows where you live.",
		"",
		"- John Woods",
	},
	{
		"Linux was not designed to stop its users from doing stupid things, as that would also stop them from doing clever things.",
	},
	{
		"Contrary to popular belief, Linux is user friendly. It just happens to be very selective about who it decides to make friends with.",
	},
	{ "Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away." },
	{
		"There are two ways of constructing a software design: One way is to make it so simple that there are obviously no deficiencies, and the other way is to make it so complicated that there are no obvious deficiencies.",
		"",
		"- C.A.R. Hoare",
	},
	{ "If you don't make mistakes, you're not working on hard enough problems.", "", "- Frank Wilczek" },
	{ "If you don't start with a spec, every piece of code you write is a patch.", "", "- Leslie Lamport" },
	{ "Caches are bugs waiting to happen.", "", "- Rob Pike" },
	{ "All loops are infinite ones for faulty RAM modules." },
	{ "All idioms must be learned. Good idioms only need to be learned once.", "", "- Alan Cooper" },
	{
		"For a successful technology, reality must take precedence over public relations, for Nature cannot be fooled.",
		"",
		"- Richard Feynman",
	},
	{
		"If programmers were electricians, parallel programmers would be bomb disposal experts. Both cut wires.",
		"",
		"- Bartosz Milewski",
	},
	{ "Almost every programming language is overrated by its practitioners.", "", "- Larry Wall" },
	{ "Fancy algorithms are slow when n is small, and n is usually small.", "", "- Rob Pike" },
	{ "Methods are just functions with a special first argument.", "", "- Andrew Gerrand" },
	{ "Care about your craft.", "", "Why spend your life developing software unless you care about doing it well?" },
	{
		"Provide options, don't make lame excuses.",
		"",
		"Instead of excuses, provide options. Don't say it can't be done; explain what can be done.",
	},
	{
		"Be a catalyst for change.",
		"",
		"You can't force change on people. Instead, show them how the future might be and help them participate in creating it.",
	},
	{
		"Make quality a requirements issue.",
		"",
		"Involve your users in determining the project's real quality requirements.",
	},
	{
		"Critically analyze what you read and hear.",
		"",
		"Don't be swayed by vendors, media hype, or dogma. Analyze information in terms of you and your project.",
	},
	{
		"DRY - Don't Repeat Yourself.",
		"",
		"Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.",
	},
	{
		"Eliminate effects between unrelated things.",
		"",
		"Design components that are self-contained, independent, and have a single, well-defined purpose.",
	},
	{
		"Use tracer bullets to find the target.",
		"",
		"Tracer bullets let you home in on your target by trying things and seeing how close they land.",
	},
	{ "Program close to the problem domain.", "", "Design and code in your user's language." },
	{
		"Iterate the schedule with the code.",
		"",
		"Use experience you gain as you implement to refine the project time scales.",
	},
	{ "Use the power of command shells.", "", "Use the shell when graphical user interfaces don't cut it." },
	{
		"Always use source code control.",
		"",
		"Source code control is a time machine for your work - you can go back.",
	},
	{ "Don't panic when debugging", "", "Take a deep breath and THINK! about what could be causing the bug." },
	{
		"Don't assume it - prove it.",
		"",
		"Prove your assumptions in the actual environment - with real data and boundary conditions.",
	},
	{ "Write code that writes code.", "", "Code generators increase your productivity and help avoid duplication." },
	{
		"Finish what you start.",
		"",
		"Where possible, the routine or object that allocates a resource should be responsible for deallocating it.",
	},
	{ "Test your software, or your users will.", "", "Test ruthlessly. Don't make your users find bugs for you." },
	{
		"Don't think outside the box - find the box.",
		"",
		'When faced with an impossible problem, identify the real constraints. Ask yourself: "Does it have to be done this way? Does it have to be done at all?"',
	},
	{
		"Some things are better done than described.",
		"",
		"Don't fall into the specification spiral - at some point you need to start coding.",
	},
	{
		"Costly tools don't produce better designs.",
		"",
		"Beware of vendor hype, industry dogma, and the aura of the price tag. Judge tools on their merits.",
	},
	{
		"Don't use manual procedures.",
		"",
		"A shell script or batch file will execute the same instructions, in the same order, time after time.",
	},
	{
		"Gently exceed your users' expectations.",
		"",
		"Come to understand your users' expectations, then deliver just that little bit more.",
	},
	{
		"Remember the big picture.",
		"",
		"Don't get so engrossed in the details that you forget to check what's happening around you.",
	},
	{
		"Fix the problem, not the blame.",
		"",
		"It doesn't really matter whether the bug is your fault or someone else's - it is still your problem, and it still needs to be fixed.",
	},
	{
		"You can't write perfect software.",
		"",
		"Software can't be perfect. Protect your code and users from the inevitable errors.",
	},
	{ "Crash early.", "", "A dead program normally does a lot less damage than a crippled one." },
	{ "Sign your work.", "", "Craftsmen of an earlier age were proud to sign their work. You should be, too." },
	{ "Think twice, code once." },
	{ "No matter how far down the wrong road you have gone, turn back now." },
	{ "Why do we never have time to do it right, but always have time to do it over?" },
	{ "Weeks of programming can save you hours of planning." },
	{ "To iterate is human, to recurse divine.", "", "- L. Peter Deutsch" },
	{ "Computers are useless. They can only give you answers.", "", "- Pablo Picasso" },
	{
		"The question of whether computers can think is like the question of whether submarines can swim.",
		"",
		"- Edsger W. Dijkstra",
	},
	{ "The city's central computer told you? R2D2, you know better than to trust a strange computer!", "", "- C3PO" },
	{
		"Most software today is very much like an Egyptian pyramid with millions of bricks piled on top of each other, with no structural integrity, but just done by brute force and thousands of slaves.",
		"",
		"- Alan Kay",
	},
	{
		"There are two major products that come out of Berkeley: LSD and UNIX. We don't believe this to be a coincidence.",
		"",
		"- Jeremy S. Anderson",
	},
	{
		"The bulk of all patents are crap. Spending time reading them is stupid. It's up to the patent owner to do so, and to enforce them.",
		"",
		"- Linus Torvalds",
	},
	{ "Controlling complexity is the essence of computer programming.", "", "- Brian Kernighan" },
	{ "The function of good software is to make the complex appear to be simple.", "", "- Grady Booch" },
	{
		"There's an old story about the person who wished his computer were as easy to use as his telephone. That wish has come true, since I no longer know how to use my telephone.",
		"",
		"- Bjarne Stroustrup",
	},
	{
		"There are only two industries that refer to their customers as 'users': illegal drugs and software.",
		"",
		"- Edward Tufte",
	},
	{
		"Most of you are familiar with the virtues of a programmer. There are three, of course: laziness, impatience, and hubris.",
		"",
		"- Larry Wall",
	},
	{
		"Computer science education cannot make anybody an expert programmer any more than studying brushes and pigment can make somebody an expert painter.",
		"",
		"- Eric S. Raymond",
	},
	{ "Optimism is an occupational hazard of programming; feedback is the treatment.", "", "- Kent Beck" },
	{ "First, solve the problem. Then, write the code.", "", "- John Johnson" },
	{
		"Measuring programming progress by lines of code is like measuring aircraft building progress by weight.",
		"",
		"- Bill Gates",
	},
	{
		"Don't worry if it doesn't work right. If everything did, you'd be out of a job.",
		"",
		"- Mosher's Law of Software Engineering",
	},
	{ "A LISP programmer knows the value of everything, but the cost of nothing.", "", "- Alan J. Perlis" },
	{ "All problems in computer science can be solved with another level of indirection.", "", "- David Wheeler" },
	{
		"Functions delay binding; data structures induce binding. Moral: Structure data late in the programming process.",
		"",
		"- Alan J. Perlis",
	},
	{ "Easy things should be easy and hard things should be possible.", "", "- Larry Wall" },
	{ "Nothing is more permanent than a temporary solution." },
	{
		"If you can't explain something to a six-year-old, you really don't understand it yourself.",
		"",
		"- Albert Einstein",
	},
	{ "Software is hard.", "", "- Donald Knuth" },
	{ "They did not know it was impossible, so they did it!", "", "- Mark Twain" },
	{ "Question: How does a large software project get to be one year late?", "Answer: One day at a time!" },
	{
		"The first 90% of the code accounts for the first 90% of the development time. The remaining 10% of the code accounts for the other 90% of the development time.",
		"",
		"- Tom Cargill",
	},
	{
		"In software, we rarely have meaningful requirements. Even if we do, the only measure of success that matters is whether our solution solves the customer's shifting idea of what their problem is.",
		"",
		"- Jeff Atwood",
	},
	{
		"If debugging is the process of removing bugs, then programming must be the process of putting them in.",
		"",
		"- Edsger W. Dijkstra",
	},
	{ "640K ought to be enough for anybody.", "", "- Bill Gates, 1981" },
	{ "To understand recursion, one must first understand recursion.", "", "- Stephen Hawking" },
	{
		"Developing tolerance for imperfection is the key factor in turning chronic starters into consistent finishers.",
		"",
		"- Jon Acuff",
	},
	{
		"Every great developer you know got there by solving problems they were unqualified to solve until they actually did it.",
		"",
		"- Patrick McKenzie",
	},
	{
		"The average user doesn't give a damn what happens, as long as (1) it works and (2) it's fast.",
		"",
		"- Daniel J. Bernstein",
	},
	{
		"Walking on water and developing software from a specification are easy if both are frozen.",
		"",
		"- Edward V. Berard",
	},
	{ "What one programmer can do in one month, two programmers can do in two months.", "", "- Frederick P. Brooks" },
	{
		"There are only two kinds of languages: the ones people complain about and the ones nobody uses.",
		"",
		"- Bjarne Stroustrup",
	},
	{
		"Any application that can be written in JavaScript, will eventually be written in JavaScript.",
		"",
		"- Atwood's Law",
	},
}

local function merge(t1, t2)
	for _, v in ipairs(t2) do
		table.insert(t1, v)
	end
end

local function generate_header()
	local top_left_corner = "╭"
	local top_right_corner = "╮"
	local bottom_left_corner = "╰"
	local bottom_right_corner = "╯"
	local horizontal_line = "─"
	local vertical_line = "│"
	local cow = [[       o
        o   ^__^
         o  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||]]

	math.randomseed(math.floor(os.time()))
	local quote = quotes[math.random(#quotes)]
	local wrapped_quote = {}
	for _, line in ipairs(quote) do
		merge(wrapped_quote, vim.fn.split(line, "\\%50c.\\{-}\\zs\\s", true))
	end
	local width = math.max(unpack(vim.fn.map(wrapped_quote, function(_, val)
		return #val
	end)))
	local text = top_left_corner .. vim.fn["repeat"](horizontal_line, width + 2) .. top_right_corner .. "\n"
	for _, line in ipairs(wrapped_quote) do
		text = text .. vertical_line .. " " .. strings.align_str(line, width) .. " " .. vertical_line .. "\n"
	end
	text = text
		.. bottom_left_corner
		.. vim.fn["repeat"](horizontal_line, width + 2)
		.. bottom_right_corner
		.. "\n"
		.. cow
	return {
		type = "text",
		val = vim.fn.split(text, "\n", true),
		opts = {
			hl = "Type",
			shrink_margin = false,
			-- wrap = "overflow";
		},
	}
end

local leader = "SPC"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "left",
		shortcut = "[" .. sc .. "] ",
		cursor = 1,
		-- width = 50,
		align_shortcut = "left",
		hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
		shrink_margin = false,
	}
	if keybind then
		keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

local file_icons = {
	enabled = true,
	highlight = true,
	-- available: devicons, mini, to use nvim-web-devicons or mini.icons
	-- if provider not loaded and enabled is true, it will try to use another provider
	provider = "mini",
}

local function icon(fn)
	if file_icons.provider ~= "devicons" and file_icons.provider ~= "mini" then
		vim.notify(
			"Alpha: Invalid file icons provider: " .. file_icons.provider .. ", disable file icons",
			vim.log.levels.WARN
		)
		file_icons.enabled = false
		return "", ""
	end

	local ico, hl = utils.get_file_icon(file_icons.provider, fn)
	if ico == "" then
		file_icons.enabled = false
		vim.notify("Alpha: Mini icons or devicons get icon failed, disable file icons", vim.log.levels.WARN)
	end
	return ico, hl
end

local function file_button(fn, sc, short_fn, autocd)
	short_fn = if_nil(short_fn, fn)
	local ico_txt
	local fb_hl = {}
	if file_icons.enabled then
		local ico, hl = icon(fn)
		local hl_option_type = type(file_icons.highlight)
		if hl_option_type == "boolean" then
			if hl and file_icons.highlight then
				table.insert(fb_hl, { hl, 0, #ico })
			end
		end
		if hl_option_type == "string" then
			table.insert(fb_hl, { file_icons.highlight, 0, #ico })
		end
		ico_txt = ico .. "	"
	else
		ico_txt = ""
	end
	local cd_cmd = (autocd and " | cd %:p:h" or "")
	local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
	local fn_start = short_fn:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
	end
	file_button_el.opts.hl = fb_hl
	return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
	ignore = function(path, ext)
		return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
	end,
	autocd = false,
}

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
	opts = opts or mru_opts
	items_number = if_nil(items_number, 10)
	local oldfiles = {}
	for _, v in pairs(vim.v.oldfiles) do
		if #oldfiles == items_number then
			break
		end
		local cwd_cond
		if not cwd then
			cwd_cond = true
		else
			cwd_cond = vim.startswith(v, cwd)
		end
		local ignore = (opts.ignore and opts.ignore(v, utils.get_extension(v))) or false
		if (filereadable(v) == 1) and cwd_cond and not ignore then
			oldfiles[#oldfiles + 1] = v
		end
	end

	local tbl = {}
	for i, fn in ipairs(oldfiles) do
		local short_fn
		if cwd then
			short_fn = fnamemodify(fn, ":.")
		else
			short_fn = fnamemodify(fn, ":~")
		end
		local file_button_el = file_button(fn, tostring(i + start - 1), short_fn, opts.autocd)
		tbl[i] = file_button_el
	end
	return {
		type = "group",
		val = tbl,
		opts = {},
	}
end

local function mru_title()
	return "MRU " .. vim.fn.getcwd()
end

local section = {
	header = generate_header(),
	top_buttons = {
		type = "group",
		val = {
			button("e", "New file", "<cmd>ene <CR>"),
		},
	},
	-- note about MRU: currently this is a function,
	-- since that means we can get a fresh mru
	-- whenever there is a DirChanged. this is *really*
	-- inefficient on redraws, since mru does a lot of I/O.
	-- should probably be cached, or maybe figure out a way
	-- to make it a reference to something mutable
	-- and only mutate that thing on DirChanged
	mru = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = "MRU", opts = { hl = "SpecialComment" } },
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { mru(10) }
				end,
			},
		},
	},
	mru_cwd = {
		type = "group",
		val = {
			{ type = "padding", val = 1 },
			{ type = "text", val = mru_title, opts = { hl = "SpecialComment", shrink_margin = false } },
			{ type = "padding", val = 1 },
			{
				type = "group",
				val = function()
					return { mru(0, vim.fn.getcwd()) }
				end,
				opts = { shrink_margin = false },
			},
		},
	},
	bottom_buttons = {
		type = "group",
		val = {
			button("q", "Quit", "<cmd>q <CR>"),
		},
	},
	footer = {
		type = "group",
		val = {},
	},
}

local config = {
	layout = {
		{ type = "padding", val = 1 },
		section.header,
		{ type = "padding", val = 2 },
		section.top_buttons,
		section.mru_cwd,
		section.mru,
		{ type = "padding", val = 1 },
		section.bottom_buttons,
		section.footer,
	},
	opts = {
		margin = 3,
		redraw_on_resize = false,
		setup = function()
			vim.api.nvim_create_autocmd("DirChanged", {
				pattern = "*",
				group = "alpha_temp",
				callback = function()
					require("alpha").redraw()
					vim.cmd("AlphaRemap")
				end,
			})
		end,
	},
}

return {
	icon = icon,
	button = button,
	file_button = file_button,
	mru = mru,
	mru_opts = mru_opts,
	section = section,
	config = config,
	-- theme config
	file_icons = file_icons,
	-- deprecated
	nvim_web_devicons = file_icons,
	leader = leader,
	-- deprecated
	opts = config,
}
