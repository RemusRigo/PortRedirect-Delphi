# Port Redirect: User's Guide

> This is the Delphi version. The [VB.NET version](https://github.com/RemusRigo/PortRedirect-VB.NET)
> types the data into any window and has two port reading methods.



## Downloads & Runtimes

Download the latest release from the [Releases page](https://github.com/RemusRigo/PortRedirect-Delphi/releases).

|Folder|Architecture|Required Runtime|
|-|-|-|
|`Win32`|32-bit|none (native Windows app)|
|`Win64`|64-bit|none (native Windows app)|

> On 64-bit Windows, use **Win64**.



## Install

Port Redirect is portable: there is no installer.

1. Copy `PortRedirect.exe` to a folder where you have write access, for example `D:\My Apps\PortRedirect\`.
2. Connect your device (e.g. a barcode scanner) and note its COM port in **Device Manager → Ports (COM & LPT)**.
3. Double-click `PortRedirect.exe`.



## Usage

1. Open **Settings** and set the port (see below).
2. Open the target application (Notepad).
3. Click **Open port**. Data received from the port is sent to the target window.
4. Click **Close port** to stop.

The **Logs** window shows what happened.

> The data is written into the target window's text box (`Edit` control) and **replaces** its content.
> This works with the classic Notepad; the new Windows 11 Notepad and most other apps don't have such a control.



## Settings

|Group|Setting|Default|
|-|-|-|
|**Input**|**Port**|COM1|
| |**Baud Rate**|9600|
| |**Data Bits**, **Parity**, **Stop Bits**, **Flow Control**|8, none, 1, none|
|**Output**|**Title**: the window title of the target application|Untitled - Notepad|

Settings are saved in `PortRedirect.json` next to `PortRedirect.exe`.



## Uninstall

Delete the folder you copied `PortRedirect.exe` to (this also deletes the settings).
