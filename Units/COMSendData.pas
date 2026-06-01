unit COMSendData;

interface

uses
  Winapi.Windows, Winapi.Messages;

procedure SendTextByTitle(const WindowTitle, Text: string);

implementation

procedure SendTextByTitle(const WindowTitle, Text: string);
var
   hWnd: Winapi.Windows.HWND;
   hChild: Winapi.Windows.HWND;
begin
   hWnd:=FindWindow(nil, PChar(WindowTitle));
   if not IsWindow(hWnd) then Exit;

   // Try to find an EDIT control inside the window
   hChild:=FindWindowEx(hWnd, 0, 'Edit', nil);
   if not IsWindow(hChild) then Exit;

   SendMessage(hChild, WM_SETTEXT, 0, LPARAM(PChar(Text)));
end;

end.

