; vim: ft=query
; extends

(call_expression
  function: (scoped_identifier
              path: (identifier) @_sqlx
              (#eq? @_sqlx "sqlx")
              name: (identifier) @_query
              (#any-of? @_query "query" "query_all" "query_scalar"))
  arguments: (arguments
               (string_literal
                 (string_content) @injection.content))
  (#set! injection.language "sql"))

(call_expression
  function: (generic_function
              function: (scoped_identifier
                          path: (identifier) @_sqlx
                          (#eq? @_sqlx "sqlx")
                          name: (identifier) @_query
                          (#any-of? @_query "query_as")))
  arguments: (arguments
               (string_literal
                 (string_content) @injection.content))
  (#set! injection.language "sql"))
