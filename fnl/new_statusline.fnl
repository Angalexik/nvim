(local vfn vim.fn)
(local bo vim.bo)
(local lsp vim.lsp)
(local api vim.api)
(local diag vim.diagnostic)

(local add-provider (. (require :feline.providers) "add_provider"))
(local cursor (require :feline.providers.cursor))
(local lsp-provider (require :feline.providers.lsp))
(local feline (require :feline))

; (local components {"left" {"active" {}
;                            "inactive" {}}
;                    "mid" {"active" {}
;                           "inactive" {}}
;                    "right" {"active" {}
;                             "inactive" {}}})

(local components {"active" [{} ; active left
                             {} ; active mid
                             {}] ; active right
                   "inactive" [{} ; inactive left
                               {} ; inactive mid
                               {}]}) ; inactive right

(fn left [component]
  (table.insert (. components.active 1) component))

(fn mid [component]
  (table.insert (. components.active 2) component))

(fn right [component]
  (table.insert (. components.active 3) component))

(fn left-in [component]
  (table.insert (. components.inactive 1) component))

(fn mid-in [component]
  (table.insert (. components.inactive 2) component))

(fn right-in [component]
  (table.insert (. components.inactive 3) component))

(local modecols {"N" "nord8"
                 "T" "nord8"
                 "!" "nord8"
                 "V" "nord7"
                 "C" "nord12"
                 "I" "nord14"
                 "R" "nord14"
                 "S" "nord14"})

(local statuscols {"running" "nord15"
                   "success" "nord14"
                   "failure" "nord11"})

(local error-severity diag.severity.ERROR)
(local warn-severity diag.severity.WARN)
(local info-severity diag.severity.INFO)
(local hint-severity diag.severity.HINT)

(fn vimode []
  (string.upper (string.gsub (string.gsub (string.sub (vfn.mode) 1 1)
                                          "" "V")
                            "" "S")))

(fn vimode-colour []
  (. modecols (vimode)))

(fn showgit []
  (and (not= vim.b.gitsigns_status nil) (> (length vim.b.gitsigns_status) 0)))

(fn insert-separators [list sep]
  (let [out []]
    (each [i elem (ipairs list)]
      (if (= i 1)
          (table.insert out elem)
          (do (table.insert out sep)
              (table.insert out elem))))
    out))

(fn git-padding [additions]
  (var num 0)
  (let [signs vim.b.gitsigns_status_dict]
    (if additions
      (set num (+ signs.changed signs.removed))
      (set num signs.removed)))
  (if (> num 0)
    " "
    ""))

(fn file-icon []
  ((. (require :nvim-web-devicons) "get_icon") (vfn.expand "%:t") ; file name
                                               (vfn.expand "%:e") ; file extension
                                               {"default" true}))

(fn file-name-base [short]
  (var name (vfn.fnamemodify (vfn.expand "%")
                             (if short
                               ":t"
                               ":~:.")))
  (set name (if (or (= "" name) (= nil name))
              "[No File]"
              name))
  (let [modified (if (api.nvim_buf_get_option 0 "modified")
                   " [+]"
                   "")]
    (if (and short (not= name "[No File]"))
      (.. "</" name modified)
      (.. name modified))))

(fn file-name []
  (file-name-base false))

(fn short-file-name []
  (file-name-base true))

(fn diagnostics-count [severity]
  (lsp-provider.get_diagnostics_count severity))

(fn diagnostic-padding [severity]
  (if (if (= severity error-severity)
        (or (> (diagnostics-count warn-severity) 0)
            (> (diagnostics-count info-severity) 0)
            (> (diagnostics-count hint-severity) 0))
        (= severity warn-severity)
        (or (> (diagnostics-count info-severity) 0)
            (> (diagnostics-count hint-severity) 0))
        (> (diagnostics-count hint-severity) 0))
    " "
    ""))

(fn cursorpos []
  (let [pos (api.nvim_win_get_cursor 0)]
    (.. (. pos 1) ":" (+ (. pos 2) 1))))

(fn show-diag []
  (or (> (diagnostics-count error-severity) 0)
      (> (diagnostics-count warn-severity) 0)
      (> (diagnostics-count info-severity) 0)
      (> (diagnostics-count hint-severity) 0)))

;; Vim mode
(left {"provider" vimode
       "hl" #{"fg" "bg"
              "bg" (vimode-colour)
              "style" "bold"}
       "left_sep" "left_rounded"
       "right_sep" #{"str" " "
                     "hl" {"bg" (vimode-colour)}}})

;; File name
(let [component #{"provider" file-name
                  "short_provider" short-file-name
                  "hl" {"bg" "bg1"}
                  "right_sep" ["right_rounded" " "]
                  "left_sep" (if $1
                               {"str" " "
                                "hl" {"bg" "bg1"}}
                               {"str" "left_rounded"})}]
  (left (component true))
  (left-in (component false)))

