@echo off 

@echo Parametro de entrada : %param1%

REM C:\Program Files (x86)\Common Files\Axoft\Servidor\APIResto\Axoft.APIResto.Service.exe SE DESACTIVO INSTALACION CON HOTFIX

@echo Parando el servicio de Resto Api Service: Resto.Api.Service.exe...
SC.EXE stop  AxApiRestoSvc

@echo Borrando el servicio Resto Api Service: Resto.Api.Service.exe...
SC.EXE delete  AxApiRestoSvc

SET programFilesCommon=%CommonProgramFiles%
@echo programFilesCommon=%programFilesCommon%

IF DEFINED %PROGRAMFILES(X86)% ( @echo x64 SET programFilesCommon=%CommonProgramFiles(x86)% ) 

@echo programFilesCommon=%programFilesCommon%

@echo Me ubico en la carpeta "%programFilesCommon%\Axoft\Servidor"...

CD %programFilesCommon%\Axoft\Servidor

@echo Borrando la carpeta "%programFilesCommon%\Axoft\Servidor\APIResto"...
RD /S /Q "%programFilesCommon%\Axoft\Servidor\APIResto"

set location=%~dp0
echo %location%
"%location%InstallerRestoApiService.exe"


