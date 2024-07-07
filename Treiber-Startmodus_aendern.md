------------------------------
Test: Startmodus eines Treibers ändern, hier am Beispiel NPCAP (Packet Capture Driver für Wireshark etc.)
------------------------------

### Alle Treiber mit Get-CimInstance anzeigen, Format Table, sortiert nach Property Name
	Get-CimInstance -ClassName Win32_SystemDriver | Sort-Object -Property name | Select-Object -Property Name, DisplayName, State, Status, Started | Format-Table

### Nur den NPCAP-Treiber mit Get-CimInstance anzeigen, Format Table, sortiert nach Property Name
	Get-CimInstance -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' } | Select-Object -Property Name, DisplayName, State, Status, Started | Format-Table

### gültige Startmodes für Driver gem. CIMWin32.mof: 
	"Boot", "System", "Auto", "Manual", "Disabled"

gültige Methoden für Win32_SystemDriver gem. https://learn.microsoft.com/de-de/windows/win32/cimwin32prov/win32-systemdriver

### Im Test gelang das Setzen des Startmodes über Get-CimInstance nicht 
### (Syntax ist noch relativ neu und nicht vertraut)
### daher erneuter Versuch über gwmi (Get-WmiObject), 
### Get-WMIObject enthält u.a. eine Methode ChangeStartMode 

### Handle auf das WMI-Objekt holen
	$wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }

### Objekt abfragen
	PS C:> $wmi
	DisplayName : Npcap Packet Driver (NPCAP)
	Name        : npcap
	State       : Running
	Status      : OK
	Started     : True

### Objekt abfragen, Property Startmode (aktueller Wert: "System")
	PS C:\> $wmi.StartMode
	System

### Setzen des Startmodus über die Methode ChangeStartMode
	PS C:\> $wmi.ChangeStartMode('Manual')
	Output:
		__GENUS          : 2
		__CLASS          : __PARAMETERS
		__SUPERCLASS     :
		__DYNASTY        : __PARAMETERS
		__RELPATH        :
		__PROPERTY_COUNT : 1
		__DERIVATION     : {}
		__SERVER         :
		__NAMESPACE      :
		__PATH           :
		ReturnValue      : 0
		PSComputerName   :

### Erneutes Abfragen gibt aber weiterhin 'System' aus, da veraltet. 
### Um den aktuellen Wert abzufragen, neues Handle holen
	$wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }

### Objekt nochmal abfragen, Property Startmode
	PS C:\> $wmi.StartMode
	Manual	

Success!

----------------------------------------------------------------------------------------
Test: wie ist der Status nach Ändern der Startart auf Manual und Reboot des Systems? 

	$wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }

	PS C:\> $wmi.StartMode
	System

Resultat: Computer says no!

Ach MS, nagel Dir doch ein Brett vors Knie!! ☠️😁

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

