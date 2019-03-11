-- Cached from LuaMacros
-- https://github.com/me2d13/luamacros/wiki/List-of-Keys



`lmc_send_keys()` sends a string of keys to the operating system. Here is how to write the string.
## Normal keys
In general, a character will send itself. For example, `abc` sends the keys `a`, then `b`, then `c`. To send modified keystrokes (such as holding shift, or ctrl), send special keys (such as F3), and more, see the rules below.

## Modifiers (shifts) for keystroke sequence
Use these keys to modify keystrokes. Foe example `+a` sends shift+a (in other words, `A`), `^c` sends ctrl+c. Use parenthesis to modify several keystrokes at once; `+(abc)` sends shift+a, shift+b, shift+c (`ABC`).
* `^` = Control  
* `%` = Alt
* `+` = Shift  
* `#` = Win
* `&` = Tab

## Left or Right modifiers for keystroke sequence
Keyboards usually have two copies of modifier keys, one on the left and one on the right. Use these when it matters which key is used.
* `<` = Left modifier key
  * `^<` = Left Control
  * `%<` = Left Alt
  * `+<` = Left Shift  
  * `#<` = Left Win
* `>` = Right modifier key (_Note: this does not work until Issue #7 is fixed_)
  * `^>` = Right Control
  * `%>` = Right Alt
  * `+>` = Right Shift  
  * `#>` = Right Win

## Special characters
* `~` = Enter Key
* `(` = Begin modifier group (see below)  
* `)` = End modifier group (see below)  
* `{` = Begin key name text (see below)  
* `}` = End key name text (see below)

## Modifier Grouping
Surround characters or key names with parentheses in order to modify them as a group.  
For example, `+abc` shifts only `a`, while `+(abc)` shifts all three characters.  


## Key Names
Refer to these keys by surrounding them with curly braces. For example, `{F3}` sends the F3 key.
* `BKSP`, `BS`, `BACKSPACE`
* `BREAK`
* `CAPSLOCK`
* `CLEAR`
* `DEL`
* `DELETE`
* `DOWN`
* `END`
* `ENTER`
* `ESC`
* `ESCAPE`
* `F1`, `F2`, `F3`, `F4`, `F5`, `F6`, `F7`, `F8`, `F9`, `F10`, `F11`, `F12`, `F13`, `F14`, `F15`, `F16`, `F17`, `F18`, `F19`, `F20`, `F21`, `F22`, `F23`, `F24`
* `HELP`
* `HOME`
* `INS`
* `LEFT`
* `NUM0`, `NUM1`, `NUM2`, `NUM3`, `NUM4`, `NUM5`, `NUM6`, `NUM7`, `NUM8`, `NUM9`
* `NUMDECIMAL`
* `NUMDIVIDE`
* `NUMLOCK`
* `NUMMINUS`
* `NUMMULTIPLY`
* `NUMPLUS`
* `PGDN`
* `PGUP`
* `PRTSC`
* `RIGHT`
* `SCROLLLOCK`
* `TAB`
* `UP`

## Repeating keys
Follow the keyname with a space and a number to send the specified key a given number of times  
e.g. `{left 6}` will send `left` six times
