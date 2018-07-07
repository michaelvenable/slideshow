@ECHO OFF

SET originalPath=%PATH%
SET PATH=%PATH%;%CD%\drivers-windows\
ruby screensaver.rb
SET PATH=%originalPath%
