-- Take any extra USB device (keyboard, keypad, etc) and re-assign its keys.
--
-- This uses LuaMacros:
--   website:      http://www.hidmacros.eu/
--   forum:        http://www.hidmacros.eu/forum/
--   download:     http://www.hidmacros.eu/luamacros.zip
--   source code:  https://github.com/me2d13/luamacros/
--
-- See also:
--   https://blog.spiralofhope.com/?p=40598
--   https://blog.spiralofhope.com/?p=41108



-- a) Get LuaMacros.
-- b) Unzip LuaMacros.
-- c) Run LuaMacros.exe.
-- d) Copy this whole script into its editor.
-- e) Read the instructions you just pasted.



-- 1) Edit the below line and name your device anything you want.
usb_device_name_1='hfsecurity Triple Foot Switch'
-- 2) Learn the unique identifier for your device.
-- 3) Unplug your device.
-- 4) Unplug any non-essential USB devices.
-- 5) Run this script.
--    At the top of this window is a triangle pointing to the right.
-- 6) Press any key on your device.
--    (Do not press a key on your regular keyboard)
-- 7) Plug in your device.
-- 8) Run this script.
--    At the top of this window is a triangle pointing to the right.
-- 9) Press any key on your device.
--    (Do not press a key on your regular keyboard)
-- 10) In the bottom window is a lot of code.  Compare the "before" and "after" lists.  One of those strings will be new when you plug in your device.  For example:
--     <unassigned>  :  \\?\HID#VID_0426&PID_3011&MI_00&COL01#8&A377D60&0&0000#{884B96C3-56EF-11D1-BC8C-00A0C91405DD} [85132629] :  keyboard
--     You can un-plug and re-plug your device and run this script as much as you want until you find your string.
-- 11) Look at the above string, Learn your usb_device_code.  For example, the above is "A377D60".  Look carefully, in that same place, for your own code.  It is between "#8&" and "&0&0000".
--     Edit the following line:
       usb_device_code_1='A377D60'
--     (Note:  Every time Windows goes through the "setting up" process for this device, you will need to determine your usb_device_code again.)



print( '-------------' )
lmc_print_devices()
print( '-------------' )



-- The following was tested for the:
--   HFSECURITY Triple Foot Switch Pedal Usb Gaming Keyboard Wired Non Slip Metal Momentary Electric Power Foot Switch
--   https://www.aliexpress.com/item/32843799982.html
--
lmc_device_set_name( usb_device_name_1, usb_device_code_1 )
lmc_set_handler(     usb_device_name_1, function( button, direction )
  -- If you.. (a) want to only trigger the macro on button-up (releasing it)
  --    and.. (b) not repeat the macro when holding the key down
  --    then change direction to 1:
  -- Some devices can be made to only trigger once when you press and hold the key.
  --   For example, the "HFSECURITY Triple Foot Switch Pedal" has the software "Usbhid Keybhoard 3.0 Designed by JC" which I would use instead of LuaMacros.
  if ( direction == 0 ) then return end
  is_button_code_assigned = true

-- 12) Create a list.
--     (This gets a little complicated, but be patient.)
--     For each key on your device:
--       12a) Write down the name of the key you will press.
--       12b) Press that key.
--         For example, if I press "1" on my keypad, the bottom of LuaMacros will say something like:
--           "The key you pressed has the button code 97 and it has not been assigned."
--       12c) Write that number down.
--     So this means I know two things.  The key "1" and the button code "97".
--     Do steps 12a, 12b and 12c for every key on your device.  Make a complete list.
--     (Note:  There may be keys which act funny, like they are pressed many times in a row (like a numpad's "000" key), or they appear as two codes.  Assigning these is for advanced users, and I do not give instructions here.)
--     (Note:  Some keys will not give a code at all, and cannot be assigned in this way.  An example is a numpad's "Num Lock" key.)
-- 13) Customize the script below.
--     For each key in the list you made in step 12:
--       a) Change the end "print" string with the name of the button that you used on step 12a.
--       b) Change the number for "button".  This is the button code that you learned on step 12c.
--       c) Decide on the keystroke to send to your computer, when you press that key.  Change the text for "lmc_send_keys" below.
--          ^  is  <control>
--          %  is  <alt>
--          +  is  <shift>
--          #  is  <win>
--          >  is  using the right-side modifier.
--                 e.g.  ^>  is <right-control>
--          An item between the curley braces { and } is the name of the key to send.
--            Documentation: https://github.com/me2d13/luamacros/wiki/List-of-Keys
--            You can also look at the source code at https://github.com/me2d13/luamacros/blob/master/src/uSendKeys.pas under "SendKeyRecs".
--     (Note:  Duplicate the line with "elseif" to make more, if you have more keys to add.)
--     (Note:  Be sure to keep the first item with "if".  Do not accidentally change it to "elseif")
--     Once you have built your list, continue to step 14.
--
--
-- Customize below
--                  (12a)                      (12c)                    (12b)
  if     ( button == 49 ) then   lmc_send_keys( '^>%#{F13}', 50 )   key='left pedal'
  elseif ( button == 50 ) then   lmc_send_keys( '^>%#{F14}', 50 )   key='middle pedal'
  elseif ( button == 51 ) then   lmc_send_keys( '^>%#{F15}', 50 )   key='right pedal'
