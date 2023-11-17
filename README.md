# Debian Installation

This is a set of scripts installing Debian and running post-installation tasks,
e.g. installing a desktop environment, packages, and config files. They are
intended for Cinnamon, GNOME, and KDE.

**Note:** While the post-installation scripts could be used for Ubuntu, some
packages have different names than their counterparts in the Debian
repositories, so this script may not work for all packages.

Requirements:

1. `curl`
2. `fzf`
3. `git`
4. `sudo`

## Install

The `install` script will install Debian on a user-prompted block device.
Supports installations on hardware using UEFI or legacy BIOS and will set a GPT
partition table and ext4 filesystem. Other features, such as bootloader or
encryption, are set when prompted.

The OS can be configured for LVM-on-LUKS full-disk encryption or not. Using GRUB
will also encrypt the `/boot` directory and write a decryption key into the
initial ramdisk so that the password prompt only appears once. For alternate
bootloaders, the `boot` directory will remain unencrypted.

There is also the optional provision for creating a separate, unencrypted
partition of arbitrary size. Useful for creating shared filesystems readable on
Windows / MacOS for USB drive installations.

The rough partition scheme is:

```
1. BIOS compatibility parition, empty if GRUB not used (1 MiB)
2. EFI partition (512 MiB)
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

```sh
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

2. Installs on LUKS-encrypted partition. Partitions (e.g. root and home) are
   kept as logical volumes on the LUKS partition.
3. Installs on unencrypted LVM partition.
4. Installs everything on primary partitions.

#### Boot system

```
1) Back
2) GRUB
3) systemd-boot
4) EFISTUB
```

2. Installs GRUB, BIOS version if no EFI firmware is detected. Otherwise, the
   EFI version is installed.
3. systemd-boot (previously gummiboot) installs kernels in `/boot` and copies
   them over to `/efi`. SystemD path hooks are also installed to update kernel
   images and microcode in `/efi` after updates.
4. Not supported yet...

#### Etc.

The script will also prompt for:

1. Host name
2. User name
3. User password
4. (Optional) LUKS password
5. Locale (e.g. `en_US.UTF-8`)
6. Time zone (e.g. `America/Toronto`)

The script will then mount the partitions, set up chroot, download and install
all the `base` and `base-devel` packages via `debootstrap`, set up the specified
user account, lock the root account, and unmount everything.

## Post-install

Once the base system is installed, use the `./postinstall` script (as the user
account, not root), to install the remaining packages, themes, etc.

Simply run:

