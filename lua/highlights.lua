local nord = {
	nord0 = {
		gui = "#2e3440",
		term = "NONE",
	},
	nord1 = {
		gui = "#3b4252",
		term = "0",
	},
	nord2 = {
		gui = "#434c5e",
		term = "8",
	},
	nord3 = {
		gui = "#4c566a",
		term = "8",
	},
	nord3_bright = {
		gui = "#616e88",
		term = "8",
	},
	nord4 = {
		gui = "#d8dee9",
		term = "NONE",
	},
	nord5 = {
		gui = "#e5e9f0",
		term = "7",
	},
	nord6 = {
		gui = "#eceff4",
		term = "15",
	},
	nord7 = {
		gui = "#8fbcbb",
		term = "14",
	},
	nord8 = {
		gui = "#88c0d0",
		term = "6",
	},
	nord9 = {
		gui = "#81a1c1",
		term = "4",
	},
	nord10 = {
		gui = "#5e81ac",
		term = "12",
	},
	nord11 = {
		gui = "#bf616a",
		term = "1",
	},
	nord12 = {
		gui = "#d08770",
		term = "11",
	},
	nord13 = {
		gui = "#ebcb8b",
		term = "3",
	},
	nord14 = {
		gui = "#a3be8c",
		term = "2",
	},
	nord15 = {
		gui = "#b48ead",
		term = "5",
	},
}

local highlights = {
	-- Floaters
	FloatBorder = { fg = nord.nord4, bg = nord.nord2 },
	NormalFloat = { fg = nord.nord4, bg = nord.nord2 },
	-- Status line
	StatusLine = { fg = nord.nord0, bg = nord.nord0 },
	StatusLineNC = { link = "StatusLine" },
	StatusLineTerm = { link = "StatusLine" },
	StatusLineTermNC = { link = "StatusLine" },
	-- cmp
	CmpItemKind = { fg = nord.nord0, bg = nord.nord9 },
	CmpItemAbbrMatch = { fg = nord.nord5 },
	CmpItemMenu = { fg = nord.nord9, opts = "italic" },
	PmenuSel = { fg = "NONE", bg = nord.nord3, opts = "underline" },
	-- Barbar
	BufferTabpageFill = { bg = nord.nord0 },

	BufferCurrent = { bg = nord.nord1 },
	BufferCurrentMod = { bg = nord.nord1, fg = nord.nord15 },
	BufferCurrentIcon = { bg = nord.nord1 },
	BufferCurrentSign = { bg = nord.nord1 },
	BufferCurrentIndex = { bg = nord.nord1 },
	BufferCurrentTarget = { bg = nord.nord1, fg = nord.nord11 },

	BufferInactive = { bg = nord.nord0, fg = nord.nord3_bright },
	BufferInactiveMod = { bg = nord.nord0, fg = nord.nord15 },
	BufferInactiveIcon = { bg = nord.nord0, fg = nord.nord3_bright },
	BufferInactiveSign = { bg = nord.nord0, fg = nord.nord3_bright },
	BufferInactiveIndex = { bg = nord.nord0, fg = nord.nord3_bright },
	BufferInactiveTarget = { bg = nord.nord0, fg = nord.nord11 },

	BufferVisible = { bg = nord.nord2 },
	BufferVisibleMod = { bg = nord.nord2, fg = nord.nord15 },
	BufferVisibleIcon = { bg = nord.nord2 },
	BufferVisibleSign = { bg = nord.nord2 },
	BufferVisibleIndex = { bg = nord.nord2 },
	BufferVisibleTarget = { bg = nord.nord2, fg = nord.nord11 },
	-- Lightspeed
	LightspeedLabel = { fg = nord.nord8, opts = "bold" },
	LightspeedLabelOverlapped = { fg = nord.nord8, opts = "bold,underline" },
	LightspeedLabelDistant = { fg = nord.nord15, opts = "bold" },
	LightspeedLabelDistantOverlapped = { fg = nord.nord15, opts = "bold,underline" },
	LightspeedShortcut = { fg = nord.nord10, opts = "bold" },
	LightspeedShortcutOverlapped = { fg = nord.nord10, opts = "bold,underline" },
	LightspeedMaskedChar = { fg = nord.nord4, bg = nord.nord2, opts = "bold" },
	LightspeedGreyWash = { fg = nord.nord3_bright },
	LightspeedUnlabeledMatch = { fg = nord.nord4, bg = nord.nord1 },
	LightspeedOneCharMatch = { fg = nord.nord8, opts = "bold,reverse" },
	LightspeedUniqueChar = { opts = "bold,underline" },
	-- Lightbulb
	LightBulbVirtualText = { fg = nord.nord13, opts = "bold" },
	-- cokeline
	TabLineFill = { bg = nord.nord0 },
	-- nvim-notify
	NotifyDEBUGBorder = { fg = nord.nord3 },
	NotifyDEBUGIcon = { fg = nord.nord3 },
	NotifyDEBUGTitle = { fg = nord.nord3 },
	NotifyERRORBorder = { fg = nord.nord11 },
	NotifyERRORIcon = { fg = nord.nord11 },
	NotifyERRORTitle = { fg = nord.nord11 },
	NotifyINFOBorder = { fg = nord.nord14 },
	NotifyINFOIcon = { fg = nord.nord14 },
	NotifyINFOTitle = { fg = nord.nord14 },
	NotifyTRACEBorder = { fg = nord.nord15 },
	NotifyTRACEIcon = { fg = nord.nord15 },
	NotifyTRACETitle = { fg = nord.nord15 },
	NotifyWARNBorder = { fg = nord.nord13 },
	NotifyWARNIcon = { fg = nord.nord13 },
	NotifyWARNTitle = { fg = nord.nord13 },
}

for k, v in pairs(highlights) do
	local command = "hi " .. k .. " "
	if v.link ~= nil then
		command = "hi link " .. k .. " " .. v.link
	else
		if v.fg ~= nil then
			if type(v.fg) == "string" then
				command = command .. "guifg=" .. v.fg .. " ctermfg=" .. v.fg .. " "
			else
				command = command .. "guifg=" .. v.fg.gui .. " ctermfg=" .. v.fg.term .. " "
			end
		end

		if v.bg ~= nil then
			if type(v.bg) == "string" then
				command = command .. "guibg=" .. v.bg .. " ctermbg=" .. v.bg .. " "
			else
				command = command .. "guibg=" .. v.bg.gui .. " ctermbg=" .. v.bg.term .. " "
			end
		end

		if v.opts ~= nil then
			command = command .. "cterm=" .. v.opts .. " gui=" .. v.opts
		end
	end
	vim.api.nvim_command(command)
end
