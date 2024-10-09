; This AutoHotKey script makes Ctrl+PrintScreen send a Ctrl+Break sequence,
; which is needed for keyboards without the Pause/Break key built in, such as
; my Dell Precision 7770 laptop. It's weird because the directive below has a
; redundant Ctrl modifier with both ^ and Ctrl in the mix... but it's the
; only way I found that works for me (VirtualBox, Windows VM, Linux host).
; See also https://www.autohotkey.com/boards/viewtopic.php?t=108220.
;
; To use it, install AutoHotKey (`scoop install autohotkey`),
; launch it, and then double-click this file in Explorer.

#Requires AutoHotkey v2.0

^PrintScreen::Send "^{CtrlBreak}"
