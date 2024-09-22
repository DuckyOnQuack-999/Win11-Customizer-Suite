import tkinter as tk
from tkinter import ttk, messagebox
import threading
import time
import subprocess
import json
import ctypes
import fnmatch
import re

# JSON data embedded as a multi-line string
SERVICES_JSON = """
{
  "Content": "Set Services to Automatic",
  "Description": "Changes all services to Automatic startup type.",
  "category": "Essential Tweaks",
  "panel": "1",
  "Order": "a014_",
  "service": [
    {
      "Name": "AJRouter",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "ALG",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "AppIDSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "AppMgmt",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "AppReadiness",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "AppVClient",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "AppXSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Appinfo",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "AssignedAccessManagerSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "AudioEndpointBuilder",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "AudioSrv",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "Audiosrv",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "AxInstSV",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "BDESVC",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "BFE",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "BITS",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "BTAGService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "BcastDVRUserService_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "BluetoothUserService_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "BrokerInfrastructure",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "Browser",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "BthAvctpSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "BthHFSrv",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "CDPSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "CDPUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "COMSysApp",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "CaptureService_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "CertPropSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "ClipSVC",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "ConsentUxUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "CoreMessagingRegistrar",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "CredentialEnrollmentManagerUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "CryptSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "CscService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DPS",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DcomLaunch",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DcpSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DevQueryBroker",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DeviceAssociationBrokerSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DeviceAssociationService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DeviceInstall",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DevicePickerUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DevicesFlowUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Dhcp",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DiagTrack",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DialogBlockingService",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "DispBrokerDesktopSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DisplayEnhancementService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DmEnrollmentSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Dnscache",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DoSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "DsSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DsmSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "DusmSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "EFS",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "EapHost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "EntAppSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "EventLog",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "EventSystem",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "FDResPub",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Fax",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "FontCache",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "FrameServer",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "FrameServerMonitor",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "GraphicsPerfSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "HomeGroupListener",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "HomeGroupProvider",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "HvHost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "IEEtwCollectorService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "IKEEXT",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "InstallService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "InventorySvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "IpxlatCfgSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "KeyIso",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "KtmRm",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "LSM",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "LanmanServer",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "LanmanWorkstation",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "LicenseManager",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "LxpSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MSDTC",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MSiSCSI",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MapsBroker",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "McpManagementService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MessagingService_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MicrosoftEdgeElevationService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MixedRealityOpenXRSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "MpsSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "MsKeyboardFilter",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "NPSMSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NaturalAuthentication",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NcaSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NcbService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NcdAutoSetup",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NetSetupSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NetTcpPortSharing",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "Netlogon",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "Netman",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NgcCtnrSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NgcSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "NlaSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "OneSyncSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "P9RdrService_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PNRPAutoReg",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PNRPsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PcaSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "PeerDistSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PenService_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PerfHost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PhoneSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PimIndexMaintenanceSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PlugPlay",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PolicyAgent",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Power",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "PrintNotify",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "PrintWorkflowUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "ProfSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "PushToInstall",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "QWAVE",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "RasAuto",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "RasMan",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "RemoteAccess",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "RemoteRegistry",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "RetailDemo",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "RmSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "RpcEptMapper",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "RpcLocator",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "RpcSs",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SCPolicySvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SCardSvr",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SDRSVC",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SEMgrSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SENS",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SNMPTRAP",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SNMPTrap",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SSDPSRV",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SamSs",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "ScDeviceEnum",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Schedule",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SecurityHealthService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Sense",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SensorDataService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SensorService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SensrSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SessionEnv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SgrmBroker",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SharedAccess",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "SharedRealitySvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "ShellHWDetection",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SmsRouter",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Spooler",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SstpSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "StateRepository",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "StiSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "StorSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SysMain",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "SystemEventsBroker",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "TabletInputService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TapiSrv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TermService",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "TextInputManagementService",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "Themes",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "TieringEngineService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TimeBroker",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TimeBrokerSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TokenBroker",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TrkWks",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "TroubleshootingSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "TrustedInstaller",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "UI0Detect",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "UdkUserSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "UevAgentService",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "UmRdpService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "UnistoreSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "UserDataSvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "UserManager",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "UsoSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "VGAuthService",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "VMTools",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "VSS",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "VacSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "VaultSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "W32Time",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WEPHOSTSVC",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WFDSConMgrSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WMPNetworkSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WManSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WPDBusEnum",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WSService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WSearch",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "WaaSMedicSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WalletService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WarpJITSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WbioSrvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Wcmsvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "WcsPlugInService",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WdNisSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WdiServiceHost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WdiSystemHost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WebClient",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Wecsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WerSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WiaRpc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WinDefend",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "WinHttpAutoProxySvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WinRM",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "Winmgmt",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "WlanSvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "WpcMonSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "WpnService",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "WpnUserService_*",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "XblAuthManager",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "XblGameSave",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "XboxGipSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "XboxNetApiSvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "autotimesvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "bthserv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "camsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "cbdhsvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "cloudidsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "dcsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "defragsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "diagnosticshub.standardcollector.service",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "diagsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "dmwappushservice",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "dot3svc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "edgeupdate",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "edgeupdatem",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "embeddedmode",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "fdPHost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "fhsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "gpsvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "hidserv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "icssvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "iphlpsvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "lfsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "lltdsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "lmhosts",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "mpssvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "msiserver",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "netprofm",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "nsi",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "p2pimsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "p2psvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "perceptionsimulation",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "pla",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "seclogon",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "shpamsvc",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "smphost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "spectrum",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "sppsvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "ssh-agent",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "svsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "swprv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "tiledatamodelsvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "tzautoupdate",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "uhssvc",
      "StartupType": "Automatic",
      "OriginalType": "Disabled"
    },
    {
      "Name": "upnphost",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vds",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vm3dservice",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "vmicguestinterface",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmicheartbeat",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmickvpexchange",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmicrdv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmicshutdown",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmictimesync",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmicvmsession",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmicvss",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "vmvss",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wbengine",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wcncsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "webthreatdefsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "webthreatdefusersvc_*",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "wercplsupport",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wisvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wlidsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wlpasvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wmiApSrv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "workfolderssvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wscsvc",
      "StartupType": "Automatic",
      "OriginalType": "Automatic"
    },
    {
      "Name": "wuauserv",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    },
    {
      "Name": "wudfsvc",
      "StartupType": "Automatic",
      "OriginalType": "Manual"
    }
  ],
  "link": "https://christitustech.github.io/winutil/dev/tweaks/Essential-Tweaks/Services"
}
"""

