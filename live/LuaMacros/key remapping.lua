-- For LuaMacros


--  Read  `List-of-Keys.md`  for the modifiers etc.

-- Learn the list of devices with 
-- lmc_print_devices()

-- Mine is
-- <unassigned>  :  \\?\HID#VID_13BA&PID_0001#8&BE46E30&0&0000#{884B96C3-56EF-11D1-BC8C-00A0C91405DD} [-1927936621] :  keyboard

-- IDEA - Just cut the appropriate stuff out of the above string.

usb_device_code='BE46E30'
usb_device_name='usb_numpad'
lmc_device_set_name( usb_device_name, usb_device_code )

lmc_set_handler(
  usb_device_name,
  function( button, direction )
    if ( direction == 1 ) then return end
    -- This is getting triggered with numlock on.
    -- TODO - handle numlock-enabled items.
    if ( button == 144 ) then return end

    --  ^%+#  is  <control><alt><shift><win>
    --  >     is a reference to using the right-side modifier.  e.g.  ^>  is the right-side control key.

    --  Note that <numlock> will not trigger a keystroke.
    if     ( button == 111 ) then  lmc_send_keys( '^>%#{NUMDIVIDE}',   50 )  --  /
    elseif ( button == 106 ) then  lmc_send_keys( '^>%#{NUMMULTIPLY}', 50 )  --  *
    elseif ( button == 109 ) then  lmc_send_keys( '^>%#{NUMMINUS}',    50 )  --  -
    elseif ( button == 103 ) then  lmc_send_keys( '^>%#{NUM7}',        50 )  --  7
    elseif ( button == 104 ) then  lmc_send_keys( '^>%#{NUM8}',        50 )  --  8
    elseif ( button == 105 ) then  lmc_send_keys( '^>%#{NUM9}',        50 )  --  9
    elseif ( button == 107 ) then  lmc_send_keys( '^>%#{NUMPLUS}',     50 )  --  +
    elseif ( button == 100 ) then  lmc_send_keys( '^>%#{NUM4}',        50 )  --  4
    elseif ( button == 101 ) then  lmc_send_keys( '^>%#{NUM5}',        50 )  --  5
    elseif ( button == 102 ) then  lmc_send_keys( '^>%#{NUM6}',        50 )  --  6
    elseif ( button ==   8 ) then  lmc_send_keys( '^>%#{BACKSPACE}',   50 )  --  <backspace>
    elseif ( button ==  97 ) then  lmc_send_keys( '^>%#{NUM1}',        50 )  --  1
    elseif ( button ==  98 ) then  lmc_send_keys( '^>%#{NUM2}',        50 )  --  2
    elseif ( button ==  99 ) then  lmc_send_keys( '^>%#{NUM3}',        50 )  --  3
    elseif ( button ==  13 ) then  lmc_send_keys( '^>%#{ENTER}',       50 )  --  <enter>
    elseif ( button ==  96 ) then  lmc_send_keys( '^>%#{NUM0}',        50 )  --  0
    -- Note that '000' will just rapidly send '96'
    elseif ( button == 110 ) then  lmc_send_keys( '^>%#{NUMDECIMAL}',  50 )  --  .
    end
  end
)

--lmc_spawn( 'calc' )

lmc.minimizeToTray = true
lmc_minimize()
lmc_say( 'Launched' )
