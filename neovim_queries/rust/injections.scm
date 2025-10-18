; extends

(call_expression
  function: (scoped_identifier
              path: (identifier) @_sqlx
              (#eq? @_sqlx "sqlx")
              name: (identifier) @_query
              (#eq? @_query "query"))
  arguments: (arguments
               (string_literal
                 (string_content) @injection.content))
  (#set! injection.language "sql"))