def is_admin():
    """
    Check if the script is running with administrative privileges.
    Returns True if admin, else False.
    """
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def get_all_services():
    """
    Retrieves all service names on the system.
    Returns a list of service names.
    """
    try:
        # Execute 'sc query state= all' command
        result = subprocess.check_output(['sc', 'query', 'state=', 'all'], universal_newlines=True, stderr=subprocess.DEVNULL)
        # Parse the output to extract service names
        services = re.findall(r'SERVICE_NAME:\s+(\S+)', result)
        return services
    except subprocess.CalledProcessError:
        return []

def expand_wildcards(service_name, all_services):
    """
    Expands wildcard service names to actual service names.
    Args:
        service_name (str): The service name with potential wildcards.
        all_services (list): List of all service names.
    Returns:
        list: List of matched service names.
    """
    if '*' in service_name or '?' in service_name:
        pattern = service_name.replace('_*', '*')  # Adjust pattern if needed
        matched = fnmatch.filter(all_services, pattern)
        return matched
    else:
        return [service_name] if service_name in all_services else []

def set_service_startup(service_name):
    """
    Sets the startup type of a service to Automatic.
    Args:
        service_name (str): The name of the service.
    Returns:
        bool: True if successful, False otherwise.
    """
    try:
        # Execute 'sc config [service_name] start= auto' command
        # Note: There is a space after 'start='
        subprocess.check_output(['sc', 'config', service_name, 'start=', 'auto'], stderr=subprocess.STDOUT, universal_newlines=True)
        return True
    except subprocess.CalledProcessError as e:
        return False

class VerboseProgressBar(tk.Tk):
    def __init__(self):
        super().__init__()

        self.title("Set Services to Automatic")
        self.geometry("600x300")
        self.resizable(False, False)

        # Create and place the progress bar
        self.progress = ttk.Progressbar(self, orient="horizontal",
                                        length=500, mode="determinate")
        self.progress.pack(pady=20)

        # Label to display verbose status messages
        self.status_label = ttk.Label(self, text="Ready", anchor="center")
        self.status_label.pack(pady=10)

        # Start button to initiate the process
        self.start_button = ttk.Button(self, text="Start Process", command=self.start_process)
        self.start_button.pack(pady=10)

        # Text widget to display detailed logs
        self.log_text = tk.Text(self, height=8, width=70, state='disabled')
        self.log_text.pack(pady=10)

    def log(self, message):
        """
        Logs a message to the text widget and updates the status label.
        """
        self.log_text.config(state='normal')
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.config(state='disabled')
        self.log_text.see(tk.END)  # Auto-scroll
        self.status_label.config(text=message)

    def start_process(self):
        """
        Starts the service modification process in a separate thread.
        """
        self.start_button.config(state='disabled')  # Disable the button during processing
        self.log("Process started...")
        threading.Thread(target=self.run_task, daemon=True).start()

    def run_task(self):
        """
        Runs the task of setting services to Automatic.
        """
        # Parse JSON data
        try:
            data = json.loads(SERVICES_JSON)
            services_list = data.get("service", [])
        except json.JSONDecodeError as e:
            self.log(f"JSON Parsing Error: {str(e)}")
            self.start_button.config(state='normal')
            return

        all_services = get_all_services()
        if not all_services:
            self.log("Failed to retrieve services. Ensure you have the necessary permissions.")
            self.start_button.config(state='normal')
            return

        # Prepare list of services to modify
        services_to_modify = []
        for service_entry in services_list:
            name = service_entry.get("Name")
            if not name:
                continue
            matched_services = expand_wildcards(name, all_services)
            if matched_services:
                services_to_modify.extend(matched_services)
            else:
                self.log(f"Service '{name}' not found.")

        total = len(services_to_modify)
        if total == 0:
            self.log("No services to modify.")
            self.start_button.config(state='normal')
            return

        self.progress["maximum"] = total
        success_count = 0
        failure_count = 0

        for idx, service in enumerate(services_to_modify, start=1):
            self.log(f"Setting '{service}' to Automatic...")
            success = set_service_startup(service)
            if success:
                self.log(f"Successfully set '{service}' to Automatic.")
                success_count += 1
            else:
                self.log(f"Failed to set '{service}'. It may already be set or requires different permissions.")
                failure_count += 1
            self.progress["value"] = idx
            self.update_idletasks()
            time.sleep(0.1)  # Simulate work

        self.log(f"Process completed: {success_count} succeeded, {failure_count} failed.")
        messagebox.showinfo("Process Completed", f"Process completed:\n{success_count} succeeded,\n{failure_count} failed.")
        self.start_button.config(state='normal')

if __name__ == "__main__":
    if not is_admin():
        messagebox.showerror("Insufficient Privileges", "This script requires administrative privileges.\nPlease run it as an administrator.")
        exit(1)

    app = VerboseProgressBar()
    app.mainloop()