```sh
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

3. Installs [base.list](packages/base.list).

4. Purge packages in [purge.list](packages/purge.list) that are unneeded but
   installed by default.

5. Install firmware packages for wireless cards and kernel modules.

6. Updates system packages.

7. Enable the `contrib` package repository.

8. Enable the `non-free` package repository.

9. Upgrade the Debian release (e.g., Buster -> Bullseye).

10. Enable sudo insults for incorrect login attempts via `/etc/sudoers`. Pipes
    to `visudo` via `tee`, so it's safe.

11. Blacklist `pcskpr` and `snd_pcsp` kernel modules.

#### 4) Miscellaneous

```
1) Back             3) Linux utilities  5) SELinux
2) All              4) Laptop tools     6) zsh
```

3. Install general command line utilities in [utils.list](packages/utils.list).

4. Install `tlp` for power management and `xorg-xbacklight` for screen
   brightness.

5. Install and activate SELinux.

6. Install `zsh`, fish-like plugins, nerd fonts, and powerlevel10k theme.

#### 5) Desktop environment

```
1) Back
2) All
3) GNOME
4) Cinnamon
5) KDE
```

3. Install GNOME desktop environment (with GDM for login).

4. Install Cinnamon desktop environment and Gammastep (with LightDM for login).

5. Install KDE desktop enviornment (with SDDM for login).

#### 6) Network tools

```
1) Back                 4) Local discovery      7) Tunnel apt over tor
2) All                  5) Firewall
3) Networking           6) Install tor
```

3. Install Network Manager and OpenSSH. Sets NetworkManager to use random MAC
   addresses for network interfaces.

4. Install Avahi and Samba and enable tools for local network hosting and
   discovery.

5. Install UFW for network firewall and set up basic rules.

6. Install `tor` and `torsocks` (no Tor Browser).

7. **EXPERIMENTAL** Tunnel all package updates through Tor.

#### 7) Applications

```
1) Back                       10) Extra applications       19) PipeWire
2) All                        11) Extra KDE applications   20) TeX Live
3) 3D acceleration            12) Emulators                21) Tor browser
4) Android tools              13) KVM (host)               22) Vim
5) General applications       14) KVM (guest)              23) Neovim
6) General KDE applications   15) Messaging                24) VirtualBox (host)
7) Codecs                     16) MinGW                    25) VirtualBox (guest)
8) Containers                 17) Music                    26) Wine
9) Development                18) Printing
```

3. Install 3D video acceleration packages in
   [3d-accel.list](packages/3d-accel.list).

4. Install packages in [android.list](packages/android.list) for accessing
   storage on Android devices.

5. Install general GTK applications from [apps.list](packages/apps.list).

6. Install general KDE (Qt) applications from
   [apps-kde.list](packages/apps-kde.list).

7. Install GStreamer plugins for handing various media codecs.

8. Install container packages (conatinerd, LXC, Nomad, Podman).

9. Install packages for programming and software development.

10. Install extra, less used applications from
    [extra.list](packages/extra.list).

11. Install extra KDE (Qt) applications from
    [extra-kde.list](packages/extra-kde.list).

12. Install game system emulators.

13. Install Virt-Manager and tools for using KVM virtualization.

14. Install packages for Linux guests to enable host-to-guest sharing and
    adjustable display resolution.

15. Install IRC, email, and other messaging clients.

16. Install MinGW for Windows/Linux cross-platform compilation.

17. Install applications for playing music (`mpd`, `ncmcpp`, `clementine`),
    computing replaygain (`ffmpeg`), tagging metadata (`beets`), and using
    Pandora (`pianobar`).

18. Install CUPS, drivers, and applications for handling printers.

19. Install PipeWire for A/V handling (replaces PulseAudio, ALSA, etc.).

20. Install TeX libraries and Font Awesome icons.

21. Download and install the Tor browser. Edits the application launcher icon to
    look for "browser-tor".

22. Install `vim` and `vim-plugins` and then set the user vimrc.

23. Install `neovim` and then set the user init.vim.

24. Install VirtualBox and kernel modules (dkms) for running it (host).

25. Install kernel modules (dkms) and tools for VirtualBox guests.

26. Install Wine not-emulator, along with the Mono and browser and some audio
    libraries.

#### 8) Themes

```
1) Back                 6) Plata (GTK)        11) Colorific themes
2) All                  7) Materia (GTK)      12) Timed backgrounds
3) Arc (GTK)            8) Materia (KDE)
4) Arc (KDE)            9) Fonts
5) Adapta (GTK)        10) Papirus (icons)
```

3. Download, compile, and install a
   [fork](https://github.com/sudorook/arc-theme) of the
   [Arc GTK theme](https://github.com/horst3180/arc-theme).

4. Download, compile, and install a [fork](https://github.com/sudorook/arc-kde)
   of the
   [Arc Kvantum theme](https://github.com/PapirusDevelopmentTeam/arc-kde).

5. Download, compile, and install a
   [fork](https://github.com/sudorook/adapta-gtk-theme) of the
   [Adapta GTK theme](https://github.com/adapta-project/adapta-gtk-theme).

6. Download, compile, and install a
   [fork](https://gitlab.com/sudorook/plata-theme) of the
   [Plata GTK theme](https://gitlab.com/tista500/plata-theme).

7. Download, compile, and install a
   [fork](https://github.com/sudorook/materia-theme) of the
   [Materia GTK theme](https://github.com/nana-4/materia-theme).

8. Download, compile, and install a
   [fork](https://github.com/sudorook/materia-kde) of the
   [Materia Kvantum theme](https://github.com/PapirusDevelopmentTeam/materia-kde).

9. Install Noto, Cantarell, Ubuntu, Dejavu, and Roboto fonts.

10. Install tweaked version of Papirus icon theme.

11. Install [colorific themes](https://github.com/sudorook/colorific.vim) for
    alacritty, gitk, kitty, Neovim, tmux, and Vim.

12. Install [timed backgrounds](https://github.com/sudorook/timed-backgrounds)
    where transitions from day to night match sunrise/sunset times.

#### 9) Personalization

```
 1) Back                            11) Import KDE settings
 2) All                             12) Import application dconf
 3) Select system fonts             13) Import GNOME terminal profiles
 4) Select icon theme               14) Enable autologin
 5) Select GTK theme                15) Invert brightness (i915)
 6) Select Plasma theme             16) Enable IOMMU (Intel)
 7) Set dark GTK                    17) Disable PulseAudio suspend
 8) Select login shell              18) Disable 802.11n
 9) Import Cinnamon dconf           19) Add scripts
10) Import GNOME dconf
```

3. Select the system font. (Noto or Roboto)

4. Select the system icon theme.

5. Select the system desktop theme (GTK).

6. Select the system desktop theme (Plasma).

7. Set GTK applications to prefer the dark theme.

8. Select default login shell (Bash or Zsh).

9. Import pre-defined dconf settings for Cinnamon.

10. Import pre-defined dconf settings for GNOME.

11. Configure default desktop and application settings for Plasma.

12. Import pre-defined dconf settings for applications.

13. Import GNOME-terminal profiles (Light/Dark) via dconf.

14. Enable autologin for the current user.

15. Invert brightness via kernel command line options in the GRUB prompt.

16. Enable Intel IOMMU for the i915 graphics driver. Helps fix blank displays
    for Haswell CPUs running kernels >=5.7.

17. Disable PulseAudio suspend (suspend can sometimes cause weird buzzing).

18. Disable 802.11n networking in iwlwifi. May help speed up poor 802.11ac
    connections.

19. Download and install
    [general utility scripts](https://github.com/sudorook/misc-scripts).
