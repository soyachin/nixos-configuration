; Neovim treesitter highlight queries para RDF Turtle
; Basado en GordianDziwis/tree-sitter-turtle (grammar.js)
; El repo no incluye queries/ → este archivo las suple.

; ── Comentarios ─────────────────────────────────────────────────────────────
(comment) @comment

; ── Directivas @prefix / @base ───────────────────────────────────────────────
"@prefix" @keyword.directive
"@base"   @keyword.directive

; SPARQL-style (case-insensitive PREFIX / BASE)
; toCaseInsensitive() genera anonymous tokens — capturamos el nodo completo
; como fallback (el namespace e IRI recibirán sus propios colores encima)
(sparql_prefix) @keyword.directive
(sparql_base)   @keyword.directive

; ── Namespaces y nombres prefijados ──────────────────────────────────────────
; e.g.  trama:  owl:  rdfs:  xsd:
(namespace)  @module

; parte local del prefixed name → e.g. :Club  :subClassOf
(pn_local)   @variable

; ── IRIs  <https://...> ──────────────────────────────────────────────────────
(iri_reference) @string.special

; ── La 'a' de rdf:type ───────────────────────────────────────────────────────
(predicate "a") @keyword.operator

; ── Literales de cadena ──────────────────────────────────────────────────────
(string) @string

; secuencias de escape dentro de strings
(echar) @string.escape

; datatype separator  ^^
"^^" @punctuation.special

; language tag  @en  @es  @fr  ...
(lang_tag) @attribute

; ── Literales numéricos ───────────────────────────────────────────────────────
(integer) @number
(decimal) @number.float
(double)  @number.float

; ── Booleanos ────────────────────────────────────────────────────────────────
(boolean_literal) @boolean

; ── Blank nodes ──────────────────────────────────────────────────────────────
(blank_node_label) @variable.builtin
(anon)             @variable.builtin

; ── Puntuación ───────────────────────────────────────────────────────────────
"." @punctuation.delimiter
";" @punctuation.delimiter
"," @punctuation.delimiter

"[" @punctuation.bracket
"]" @punctuation.bracket
"(" @punctuation.bracket
")" @punctuation.bracket
