# HiDPI in grub and ttys
see https://martin.rpdev.net/2017/01/21/setting-console-font-size-on-hidpi-screens-in-fedora.html
and - as often - the excellent Arch Wiki
https://wiki.archlinux.org/index.php/HiDPI

## grub
Note: On some systems all the grub commands might be  called grub2-<cmd>.
On most systems in 2020 grub2 has become the default and no grub*2* prefix is
necessary.

### create grub fontfile
``` bash
mkdir /boot/grub2/fonts
grub-mkfont -s 35 -o /boot/grub2/fonts/Inconsolata35.pf2 \
 /usr/share/fonts/truetype/inconsolata/Inconsolata.otf
```

### set grub font in /etc/default/grub
Note: as of 2020 in Debian changing "GRUB\_TERMINAL\_OUTPUT" to "gfxterm" is no
longer necessary since grub sets it automatically.
Run grub-mkconfig and locate the font section in the output to check.

``` bash
echo -e '
### custom font HiDPI
GRUB_FONT="/boot/grub/fonts/Inconsolata35.pf2"
' >> /etc/default/grub
```

### make new grub config
Locate your current grub config and write the new one accordingly.
On some efi systems the grub.cfg is located in the efi folder.
On some systems the grub2 config is in a grub2 folder.

#### BIOS / grub.cfg in /boot/grub
`grub-mkconfig -o /boot/grub/grub.cfg`

#### EFI / grub.cfg in /boot/efit
`grub-mkconfig -o /boot/efi/EFI/fedora/grub.cfg`

## TTY / linux-console
see https://wiki.archlinux.org/index.php/HiDPI#Linux\_console
Note: on debian console-setup is used, von vconsole.conf

### early boot
If the HiDPI is not autodetected, and the tty font stays small, you can add a
set the font in the grub linux commandline. Keep other cmdline options (quite,
splash) as desired.

If this does not work see the above link for troubleshooting, e.g. EFI legacy
boot.

*Note: not tested, since the early boot font is fine for me. I am not sure about the 'Uni3-' part beeing correct.*
``` bash
GRUB_CMDLINE_LINUX_DEFAULT="fbcon=font:Uni3-Terminus32x16"
```

### running system ttys
On debian the ttys of the running system use the font defined in console-setup.
see
```bash
showconsolefont
setfont Uni3-Terminus32x16
setupconf
```

Fonts (on debian) are located in /usr/share/consolesetup/fonts/ and consist
of a fontface and a codeset.
You can test your new settings by modifying the contents and running `setupcon`
on a tty.

e.g. 'Uni3-Terminus32x16.psf.gz' corresponds to
```bash
CODESET="Uni3"
FONTFACE="Terminus"
FONTSIZE="32x16"
```


