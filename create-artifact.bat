@ECHO off
:start
set /P artifact_path="Path to Artifact: "
IF NOT EXIST "%artifact_path%" (
    echo Artifact path %artifact_path% does not exist!
    pause
    goto script_exit
)
set /P artifact_group="Artifact Group: "
set /P artifact_id="Artifact ID: "
set /P artifact_version="Artifact Version: "
echo ""
set /P verify="Confirm? [y/n]"
IF /I "%verify%" == "Y" goto build_artifact
ELSE goto start

:build_artifact
echo Installing file...
call mvnd install:install-file -DgroupId=%artifact_group% -DartifactId=%artifact_id% -Dversion=%artifact_version% -Dfile="%artifact_path%" -Dpackaging=jar -DlocalRepositoryPath=. -DcreateChecksum=true -DgeneratePom=true

REM Check if Maven command failed
IF ERRORLEVEL 1 (
    echo Maven install command failed!
    pause
    goto script_exit
)

for /r %%x in (maven-metadata.xml*) do del "%%x"
for /r %%x in (maven-metadata-local.xml*) do copy "%%x" "%%x\..\maven-metadata.xml*"

echo Script completed successfully!
pause
goto end

:script_exit
echo Script terminated due to error.
pause

:end