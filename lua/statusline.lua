local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local vcs = require('galaxyline.provider_vcs')
local diag = require('galaxyline.provider_diagnostic')
local finfo = require('galaxyline.provider_fileinfo')

local fn = vim.fn
local cmd = vim.cmd
local api = vim.api
local bo = vim.bo

local section = gl.section

gl.short_line_list = {"startify", "vim-plug", "vista", "qf"}

local colours = {
	bg0 = "#2e3440", -- nord0
	bg1 = "#4c566a", -- nord3
	fg = "#d8dee9", -- nord4
	nord3_bright = "#7b88a1", -- grey
	nord7 = "#8fbcbb", -- blue/green
	nord8 = "#88c0d0", -- blue
	nord9 = "#81a1c1", -- blue
	nord10 = "#5e81ac", -- blue
	nord11 = "#bf616a", -- red
	nord12 = "#d08770", -- orange
	nord13 = "#ebcb8b", -- yellow
	nord14 = "#a3be8c", -- green
}

local modecols = {
	N = colours.nord8,
	T = colours.nord8,
	['!'] = colours.nord8,
	V = colours.nord7,
	I = colours.nord14,
	R = colours.nord14,
	C = colours.nord12,
	S = colours.nord14,
}

local leftsep = {
	LeftSeparator = {
		provider = function ()
			return ''
		end,
		highlight = {colours.bg1},
	}
}

local rightsep = {
	RightSeparator = {
		provider = function ()
			return ''
		end,
		highlight = {colours.bg1},
	},
}

local padding = {
	Padding = {
		provider = function ()
			return ' '
		end
	}
}

---@param path string
---@return string
local function shortenPath(path)

	while #path + 2 > (fn.winwidth(fn.winnr()) - 50) do -- 50 is approx width of right section
		local split = vim.split(path, '/')
		if #split < 2 then
			break
		end
		path = '<' .. table.concat(
			{unpack(
				split, 2
			)},
			'/'
		)
	end

	-- breaks if file path begins with `<`, but you shouldn't be putting that in a file name anyway
	return string.gsub(path, '^%<', '</')
end

local function showgit()
	return condition.check_git_workspace and fn.winwidth(fn.winnr()) > 70
end

local function showlsp()
	return diag.get_diagnostic_error() or
		diag.get_diagnostic_warn() or
		diag.get_diagnostic_info() or
		diag.get_diagnostic_hint()
end

---@param text string
---@return string
local function strip(text)
	if text then
		return string.gsub(text, "%s+", "")
	end
end

local function getalediag()
	local getcount = fn["ale#statusline#Count"]
	local bufnr = fn.bufnr('%')
	local errorcount = getcount(bufnr).error
	local warningcount = getcount(bufnr).total - errorcount
	return {
		errors = errorcount,
		warnings = warningcount
	}
end

local function addLeftSection(component)
	table.insert(section.left, component)
end

local function addRightSection(component)
	table.insert(section.right, component)
end

local function addShortLeftSection(component)
	table.insert(section.short_line_left, component)
end

local function addShortRightSection(component)
	table.insert(section.short_line_right, component)
end

local function FileName(short)
	local name = ''
	if short then name = 'FileNameShort' else name = 'FileName' end
	local filename = {
		provider = function ()
			-- return string.gsub(fileinfo.get_current_file_name('', ''), '^%s*(.-)%s*$', '%1')
			local icon = ''
			local padding = ''
			if bo.modifiable and not short then
				padding = '  ' -- first space isn't shown
			end
			local path = shortenPath(fn.fnamemodify(fn.expand('%'), ':~:.'))
			if path == '' then
				path = '[No File]'
			end
			if fn.getbufinfo(fn.bufnr('%'))[1].changed == 1 then
				icon = '  '
			end
			return padding .. path .. icon
		end,
		highlight = {colours.fg, colours.bg1},
		separator = '',
		separator_highlight = {colours.bg1},
	}
	return { [name] = filename }
end

local FileType = {
	FileType = {
		provider = function ()
			return '  ' .. bo.filetype -- first space isn't displayed
		end,
		condition = function ()
			local ft = bo.filetype
			return not (not ft or ft == '')
		end,
		highlight = {colours.fg, colours.bg1},
	}
}

local FTIcon = {
	FTIcon = {
		provider = function ()
			return finfo.get_file_icon()
		end,
		condition = function ()
			local ft = bo.filetype
			return not (not ft or ft == '')
		end,
		highlight = {colours.bg1, colours.nord9},
		separator = '',
		separator_highlight = {colours.nord9},
	}
}

addLeftSection({
	ModeSep = {
		provider = function ()
			local mode = string.upper(
			string.gsub(
			string.sub(fn.mode(), 1, 1), "", "V"
			):gsub("", "S")
			)
			cmd("hi GalaxyModeSep guifg=" .. modecols[mode])
			return ''
		end,
		highlight = {colours.bg1},
	}
})

addLeftSection({
	ViMode = {
		provider = function ()
			local mode = string.upper(
			string.gsub(
			string.sub(fn.mode(), 1, 1), "", "V"
			):gsub("", "S")
			)
			cmd("hi GalaxyViMode guibg=" .. modecols[mode])
			return mode .. ' '
		end,
		-- separator = '',
		-- separator_highlight = {colours.bg1},
		highlight = {colours.bg1, colours.fg, "bold"},
	}
})

addLeftSection(FileName(false))

