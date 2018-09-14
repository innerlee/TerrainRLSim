https://askubuntu.com/questions/745135/how-to-enable-indirect-glx-contexts-iglx-in-ubuntu-14-04-lts-with-nvidia-gfx


I had a similar issue when running some GL applications via 'ssh -X' and solved it by adding "+iglx" to xserver-command in /usr/share/lightdm/lightdm.conf.d/50-xserver-command.conf.

[SeatDefaults]
# Dump core
xserver-command=X -core +iglx
After which you either reboot or Ctrl-Alt-F1, login, and 'sudo service lightdm restart'.

----

An alternative (and display-manager-independent) way to add the options is to add the following section to /etc/X11/xorg.conf:

Section "ServerFlags"
    Option "IndirectGLX" "on"
EndSection

----

I was having the same issue running a custom OpenGL program over ssh -X. The above solution worked with a slight modification

Section "ServerFlags"
    Option "AllowIndirectGLX" "on"
    Option "IndirectGLX" "on"
EndSection
This worked with ubuntu 16.04 server running kubuntu-desktop with NVIDIA GTX 1070 GPU and NVIDIA binary driver installed through apt.


----
https://us.download.nvidia.com/XFree86/Linux-x86/340.98/README/xconfigoptions.html

Option "AllowIndirectGLXProtocol" "boolean"
There are two ways that GLX applications can render on an X screen: direct and indirect. Direct rendering is generally faster and more featureful, but indirect rendering may be used in more configurations. Direct rendering requires that the application be running on the same machine as the X server, and that the OpenGL library have sufficient permissions to access the kernel driver. Indirect rendering works with remote X11 connections as well as unprivileged clients like those in a chroot with no access to device nodes.

For those who wish to disable the use of indirect GLX protocol on a given X screen, setting the "AllowIndirectGLXProtocol" to a true value will cause GLX CreateContext requests with the direct parameter set to False to fail with a BadValue error.

Starting with X.Org server 1.16, there are also command-line switches to enable or disable use of indirect GLX contexts. -iglx disables use of indirect GLX protocol, and +iglx enables use of indirect GLX protocol. +iglx is the default in server 1.16, but as of this writing it is expected that in the next major release -iglx will be the default.

The NVIDIA GLX implementation will prohibit creation of indirect GLX contexts if the AllowIndirectGLXProtocol option is set to False, or the -iglx switch was passed to the X server (X.Org server 1.16 or higher), or the X server defaulted to '-iglx'.

Default: enabled (indirect protocol is allowed, unless disabled by the server).

----

https://www.scm.com/doc/Installation/Remote_GUI.html#x11-with-opengl-over-ssh-3d-graphics
