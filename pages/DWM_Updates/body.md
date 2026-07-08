I've spent the last few days going over the older scripts in my DWM setup. I've refactored all of the older unoptimised code and I've cut anything unneccercery. My DWM system is one of the most barebones yet functional systems that you will likley see this week. I've used many softwares in the open source community to put togeather a fully optimised system that has wiggle room for pretty rice features.
<br>

## Base Components
> In my system, I am of course using the DWM + ST + DMENU combo for the main ui components.

I've spent hours patching DWM with many non-standard features. These include; dwm-alwayscecnter (center new windows), dwm-cfacts (vertical mfacts) dwm-dwmc (better implementation of fakesignal), dwm-fullgaps (adjustable vanity gaps between windows), dwm-inplacerotate (allows for cycling of master and stack area), dwm-status2d-swap-save-restore (provides codes for changing colors in the dwmbar), dwm-xrdb (pulls global resource colors from xrdb, allows for custom on-the-fly colorschemes). Along with this I have patched DWM with my own custom patches too, some of these include; workspace tagging (you can change the name of workspaces), dual bar + custom section management engine which allows for centering text on the bottom bar (replaced the old usage of lemonbar + dwm, best idea ever), and I'm sure there are more features I am forgetting as its been so long.
<br><br>

For ST, I'm using the base st-graphics repo, which allows for seamless intergration of the kitty terminal image protocal. St has also been patched with an XResources patch to allow for the same XRDB global styling as DWM and st-alpha which lets you set the background opacity of ST windows. In ST's config.def.h I've enabled zoom features bound to CTRL+hyphen and CTRL+plus. Most of the terminal magic is on the shell itself. I'm using MKSH.
<br><br>

DMENU is the least customised out of the three, all I did for dmenu was I added a bar-height patch (More on this later) along with the dmenu-fuzzyhighlight patch which improves the searching system greatly along with adding some pretty colors.
<br>

## Intergration
> How these systems tie togeather

In DWM's config.def.h I've setup both dmenu and st to use DWM's font and color scheme which allows for seamless theme consistency without needing to wait for individual systems to load colors and configs.
<br><br>

Because of this inline intergration, DMENU is setup to use the same font as DWM AND be the same height as the top dwm bar. In the picom (compositor) settings, I've added a small animation cue that makes dmenu animate by sliding in from the top and easing to a stop, covering the entire top dwmbar and on close it simply does the oposite and slides up and off-screen.
<br><br>

The DWMBAR setup on this project deserves its own section but I'm going to cut the waffle short and ramble about it here instead: As stated previously, I've heavily customised the way the builtin DWMBAR behaves. I have made it so that you can provide the status text in 5 seperate parts; Part one goes in the top-right, the next part goes in the bottom-left, then the bottom-center and finally the bottom-right. These parts are seperated by semicolons. In my DWMBAR I've setup a "modules" directory within the main "script" directory, this is where any bar-related scripts (other than the main bar script) are located. Also in the "config" directory you can find a barconfig file that allows you to change the configuration of the dwmbar on the fly. the bar config contains two lines, the first contains a list of files within the "modules" folder that will be loaded, the next line determines where each module will be loaded on the bar by prefixing the modules filename with a '$' and using a special "$SEP" value to signify a seperator. The dwmbar loop script itself is quite well-made too, it of course loads the scripts from the barconfig, it loads each of these scripts asyncronously and caches the values into temporary files, each scripts output is then loaded to a variable of its own filename eg a file called "MY_MODULE" will be loaded into the "MY_MODULE" variable which can then be referenced in the barconfig with "$MY_MODULE". Please read the barconfig for a better idea of this.
<br>
<br>
Another hot-topic is notification daemons, beacuse im lazy and don't need to sacrafice usabilty for non-corperate FOSS, my system just uses as basic DBUS stream daemon. For this I've used statnot which is a small python script that allows for reading from DBUS notification streams. I've modded statnot to output the current time and notification body into a temporary file. This file is then read by the bottom-center bar module and displayed if the notification was sent within the last 10 seconds. Check out the MEDIA module for more on this. So using statnot and having an embedded notification display on the bar means I dident need to bother with any GUI notification daemon such as Dunst which I've used in the past.
<br>

## Customisation
All the components in my system are compatable with XRDB. I've implemented hellwal into my system, hellwal takes in a image and returns a pallete of colors which are used in parts of my system, for more on hellwal specifically you can look into "background" in the "scripts" folder of the project and you can look into the "hellwal" templates folder in the "config" directory.
<br>
<br>

I've written a custom script that when run, opens a yazi file selector floating window in a designated wallpaper directory. When the user selects a image file, that image will be set as the background, hellwal will scrape its images, and several script components will run and reload the DWM (DWMS bars and client border colors) and ST's terminal colors. This component used to use ranger for this but recently I put work into getting Yazi to work with this instead. This is because Yazi is slightly faster at image previews than Ranger, Yazi just seems faster in general. This wallpaper selection menu can be opened with "MOD+t"

<br>
## Features
I've decided on using selx and sxot for screenshot selection and capture, read the "screenshot" script in the "scripts" folder, you can run this script by pressing MOD+SHFT+S. I've written a basic forcequit script which can be activated with "MOD+SHFT+q" and this script simply querys the active client and throws a few fatal kill sigals to its PID which WILL force the program to quit regardless. There is a keybind for compositor toggling that being MOD+SHFT+B. You can press MOD+X to suspend and lock the system (using slock), note that the system for syspending the sysetm is to signal /sys/power/state which needs to be enabled in the kernel.
<br><br>
For documentation of more features, go look into the shell configuration in "config" ("mkshrc") also view the config.def.h files of DWM and less importantly ST and DMENU.
---
<br>
This system is my own and its not made for with other people in mind, this post is just a self-appreciation post really :'). <a href="https://github.com/x3hy/dwm">Here is the GIT repo is you're interestedU</a>
