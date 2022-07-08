local cmp = require('cmp')

local symbol_map = {
	Text = '',
	Method = '',
	Function = '',
	Constructor = '',
	Field = "ﰠ",
	Variable = '',
	Class = 'פּ',
	Interface = 'ﰮ',
	Module = '',
	Property = '襁',
	Unit = '',
	Value = '',
	Enum = '',
	Keyword = '',
	Snippet = '﬌',
	Color = '',
	File = '',
	Reference = "",
	Folder = '',
	EnumMember = '',
	Constant = '',
	Struct = '',
	Event = "",
	Operator = "",
	TypeParameter = "",
}

cmp.setup({
	window = {
		completion = {
			col_offset = -3,
			side_padding = 0,
		},
	},
	snippet = {
		expand = function(args)
			vim.fn['vsnip#anonymous'](args.body)
		end,
	},
	formatting = {
		fields = {"kind", "abbr", "menu"},
		format = function (entry, vim_item)
			vim_item.menu = "(" .. vim_item.kind .. ")"
			vim_item.kind = " " .. symbol_map[vim_item.kind] .. " "
			return vim_item
		end
	},
	mapping = {
		['<Plug>(cmp-next)'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		['<Plug>(cmp-prev)'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
		{ name = 'buffer' },
		{ name = 'path' },
	}
})

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
		return true
	else
		return false
	end
end

_G.tab_complete = function()
	if cmp and cmp.visible() then
		return t '<Plug>(cmp-next)'
	elseif vim.fn.call('vsnip#available', {1}) == 1 then
		return t('<Plug>(vsnip-expand-or-jump)')
	elseif check_back_space() then
		return t '<Tab>'
	end
	return ''
end

_G.s_tab_complete = function()
	if cmp and cmp.visible() then
		return t '<Plug>(cmp-prev)'
	elseif vim.fn.call('vsnip#jumpable', {-1}) == 1 then
		return t('<Plug>(vsnip-jump-prev)')
	else
		return t '<S-Tab>'
	end
	return ''
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
