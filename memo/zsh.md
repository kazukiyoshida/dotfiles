### typeset command

zsh の build in command.
関数の中で変数のスコープを宣言できる.
```
local v       # ローカル変数 v
typeset v     # ローカル変数 v（上と同じ）
typeset -g v  # グローバル変数 v
```

typeset -U で配列の重複を防ぐことができる.
For arrays (but not for associative arrays), 
keep only the first occurrence of each duplicated value
e.g. ‘typeset -U PATH path’.
cf. https://zsh.sourceforge.io/Doc/Release/Shell-Builtin-Commands.html


### Zsh の path, PATH

zsh では配列の変数として $path が定義されている.
個の配列は、zsh の機能により $PATH と常に同期するようになっている.
https://unix.stackexchange.com/questions/532148/what-is-the-difference-between-path-and-path-lowercase-versus-uppercase-with

以下のように typeset -U で配列の重複を防ぐことで、PATH の重複を防ぐことができる.
typeset -U path
