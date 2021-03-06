; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES.

[Setup]
; NOTE: The value of AppId uniquely identifies the ACR Illustrations installer application. Do not change it. 
AppId={{aa6f9522-23cd-4b99-b67f-4c8aa55cb347}
AppName=Afghan Children Reading Illustrations
; You can change the AppVersion to reflect updates to the ACR Illustrations
AppVersion=1.1
AppPublisher=Afghan Children Read/Ministry of Education of the Government of the Islamic Republic of Afghanistan
AppPublisherURL=https://moe.gov.af/
AppSupportURL=
AppUpdatesURL=
DefaultDirName="{commonappdata}\SIL\ImageCollections\Afghan Children Read"
DefaultGroupName=
OutputBaseFilename=Install ACR Illustrations-{#SetupSetting("AppVersion")}
DisableProgramGroupPage=yes
LicenseFile=images-license.txt
InfoBeforeFile=info-to-show-in-installer.txt
OutputDir=output
Compression=none
SourceDir=".\"
DisableDirPage=yes
;SignTool=standard

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl";

[Files]
Source: "output\processed-images\*"; DestDir: "{app}\images"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "index.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "images-license.txt"; DestDir: "{app}"; Flags: ignoreversion

; NOTE: Don't use "Flags: ignoreversion" on any shared system files
; NOTE: Text in Dari/Pashto requires UTF-8 files that begin with a byte order marker (xFEFF, or 0xEF,0xBB,0xBF in UTF-8).
; If your text editor doesn't let you choose to add this in, see here for some ideas on how to do so:
; https://stackoverflow.com/questions/3127436/adding-bom-to-utf-8-files
