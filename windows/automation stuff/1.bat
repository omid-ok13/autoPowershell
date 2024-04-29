@echo off
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\wwwroot\LogFile (
	if not exist z:\WebServer-01\%%G\%%H\wwwroot\LogFile (
		mkdir z:\WebServer-01\%%G\%%H\wwwroot\LogFile
	)
	forfiles /P "HostingSpaces\%%G\%%H\wwwroot\LogFile" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\wwwroot\LogFile"
)
)
)
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\wwwroot\LogFiles (
	if not exist z:\WebServer-01\%%G\%%H\wwwroot\LogFiles (
		mkdir z:\WebServer-01\%%G\%%H\wwwroot\LogFiles
	)
	forfiles /P "HostingSpaces\%%G\%%H\wwwroot\LogFiles" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\wwwroot\LogFiles"
)
)
)
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\wwwroot\LogFile\Raja (
	if not exist z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Raja (
		mkdir z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Raja
	)
	forfiles /P "HostingSpaces\%%G\%%H\wwwroot\LogFile\Raja" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Raja"
)
)
)
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\wwwroot\LogFile\Fadak (
	if not exist z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Fadak (
		mkdir z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Fadak
	)
	forfiles /P "HostingSpaces\%%G\%%H\wwwroot\LogFile\Fadak" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Fadak"
)
)
)
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\wwwroot\LogFile\Bonrail (
	if not exist z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Bonrail (
		mkdir z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Bonrail
	)
	forfiles /P "HostingSpaces\%%G\%%H\wwwroot\LogFile\Bonrail" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\wwwroot\LogFile\Bonrail"
)
)
)
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\logs (
FOR /f %%T IN ('dir HostingSpaces\%%G\%%H\logs /b') DO (
	if not exist z:\WebServer-01\%%G\%%H\logs (
		mkdir z:\WebServer-01\%%G\%%H\logs
	)
	if not exist z:\WebServer-01\%%G\%%H\logs\%%T (
		mkdir z:\WebServer-01\%%G\%%H\logs\%%T
	)
	forfiles /P "HostingSpaces\%%G\%%H\logs\%%T" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\logs\%%T"
)
)
)
FOR /f %%G IN ('dir HostingSpaces /b') DO (
FOR /f %%H IN ('dir HostingSpaces\%%G /b') DO (
IF EXIST HostingSpaces\%%G\%%H\wwwroot\wwwroot\LogFile (
	if not exist z:\WebServer-01\%%G\%%H\wwwroot\wwwroot\LogFile (
		mkdir z:\WebServer-01\%%G\%%H\wwwroot\wwwroot\LogFile
	)
	forfiles /P "HostingSpaces\%%G\%%H\wwwroot\wwwroot\LogFile" /M * /D -1 /C "cmd /c move @path z:\WebServer-01\%%G\%%H\wwwroot\wwwroot\LogFile"
)
)
)
)