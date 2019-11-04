@echo off
set DIR="%~dp0"
set JAVA_EXEC="%DIR:"=%\java"
%JAVA_EXEC% --add-exports javafx.controls/com.sun.javafx.scene.control=com.jfoenix --add-exports javafx.controls/com.sun.javafx.scene.control.behavior=com.jfoenix --add-exports javafx.graphics/com.sun.javafx.scene=com.jfoenix --add-exports javafx.base/com.sun.javafx.event=com.jfoenix -m jupiter/jupiter.Jupiter  %*
