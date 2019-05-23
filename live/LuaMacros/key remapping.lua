-- Take any extra USB device (keyboard, keypad, etc) and re-assign its keys.
-- This uses LuaMacros:
--   website:      http://www.hidmacros.eu/
--   forum:        http://www.hidmacros.eu/forum/
--   download:     http://www.hidmacros.eu/luamacros.zip
--   source code:  https://github.com/me2d13/luamacros/



-- 1) Edit the below line and name your device anything you want.
usb_device_name_1='hfsecurity Triple Foot Switch'
-- 2) Learn the unique identifier for your device.
-- 3) Unplug your device
-- 4) Run this script:  At the top of this window is a triangle pointing to the right.
--    Continue to step 5.
      lmc_print_devices()
-- 5) Press any key
-- 6) Plug in your device
-- 7) Unplug any non-essential USB devices.
-- 8) Run this script:  At the top of this window is a triangle pointing to the right.
-- 9) Press any key
--    (Do not click the "Cancel" button)
-- 10) In the bottom window is a lot of code.  Compare the "before" and "after" lists.  One of those strings will be new when you plug in your device.  For example:
--     <unassigned>  :  \\?\HID#VID_0426&PID_3011&MI_00&COL01#8&A377D60&0&0000#{884B96C3-56EF-11D1-BC8C-00A0C91405DD} [85132629] :  keyboard
--     You can un-plug and re-plug your device and run this script as much as you want until you find your string.
-- 11) Look at the above string, Learn your usb_device_code.  For example, the above is "A377D60".  Look carefully, in that same place, for your own code.  It is between "#8&" and "&0&0000".
--     Edit the following line:
       usb_device_code_1='A377D60'
--     ( Note:  Every time Windows goes through the "setting up" process for this device, you will need to determine your usb_device_code again. )
-- 12) Learn your list of keys.
--     12a) Write down the name of your key.  For example, on my keypad I would write the number "1".
--     12b) Press that key.  For example, I would press "1" on my keypad.
--     12c) Write down the number that appears in the bottom window of LuaMacros.  For example, when I press "1" on my keypad, LuaMacros shows "The key you pressed has the button code:  97".
--          So this means I know two things.  "1" and "97"
--     Do steps 11a, 11b and 11c for every key on your device.
--     ( Note:  There may be keys which act funny, like they are pressed many times in a row, they appear as two codes, or they do not give a code at all!  Assigning these is for advanced users, and I do not give instructions here. )
--     Once you have completed your list, continue to step 12.

--     ( Note:  This code is is taken from  https://github.com/me2d13/luamacros/blob/master/src/samples/quickstart.lua )
       lmc_assign_keyboard( 'MACROS' )
       lmc_set_handler(
         'MACROS',
         function( button, direction )
           if ( direction == 1 ) then return end
           print( 'The key you pressed has the button code:  ' .. button )
         end
       )

-- 13) Customize your script
--     (This gets a little complicated, but be patient.)
--     For each key in your list:
--       13a) Change the end "print" string with the name of the button that you used on step 12a.
--       13b) Change the number for "button".  This is the button code that you learned on step 12c.
--       13c) Decide on the keystroke to send to your computer, when you press that key.  Change the text for "lmc_send_keys" below.
--            ^%+#  is  <control><alt><shift><win>
--            >     is a reference to using the right-side modifier.  e.g.  ^>  is the right-side control key.
--            You can find the list at https://github.com/me2d13/luamacros/blob/master/src/uSendKeys.pas under "SendKeyRecs".

-- The following was tested for the:
--   HFSECURITY Triple Foot Switch Pedal Usb Gaming Keyboard Wired Non Slip Metal Momentary Electric Power Foot Switch
--   https://www.aliexpress.com/item/32843799982.html
--
lmc_device_set_name( usb_device_name_1, usb_device_code_1 )
lmc_set_handler(
  usb_device_name_1,
  function( button, direction )
    -- To change:      13a)                       13c)                     13b)
    if     ( button == 49 ) then  lmc_send_keys( '^>%#{F13}', 50 )  print( 'left' )
    elseif ( button == 50 ) then  lmc_send_keys( '^>%#{F14}', 50 )  print( 'middle' )
    elseif ( button == 51 ) then  lmc_send_keys( '^>%#{F15}', 50 )  print( 'right' )
    end
  end
)


