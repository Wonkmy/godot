@echo off
cd /d "%~dp0"

rem Old command kept: generate default VS project.
rem scons platform=windows vsproj=yes d3d12=no

where python >nul 2>nul
if errorlevel 1 (
    echo Python was not found in PATH.
    exit /b 1
)

where scons >nul 2>nul
if errorlevel 1 (
    echo SCons was not found in PATH.
    exit /b 1
)

set "BUILD_DEPS=%LOCALAPPDATA%\Godot\build_deps"

rem Install missing build deps required by current Windows defaults.
if not exist "%BUILD_DEPS%\accesskit" (
    echo Installing missing AccessKit build dependency...
    python misc\scripts\install_accesskit.py
    if errorlevel 1 exit /b 1
)

if not exist "%BUILD_DEPS%\angle-x86_64-msvc" (
    echo Installing missing ANGLE build dependency...
    python misc\scripts\install_angle.py
    if errorlevel 1 exit /b 1
)

rem Generate VS project matching the current editor dev build.
scons platform=windows target=editor dev_build=yes vsproj=yes d3d12=no

