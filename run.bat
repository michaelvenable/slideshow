@ECHO OFF

SET originalPath=%PATH%
SET PATH=%PATH%;%CD%\drivers-windows\
ruby slideshow.rb
SET PATH=%originalPath%
