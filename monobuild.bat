@echo off
setlocal

cd /d "%~dp0"

echo Building Godot editor with Mono/C# support...
scons platform=windows target=editor dev_build=yes d3d12=no module_mono_enabled=yes
if errorlevel 1 (
    echo Mono editor build failed.
    exit /b 1
)

set GODOT_MONO_EXE=bin\godot.windows.editor.dev.x86_64.mono.exe
if not exist "%GODOT_MONO_EXE%" (
    echo Cannot find %GODOT_MONO_EXE%.
    exit /b 1
)

echo Generating Mono glue...
"%GODOT_MONO_EXE%" --generate-mono-glue .\modules\mono\glue
if errorlevel 1 (
    echo Mono glue generation failed.
    exit /b 1
)

echo Building C# assemblies...
python .\modules\mono\build_scripts\build_assemblies.py --godot-output-dir .\bin
if errorlevel 1 (
    echo C# assemblies build failed.
    exit /b 1
)

echo Registering local Godot C# NuGet packages...
dotnet nuget add source "%CD%\bin\GodotSharp\Tools\nupkgs" --name GodotLocal48Dev 2>nul

echo Mono/C# build finished.
