unit COMSendData;

interface

uses
  Winapi.Windows, Winapi.Messages;

procedure SendDataToApp(const WindowTitle, Text: string);

implementation

function EnumWindowsCallback(hWnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  Title: array[0..255] of Char;
begin
  GetWindowText(hWnd, Title, Length(Title));

  // Match ANY Notepad window
  if Pos('Notepad', Title) > 0 then
  begin
    PCardinal(lParam)^ := hWnd;
    Result := False; // stop enumeration
    Exit;
  end;

  Result := True;
end;

procedure SendDataToApp(const WindowTitle, Text: string);
var
   hWnd, hChild: Winapi.Windows.HWND;
begin
   hWnd := 0;
   EnumWindows(@EnumWindowsCallback, LPARAM(@hWnd));

   if hWnd = 0 then Exit;

   hChild := FindWindowEx(hWnd, 0, 'Edit', nil);
   if hChild = 0 then Exit;

   SendMessage(hChild, WM_SETTEXT, 0, LPARAM(PChar(Text)));
end;

end.

