Android Local Manifests
=======================

This repo holds a bunch of XML files that represent local_manifest.xml files
that can be used to properly use the MotoMagic device repos within a desired
AOSP tree.

Basically take one of these files, rename it to "local_manifest.xml" and
place it in your ".repo" folder, then repo sync.

Available Files
---------------

### local_manifest.xml

The main local_manifest.xml that should work with most android trees.  Includes
any repos that are not ROM-specific.
