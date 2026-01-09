# use a truecolor capable terminal emulator
use a true color capable terminal (xterm/st/konsole/gnome-terminal or so)
Truecolor (24bit color) does away with the terminal palette translation, and instead directly specifies the color in HTML/HEX color RGB, albeit using a terminal color escape sequence:
e \<esc>

more info: https://gist.github.com/XVilka/8346728

# test terminal colors
``` bash
# single tc print
printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
# multicolor
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g
    }
    printf "\n";
}'
```

# reference list 256 colors
https://jonasjacek.github.io/colors/

They are often either used by direct addressing the color number, e.g.
"color234" in mutt, or bei their names e.g. "DarkSeaGreen" (==color108) in
urxvt, or by using a shorthand, e.g. what is displayed with the '/cubes' script
in irssi. In irssi '%x7D' is: _x_: background, 7D = the greyscale palette at the end
of the 256 color range, 7=grey range, D = forth colour => color234 / Grey11.
See: https://github.com/irssi/irssi/blob/master/docs/formats.txt
irssi also supports HEX notation.