Using Windows PowerShell to Determine Service Launch Order
https://devblogs.microsoft.com/scripting/using-windows-powershell-to-determine-service-launch-order/
Get-WmiObject -Class win32_LoadOrderGroupServiceMembers |
ForEach-Object {
New-Object -TypeName psobject -Property `
   @{
     “GroupOrder”=([wmi]$_.GroupComponent).GroupOrder
     “GroupName”=([wmi]$_.GroupComponent).Name
     “ServiceName”=([wmi]$_.PartComponent).Name
     “Started”=([wmi]$_.PartComponent).Started
    }
} |
Where-Object { $_.started } |
Sort-Object -Property grouporder -Descending


--------------------------------------------
GroupOrder GroupName                 Started ServiceName
---------- ---------                 ------- -----------
        75 Core Security Extensions     True WindowsTrustedRTProxy
        75 Core Security Extensions     True IntelPMT
        75 Core Security Extensions     True intelpep
        75 Core Security Extensions     True WindowsTrustedRT
        73 PNP Filter                   True rdyboost
        73 PNP Filter                   True Serenum
        73 PNP Filter                   True fvevol
        73 PNP Filter                   True iorate
        73 PNP Filter                   True ksthunk
        72 Network                      True mpsdrv
        72 Network                      True srvnet
        72 Network                      True CSC
        72 Network                      True Dfsc
        72 Network                      True MsQuic
        72 Network                      True rdbss
        72 Network                      True Mup
        72 Network                      True mrxsmb
        72 Network                      True srv2
        72 Network                      True mrxsmb20
        72 Network                      True wtd
        72 Network                      True bowser
        71 Core                         True ACPI
        71 Core                         True CNG
        68 Extended Base                True HDAudBus
        68 Extended Base                True Serial
        68 Extended Base                True AmdPPM
        68 Extended Base                True amdgpio2
        68 Extended Base                True CompositeBus
        68 Extended Base                True HidUsb
        68 Extended Base                True umbus
        68 Extended Base                True Vid
        68 Extended Base                True swenum
        68 Extended Base                True WmiAcpi
        64 NetworkProvider              True mpssvc
        64 NetworkProvider              True LanmanWorkstation
        64 NetworkProvider              True BFE
        62 SpoolerGroup                 True Spooler
        61 SchedulerGroup               True Schedule
        60 ShellSvcGroup                True ShellHWDetection
        59 NetBIOSGroup                 True NetBIOS
        57 TDI                          True Wcmsvc
        57 TDI                          True Dnscache
        57 TDI                          True lmhosts
        57 TDI                          True DusmSvc
        57 TDI                          True WlanSvc
        57 TDI                          True Dhcp
        56 NDIS                         True rspndr
        56 NDIS                         True rt640x64
        56 NDIS                         True npcap
        56 NDIS                         True lltdio
        56 NDIS                         True kdnic
        56 NDIS                         True vwififlt
        56 NDIS                         True wanarp
        56 NDIS                         True VBoxNetAdp
        56 NDIS                         True Psched
        56 NDIS                         True NativeWifiP
        56 NDIS                         True VBoxNetLwf
        56 NDIS                         True NdisTapi
        56 NDIS                         True NdisCap
        56 NDIS                         True Ndisuio
        56 NDIS                         True MsLldp
        55 PNP_TDI                      True afunix
        55 PNP_TDI                      True AFD
        55 PNP_TDI                      True WFPLWFS
        55 PNP_TDI                      True ndproxy
        55 PNP_TDI                      True tdx
        55 PNP_TDI                      True Tcpip
        55 PNP_TDI                      True NetBT
        54 Cryptography                 True amdpsp
        54 Cryptography                 True KSecPkg
        53 PlugPlay                     True TextInputManagementService
        53 PlugPlay                     True PlugPlay
        53 PlugPlay                     True Power
        52 MS_WindowsLocalValidation    True SamSs
        50 AudioGroup                   True FontCache
        50 AudioGroup                   True AudioEndpointBuilder
        50 AudioGroup                   True Audiosrv
        49 ProfSvc_Group                True SENS
        49 ProfSvc_Group                True Themes
        49 ProfSvc_Group                True SysMain
        49 ProfSvc_Group                True ProfSvc
        47 Event Log                    True EventLog
        46 COM Infrastructure           True DcomLaunch
        46 COM Infrastructure           True RpcEptMapper
        46 COM Infrastructure           True LSM
        46 COM Infrastructure           True RpcSs
        46 COM Infrastructure           True BrokerInfrastructure
        45 NDIS Wrapper                 True NDIS
        43 File System                  True Msfs
        43 File System                  True Npfs
        43 File System                  True CimFS
        41 Video                        True BasicDisplay
        41 Video                        True nvlddmkm
        41 Video                        True BasicRender
        41 Video                        True NVDisplay.ContainerLocalSystem
        40 Video Init                   True DXGKrnl
        35 Base                         True USBHUB3
        35 Base                         True Beep
        35 Base                         True condrv
        35 Base                         True usbccgp
        35 Base                         True KSecDD
        35 Base                         True Null
        34 Boot File System             True Ntfs
        34 Boot File System             True fastfat
        33 Filter                       True CLFS
        32 FSFilter Top                 True bindflt
        31 FSFilter Activity Monitor    True UCPD
        29 FSFilter Anti-Virus          True WdFilter
        25 FSFilter Quota Management    True storqosflt
        22 FSFilter HSM                 True CldFlt
        20 FSFilter Compression         True Wof
        19 FSFilter Encryption          True FileCrypt
        18 FSFilter Virtualization      True bfs
        18 FSFilter Virtualization      True luafv
        18 FSFilter Virtualization      True wcifs
        13 FSFilter Bottom              True FileInfo
        11 FSFilter Infrastructure      True FltMgr
        10 SCSI CDROM Class             True cdrom
         9 SCSI Class                   True EhStorClass
         6 SCSI miniport                True stornvme
         6 SCSI miniport                True storahci
         5 System Bus Extender          True spaceport
         5 System Bus Extender          True volmgrx
         5 System Bus Extender          True GPIOClx0101
         5 System Bus Extender          True volmgr
         5 System Bus Extender          True mountmgr
         4 Boot Bus Extender            True acpiex
         4 Boot Bus Extender            True msisadrv
         4 Boot Bus Extender            True TPM
         4 Boot Bus Extender            True partmgr
         4 Boot Bus Extender            True pci
         4 Boot Bus Extender            True Ucx01000
         4 Boot Bus Extender            True pdc
         4 Boot Bus Extender            True vdrvroot
         3 WdfLoadGroup                 True Wdf01000
         1 System Reserved              True pcw




----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------




https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-loadordergroup#:~:text=The%20Win32_LoadOrderGroup%20WMI%20class%20represents%20a%20group%20of,presence%20of%20the%20antecedent%20services%20to%20function%20correctly.

gwmi Win32_LoadOrderGroup

roupOrder Name
---------- ----
         1 System Reserved
         2 EMS
         3 WdfLoadGroup
         4 Boot Bus Extender
         5 System Bus Extender
         6 SCSI miniport
         7 Port
         8 Primary Disk
         9 SCSI Class
        10 SCSI CDROM Class
        11 FSFilter Infrastructure
        12 FSFilter System
        13 FSFilter Bottom
        14 FSFilter Copy Protection
        15 FSFilter Security Enhancer
        16 FSFilter Open File
        17 FSFilter Physical Quota Management
        18 FSFilter Virtualization
        19 FSFilter Encryption
        20 FSFilter Compression
        21 FSFilter Imaging
        22 FSFilter HSM
        23 FSFilter Cluster File System
        24 FSFilter System Recovery
        25 FSFilter Quota Management
        26 FSFilter Content Screener
        27 FSFilter Continuous Backup
        28 FSFilter Replication
        29 FSFilter Anti-Virus
        30 FSFilter Undelete
        31 FSFilter Activity Monitor
        32 FSFilter Top
        33 Filter
        34 Boot File System
        35 Base
        36 Pointer Port
        37 Keyboard Port
        38 Pointer Class
        39 Keyboard Class
        40 Video Init
        41 Video
        42 Video Save
        43 File System
        44 Streams Drivers
        45 NDIS Wrapper
        46 COM Infrastructure
        47 Event Log
        48 PerceptionGroup
        49 ProfSvc_Group
        50 AudioGroup
        51 UIGroup
        52 MS_WindowsLocalValidation
        53 PlugPlay
        54 Cryptography
        55 PNP_TDI
        56 NDIS
        57 TDI
        58 iSCSI
        59 NetBIOSGroup
        60 ShellSvcGroup
        61 SchedulerGroup
        62 SpoolerGroup
        63 SmartCardGroup
        64 NetworkProvider
        65 MS_WindowsRemoteValidation
        66 NetDDEGroup
        67 Parallel arbitrator
        68 Extended Base
        69 PCI Configuration
        70 MS Transactions
        71 Core
        72 Network
        73 PNP Filter
        74 System
        75 Core Security Extensions
        76 NetworkService
        77 Hyper-V Parsers
        78 Early-Launch
        79 LocalService
        
        
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


        
History meiner Powershell-Sitzung

    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : MsSecFlt
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Minifilter für Microsoft-SEC (Security Events Component)
    Description             : Minifilter für Microsoft-SEC (Security Events Component)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Minifilter für Microsoft-SEC (Security Events Component)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\mssecflt.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : MsSecWfp
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Security WFP Callout Driver
    Description             : Microsoft Security WFP Callout Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Security WFP Callout Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\mssecwfp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : mssmbios
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-Systemverwaltungs-BIOS-Treiber
    Description             : Microsoft-Systemverwaltungs-BIOS-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft-Systemverwaltungs-BIOS-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\mssmbios.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : MSTEE
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Streaming Tee/Sink-to-Sink-Konvertierung
    Description             : Microsoft Streaming Tee/Sink-to-Sink-Konvertierung
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Streaming Tee/Sink-to-Sink-Konvertierung
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\MSTEE.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 19
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : MTConfig
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Input Configuration Driver
    Description             : Microsoft Input Configuration Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Input Configuration Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\MTConfig.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 30
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Mup
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Mup
    Description             : Mup
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Mup
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\Drivers\mup.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : mvumis
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : mvumis
    Description             : mvumis
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : mvumis
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\mvumis.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 17
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NativeWifiP
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NativeWiFi-Filter
    Description             : NativeWiFi-Filter
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NativeWiFi-Filter
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\nwifi.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ndfltr
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : NetworkDirect-Dienst
    Description             : NetworkDirect-Dienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : NetworkDirect-Dienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ndfltr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 2
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NDIS
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NDIS-Systemtreiber
    Description             : NDIS-Systemtreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NDIS-Systemtreiber
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\ndis.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NdisCap
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-NDIS-Aufzeichnung
    Description             : Microsoft-NDIS-Aufzeichnung
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft-NDIS-Aufzeichnung
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ndiscap.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NdisImPlatform
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-Multiplexorprotokoll für Netzwerkadapter
    Description             : Microsoft-Multiplexorprotokoll für Netzwerkadapter
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-Multiplexorprotokoll für Netzwerkadapter
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\NdisImPlatform.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NdisTapi
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : RAS-NDIS-TAPI-Treiber
    Description             : RAS-NDIS-TAPI-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : RAS-NDIS-TAPI-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\ndistapi.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Ndisuio
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NDIS Usermode I/O Protocol
    Description             : NDIS Usermode I/O Protocol
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NDIS Usermode I/O Protocol
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ndisuio.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NdisVirtualBus
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Enumerator für virtuelle Microsoft-Netzwerkadapter
    Description             : Enumerator für virtuelle Microsoft-Netzwerkadapter
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Enumerator für virtuelle Microsoft-Netzwerkadapter
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\NdisVirtualBus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NdisWan
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : RAS-NDIS-WAN-Treiber
    Description             : RAS-NDIS-WAN-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : RAS-NDIS-WAN-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ndiswan.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ndiswanlegacy
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : NDIS-WAN-Legacytreiber für den Remotezugriff
    Description             : NDIS-WAN-Legacytreiber für den Remotezugriff
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : NDIS-WAN-Legacytreiber für den Remotezugriff
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\ndiswan.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NDKPerf
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : NDKPerf Driver
    Description             : NDKPerf Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : NDKPerf Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\NDKPerf.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NDKPing
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : NDKPing Driver
    Description             : NDKPing Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : NDKPing Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\NDKPing.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ndproxy
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NDIS Proxy Driver
    Description             : NDIS Proxy Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NDIS Proxy Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\NDProxy.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Ndu
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Windows Network Data Usage Monitoring Driver
    Description             : Windows Network Data Usage Monitoring Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Windows Network Data Usage Monitoring Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Ndu.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NetAdapterCx
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Network Adapter Wdf Class Extension Library
    Description             : Network Adapter Wdf Class Extension Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Network Adapter Wdf Class Extension Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\NetAdapterCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NetBIOS
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NetBIOS Interface
    Description             : NetBIOS Interface
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NetBIOS Interface
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\netbios.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NetBT
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NetBT
    Description             : NetBT
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NetBT
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\netbt.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : netvsc
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : netvsc
    Description             : netvsc
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : netvsc
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\netvsc.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 47
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : npcap
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Npcap Packet Driver (NPCAP)
    Description             : Npcap Packet Driver (NPCAP)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Npcap Packet Driver (NPCAP)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\npcap.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 25
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Npfs
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Npfs
    Description             : Npfs
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Npfs
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Npfs.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : npsvctrig
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Named pipe service trigger provider
    Description             : Named pipe service trigger provider
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Named pipe service trigger provider
    ErrorControl            : Severe
    PathName                : C:\WINDOWS\system32\drivers\npsvctrig.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : nsiproxy
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NSI Proxy Service Driver
    Description             : NSI Proxy Service Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NSI Proxy Service Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\nsiproxy.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Ntfs
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Ntfs
    Description             : Ntfs
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Ntfs
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Ntfs.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Null
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Null
    Description             : Null
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Null
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Null.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : nvdimm
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-NVDIMM-Gerätetreiber
    Description             : Microsoft-NVDIMM-Gerätetreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-NVDIMM-Gerätetreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\nvdimm.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : NVHDA
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Service for NVIDIA High Definition Audio Driver
    Description             : Service for NVIDIA High Definition Audio Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Service for NVIDIA High Definition Audio Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\nvhda64v.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : nvlddmkm
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : nvlddmkm
    Description             : nvlddmkm
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : nvlddmkm
    ErrorControl            : Ignore
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\nv_dispig.inf_amd64_7e5fd280efaa5445\nvlddmkm.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 6
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : nvmedisk
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft NVMe-Datenträgertreiber
    Description             : Microsoft NVMe-Datenträgertreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft NVMe-Datenträgertreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\nvmedisk.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : nvraid
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : nvraid
    Description             : nvraid
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : nvraid
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\nvraid.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 7
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : nvstor
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : nvstor
    Description             : nvstor
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : nvstor
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\nvstor.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 18
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : P9Rdr
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Plan 9 Redirector Driver
    Description             : Plan 9 Redirector Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Plan 9 Redirector Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\p9rdr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Parport
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Treiber für parallelen Anschluss
    Description             : Treiber für parallelen Anschluss
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Treiber für parallelen Anschluss
    ErrorControl            : Ignore
    PathName                : C:\WINDOWS\system32\drivers\parport.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : partmgr
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Partitionstreiber
    Description             : Partitionstreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Partitionstreiber
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\partmgr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pci
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : PCI-Bus-Treiber
    Description             : PCI-Bus-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : PCI-Bus-Treiber
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\pci.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 3
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pciide
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : pciide
    Description             : pciide
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : pciide
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\pciide.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 9
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pcmcia
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : pcmcia
    Description             : pcmcia
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : pcmcia
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\pcmcia.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pcw
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Performance Counters for Windows Driver
    Description             : Performance Counters for Windows Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Performance Counters for Windows Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\pcw.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pdc
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : pdc
    Description             : pdc
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : pdc
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\pdc.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : PEAUTH
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : PEAUTH
    Description             : PEAUTH
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : PEAUTH
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\peauth.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : percsas2i
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : percsas2i
    Description             : percsas2i
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : percsas2i
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\percsas2i.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 19
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : percsas3i
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : percsas3i
    Description             : percsas3i
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : percsas3i
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\percsas3i.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 20
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : PktMon
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Packet Monitor Driver
    Description             : Packet Monitor Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Packet Monitor Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\PktMon.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pmem
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-Treiber für Datenträger mit persistentem Speicher
    Description             : Microsoft-Treiber für Datenträger mit persistentem Speicher
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-Treiber für Datenträger mit persistentem Speicher
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\pmem.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : PNPMEM
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Speichermodultreiber
    Description             : Microsoft Speichermodultreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Speichermodultreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\pnpmem.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : portcfg
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : portcfg
    Description             : portcfg
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : portcfg
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\portcfg.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : PptpMiniport
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : WAN-Miniport (PPTP)
    Description             : WAN-Miniport (PPTP)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : WAN-Miniport (PPTP)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\raspptp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : PRM
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft PRM-Treiber
    Description             : Microsoft PRM-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft PRM-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\prm.inf_amd64_de435dc5c75d64a5\PRM.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Processor
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Prozessortreiber
    Description             : Prozessortreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Prozessortreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\processr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 26
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Psched
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : QoS-Paketplaner
    Description             : QoS-Paketplaner
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : QoS-Paketplaner
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\pacer.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : pvscsi
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : pvscsi Storage Controller Driver
    Description             : pvscsi Storage Controller Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : pvscsi Storage Controller Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\pvscsii.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 21
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : PxHlpa64
    State                   : Stopped
    ExitCode                : 31
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : PxHlpa64
    Description             : PxHlpa64
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Unknown
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         :
    DisplayName             : PxHlpa64
    ErrorControl            : Unknown
    PathName                :
    ServiceType             : Unknown
    StartName               :
    TagId                   :
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : QWAVEdrv
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : QWAVE-Treiber
    Description             : QWAVE-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : QWAVE-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\qwavedrv.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Ramdisk
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Windows RAM Disk Driver
    Description             : Windows RAM Disk Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Windows RAM Disk Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\ramdisk.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RasAcd
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Remote Access Auto Connection Driver
    Description             : Remote Access Auto Connection Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Remote Access Auto Connection Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\rasacd.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RasAgileVpn
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : WAN-Miniport (IKEv2)
    Description             : WAN-Miniport (IKEv2)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : WAN-Miniport (IKEv2)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\AgileVpn.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Rasl2tp
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : WAN-Miniport (L2TP)
    Description             : WAN-Miniport (L2TP)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : WAN-Miniport (L2TP)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rasl2tp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RasPppoe
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Remotezugriff-PPPOE-Treiber
    Description             : Remotezugriff-PPPOE-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Remotezugriff-PPPOE-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\raspppoe.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RasSstp
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : WAN-Miniport (SSTP)
    Description             : WAN-Miniport (SSTP)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : WAN-Miniport (SSTP)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rassstp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : rdbss
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Umgeleitetes Puffersubsystem
    Description             : Umgeleitetes Puffersubsystem
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Umgeleitetes Puffersubsystem
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\rdbss.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 4
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : rdpbus
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Redirector-Bustreiber für Remotedesktop-Gerät
    Description             : Redirector-Bustreiber für Remotedesktop-Gerät
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Redirector-Bustreiber für Remotedesktop-Gerät
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rdpbus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RDPDR
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Redirector-Gerätetreiber für Remotedesktop
    Description             : Redirector-Gerätetreiber für Remotedesktop
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Redirector-Gerätetreiber für Remotedesktop
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rdpdr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RdpVideoMiniport
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Remote Desktop Video Miniport Driver
    Description             : Remote Desktop Video Miniport Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Remote Desktop Video Miniport Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rdpvideominiport.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : rdyboost
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : ReadyBoost
    Description             : ReadyBoost
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : ReadyBoost
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\rdyboost.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ReFS
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : ReFS
    Description             : ReFS
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : ReFS
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ReFS.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ReFSv1
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : ReFSv1
    Description             : ReFSv1
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : ReFSv1
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ReFSv1.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RFCOMM
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Bluetooth Device (RFCOMM Protocol TDI)
    Description             : Bluetooth Device (RFCOMM Protocol TDI)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Bluetooth Device (RFCOMM Protocol TDI)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rfcomm.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : rhproxy
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Ressourcenhub-Proxytreiber
    Description             : Ressourcenhub-Proxytreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Ressourcenhub-Proxytreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rhproxy.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 22
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : RoutePolicy
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Route Policy Service
    Description             : Microsoft Route Policy Service
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Route Policy Service
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\RoutePolicy.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : rspndr
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Antwort für Verbindungsschicht-Topologieerkennung
    Description             : Antwort für Verbindungsschicht-Topologieerkennung
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Antwort für Verbindungsschicht-Topologieerkennung
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rspndr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : rt640x64
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Realtek RT640 NT Driver
    Description             : Realtek RT640 NT Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Realtek RT640 NT Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\rt640x64.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 13
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : s3cap
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : s3cap
    Description             : s3cap
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : s3cap
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vms3cap.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 3
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : sbp2port
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Bustreiber für SBP2-Transport/Protokoll
    Description             : Bustreiber für SBP2-Transport/Protokoll
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Bustreiber für SBP2-Transport/Protokoll
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\sbp2port.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : scfilter
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Filtertreiber für Smartcards der Plug & Play-Klasse
    Description             : Filtertreiber für Smartcards der Plug & Play-Klasse
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Filtertreiber für Smartcards der Plug & Play-Klasse
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\scfilter.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : scmbus
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-Treiber für Speicherklassen-Speicherbus
    Description             : Microsoft-Treiber für Speicherklassen-Speicherbus
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-Treiber für Speicherklassen-Speicherbus
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\scmbus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : sdbus
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : sdbus
    Description             : sdbus
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : sdbus
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\sdbus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 11
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SDFRd
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : SDF-Reflektor
    Description             : SDF-Reflektor
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : SDF-Reflektor
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SDFRd.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : sdstor
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Treiber für SD-Speicherport
    Description             : Treiber für SD-Speicherport
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Treiber für SD-Speicherport
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\sdstor.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SerCx
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Serial UART Support Library
    Description             : Serial UART Support Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Serial UART Support Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SerCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SerCx2
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Serial UART Support Library
    Description             : Serial UART Support Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Serial UART Support Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SerCx2.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Serenum
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Serenum-Filtertreiber
    Description             : Serenum-Filtertreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Serenum-Filtertreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\serenum.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 5
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Serial
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Treiber für seriellen Anschluss
    Description             : Treiber für seriellen Anschluss
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Treiber für seriellen Anschluss
    ErrorControl            : Ignore
    PathName                : C:\WINDOWS\system32\drivers\serial.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 32
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : sermouse
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Serieller Maustreiber
    Description             : Serieller Maustreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Serieller Maustreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\sermouse.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : sfloppy
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : High-Capacity-Diskettenlaufwerk
    Description             : High-Capacity-Diskettenlaufwerk
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : High-Capacity-Diskettenlaufwerk
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\sfloppy.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SgrmAgent
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : System Guard Runtime Monitor Agent
    Description             : System Guard Runtime Monitor Agent
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Disabled
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : System Guard Runtime Monitor Agent
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SgrmAgent.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SiSRaid2
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : SiSRaid2
    Description             : SiSRaid2
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : SiSRaid2
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SiSRaid2.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 22
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SiSRaid4
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : SiSRaid4
    Description             : SiSRaid4
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : SiSRaid4
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\sisraid4.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 23
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SmartSAMD
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : SmartSAMD
    Description             : SmartSAMD
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : SmartSAMD
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SmartSAMD.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 259
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : smbdirect
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : smbdirect
    Description             : smbdirect
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : smbdirect
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\smbdirect.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : spaceparser
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : spaceparser
    Description             : spaceparser
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : spaceparser
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\spaceparser.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : spaceport
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Treiber für Speicherplätze
    Description             : Treiber für Speicherplätze
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Treiber für Speicherplätze
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\spaceport.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 8
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SpatialGraphFilter
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Holographic Spatial Graph Filter
    Description             : Holographic Spatial Graph Filter
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Holographic Spatial Graph Filter
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SpatialGraphFilter.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : SpbCx
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Simple Peripheral Bus Support Library
    Description             : Simple Peripheral Bus Support Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Simple Peripheral Bus Support Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\SpbCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : srv2
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Server-SMB-Treiber 2.xxx
    Description             : Server-SMB-Treiber 2.xxx
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Server-SMB-Treiber 2.xxx
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\srv2.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : srvnet
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : srvnet
    Description             : srvnet
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : srvnet
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\srvnet.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : stexstor
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : stexstor
    Description             : stexstor
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : stexstor
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\stexstor.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 25
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : storahci
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Standardmäßiger SATA AHCI-Treiber von Microsoft
    Description             : Standardmäßiger SATA AHCI-Treiber von Microsoft
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Standardmäßiger SATA AHCI-Treiber von Microsoft
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\storahci.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 32
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : storflt
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Hyper-V-Speicherbeschleunigung
    Description             : Microsoft Hyper-V-Speicherbeschleunigung
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Hyper-V-Speicherbeschleunigung
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vmstorfl.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 46
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : stornvme
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Standardmäßiger NVM Express-Treiber von Microsoft
    Description             : Standardmäßiger NVM Express-Treiber von Microsoft
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Standardmäßiger NVM Express-Treiber von Microsoft
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\stornvme.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 33
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : storqosflt
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : QoS-Filter für Speicher – Treiber
    Description             : QoS-Filter für Speicher – Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : QoS-Filter für Speicher – Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\storqosflt.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : storufs
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Universal Flash Storage (UFS)-Treiber
    Description             : Microsoft Universal Flash Storage (UFS)-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Universal Flash Storage (UFS)-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\storufs.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : storvsc
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : storvsc
    Description             : storvsc
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : storvsc
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\storvsc.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 26
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : swenum
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Software-Bus-Treiber
    Description             : Software-Bus-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Software-Bus-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\swenum.inf_amd64_d84a235075a8ff73\swenum.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 23
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : tap0901
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : TAP-Windows Adapter V9
    Description             : TAP-Windows Adapter V9
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : TAP-Windows Adapter V9
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tap0901.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 21
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Tcpip
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : TCP/IP-Protokolltreiber
    Description             : TCP/IP-Protokolltreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : TCP/IP-Protokolltreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tcpip.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 3
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Tcpip6
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : @todo.dll,-100;Microsoft IPv6 Protocol Driver
    Description             : @todo.dll,-100;Microsoft IPv6 Protocol Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : @todo.dll,-100;Microsoft IPv6 Protocol Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tcpip.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 3
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : tcpipreg
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : @%SystemRoot%\System32\drivers\tcpipreg.sys,-10110,
    Description             : @%SystemRoot%\System32\drivers\tcpipreg.sys,-10110,
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : @%SystemRoot%\System32\drivers\tcpipreg.sys,-10110,
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tcpipreg.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : tdx
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : NetIO-Legacy-TDI-Supporttreiber
    Description             : NetIO-Legacy-TDI-Supporttreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : NetIO-Legacy-TDI-Supporttreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\tdx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 4
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : terminpt
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Remotedesktop-Eingabetreiber von Microsoft
    Description             : Remotedesktop-Eingabetreiber von Microsoft
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Remotedesktop-Eingabetreiber von Microsoft
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\terminpt.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 43
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : teVirtualMIDI64
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : teVirtualMIDI - Virtual MIDI Driver x64
    Description             : teVirtualMIDI - Virtual MIDI Driver x64
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : teVirtualMIDI - Virtual MIDI Driver x64
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\teVirtualMIDI64.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : TPM
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : TPM
    Description             : TPM
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : TPM
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tpm.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 5
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : TsUsbFlt
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB-Hub-Klassenfiltertreiber für Remotedesktop
    Description             : USB-Hub-Klassenfiltertreiber für Remotedesktop
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB-Hub-Klassenfiltertreiber für Remotedesktop
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tsusbflt.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : TsUsbGD
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Allgemeines Remotedesktop-USB-Gerät
    Description             : Allgemeines Remotedesktop-USB-Gerät
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Allgemeines Remotedesktop-USB-Gerät
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\TsUsbGD.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 24
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : tsusbhub
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Remote Desktop USB Hub
    Description             : Remote Desktop USB Hub
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Remote Desktop USB Hub
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tsusbhub.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 10
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : tunnel
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-Tunnelminiport-Adaptertreiber
    Description             : Microsoft-Tunnelminiport-Adaptertreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-Tunnelminiport-Adaptertreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\tunnel.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UASPStor
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Per USB angeschlossener SCSI (UAS)-Treiber
    Description             : Per USB angeschlossener SCSI (UAS)-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Per USB angeschlossener SCSI (UAS)-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\uaspstor.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UcmCx0101
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB Connector Manager KMDF Class Extension
    Description             : USB Connector Manager KMDF Class Extension
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB Connector Manager KMDF Class Extension
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\Drivers\UcmCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UcmTcpciCx0101
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : UCM-TCPCI KMDF Class Extension
    Description             : UCM-TCPCI KMDF Class Extension
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : UCM-TCPCI KMDF Class Extension
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\Drivers\UcmTcpciCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UcmUcsiAcpiClient
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : UCM-UCSI ACPI-Client
    Description             : UCM-UCSI ACPI-Client
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : UCM-UCSI ACPI-Client
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\UcmUcsiAcpiClient.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UcmUcsiCx0101
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : UCM-UCSI KMDF Class Extension
    Description             : UCM-UCSI KMDF Class Extension
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : UCM-UCSI KMDF Class Extension
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\Drivers\UcmUcsiCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UCPD
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : UCPD
    Description             : UCPD
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : UCPD
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\UCPD.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Ucx01000
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : USB Host Support Library
    Description             : USB Host Support Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : USB Host Support Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ucx01000.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UdeCx
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB Device Emulation Support Library
    Description             : USB Device Emulation Support Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB Device Emulation Support Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\udecx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : udfs
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : udfs
    Description             : udfs
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Disabled
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : udfs
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\udfs.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UEFI
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : UEFI-Treiber von Microsoft
    Description             : UEFI-Treiber von Microsoft
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : UEFI-Treiber von Microsoft
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\uefi.inf_amd64_3abb917fc03c6fa8\UEFI.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UevAgentDriver
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : UevAgentDriver
    Description             : UevAgentDriver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Disabled
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : UevAgentDriver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\UevAgentDriver.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Ufx01000
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB Function Class Extension
    Description             : USB Function Class Extension
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB Function Class Extension
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ufx01000.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UfxChipidea
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Chipidea-Controller (USB)
    Description             : Chipidea-Controller (USB)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Chipidea-Controller (USB)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\ufxchipidea.inf_amd64_a479fc09885aecbd\UfxChipidea.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 18
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ufxsynopsys
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Synopsys-Controller (USB)
    Description             : Synopsys-Controller (USB)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Synopsys-Controller (USB)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ufxsynopsys.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 19
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : umbus
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : UMBusenumerator-Treiber
    Description             : UMBusenumerator-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : UMBusenumerator-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\umbus.inf_amd64_3702527f0d5a77cf\umbus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 33
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : umc_audio
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : umc_audio
    Description             : umc_audio
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : umc_audio
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\umc_audio.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : umc_audioks
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : umc_audioks
    Description             : umc_audioks
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : umc_audioks
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\umc_audioks.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UmPass
    State                   : Stopped
    ExitCode                : 31
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-UMPass-Treiber
    Description             : Microsoft-UMPass-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-UMPass-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\umpass.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 14
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UrsChipidea
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Chipidea USB Role-Switch-Treiber
    Description             : Chipidea USB Role-Switch-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Chipidea USB Role-Switch-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\urschipidea.inf_amd64_1dcac3970ff32f7b\urschipidea.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 15
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UrsCx01000
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB Role-Switch Support Library
    Description             : USB Role-Switch Support Library
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB Role-Switch Support Library
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\urscx01000.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : UrsSynopsys
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Synopsys USB Role-Switch-Treiber
    Description             : Synopsys USB Role-Switch-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Synopsys USB Role-Switch-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\urssynopsys.inf_amd64_d123de445c8c5235\urssynopsys.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 16
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Usb4DeviceRouter
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB4-Geräte-Routerdienst
    Description             : USB4-Geräte-Routerdienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB4-Geräte-Routerdienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\usb4devicerouter.inf_amd64_25bbbecf5717d57c\Usb4DeviceRouter.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 21
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Usb4HostRouter
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB4-Hostrouterdienst
    Description             : USB4-Hostrouterdienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB4-Hostrouterdienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\usb4hostrouter.inf_amd64_965fa3dfd314155c\Usb4HostRouter.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbaudio
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB-Audiotreiber (WDM)
    Description             : USB-Audiotreiber (WDM)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB-Audiotreiber (WDM)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbaudio.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbaudio2
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB Audio 2.0-Dienst
    Description             : USB Audio 2.0-Dienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB Audio 2.0-Dienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbaudio2.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbccgp
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Standard-USB-Haupttreiber
    Description             : Microsoft Standard-USB-Haupttreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft Standard-USB-Haupttreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbccgp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 11
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbcir
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : eHome-Infrarotempfänger (USBCIR)
    Description             : eHome-Infrarotempfänger (USBCIR)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : eHome-Infrarotempfänger (USBCIR)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbcir.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 15
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbehci
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Miniporttreiber für erweiterten Microsoft USB 2.0-Hostcontroller
    Description             : Miniporttreiber für erweiterten Microsoft USB 2.0-Hostcontroller
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Miniporttreiber für erweiterten Microsoft USB 2.0-Hostcontroller
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbehci.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 24
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbhub
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft USB-Standardhubtreiber
    Description             : Microsoft USB-Standardhubtreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft USB-Standardhubtreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbhub.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 20
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : USBHUB3
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Hochgeschwindigkeits-Hub (SuperSpeed)
    Description             : Hochgeschwindigkeits-Hub (SuperSpeed)
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Hochgeschwindigkeits-Hub (SuperSpeed)
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\UsbHub3.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 22
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbohci
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Miniporttreiber für Microsoft USB Open Host-Controller
    Description             : Miniporttreiber für Microsoft USB Open Host-Controller
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Miniporttreiber für Microsoft USB Open Host-Controller
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbohci.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 23
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbprint
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft USB-Druckerklasse
    Description             : Microsoft USB-Druckerklasse
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft USB-Druckerklasse
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbprint.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 20
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbser
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft-Treiber für serielle USB-Geräte
    Description             : Microsoft-Treiber für serielle USB-Geräte
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft-Treiber für serielle USB-Geräte
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbser.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : USBSTOR
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : USB-Massenspeichertreiber
    Description             : USB-Massenspeichertreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : USB-Massenspeichertreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\USBSTOR.SYS
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : usbuhci
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Miniporttreiber für universellen Microsoft USB-Hostcontroller
    Description             : Miniporttreiber für universellen Microsoft USB-Hostcontroller
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Miniporttreiber für universellen Microsoft USB-Hostcontroller
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\usbuhci.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 25
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : USBXHCI
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : USB-xHCI-kompatibler Hostcontroller
    Description             : USB-xHCI-kompatibler Hostcontroller
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : USB-xHCI-kompatibler Hostcontroller
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\USBXHCI.SYS
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VBoxNetAdp
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : VirtualBox NDIS 6.0 Miniport Service
    Description             : VirtualBox NDIS 6.0 Miniport Service
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : VirtualBox NDIS 6.0 Miniport Service
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\VBoxNetAdp6.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 14
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VBoxNetLwf
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : VirtualBox NDIS6 Bridged Networking Service
    Description             : VirtualBox NDIS6 Bridged Networking Service
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : VirtualBox NDIS6 Bridged Networking Service
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\VBoxNetLwf.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 24
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VBoxSup
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : VirtualBox Service
    Description             : VirtualBox Service
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : VirtualBox Service
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\VBoxSup.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VBoxUSBMon
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : VirtualBox USB Monitor Service
    Description             : VirtualBox USB Monitor Service
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : VirtualBox USB Monitor Service
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\VBoxUSBMon.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vdrvroot
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft virtueller Datenträgerenumerator
    Description             : Microsoft virtueller Datenträgerenumerator
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft virtueller Datenträgerenumerator
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\vdrvroot.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 4
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VerifierExt
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Treiberüberprüfungserweiterung
    Description             : Treiberüberprüfungserweiterung
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Treiberüberprüfungserweiterung
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\VerifierExt.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vhdmp
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : vhdmp
    Description             : vhdmp
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : vhdmp
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vhdmp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 34
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vhf
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Virtual HID Framework (VHF)-Treiber
    Description             : Virtual HID Framework (VHF)-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Virtual HID Framework (VHF)-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vhf.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 12
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Vid
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Vid
    Description             : Vid
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Vid
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Vid.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 42
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VirtualRender
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : VirtualRender
    Description             : VirtualRender
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : VirtualRender
    ErrorControl            : Ignore
    PathName                : C:\WINDOWS\system32\DriverStore\FileRepository\vrd.inf_amd64_df3fa89d8f6bbc88\vrd.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vmbus
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Bus des virtuellen Computers
    Description             : Bus des virtuellen Computers
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Bus des virtuellen Computers
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vmbus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 12
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VMBusHID
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : VMBusHID
    Description             : VMBusHID
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : VMBusHID
    ErrorControl            : Ignore
    PathName                : C:\WINDOWS\system32\drivers\VMBusHID.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 44
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vmgid
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Hyper-V-Gastinfrastrukturtreiber
    Description             : Microsoft Hyper-V-Gastinfrastrukturtreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Hyper-V-Gastinfrastrukturtreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vmgid.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : volmgr
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Treiber für Volume-Manager
    Description             : Treiber für Volume-Manager
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Treiber für Volume-Manager
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\volmgr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 9
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : volmgrx
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Dynamischer Volume-Manager
    Description             : Dynamischer Volume-Manager
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Dynamischer Volume-Manager
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\volmgrx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 10
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : volsnap
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Volumeschattenkopie-Treiber
    Description             : Volumeschattenkopie-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Volumeschattenkopie-Treiber
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\volsnap.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : volume
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Volumetreiber
    Description             : Volumetreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Volumetreiber
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\volume.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vpci
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Hyper-V Virtual PCI Bus
    Description             : Microsoft Hyper-V Virtual PCI Bus
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Hyper-V Virtual PCI Bus
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vpci.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 13
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vsmraid
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : vsmraid
    Description             : vsmraid
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : vsmraid
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vsmraid.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 26
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : VSTXRAID
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Windows-Treiber für VIA StorX RAID-Speichercontroller
    Description             : Windows-Treiber für VIA StorX RAID-Speichercontroller
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Windows-Treiber für VIA StorX RAID-Speichercontroller
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vstxraid.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 27
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vwifibus
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Virtual Wireless Bus Driver
    Description             : Virtual Wireless Bus Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Virtual Wireless Bus Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vwifibus.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : vwififlt
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Virtual WiFi Filter Driver
    Description             : Virtual WiFi Filter Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : System
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Virtual WiFi Filter Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\vwififlt.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WacomPen
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Wacom HID-Treiber für seriellen Stift
    Description             : Wacom HID-Treiber für seriellen Stift
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Wacom HID-Treiber für seriellen Stift
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wacompen.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 31
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : wanarp
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Remotezugriff-IP-ARP-Treiber
    Description             : Remotezugriff-IP-ARP-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Remotezugriff-IP-ARP-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\wanarp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : wanarpv6
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Remotezugriff-IPv6-ARP-Treiber
    Description             : Remotezugriff-IPv6-ARP-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Remotezugriff-IPv6-ARP-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\wanarp.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : wcifs
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Windows Container Isolation
    Description             : Windows Container Isolation
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Windows Container Isolation
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wcifs.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WdBoot
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Defender Antivirus-Starttreiber
    Description             : Microsoft Defender Antivirus-Starttreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Microsoft Defender Antivirus-Starttreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wd\WdBoot.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Wdf01000
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Kernelmodustreiber-Frameworkdienst
    Description             : Kernelmodustreiber-Frameworkdienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Kernelmodustreiber-Frameworkdienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Wdf01000.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WdFilter
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Defender Antivirus-Minifiltertreiber
    Description             : Microsoft Defender Antivirus-Minifiltertreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft Defender Antivirus-Minifiltertreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wd\WdFilter.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : wdiwifi
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WDI Driver Framework
    Description             : WDI Driver Framework
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WDI Driver Framework
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\wdiwifi.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WdmCompanionFilter
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WdmCompanionFilter
    Description             : WdmCompanionFilter
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WdmCompanionFilter
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WdmCompanionFilter.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WdNisDrv
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Treiber für Microsoft Defender Antivirus-Netzwerkinspektionssystem
    Description             : Treiber für Microsoft Defender Antivirus-Netzwerkinspektionssystem
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Treiber für Microsoft Defender Antivirus-Netzwerkinspektionssystem
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wd\WdNisDrv.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WFPLWFS
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Windows-Filterplattform
    Description             : Microsoft Windows-Filterplattform
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft Windows-Filterplattform
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wfplwfs.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WifiCx
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Wifi Network Adapter Class Extension
    Description             : Wifi Network Adapter Class Extension
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Wifi Network Adapter Class Extension
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WifiCx.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WIMMount
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WIMMount
    Description             : WIMMount
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WIMMount
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wimmount.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WindowsTrustedRT
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Windows Trusted Execution Environment Class Extension
    Description             : Windows Trusted Execution Environment Class Extension
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Windows Trusted Execution Environment Class Extension
    ErrorControl            : Critical
    PathName                : C:\WINDOWS\system32\drivers\WindowsTrustedRT.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WindowsTrustedRTProxy
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Windows Trusted Runtime – Sicherer Dienst
    Description             : Microsoft Windows Trusted Runtime – Sicherer Dienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft Windows Trusted Runtime – Sicherer Dienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WindowsTrustedRTProxy.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 2
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WinMad
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WinMad-Dienst
    Description             : WinMad-Dienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WinMad-Dienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\winmad.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 4
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WinNat
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Windows-NAT-Treiber
    Description             : Windows-NAT-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Windows-NAT-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\winnat.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WinSetupMon
    State                   : Stopped
    ExitCode                : 31
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WinSetupMon
    Description             : WinSetupMon
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Unknown
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         :
    DisplayName             : WinSetupMon
    ErrorControl            : Unknown
    PathName                :
    ServiceType             : Unknown
    StartName               :
    TagId                   :
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WINUSB
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WinUSB - Kernel Driver 06/02/2012 6.1.7600.16385
    Description             : WinUSB - Kernel Driver 06/02/2012 6.1.7600.16385
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WinUSB - Kernel Driver 06/02/2012 6.1.7600.16385
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WinUSB.SYS
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WinVerbs
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WinVerbs-Dienst
    Description             : WinVerbs-Dienst
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WinVerbs-Dienst
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\winverbs.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 3
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WireGuard
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WireGuard
    Description             : WireGuard
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WireGuard
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wireguard.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WmiAcpi
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Microsoft Windows Management Interface for ACPI
    Description             : Microsoft Windows Management Interface for ACPI
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Microsoft Windows Management Interface for ACPI
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wmiacpi.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 36
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : Wof
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : Windows Overlay File System Filter Driver
    Description             : Windows Overlay File System Filter Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Boot
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : Windows Overlay File System Filter Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\Wof.sys
    ServiceType             : File System Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WpdUpFltr
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WPD Upper Class Filter Driver
    Description             : WPD Upper Class Filter Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WPD Upper Class Filter Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WpdUpFltr.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : ws2ifsl
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Winsock-IFS-Treiber
    Description             : Winsock-IFS-Treiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Disabled
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Winsock-IFS-Treiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\ws2ifsl.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : wtd
    State                   : Running
    ExitCode                : 0
    Started                 : True
    ServiceSpecificExitCode : 0
    Caption                 : wtd
    Description             : wtd
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Auto
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : True
    DesktopInteract         : False
    DisplayName             : wtd
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\wtd.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WudfPf
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : User Mode Driver Frameworks Platform Driver
    Description             : User Mode Driver Frameworks Platform Driver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : User Mode Driver Frameworks Platform Driver
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WudfPf.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WUDFRd
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Windows Driver Foundation - User-mode Driver Framework Reflector
    Description             : Windows Driver Foundation - User-mode Driver Framework Reflector
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Windows Driver Foundation - User-mode Driver Framework Reflector
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\WUDFRd.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 2
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : WUDFWpdFs
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : WPD-Dateisystemtreiber
    Description             : WPD-Dateisystemtreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : WPD-Dateisystemtreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\DRIVERS\WUDFRd.sys
    ServiceType             : Kernel Driver
    StartName               : \Driver\WudfRd
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : xboxgip
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Eingabeprotokolltreiber für Xbox-Spiele
    Description             : Eingabeprotokolltreiber für Xbox-Spiele
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Eingabeprotokolltreiber für Xbox-Spiele
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\xboxgip.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : xinputhid
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : XINPUT-HID-Filtertreiber
    Description             : XINPUT-HID-Filtertreiber
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : XINPUT-HID-Filtertreiber
    ErrorControl            : Normal
    PathName                : C:\WINDOWS\system32\drivers\xinputhid.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 1
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    Status                  : OK
    Name                    : xusb22
    State                   : Stopped
    ExitCode                : 1077
    Started                 : False
    ServiceSpecificExitCode : 0
    Caption                 : Treiberdienst 22 für Xbox 360 Wireless Receiver
    Description             : Treiberdienst 22 für Xbox 360 Wireless Receiver
    InstallDate             :
    CreationClassName       : Win32_SystemDriver
    StartMode               : Manual
    SystemCreationClassName : Win32_ComputerSystem
    SystemName              : BELIAL
    AcceptPause             : False
    AcceptStop              : False
    DesktopInteract         : False
    DisplayName             : Treiberdienst 22 für Xbox 360 Wireless Receiver
    ErrorControl            : Ignore
    PathName                : C:\WINDOWS\system32\drivers\xusb22.sys
    ServiceType             : Kernel Driver
    StartName               :
    TagId                   : 0
    PSComputerName          :
    CimClass                : root/cimv2:Win32_SystemDriver
    CimInstanceProperties   : {Caption, Description, InstallDate, Name...}
    CimSystemProperties     : Microsoft.Management.Infrastructure.CimSystemProperties
    
    
    
    PS C:\WINDOWS\system32> $wmi
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi.StartMode=Manual
    Manual : Die Benennung "Manual" wurde nicht als Name eines Cmdlet, einer Funktion, einer Skriptdatei oder eines ausführbaren Programms erkannt. Überprüfen Sie die Schreibweise des Namens, oder ob der Pfad korrekt ist (sofern enthalten), und wiederholen Sie den Vorgang.
    In Zeile:1 Zeichen:16
    + $wmi.StartMode=Manual
    +                ~~~~~~
        + CategoryInfo          : ObjectNotFound: (Manual:String) [], CommandNotFoundException
        + FullyQualifiedErrorId : CommandNotFoundException
    
    PS C:\WINDOWS\system32> $wmi.StartMode('Manual')
    Fehler beim Aufrufen der Methode, da [Microsoft.Management.Infrastructure.CimInstance] keine Methode mit dem Namen "StartMode" enthält.
    In Zeile:1 Zeichen:1
    + $wmi.StartMode('Manual')
    + ~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidOperation: (StartMode:String) [], RuntimeException
        + FullyQualifiedErrorId : MethodNotFound
    
    PS C:\WINDOWS\system32> $wmi.StartMode='Manual'
    "StartMode" ist eine ReadOnly-Eigenschaft.
    In Zeile:1 Zeichen:1
    + $wmi.StartMode='Manual'
    + ~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : NotSpecified: (:) [], SetValueException
        + FullyQualifiedErrorId : ReadOnlyCIMProperty
    
    PS C:\WINDOWS\system32> $wmi.ChangeStartMode='Manual'
    Ausnahme beim Festlegen von "ChangeStartMode": "Die Eigenschaft "ChangeStartMode" wurde für dieses Objekt nicht gefunden. Vergewissern Sie sich, dass die Eigenschaft vorhanden ist und festgelegt werden kann."
    In Zeile:1 Zeichen:1
    + $wmi.ChangeStartMode='Manual'
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : NotSpecified: (:) [], SetValueInvocationException
        + FullyQualifiedErrorId : ExceptionWhenSetting
    
    PS C:\WINDOWS\system32> $wmi = Get-CimInstance -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> $wmi = Get-CimInstance -ClassName Win32_SystemDriver -Filter 'Name = npcap' }
    In Zeile:1 Zeichen:77
    + ... et-CimInstance -ClassName Win32_SystemDriver -Filter 'Name = npcap' }
    +                                                                         ~
    Unerwartetes Token "}" in Ausdruck oder Anweisung.
        + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException
        + FullyQualifiedErrorId : UnexpectedToken
    
    PS C:\WINDOWS\system32> $wmi = Get-CimInstance -ClassName Win32_SystemDriver -Filter 'Name = npcap'
    Get-CimInstance : Die Anfrage ist ungültig.
    In Zeile:1 Zeichen:8
    + $wmi = Get-CimInstance -ClassName Win32_SystemDriver -Filter 'Name =  ...
    +        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidArgument: (:) [Get-CimInstance], CimException
        + FullyQualifiedErrorId : HRESULT 0x80041017,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand
    
    PS C:\WINDOWS\system32> $wmi = Get-CimInstance -ClassName Win32_SystemDriver -Filter 'Name like npcap'
    Get-CimInstance : Die Anfrage ist ungültig.
    In Zeile:1 Zeichen:8
    + $wmi = Get-CimInstance -ClassName Win32_SystemDriver -Filter 'Name li ...
    +        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidArgument: (:) [Get-CimInstance], CimException
        + FullyQualifiedErrorId : HRESULT 0x80041017,Microsoft.Management.Infrastructure.CimCmdlets.GetCimInstanceCommand
    
    PS C:\WINDOWS\system32> $wmi = Get-CimInstance -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> (Get-CimInstance -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' })
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> (Get-CimInstance -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }).Startmode
    System
    PS C:\WINDOWS\system32> $wmi = Get-CimInstance -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> foreach ($service in $wmi) { $service.ChangeStartMode("Manual") }
    Fehler beim Aufrufen der Methode, da [Microsoft.Management.Infrastructure.CimInstance] keine Methode mit dem Namen "changestartmode" enthält.
    In Zeile:1 Zeichen:30
    + foreach ($service in $wmi) { $service.ChangeStartMode("Manual") }
    +                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidOperation: (changestartmode:String) [], RuntimeException
        + FullyQualifiedErrorId : MethodNotFound
    
    PS C:\WINDOWS\system32> gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> $wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi.ChangeStartMode('Manual')
    
    
    __GENUS          : 2
    __CLASS          : __PARAMETERS
    __SUPERCLASS     :
    __DYNASTY        : __PARAMETERS
    __RELPATH        :
    __PROPERTY_COUNT : 1
    __DERIVATION     : {}
    __SERVER         :
    __NAMESPACE      :
    __PATH           :
    ReturnValue      : 0
    PSComputerName   :
    
    
    
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi.ChangeStartMode('Manual')
    
    
    __GENUS          : 2
    __CLASS          : __PARAMETERS
    __SUPERCLASS     :
    __DYNASTY        : __PARAMETERS
    __RELPATH        :
    __PROPERTY_COUNT : 1
    __DERIVATION     : {}
    __SERVER         :
    __NAMESPACE      :
    __PATH           :
    ReturnValue      : 0
    PSComputerName   :
    
    
    
    PS C:\WINDOWS\system32> gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> $wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi
    
    
    DisplayName : Npcap Packet Driver (NPCAP)
    Name        : npcap
    State       : Running
    Status      : OK
    Started     : True
    
    
    
    PS C:\WINDOWS\system32> $wmi.StartMode
    Manual
    PS C:\WINDOWS\system32> $wmi.ChangeStartMode('System')
    
    
    __GENUS          : 2
    __CLASS          : __PARAMETERS
    __SUPERCLASS     :
    __DYNASTY        : __PARAMETERS
    __RELPATH        :
    __PROPERTY_COUNT : 1
    __DERIVATION     : {}
    __SERVER         :
    __NAMESPACE      :
    __PATH           :
    ReturnValue      : 0
    PSComputerName   :
    
    
    
    PS C:\WINDOWS\system32> $wmi.StartMode
    Manual
    PS C:\WINDOWS\system32> $wmi.StartMode
    Manual
    PS C:\WINDOWS\system32> $wmi.StartMode
    Manual
    PS C:\WINDOWS\system32> $wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi.ChangeStartMode('Manual')
    
    
    __GENUS          : 2
    __CLASS          : __PARAMETERS
    __SUPERCLASS     :
    __DYNASTY        : __PARAMETERS
    __RELPATH        :
    __PROPERTY_COUNT : 1
    __DERIVATION     : {}
    __SERVER         :
    __NAMESPACE      :
    __PATH           :
    ReturnValue      : 0
    PSComputerName   :
    
    
    
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32> $wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi.StartMode
    Manual
    PS C:\WINDOWS\system32> $wmi.ChangeStartMode('System')
    
    
    __GENUS          : 2
    __CLASS          : __PARAMETERS
    __SUPERCLASS     :
    __DYNASTY        : __PARAMETERS
    __RELPATH        :
    __PROPERTY_COUNT : 1
    __DERIVATION     : {}
    __SERVER         :
    __NAMESPACE      :
    __PATH           :
    ReturnValue      : 0
    PSComputerName   :
    
    
    
    PS C:\WINDOWS\system32> $wmi = gwmi -ClassName Win32_SystemDriver | Where-Object { $_.Name -match 'npcap' }
    PS C:\WINDOWS\system32> $wmi.StartMode
    System
    PS C:\WINDOWS\system32>        
            
            