;; Git block
(left {"provider" #(let [signs vim.b.gitsigns_status_dict
                         added signs.added
                         changed signs.changed
                         removed signs.removed
                         columns []]
                     (when (> added 0)
                       (table.insert columns
                                     {:str (.. "+" added)
                                      :hl {"fg" "nord14"}}))
                     (when (> changed 0)
                       (table.insert columns
                                     {:str (.. "~" changed)
                                      :hl {"fg" "nord13"}}))
                     (when (> removed 0)
                       (table.insert columns
                                     {:str (.. "-" removed)
                                      :hl {"fg" "nord11"}}))
                     (insert-separators columns " "))
       "enabled" showgit
       "truncate_hide" true
       "hl" {"bg" "bg1"}
       "left_sep" "left_rounded"
       "right_sep" "right_rounded"})

(right {"provider" #(let [register (vfn.reg_recording)]
                      (if (not= register "")
                        (.. " Recording @" register)
                        ""))
        "hl" {"bg" "bg1"}
        "left_sep" {"str" "left_rounded"
                    "hl" {"fg" "nord11"}}
        "right_sep" "right_rounded"
        "icon" {"str" "綠"
                "hl" {"bg" "nord11"
                      "fg" "bg"}}})

(right {"provider" #(if (and (not= vim.g.asyncrun_status nil)
                             (not= vim.g.asyncrun_status ""))
                      " AsyncRun"
                      "")
        "truncate_hide" true
        "priority" 0
        "hl" {"bg" "bg1"}
        "left_sep" #{"str" "left_rounded"
                     "hl" {"fg" (. statuscols vim.g.asyncrun_status)}}
        "right_sep" "right_rounded"
        "icon" #(let [icon (match vim.g.asyncrun_status
                             "running" "省"
                             "success" "﫠"
                             "failure" " ")]
                  {"str" icon
                   "hl" {"fg" "bg"
                         "bg" (. statuscols vim.g.asyncrun_status)}})})
;; File type
(let [component {"provider" #(.. " " bo.filetype)
                 "truncate_hide" true
                 "priority" 1
                 "enabled" #(and bo.filetype
                                   (not= bo.filetype ""))
                 "hl" {"bg" "bg1"}
                 "left_sep" [" " {"str" "left_rounded"
                                  "hl" {"fg" "nord9"}}]
                 "right_sep" "right_rounded"
                 "icon" #{"str" (.. (file-icon) " ")
                          "hl" {"bg" "nord9"
                                "fg" "bg"}}}]
  (right component)
  (right-in component))

;; Words per minute
(right {"provider" #(.. " " ((. (require "wpm") "wpm")) " WPM")
        "hl" {"bg" "bg1"
              "fg" "nord9"}
        "truncate_hide" true
        "priority" -1
        "left_sep" [" " {"str" "left_rounded"
                         "hl" {"fg" "nord9"}}]
        "right_sep" "right_rounded"
        "icon" {"str" " "
                "hl" {"bg" "nord9"
                      "fg" "bg"}}})

;; Position
(right {"provider" #(let [percentage (cursor.line_percentage nil {:padding true})]
                      (.. " " (cursorpos) " " percentage "/" (vfn.line "$")))
        "short_provider" #(.. " " (cursorpos))
        "hl" {"bg" "bg1"
              "fg" "nord9"}
        "left_sep" [" " {"str" "left_rounded"
                         "hl" {"fg" "nord9"}}]
        "right_sep" "right_rounded"
        "icon" {"str" " "
                "hl" {"bg" "nord9"
                      "fg" "bg"}}})

;; Diagnostics block
(let [component
      {"provider" #(let [errors (diagnostics-count error-severity)
                         warnings (diagnostics-count warn-severity)
                         informations (diagnostics-count info-severity)
                         hints (diagnostics-count hint-severity)
                         columns []]
                     (when (> errors 0)
                       (table.insert columns
                                     {:str (.. "E:" errors)
                                      :hl {"fg" "nord11"}}))
                     (when (> warnings 0)
                       (table.insert columns
                                     {:str (.. "W:" warnings)
                                      :hl {"fg" "nord13"}}))
                     (when (> informations 0)
                       (table.insert columns
                                     {:str (.. "I:" informations)
                                      :hl {"fg" "nord8"}}))
                     (when (> hints 0)
                       (table.insert columns
                                     {:str (.. "H:" hints)
                                      :hl {"fg" "nord10"}}))
                     (insert-separators columns " "))
       "enabled" show-diag
       "truncate_hide" true
       "priority" 2
       "hl" {"bg" "bg1"}
       "left_sep" [" " "left_rounded"]
       "right_sep" "right_rounded"}]
  (right component)
  (right-in component))

(let [theme {"fg" "#d8dee9"
             "bg" "#2e3440"
             "bg1" "#4c566a"
             "nord7" "#8fbcbb"
             "nord8" "#88c0d0"
             "nord9" "#81a1c1"
             "nord10" "#5e81ac"
             "nord11" "#bf616a"
             "nord12" "#d08770"
             "nord13" "#ebcb8b"
             "nord14" "#a3be8c"
             "nord15" "#b48ead"}]
  (feline.setup {"components" components
                 "theme" theme
                 "custom_providers" {"left_rounded" #""
                                     "right_rounded" #""}
                 "force_inactive" {"filetypes" ["^help$"
                                                "^alpha$"
                                                "^oil$"
                                                "^qf$"
                                                "^fugitive$"
                                                "^fugitiveblame$"]
                                   "buftypes" ["^terminal$"]}}))