addLeftSection({
	GitSep = {
		provider = function ()
			if showgit() and (vcs.diff_remove() or vcs.diff_add() or vcs.diff_modified()) then
				return ' '
			end
		end,
		highlight = {colours.bg1},
	},
})

addLeftSection({
	GitAdditions = {
		provider = function ()
			if vcs.diff_add() then
				if vcs.diff_modified() or vcs.diff_remove() then
					return vcs.diff_add()
				else
					return strip(vcs.diff_add())
				end
			end
		end,
		icon = "+",
		highlight = {colours.nord14, colours.bg1},
		condition = showgit
	}
})

addLeftSection({
	GitModifications = {
		provider = function ()
			if vcs.diff_modified() then
				if vcs.diff_remove() then
					return vcs.diff_modified()
				else
					return strip(vcs.diff_modified())
				end
			end
		end,
		icon = "~",
		highlight = {colours.nord13, colours.bg1},
		condition = showgit
	}
})

addLeftSection({
	GitDeletions = {
		provider = function ()
			return strip(vcs.diff_remove())
		end,
		icon = "-",
		highlight = {colours.nord11, colours.bg1},
		condition = showgit
	}
})

addLeftSection({
	GitSepRight = {
		provider = function ()
			if showgit() and (vcs.diff_remove() or vcs.diff_add() or vcs.diff_modified()) then
				return ''
			end
		end,
		highlight = {colours.bg1},
	}
})

addLeftSection({
	ResetColour = {
		provider = function ()
			return ''
		end,
		highlight = {colours.bg0},
	}
})

addRightSection(FTIcon)
addRightSection(FileType)

addRightSection({
	CondRightSeparator = {
		provider = function ()
			return ''
		end,
		highlight = {colours.bg1},
		condition = function ()
			local ft = bo.filetype
			return not (not ft or ft == '')
		end,
	},
})
addRightSection(padding)

addRightSection({
	LineNCharN = {
		provider = function ()
			return fn.line('.') .. ':' .. fn.col('.')
		end,
		highlight = {colours.nord9, colours.bg1},
		separator = '',
		separator_highlight = {colours.bg1},
	}
})

addRightSection(rightsep)
addRightSection(padding)

addRightSection({
	PercentTotLines = {
		provider = function ()
			local curline = fn.line('.')
			local totlines = fn.line('$')
			local percent = math.modf((curline / totlines) * 100)
			return percent .. '%/' .. totlines
		end,
		highlight = {colours.nord9, colours.bg1},
		separator = '',
		separator_highlight = {colours.bg1},
	}
})

addRightSection(rightsep)
-- addRightSection(padding)

addRightSection({
	DiagLeftSep = {
		provider = function ()
			if showlsp() then
				return '  ' -- the first space doesn't appear for some reason
			end
		end,
		highlight = {colours.bg1},
	}
})

-- addRightSection({
-- 	things = {
-- 		provider = function ()
-- 			return diag.get_diagnostic_error()
-- 		end
-- 	}
-- })


-- addRightSection({
-- 	ALEWarning = {
-- 		provider = function ()
-- 			return "W:" .. getalediag().warnings
-- 		end,
-- 		highlight = {colours.nord13, colours.bg1},
-- 		separator = '',
-- 		separator_highlight = {colours.bg1},
-- 	}
-- })

-- addRightSection({
-- 	nothing = {
-- 		provider = function ()
-- 			return ' '
-- 		end,
-- 		highlight = {colours.fg, colours.bg1},
-- 	}
-- })

-- addRightSection({
-- 	ALEError = {
-- 		provider = function ()
-- 			return "E:" .. getalediag().errors
-- 		end,
-- 		highlight = {colours.nord11, colours.bg1},
-- 	}
-- })

addRightSection({
	Hints = {
		provider = function ()
			if diag.get_diagnostic_info() or
				diag.get_diagnostic_warn() or
				diag.get_diagnostic_error()
			then
				return diag.get_diagnostic_hint()
			else
				return strip(diag.get_diagnostic_hint())
			end
		end,
		icon = "H:",
		highlight = {colours.nord3_bright, colours.bg1},
	}
})

addRightSection({
	Informations = {
		provider = function ()
			if diag.get_diagnostic_warn() or
				diag.get_diagnostic_error()
			then
				return diag.get_diagnostic_info()
			else
				return strip(diag.get_diagnostic_info())
			end
		end,
		icon = "I:",
		highlight = {colours.nord8, colours.bg1},
	}
})

addRightSection({
	Warnings = {
		provider = function ()
			if diag.get_diagnostic_error() then
				return diag.get_diagnostic_warn()
			else
				return strip(diag.get_diagnostic_warn())
			end
		end,
		icon = "W:",
		highlight = {colours.nord13, colours.bg1},
	}
})

addRightSection({
	Errors = {
		provider = function ()
			return strip(diag.get_diagnostic_error())
		end,
		icon = "E:",
		highlight = {colours.nord11, colours.bg1},
	}
})

addRightSection({
	DiagRightSep = {
		provider = function ()
			if showlsp() then
				return ''
			end
		end,
		highlight = {colours.bg1},
	}
})

addShortLeftSection(leftsep)

addShortLeftSection(FileName(true))

addShortRightSection(FTIcon)
addShortRightSection(FileType)

addShortRightSection({
	CondRightSeparator = {
		provider = function ()
			return ''
		end,
		highlight = {colours.bg1},
		condition = function ()
			local ft = bo.filetype
			return not (not ft or ft == '')
		end,
	},
})
