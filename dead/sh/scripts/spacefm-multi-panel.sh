# While a really cool idea, it's confusing as all hell for me, and all spacefm instances will have the same panel setup, which is stupid.

\spacefm \
  --new-window \
  --panel=1  --no-saved-tabs \
    /mnt/1/windows-data/l/live/_outbox--1/ \
&
# Make sure that multiple spacefm windows don't spawn.
\sleep  1
\spacefm \
  --panel=2  --no-saved-tabs  --reuse-tab \
    /1/__/ \
&
\spacefm \
  --panel=3  --reuse-tab \
    /1/ \
&
\spacefm \
  --panel=4  --reuse-tab \
    /mnt/1/windows-data/l/live/__/ \
    /l/_outbox--0/ \
&
# Make sure that everything is loaded up before these socket commands are sent.
\sleep  2

\spacefm &

# I don't see how multiple socket commands can be sent in one line.  Bah.
# I don't know how to set the sizes of each panel.
\spacefm  --socket-cmd  set window_maximized true
\spacefm  --socket-cmd  set focused_panel 1
\spacefm  --socket-cmd  set focused_pane filelist
\spacefm  --socket-cmd  set panel1_visible true
\spacefm  --socket-cmd  set panel2_visible true
\spacefm  --socket-cmd  set panel3_visible true
\spacefm  --socket-cmd  set panel4_visible true
