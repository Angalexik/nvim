(local nord0 "#2e3440")
(local nord3 "#4c566a")
(local nord3-bright "#616e88")
(local nord4 "#d8dee9")
(local nord9 "#81a1c1")
(local nord11 "#bf616a")
(local nord12 "#d08770")
(local nord15 "#b48ead")

(local mappings (require :cokeline/mappings))

(fn picking []
  (or (mappings.is_picking_close) (mappings.is_picking_focus)))

(fn tabcount []
  (# (vim.api.nvim_list_tabpages)))

(fn showTabs? []
  (> (tabcount) 1))

(fn currentTab []
  (let [handle (vim.api.nvim_get_current_tabpage)]
    (accumulate [idx nil
                 i t (ipairs (vim.api.nvim_list_tabpages))]
      (if (= handle t)
        i
        idx))))

{:components [{:text #(if $.is_focused
                        ""
                        " ")
               :fg #(if $.is_modified
                        nord15
                        nord9)
               :bg nord0}
              {:text #(if (and (picking) (not $.is_focused))
                          (.. $.pick_letter " ")
                          $.devicon.icon)
               :fg #(if (and (picking) (not $.is_focused))
                        nord11)
               :style #(if (picking)
                           "bold")}
              {:text #$.unique_prefix
               :fg nord3-bright}
              {:text #(.. $.filename " ")}
              {:text #(if $.is_modified
                          "●"
                          "")
               :delete_buffer_on_left_click true}
              {:text #(if $.is_focused
                        ""
                        " ")
               :fg #(if $.is_modified
                        nord15
                        nord9)
               :bg nord0}]
 :rhs [{:text #(if (showTabs?)
                 ""
                 "")
        :bg nord0
        :fg nord12}
       {:text #(if (showTabs?)
                 "󰓩 "
                 "")
        :bg nord12
        :fg nord0}
       {:text #(if (showTabs?)
                  (.. " " (currentTab) "/" (tabcount))
                  "")
        :bg nord3}
       {:text #(if (showTabs?)
                 ""
                 "")
        :bg nord0
        :fg nord3}]
 :default_hl {:fg #(if $.is_focused
                       nord0
                       $.is_modified
                       nord15
                       nord4)
              :bg #(if (and $.is_focused $.is_modified)
                       nord15
                       $.is_focused
                       nord9
                       nord0)}}