-- 14) Once you have customized your script, then you can run this script:  At the top of this window is a triangle pointing to the right.
-- 15) Every program will have its own way to use hotkeys.  Maybe you have LuaMacros just send strings for your text editor.

-- An example of customizing OBS:
-- Launch it
-- File > Settings > Hotkeys
-- Click any of the items
-- Press the key on your usb device
-- You will see the hotkey combination appear.  For example, maybe:
--   lmc_send_keys( '^>%#{F13}', 50 )
--   displays:
--   Control + Windows + Alt + OBS_KEY_F13



-- If you want to use additional devices, then you must do these things:
--   1. Make usb_device_code something unique, like usb_device_code_2, and change that in two places.
--   2. Make usb_device_name something unique, like usb_device_name_2, and change that in three places
-- You can also perform more actions.  See:
--   https://github.com/me2d13/luamacros/wiki/Basic-Functions
-- Remember that this is the LUA programming language:
--   https://www.lua.org/
--   http://lua-users.org/
-- Below is a more complex example:



-- This is for a pretty generic usb keypad.
--
-- <unassigned>  :  \\?\HID#VID_13BA&PID_0001#8&5C15E41&0&0000#{884B96C3-56EF-11D1-BC8C-00A0C91405DD} [772079993] :  keyboard
--
usb_device_code_2='5C15E41'
usb_device_name_2='usb number pad'
lmc_device_set_name( usb_device_name_2, usb_device_code_2 )
lmc_set_handler(
  usb_device_name_2,
  function( button, direction )
    if ( direction == 1 ) then return end
    -- This is getting triggered with numlock on.
    -- TODO - handle numlock-enabled items.
    if ( button == 144 ) then return end
    --  Note that <numlock> will not trigger a keystroke.
    if     ( button == 111 ) then  lmc_send_keys( '^>%#{NUMDIVIDE}',   50 )  print( '/' )
    elseif ( button == 106 ) then  lmc_send_keys( '^>%#{NUMMULTIPLY}', 50 )  print( '*' )
    elseif ( button == 109 ) then  lmc_send_keys( '^>%#{NUMMINUS}',    50 )  print( '-' )
    elseif ( button == 103 ) then  lmc_send_keys( '^>%#{NUM7}',        50 )  print( '7' )
    elseif ( button == 104 ) then  lmc_send_keys( '^>%#{NUM8}',        50 )  print( '8' )
    elseif ( button == 105 ) then  lmc_send_keys( '^>%#{NUM9}',        50 )  print( '9' )
    elseif ( button == 107 ) then  lmc_send_keys( '^>%#{NUMPLUS}',     50 )  print( '+' )
    elseif ( button == 100 ) then  lmc_send_keys( '^>%#{NUM4}',        50 )  print( '4' )
    elseif ( button == 101 ) then  lmc_send_keys( '^>%#{NUM5}',        50 )  print( '5' )
    elseif ( button == 102 ) then  lmc_send_keys( '^>%#{NUM6}',        50 )  print( '6' )
    elseif ( button ==   8 ) then  lmc_send_keys( '^>%#{BACKSPACE}',   50 )  print( '<backspace>' )
    elseif ( button ==  97 ) then  lmc_send_keys( '^>%#{NUM1}',        50 )  print( '1' )
    elseif ( button ==  98 ) then  lmc_send_keys( '^>%#{NUM2}',        50 )  print( '2' )
    elseif ( button ==  99 ) then  lmc_send_keys( '^>%#{NUM3}',        50 )  print( '3' )
    elseif ( button ==  13 ) then  lmc_send_keys( '^>%#{ENTER}',       50 )  print( '<enter>' )
    elseif ( button ==  96 ) then  lmc_send_keys( '^>%#{NUM0}',        50 )  print( '0' )
    -- Note that '000' will just rapidly send '96'
    elseif ( button == 110 ) then  lmc_send_keys( '^>%#{NUMDECIMAL}',  50 )  print( '.' )
    end
  end
)





lmc.minimizeToTray = true
lmc_minimize()
-- lmc_say( 'Launched' )
-- lmc_spawn( 'calc' )



-- IDEA - Just cut the appropriate stuff out ot lmc_print_devices()
--        The problem is that it outputs content with escaped stuff, which doesn't neatly fit into a string if simply copy-pasted.  This doesn't seem worth attempting.
