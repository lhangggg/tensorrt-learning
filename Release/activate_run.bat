@echo off
SET "CONAN_OLD_PATH=%PATH%"

FOR /F "usebackq tokens=1,* delims==" %%i IN ("D:\project\learning\tensorrt-learning\Release\environment_run.bat.env") DO (
    CALL SET "%%i=%%j"
)

SET "CONAN_OLD_PROMPT=%PROMPT%"
SET "PROMPT=(conanrunenv) %PROMPT%"