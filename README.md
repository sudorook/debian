# Debian Post-Installation

This is a set of scripts for running post-installation tasks for Debian 9
(Stretch), 10 (Buster), or Unstable (sid). Works best if the Cinnamon or GNOME
desktop environments are already installed.

**Note:** Some Ubuntu packages have different names, so this script may not
work for some packages.

Depends on `wget` and `git`.

## Usage
```
./postinstall
```

The script will check if the dependencies are installed and if the network
connection is active. The rest should be self explanatory.


## Options
```
1) Quit                 4) Miscellaneous        7) Applications
2) Autopilot            5) Desktop environment  8) Themes
3) Base                 6) Network tools        9) Personalization
```

### 2) Autopilot

Automatically install (without prompting) packages and configs.

### 3) Base
```
1) Back                      6) Enable non-free
2) Base packages             7) Updates
3) Purge packages            8) Upgrade Debian release
4) Firmware                  9) Sudo insults
5) Enable contrib           10) Disable system beep
```

2) Installs [base.list](packages/base.list).

3) Purge packages in [purge.list](packages/purge.list) that are unneeded but
   installed by default.

4) Install firmware packages for wireless cards and kernel modules.

5) Enable the `contrib` package repository.

6) Enable the `non-free` package repository.

7) Updates system packages.

8) Upgrade the Debian release (e.g., Stretch -> Buster).

9) Enable sudo insults for incorrect login attempts via `/etc/sudoers`. Pipes
   to `visudo` via `tee`, so it's safe.

10) Blacklist `pcskpr` and `snd_pcsp` kernel modules.

### 4) Miscellaneous
```
1) Back             3) zsh              5) Linux utilities
2) All              4) SELinux          6) Laptop tools
```

3) Install `zsh`, [fishy-lite](https://github.com/sudorook/fishy-lite), and
   change default shell to `zsh`.

4) Install and activate SELinux.

5) Install general command line utilities in [utils.list](packages/utils.list).

6) Install `tlp` for power management and `xorg-xbacklight` for screen
   brightness.

### 5) Desktop environment
```
1) Back
2) All
3) GNOME
4) Cinnamon
```

3) Install GNOME desktop environment (with GDM for login).

4) Install Cinnamon desktop environment and Redshift (with LightDM for login).

### 6) Network tools
```
1) Back                 3) Network tools        5) Tunnel apt over tor
2) All                  4) Install tor
```

3) Install NetworkManager, Samba, SSH, and UFW for networking management and
   security. Automatically sets NetworkManager to use random MAC addresses for
   network interfaces, enables Avahi daemon for local hostname resolution, and
   enables UFW firewall systemd unit. **DOES NOT** set default firewall rules.

4) Install `tor` and `torsocks` (no Tor Browser).

5) **EXPERIMENTAL** Tunnel all package updates through Tor.

### 7) Applications
```
1) Back                    7) Emulators             13) Vim
2) All                     8) KVM (host)            14) VirtualBox (host)
3) Android tools           9) KVM (guest)           15) VirtualBox (guest)
4) General applications   10) Music                 16) Wine
5) Codecs                 11) TeX Live
6) Development            12) Tor browser
```

3) Install packages in [android.list](packages/android.list) for accessing
   storage on Android devices.

4) Install general daily use applications from [apps.list](packages/apps.list).

5) Install GStreamer plugins for handing various media codecs.

6) Install packages for programming and software development.

7) Install game system emulators.

8) Install Virt-Manager and tools for using KVM virtualization.

9) Install packages for Linux guests to enable host-to-guest sharing and
    adjustable display resolution.

10) Install applications for playing music (`mpd`, `ncmcpp`, `clementine`),
    computing replaygain (`bs1770gain`), and using Pandora (`pianobar`).

11) Install TeX libraries and Font Awesome icons.

12) Download and install the Tor browser. Edits the application launcher icon
    to look for "browser-tor".

13) Install `vim` and `vim-plugins` and then set the user vimrc.

14) Install VirtualBox and kernel modules (dkms) for running it (host).

15) Install kernel modules (dkms) and tools for VirtualBox guests.

16) Install Wine not-emulator, along with the Mono and browser and some audio
    libraries.

### 8) Themes
```
1) Back               4) Adapta (GTK)       7) Vim theme
2) All                5) Fonts              8) Thunderbird theme
3) Arc (GTK)          6) Papirus (icons)    9) Timed backgrounds
```

3) Download, compile, and install a [fork](https://github.com/sudorook/arc-theme)
   of the [Arc GTK theme](https://github.com/horst3180/arc-theme).

4) Download, compile, and install a [fork](https://github.com/sudorook/adapta-gtk-theme)
   of the [Adapta GTK theme](https://github.com/adapta-project/adapta-gtk-theme).

5) Install Noto, Cantarell, Ubuntu, Dejavu, and Roboto fonts.

6) Install tweaked version of Papirus icon theme.

7) Set the default Vim theme to [colorific](https://github.com/sudorook/colorific.vim).

8) Install the [Monterail theme](https://github.com/spymastermatt/thunderbird-monterail)
   for Thunderbird.

9) Install [timed backgrounds](https://github.com/sudorook/timed-backgrounds)
   where transitions from day to night match sunrise/sunset times.

### 9) Personalization
```
1) Back                              8) Import GNOME dconf
2) All                               9) Import application dconf
3) Select system font               10) Import GNOME terminal profiles
4) Select icon theme                11) Enable autologin
5) Select desktop theme             12) Invert brightness
6) Set dark GTK                     13) Disable PulseAudio suspend
7) Import Cinnamon dconf            14) Add scripts
```

3) Select the system font. (Noto or Roboto)

4) Select the system icon theme.

5) Select the system desktop theme.

6) Set applications to prefer the dark theme.

7) Import pre-defined dconf settings for Cinnamon.

8) Import pre-defined dconf settings for GNOME.

9) Import pre-defined dconf settings for applications.

10) Import terminal profiles (Light/Dark) via dconf.

11) Enable autologin for the current user.

12) Invert brightness via kernel command line options in the GRUB prompt.

13) Disable PulseAudio suspend (suspend can sometimes cause weird buzzing).

14) Download and install [general utility scripts](https://github.com/sudorook/misc-scripts).
