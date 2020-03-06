if exists('b:current_syntax')
  let s:current_syntax = b:current_syntax
  silent! unlet b:current_syntax
endif

syntax include @JSSyntax syntax/javascript.vim
silent! unlet b:current_syntax
syntax include @XMLSyntax syntax/xml.vim
silent! unlet b:current_syntax
syntax include @CSSSyntax syntax/css.vim
silent! unlet b:current_syntax

if exists('s:current_syntax')
  let b:current_syntax = s:current_syntax
endif

syntax keyword mintBlock
      \ do sequence parallel if else case try catch

syntax keyword mintCompoundType
      \ Result Maybe Promise Array

syntax keyword mintLiteralType
      \ Number Bool String Object Time Html Void Never

syntax keyword mintDeclarator
      \ enum component module record routes provider store

syntax keyword mintInitializer
      \ fun let where next state property

syntax keyword mintKeyword
      \ decode encode return connect use

syntax keyword mintOperator
      \ "<{ }>" "::" "=>" "|>" "<|"

syntax keyword mintSpecifier
      \ as break return using get exposing ok error just nothing void

" String
syntax region mintString start=/"/ skip=/\\"/ end=/"/ oneline contains=mintInteroplatedWrapper
" String interpolation
syntax region mintInterpolatedWrapper start="#{" end="}" contained containedin=mintString contains=mintInterpolation
syntax region mintInterpolation start="#{" end="}" contained contains=@mintAll

" Numbers
syntax match mintNumber "\v<\d+>"
syntax match mintNumber "\v<\d+\.\d+>"

" Pascal-cased types
syntax match mintDefinedType "\v[A-Z][A-Za-z0-9]*(\.[A-Z][A-Za-z0-9]*)*" contained
syntax cluster mintType contains=mintLiteralType,mintDefinedType,mintCompoundType

syntax match mintIdentifier "\w+"

" Colour links
hi link mintBlock        Statement
hi link mintDeclarator   Structure
hi link mintStyle        Structure
hi link mintInitializer  Statement
hi link mintKeyword      Keyword
hi link mintType         Type
hi link mintOperator     Operator
hi link mintSpecifier    Statement
hi link mintString       String
hi link mintNumber       Number

syntax cluster mintAll contains=mintBlock,mintCompoundType,mintDeclarator,mintInitializer,mintKeyword,mintOperator,mintSpecifier,mintString

syntax region mintEmbeddedHtmlRegion
      \ start=+<\z([^ /!?<>"'=:]\+\)+
      \ start=+<\z(\s\{0}\)>+
      \ skip=+<!--\_.\{-}-->+
      \ end=+</\z1\_s\{-}>+
      \ end=+/>+
      \ fold
      \ contains=@Spell,@XMLSyntax
      \ keepend

syntax match mintJsInterpolationQuotes /[{}]/
syntax region mintEmbeddedJsRegion
      \ start="`"
      \ end="`"
      \ keepend
      \ matchgroup=mintJsInterpolationQuotes
      \ contains=mintInterpolation,@jsExpression,ALLBUT,jsTemplateString

"syntax region mintEmbeddedStyle
"      \ start="style {"
"      \ start="style [^}]\+{"
"      \ end="}"
"      \ contains=@mintAll,@CSSSyntax
"      \ fold

syntax match mintBraces /[{}]/
syntax keyword mintStyleKeyword style nexgroup=mintStyleIdentifier skipwhite nextgroup=mintStyleIdentifier
syntax match mintStyleIdentifier /\<\k\k*/ contained skipwhite skipempty nextgroup=mintStyleBlock
syntax region mintStyleBlock contained matchgroup=mintBraces start="{" end="}" contains=@mintAll,cssDefinition,cssTagName,cssAttributeSelector,cssClassName,cssIdentifier,cssAtRule,cssAttrRegion,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssCustomProp,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape,cssVendor,cssDefinition,cssHacks,cssNoise

hi link mintStyleKeyword Structure

"syntax region mintEmbeddedCssRegion
"      \ start="[^}]\+{"
"      \ end=+}+
"      \ fold
"      \ contains=@CSSSyntax,cssDefinition,@Spell,@XMLSyntax


