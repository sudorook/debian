# Debian Installation

This is a set of scripts installing Debian and running post-installation tasks,
e.g. installing a DE, packages, and config files. They are intended for
Cinnamon or GNOME desktop environments.

**Note:** While the post-installation scripts could be used for Ubuntu, some
packages have different names than in the Debian repositories, so this script
may not work for all packages.

Requirements:
1. `wget`
2. `git`
3. `sudo`

## Install

The `install` script will install Debian on a user-prompted block device.
Supports installations on hardware using UEFI or legacy BIOS and will set a GPT
partition table and ext4 filesystem. Other features, such as bootloader or
encryption, are set when prompted.

The OS can be configured for LVM-on-LUKS full-disk encryption or not. Using
GRUB will also encrypt the `/boot` directory and write a decryption key into
the initial ramdisk so that the password prompt only appears once. For
alternate bootloaders, the `boot` directory will remain unencrypted.

There is also the optional provision for creating a separate, unencrypted
partition of arbitrary size. Useful for creating shared filesystems readable on
Windows / MacOS for USB drive installations.

The rough partition scheme is:
```
1. BIOS compatibility parition, empty if GRUB not used (1 Mb)
2. EFI partition (500 Mb)
3. Share partition (optional)
4. Debian system (Plain / LVM / LUKS-encrypted partitions or volumes)
   - swap
   - root
   - home (optional)
```

**Note:** The script uses `sgdisk` for partitioning, which uses binary (base 2)
units for specifying partition sizes. For example, 500M corresponds to 500
mebibytes, not 500 megabytes.

To run, (need to be root):
```
sudo ./install
```

### Options

Installation options will be queries as the script runs.

#### Partitioning
```
1) Back
2) LVM on LUKS
3) LVM
4) Plain
```

2) Installs on LUKS-encrypted partition. Partitions (e.g. root and home) are
   kept as logical volumes on the LUKS partition.
3) Installs on unencrypted LVM partition.
4) Installs everything on primary partitions.

#### Boot system
```
1) Back
2) GRUB
3) systemd-boot
4) EFISTUB
```

2) Installs GRUB, BIOS version of no EFI firmware is detected. Otherwise, the
   EFI version is installed.
3) systemd-boot (previously gummiboot) installs kernels in `/boot` and copies
   them over to `/efi`. Systemd path hoods are also installed to update kernel
   images and microcode in `/efi` after updates.
4) Not supported yet...

#### Etc.

The script will also prompt for:
1. Host name
2. User name
3. User password
4. (Optional) LUKS password
5. Locale (e.g. `en_US.UTF-8`)
6. Time zone (e.g. `America/Toronto`)

The script will then mount the partitions, set up chroot, download and install
all the `base` and `base-devel` packages via `debootstrap`, set up the
specified user account, lock the root account, and unmount everything.

## Post-install

Once the base system is installed, use the `./postinstall` script (as the user
account, not root), to install the remaining packages, themes, etc.

Simply run:
```
./postinstall
```

The script will check if the dependencies are installed and if the network
connection is active. The rest should be self explanatory.

### Options
```
1) Quit                 4) Miscellaneous        7) Applications
2) Autopilot            5) Desktop environment  8) Themes
3) Base                 6) Network tools        9) Personalization
```

#### 2) Autopilot

Automatically install (without prompting) packages and configs.

#### 3) Base
```
1) Back                      7) Enable contrib
2) All                       8) Enable non-free
3) Base packages             9) Upgrade Debian release
4) Purge packages           10) Sudo insults
5) Firmware                 11) Disable system beep
6) Updates
```

3) Installs [base.list](packages/base.list).

4) Purge packages in [purge.list](packages/purge.list) that are unneeded but
   installed by default.

5) Install firmware packages for wireless cards and kernel modules.

6) Updates system packages.

7) Enable the `contrib` package repository.

8) Enable the `non-free` package repository.

9) Upgrade the Debian release (e.g., Buster -> Bullseye).

10) Enable sudo insults for incorrect login attempts via `/etc/sudoers`. Pipes
   to `visudo` via `tee`, so it's safe.

11) Blacklist `pcskpr` and `snd_pcsp` kernel modules.

#### 4) Miscellaneous
```
1) Back             3) Linux utilities  5) SELinux
2) All              4) Laptop tools     6) zsh
```

3) Install general command line utilities in [utils.list](packages/utils.list).

4) Install `tlp` for power management and `xorg-xbacklight` for screen
   brightness.

5) Install and activate SELinux.

6) Install `zsh`, [fishy-lite](https://github.com/sudorook/fishy-lite), and
   change default shell to `zsh`.

#### 5) Desktop environment
```
1) Back
2) All
3) GNOME
4) Cinnamon
```

3) Install GNOME desktop environment (with GDM for login).

