(fn set! [name ?value]
  (let [name-string (tostring name)
        starts-with-no (= (name-string:sub 1 2) "no")
        has-value (not= ?value nil)
        possible-fn (or (list? ?value)
                        (sym? ?value)
                        (varg? ?value)
                        (multi-sym? ?value))
        name (if (and starts-with-no (not has-value))
                 (name-string:sub 3)
                 name-string)]
    (if possible-fn
        `(let [v# ,?value ; to not evalute the value twice
               fname# ,(tostring (gensym "__set_fn"))]
           (if (= (type v#) "function")
               (do
                 (tset _G fname# v#)
                 (tset vim.opt ,name (.. "v:lua." fname# "()")))
               (tset vim.opt ,name v#)))
        has-value
        `(tset vim.opt ,name ,?value)
        starts-with-no
        `(tset vim.opt ,name false)
        `(tset vim.opt ,name true))))

{: set!}
