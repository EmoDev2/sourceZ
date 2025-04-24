#NoEnv  ; Mejor rendimiento del script
SendMode Input  ; Método para enviar pulsaciones de teclas
SetWorkingDir %A_ScriptDir%  ; Directorio de trabajo actual

; Alerta inicial con ícono y opciones Sí/No

MsgBox, 52, Advertencia, Estás a punto de ejecutar un software que cambiará los componentes del sistema PERMANENTEMENTE. ¿Quieres continuar?
IfMsgBox, No
    ExitApp

; Crear una lista de fuentes instaladas
fonts := []
Loop, %A_WinDir%\Fonts\*.*, 0, 1
{
    fontName := StrReplace(A_LoopFileName, ".ttf")  ; Extraer el nombre de la fuente
    fonts.Push(fontName)
}

; Convertir la lista en un formato adecuado para ComboBox (separado por |)
fontList := ""
for index, font in fonts
{
    fontList .= font "|"
}

; Crear GUI
Gui, Font, s12  ; Establecer tamaño de fuente predeterminado
Gui, Add, Text, x20 y20 w400, Selecciona una fuente de la lista:
Gui, Add, ComboBox, vFontChoice x20 y50 w350 h200, %fontList%  ; Mostrar fuentes instaladas
Gui, Add, Button, gSubmit x20 y100 w100 h30, Aplicar
Gui, Show, w450 h150, Personalizador de Fuente del Sistema
return

Submit:
Gui, Submit, NoHide

Font := FontChoice

if Font {
    ; Alerta antes de ejecutar cambios con opciones Sí/No
 
MsgBox, 52, Confirmación, El software realizará cambios en las fuentes y otros componentes del sistema, además reiniciará el equipo. ¿Estás seguro de que deseas ejecutarlo?
    IfMsgBox, No
        Return

    ; Ejecutar comandos directamente desde AutoHotkey
    RunWait, % "reg add ""HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"" /v ""Segoe UI (TrueType)"" /t REG_SZ /d """" /f", , Hide
    RunWait, % "reg add ""HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"" /v ""Segoe UI Bold (TrueType)"" /t REG_SZ /d """" /f", , Hide
    RunWait, % "reg add ""HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"" /v ""Segoe UI Italic (TrueType)"" /t REG_SZ /d """" /f", , Hide
    RunWait, % "reg add ""HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"" /v ""Segoe UI"" /t REG_SZ /d """ Font """ /f", , Hide
    Run, shutdown /f /r /t 1

    ; Mensaje final con ícono de error
    MsgBox, 16, Error, La fuente "%Font%" ha sido configurada como sustituta de Segoe UI. El sistema se reiniciará ahora.
} else {
    MsgBox, 16, Error, Por favor selecciona una fuente de la lista.
}
return

GuiClose:
ExitApp