--                  (12a)                      (12c)                    (12b)
-- Customize above
--
  else
    is_button_code_assigned=false
    key=''
  end
  if key ~= '' then
    print( 'The key you pressed has the button code ' .. button .. ' and is the ' .. key .. '.' )
  end
end)  --  lmc_set_handler
--
-- 14) Decide if you want to have LuaMacros automatically minimize to the tray when you run this script.
--     If you do, then you can remove the "--" from the beginning of lmc_minimize() below:
lmc.minimizeToTray = true
--lmc_minimize()
-- 15) Save your script with Control-s.
-- 16) Run this script.
--     At the top of this window is a triangle pointing to the right.
-- 17) Make a shortcut to easily run this script with LuaMacros
--     In Windows explorer:
--        a) Right-click in an empty space
--        b) New > Shortcut
--        c) Make it something like "C:\CUSTOMIZE\LuaMacros.exe" "C:\CUSTOMIZE\key remapping.lua"
--           Change "CUSTOMIZE" to the appropriate path.
-- 18) You are now done!
--     From now on, you can use the shortcut to start LuaMacros with this script loaded, and run this script using the triangle pointing to the right at the top of the LuaMacros window.



----------------------------------------
-- (Optional) Customize your software --
----------------------------------------


-- Unless you have LuaMacros output strings, you'll want to customize your software to use your device's new macros.
-- An example of customizing OBS Studio (https://obsproject.com/):
--   1. Start LuaMacros.
--   2. Run this script.
--      At the top of this window is a triangle pointing to the right.
--   3. Start OBS Studio.
--   4. File > Settings > Hotkeys
--   5. Click any of the items you wish to customize.
--   6. Press the key on your USB device
--      You will see the hotkey combination appear.  For example:
--        lmc_send_keys( '^>%#{F13}', 50 )
--        displays:
--        Control + Windows + Alt + OBS_KEY_F13
--   7. Click OK



-------------------------
-- (Optional) Advanced --
-------------------------


-- If you want to use additional devices, then you must do these things:
--   1. Copy the above code you were customizing.
--   2. Make usb_device_code something unique, like usb_device_code_2, and change that in two places.
--   3. Make usb_device_name something unique, like usb_device_name_2, and change that in three places
-- You can also perform more actions.  See:
--   https://github.com/me2d13/luamacros/wiki/Basic-Functions
-- Remember that this is the LUA programming language:
--   https://www.lua.org/
--   LuaMacros is using 5.2, determined with:  print( _VERSION )
--   Lua 5.2 documentation:  https://www.lua.org/manual/5.2/manual.html
--   See also http://lua-users.org/



--
-- This is for my generic usb keypad:
--
-- <unassigned>  :  \\?\HID#VID_13BA&PID_0001#8&5C15E41&0&0000#{884B96C3-56EF-11D1-BC8C-00A0C91405DD} [772079993] :  keyboard
--
usb_device_code_2='5C15E41'
usb_device_name_2='usb number pad'
lmc_device_set_name( usb_device_name_2, usb_device_code_2 )
lmc_set_handler(     usb_device_name_2, function( button, direction )
  if ( direction == 0 ) then return end
  -- This is getting triggered with numlock on.
  -- TODO - handle numlock-enabled items.
  if ( button == 144 ) then return end
  --  Note that <numlock> will not trigger a keystroke.
  -- ^  is  <control>
  -- %  is  <alt>
  -- +  is  <shift>
  -- #  is  <win>
  -- >  is  using the right-side modifier.
  --        e.g.  ^>  is <right-control>
  -- ^>%#  is  <control><right-alt><win>
  if     ( button == 111 ) then   lmc_send_keys( '^>%#{NUMDIVIDE}',   50 )   key='/'
  elseif ( button == 106 ) then   lmc_send_keys( '^>%#{NUMMULTIPLY}', 50 )   key='*'
  elseif ( button == 109 ) then   lmc_send_keys( '^>%#{NUMMINUS}',    50 )   key='-'
  elseif ( button == 103 ) then   lmc_send_keys( '^>%#{NUM7}',        50 )   key='7'
  elseif ( button == 104 ) then   lmc_send_keys( '^>%#{NUM8}',        50 )   key='8'
  elseif ( button == 105 ) then   lmc_send_keys( '^>%#{NUM9}',        50 )   key='9'
  elseif ( button == 107 ) then   lmc_send_keys( '^>%#{NUMPLUS}',     50 )   key='+'
  elseif ( button == 100 ) then   lmc_send_keys( '^>%#{NUM4}',        50 )   key='4'
  elseif ( button == 101 ) then   lmc_send_keys( '^>%#{NUM5}',        50 )   key='5'
  elseif ( button == 102 ) then   lmc_send_keys( '^>%#{NUM6}',        50 )   key='6'
  elseif ( button ==   8 ) then   lmc_send_keys( '^>%#{BACKSPACE}',   50 )   key='<backspace>'
  elseif ( button ==  97 ) then   lmc_send_keys( '^>%#{NUM1}',        50 )   key='1'
  elseif ( button ==  98 ) then   lmc_send_keys( '^>%#{NUM2}',        50 )   key='2'
  elseif ( button ==  99 ) then   lmc_send_keys( '^>%#{NUM3}',        50 )   key='3'
  elseif ( button ==  13 ) then   lmc_send_keys( '^>%#{ENTER}',       50 )   key='<enter>'
  elseif ( button ==  96 ) then   lmc_send_keys( '^>%#{NUM0}',        50 )   key='0'
  -- Note that '000' will just rapidly send '96'
  elseif ( button == 110 ) then   lmc_send_keys( '^>%#{NUMDECIMAL}',  50 )   key='.'
  else
    is_button_code_assigned=false
    key=''
  end
  if key ~= '' then
    print( 'The key you pressed has the button code ' .. button .. ' and is the ' .. key .. ' key.' )
  end
end)  --  lmc_set_handler



---------------------------------------------------
-- Ignore, and do not edit the rest of this file --
---------------------------------------------------


-- (Note:  This code is is taken from  https://github.com/me2d13/luamacros/blob/master/src/samples/quickstart.lua)
lmc_assign_keyboard( 'MACROS' )
lmc_set_handler(     'MACROS', function( button, direction )
  -- Immediately trigger the macro on downstroke (when the key is pressed).
  -- Does nothing when the key is released back up.
  -- Avoids duplicate keystroke registration.
  -- Enables press and hold behaviour.
  -- direction == 1 is the upstroke (when the is key released back up).
--  if ( direction == 0 ) then return end
  if is_button_code_assigned == false then
    print( 'The key you pressed has the button code ' .. button .. ' and it has not been assigned.' )
    return
  end
end)




-- TODO - Do not repeat keys when held down.  Check the time?
-- IDEA - Just cut the appropriate stuff out ot lmc_print_devices()
--        The problem is that it outputs content with escaped stuff, which doesn't neatly fit into a string if simply copy-pasted.  This doesn't seem worth attempting.