4) Install Cinnamon desktop environment and Redshift (with LightDM for login).

#### 6) Network tools
```
1) Back                 4) Local discovery      7) Tunnel apt over tor
2) All                  5) Firewall
3) Networking           6) Install tor
```

3) Install Network Manager and OpenSSH. Sets NetworkManager to use random MAC
   addresses for network interfaces.

4) Install Avahi and Samba and enable tools for local network hosting and
   discovery.

5) Install UFW for network firewall and set up basic rules.

6) Install `tor` and `torsocks` (no Tor Browser).

7) **EXPERIMENTAL** Tunnel all package updates through Tor.

#### 7) Applications
```
1) Back                    8) Emulators             15) TeX Live
2) All                     9) KVM (host)            16) Tor browser
3) Android tools          10) KVM (guest)           17) Vim
4) General applications   11) Messaging             18) VirtualBox (host)
5) Codecs                 12) MinGW                 19) VirtualBox (guest)
6) Development            13) Music                 20) Wine
7) Extra applications     14) Printing
```

3) Install packages in [android.list](packages/android.list) for accessing
   storage on Android devices.

4) Install general daily use applications from [apps.list](packages/apps.list).

5) Install GStreamer plugins for handing various media codecs.

6) Install packages for programming and software development.

7) Install extra, less used applications from [extra.list](packages/extra.list).

8) Install game system emulators.

9) Install Virt-Manager and tools for using KVM virtualization.

10) Install packages for Linux guests to enable host-to-guest sharing and
    adjustable display resolution.

11) Install IRC, email, and other messaging clients.

12) Install MinGW for Windows/Linux cross-platform compilation.

13) Install applications for playing music (`mpd`, `ncmcpp`, `clementine`),
    computing replaygain (`bs1770gain`), and using Pandora (`pianobar`).

14) Install CUPS, drivers, and applications for handling printers.

15) Install TeX libraries and Font Awesome icons.

16) Download and install the Tor browser. Edits the application launcher icon
    to look for "browser-tor".

17) Install `vim` and `vim-plugins` and then set the user vimrc.

18) Install VirtualBox and kernel modules (dkms) for running it (host).

19) Install kernel modules (dkms) and tools for VirtualBox guests.

20) Install Wine not-emulator, along with the Mono and browser and some audio
    libraries.

#### 8) Themes
```
1) Back                 5) Plata (GTK)         9) Colorific themes
2) All                  6) Materia (GTK )      10) Thunderbird theme
3) Arc (GTK)            7) Fonts               11) Timed backgrounds
4) Adapta (GTK)         8) Papirus (icons)
```

3) Download, compile, and install a [fork](https://github.com/sudorook/arc-theme)
   of the [Arc GTK theme](https://github.com/horst3180/arc-theme).

4) Download, compile, and install a [fork](https://github.com/sudorook/adapta-gtk-theme)
   of the [Adapta GTK theme](https://github.com/adapta-project/adapta-gtk-theme).

5) Download, compile, and install a [fork](https://gitlab.com/sudorook/plata-theme)
   of the [Plata GTK theme](https://gitlab.com/tista500/plata-theme).

6) Download, compile, and install a [fork](https://github.com/sudorook/materia-theme)
   of the [Materia GTK theme](https://github.com/nana-4/materia-theme).

7) Install Noto, Cantarell, Ubuntu, Dejavu, and Roboto fonts.

8) Install tweaked version of Papirus icon theme.

9) Install [colorific themes](https://github.com/sudorook/colorific.vim) for
   alacritty, gitk, kitty, Neovim, tmux, and Vim.

10) Install the [Monterail theme](https://github.com/spymastermatt/thunderbird-monterail)
    for Thunderbird.

11) Install [timed backgrounds](https://github.com/sudorook/timed-backgrounds)
    where transitions from day to night match sunrise/sunset times.

#### 9) Personalization
```
1) Back                              9) Import application dconf
2) All                              10) Import GNOME terminal profiles
3) Select system font               11) Enable autologin
4) Select icon theme                12) Invert brightness (i915)
5) Select desktop theme             13) Enable IOMMU (Intel)
6) Set dark GTK                     14) Disable PulseAudio suspend
7) Import Cinnamon dconf            15) Disable 802.11n
8) Import GNOME dconf               16) Add scripts
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

13) Enable Intel IOMMU for the i915 graphics driver. Helps fix blank displays
    for Haswell CPUs running kernels >=5.7.

14) Disable PulseAudio suspend (suspend can sometimes cause weird buzzing).

15) Disable 802.11n networking in iwlwifi. May help speed up poor 802.11ac
    connections.

16) Download and install [general utility scripts](https://github.com/sudorook/misc-scripts).
