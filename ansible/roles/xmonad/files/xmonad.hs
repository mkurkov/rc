import XMonad
import XMonad.Config.Gnome
import XMonad.Config.Kde

import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Util.EZConfig(additionalKeysP)
import System.Exit
import Graphics.X11.Xlib
import System.IO

-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowGo
import qualified XMonad.Actions.Search as S
import XMonad.Actions.Search
import qualified XMonad.Actions.Submap as SM
import XMonad.Actions.GridSelect

-- utils
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadSpawnActionTerminal, scratchpadManageHook, scratchpadFilterOutWorkspace)
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.Prompt 		as P
import XMonad.Prompt.Shell
import XMonad.Prompt
import XMonad.Util.WindowProperties (getProp32s)

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.InsertPosition

-- layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Reflect
import XMonad.Layout.IM
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Grid
import XMonad.Layout.Gaps
import XMonad.Layout.Master

-- Data.Ratio for IM layout
import Data.Ratio ((%))

-- Main --
main = xmonad $ withUrgencyHook NoUrgencyHook $ gnomeConfig
       {
         terminal   = myTerminal,
         manageHook = myManageHook,
         layoutHook = myLayoutHook,
         modMask    = myModMask,
         workspaces = myWorkspaces
       }
       `additionalKeysP` myKeys

myTerminal = "urxvt"

myKeys =
    [
        -- Lock Screen
        ("M-S-l",    spawn lockScreenCommand),
        -- MPC
        ("M-<R>",    spawn "mpc -q next"),
        ("M-<L>",    spawn "mpc -q prev"),
        ("M-<U>",    spawn "mpc -q toggle"),
        ("M-<D>",    spawn "mpc -q stop"),
        ("M-`", scratchpadSpawnActionTerminal myTerminal),
        ("M-z",      shellPrompt defaultXPConfig {height = 22}),
        ("M-<F10>",  spawn "amixer -q set Master toggle"),
        ("M-<F11>",  spawn "amixer -q set Master 7%-"),
        ("M-<F12>",  spawn "amixer -q set Master 7%+"),
        ("M-g", goToSelected  defaultGSConfig {gs_navigate = navNSearch}),
        ("M-f", gridselectWorkspace defaultGSConfig {gs_navigate = navNSearch} W.greedyView)
    ]

--lockScreenCommand = "qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"
lockScreenCommand = "gnome-screensaver-command -l"

myWorkspaces =
    ["1:web", "2:shell", "3:emacs", "4:chat", "5:skype", "6:work", "7:doc", "8:media", "9:virtualbox"]
-- ["1:home/mail", "2:home/web", "4:home/chat", "5:home/skype", "6:kato/mail", "

myModMask :: KeyMask
myModMask = mod4Mask

-- hooks
-- automaticly switching app to workspace
myManageHook :: ManageHook
myManageHook = scratchpadManageHook (W.RationalRect 0.25 0.375 0.5 0.35) <+>
               ( composeAll . concat $
                                [[isFullscreen                  --> doFullFloat
                                 , title =? "Conkeror edit"     --> doFloat
                                 , className =? "Conkeror"      --> doShift "1:web"
                                 , className =? "Google-chrome" --> doShift "6:work"
                                 , className =? "Chromium"      --> doShift "6:work"
                                 , className =? "Emacs"         --> doShift "3:emacs"
		                 , className =? "Skype"         --> insertPosition Below Newer <+> doShift "5:skype"
		                 , className =? "Skype-bin"     --> insertPosition Below Newer <+> doShift "5:skype"
                                 , className =? "Empathy"       --> doShift "4:chat"
                                 , className =? "Pidgin"        --> doShift "4:chat"
                                 , className =? "Ktp-contactlist" --> doShift "4:chat"
                                 , className =? "Ktp-text-ui"    --> insertPosition Below Newer <+> doShift "4:chat"
                                 , className =? "OpenOffice.org 3.2" --> doShift "7:doc"
		                 , className =? "Xmessage" 	--> doCenterFloat
		                 , className =? "Zenity" 	--> doCenterFloat
		                 , className =? "feh"   	--> doCenterFloat
		                 , className =? "Apvlv" 	--> doShift "7:doc"
		                 , className =? "Evince" 	--> doShift "7:doc"
		                 , className =? "Epdfview" 	--> doShift "7:doc"
                                 , className =? "Unity-2d-panel" --> doIgnore
                                 , className =? "Unity-2d-launcher" --> doFloat
		                 ]]
               ) <+> (kdeOverride --> doFloat) <+> manageDocks


--LayoutHook
myLayoutHook  =  onWorkspace "4:chat" imLayout $
                 onWorkspace "5:skype" skypeL $
                 onWorkspace "1:web" webL $
                 standardLayouts
    where
	standardLayouts =   avoidStruts  $ (tiled |||  reflectTiled ||| Mirror tiled ||| Grid ||| Full)

        --Layouts
	tiled     = smartBorders (ResizableTall 1 (2/100) (1/2) [])
        reflectTiled = (reflectHoriz tiled)
	full 	  = noBorders Full

        --Im Layout
        imLayout = avoidStruts $ smartBorders $ withIM ratio (Or pidginRoster ktpRoster) $ reflectHoriz $
                   withIM skypeRatio skypeRoster (reflectTiled ||| tiled ||| Grid)
            where
              chatLayout = Grid
	      ratio      = (1%9)
              skypeRatio = (1%8)
              -- empathyRoster = And (ClassName "Empathy") (Role "contact_list")
              ktpRoster  = ClassName "Ktp-contactlist"
              pidginRoster  = And (ClassName "Pidgin") (Role "buddy_list")
              skypeRoster  = Or ((ClassName "Skype") `And` (Title "mkurkov - Skype™ (Beta)")) ((ClassName "Skype-bin") `And` (Title "mkurkov - Skype™"))

	--Web Layout
	webL = avoidStruts $ ( tiled ||| reflectHoriz tiled |||  full)

        --VirtualLayout
        fullL = avoidStruts $ full

        skypeL =  avoidStruts $ mastered (1/100) (1/8) $ Grid


--kdeOverride :: Query Bool
kdeOverride = ask >>= \w -> liftX $ do
    override <- getAtom "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE"
    wt <- getProp32s "_NET_WM_WINDOW_TYPE" w
    return $ maybe False (elem $ fromIntegral override) wt
