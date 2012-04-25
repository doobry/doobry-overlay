doobry's random ebuilds
=======================

This is a gentoo overlay for random ebuilds I've written, tweaked or downloaded.


Emerging layman
---------------

This simplest way to manage your overlays is with layman, which can be emerged with:

    emerge -av layman
    
Remember to add the layman source to /etc/make.conf as instructed by the emerge output.


Adding the overlay
------------------

You can add this overlay using layman with:

    layman -f -o http://github.com/doobry/doobry-overlay/raw/master/layman.xml -a doobry
 
You should also add the url to the list of remote overlays in /etc/layman/layman.cfg


Removing the overlay
--------------------

You can remove this overlay from layman with:

    layman -d doobry
