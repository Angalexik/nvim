(import-macros {: augroup!} :macros)

(augroup! [:config-filetypes &clear]
  ; Allow JSON comments
  (au! :FileType "json" #(set vim.bo.filetype :jsonc))

  (au! :FileType ["jsonc" "kerboscript"] #(set vim.bo.commentstring "// %s"))

  ; Apparently treesitter has to be started on the FileType event
  (au! :FileType "*" #(pcall vim.treesitter.start)))

(augroup! [:config-misc &clear]
  (au! :TermClose "*" #(if (= vim.v.event.status 0)
                           (do
                             (vim.api.nvim_buf_delete 0 {})
                             (vim.notify_once "Previous terminal job was successful!"))
                           (vim.notify_once "Error code detected in the current terminal job!")))
  (au! :CursorMoved "*" #(if (and (= vim.v.hlsearch 1)
                                  (= (. (vim.fn.searchcount) :exact_match) 0))
                             (vim.schedule #(vim.cmd.nohlsearch)))))
