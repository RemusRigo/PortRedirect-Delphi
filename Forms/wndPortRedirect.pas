unit wndPortRedirect;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.ImageList,
   Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
   AppSettings, SerialCommunication,
   wndSettings, wndAbout;

const
   DCB_BINARY = $0001;
   SYSMENU_ABOUT_ID = UINT(1000);
  DCB_fBinary        = $00000001;
  DCB_fParity        = $00000002;
  DCB_fOutxCtsFlow   = $00000004;
  DCB_fOutxDsrFlow   = $00000008;
  DCB_fDtrControl    = $00000030; // 2 bits
  DCB_fDsrSensitivity= $00000040;
  DCB_fTXContinueOnXoff = $00000080;
  DCB_fOutX          = $00000100;
  DCB_fInX           = $00000200;
  DCB_fErrorChar     = $00000400;
  DCB_fNull          = $00000800;
  DCB_fRtsControl    = $00003000; // 2 bits
  DCB_fAbortOnError  = $00004000;

type
   TfrmPortRedirect = class(TForm)
    memoData: TMemo;
      ToolBar1: TToolBar;
      toolBtnOpen: TToolButton;
      toolBtnClose: TToolButton;
      toolBtnSettings: TToolButton;
      imgListButtons: TImageList;
    StatusBar: TStatusBar;
      procedure toolBtnOpenClick(Sender: TObject);
      procedure FormShow(Sender: TObject);
    procedure toolBtnSettingsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure toolBtnCloseClick(Sender: TObject);
      protected
         procedure CreateWnd; override;
         procedure WndProc(var Message: TMessage); override;
      private
         Serial: TSerialThread;
         dcb: TDCB;
         AppSettings: TAppSettings;
      public
   end;

var
  frmPortRedirect: TfrmPortRedirect;

implementation

{$R *.dfm}

uses
   AppData, COMSendData;

//-------------------------------------------------------------------------------------------------
// SendKeys
procedure SendKeys(const S: string);
var
  i: Integer;
  c: Char;
begin
   for i:=1 to Length(S) do
   begin
      c:=S[i];
      keybd_event(VkKeyScan(c), 0, 0, 0);
      keybd_event(VkKeyScan(c), 0, KEYEVENTF_KEYUP, 0);
   end;
end;

//-------------------------------------------------------------------------------------------------
// CreateWnd
procedure TfrmPortRedirect.CreateWnd;
var
   hSysMenu: HMENU;
begin
   inherited;
   hSysMenu:=GetSystemMenu(Handle, False);
   AppendMenu(hSysMenu, MF_SEPARATOR, 0, nil);
   AppendMenu(hSysMenu, MF_STRING, SYSMENU_ABOUT_ID, 'About');
end;

//-------------------------------------------------------------------------------------------------
// WndProc
procedure TfrmPortRedirect.WndProc(var Message: TMessage);
var
  frm: TfrmAbout;
begin
   inherited;
   if Message.Msg = WM_SYSCOMMAND then
      if UINT(Message.WParam) = SYSMENU_ABOUT_ID then
      begin
         frm:=TfrmAbout.Create(Self);
         try
            frm.ShowModal;
         finally
            frm.Free;
         end;
      end;
end;

//-------------------------------------------------------------------------------------------------
// frmPortRedirect onShow
procedure TfrmPortRedirect.FormShow(Sender: TObject);
begin
   Self.Caption:=appCaption;

   AppSettings:=TAppSettings.Create;
   AppSettings.LoadSettings;

   toolBtnOpenClick(nil);
end;

//-------------------------------------------------------------------------------------------------
// frmPortRedirect onClose
procedure TfrmPortRedirect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Assigned(Serial) then
   begin
      Serial.Stop;
      Serial.WaitFor;
      Serial.Free;
   end;

   AppSettings.Free;
   AppSettings:=nil;
end;

//-------------------------------------------------------------------------------------------------
// toolBtnOpen onClick
procedure TfrmPortRedirect.toolBtnOpenClick(Sender: TObject);
begin

   // Prevent multiple threads
   if Assigned(Serial) then
   begin
      Serial.Stop;
      Serial.WaitFor;
      Serial.Free;
      Serial:=nil;
   end;

   // Build DCB from settings
   FillChar(dcb, SizeOf(dcb), 0);
   dcb.DCBlength:=SizeOf(dcb);

   dcb.BaudRate:=AppSettings.BaudRate;
   dcb.ByteSize:=AppSettings.DataBits;
   dcb.Parity  :=AppSettings.Parity;
   dcb.StopBits:=AppSettings.StopBits;

   case AppSettings.FlowControl of
      0:
      begin
         dcb.Flags:=dcb.Flags or DCB_fBinary;
      end;

      1:
      begin
         dcb.Flags:=dcb.Flags or $00000004; // fOutxCtsFlow
         dcb.Flags:=dcb.Flags or (RTS_CONTROL_HANDSHAKE shl 12);
      end;

      2:
      begin
         dcb.Flags:=dcb.Flags or $00000100; // fOutX
         dcb.Flags:=dcb.Flags or $00000200; // fInX
      end;
   end;

   Serial:=TSerialThread.Create(AppSettings.Port, dcb,
      procedure(const Data: string)
      var
         hwndApp: HWND;
      begin
         MemoData.Lines.Add(Data);

         TThread.Queue(nil,
            procedure
            begin
               hwndApp:=FindWindow(nil, PWideChar(AppSettings.WindowTitle));
               if hwndApp <> 0 then
               begin
                  SetForegroundWindow(hwndApp);
                  Sleep(200);
                  SendKeys(data);
               end;
            end);

      end
   );
   StatusBar.SimpleText:='Port: '+AppSettings.Port+'  Baud Rate: '+IntToStr(dcb.BaudRate);
end;

//-------------------------------------------------------------------------------------------------
// toolBtnStop onClick
procedure TfrmPortRedirect.toolBtnCloseClick(Sender: TObject);
begin
   if Assigned(Serial) then
   begin
      Serial.Stop;
      Serial.WaitFor;
      Serial.Free;
      Serial:=nil;
   end;
end;

//-------------------------------------------------------------------------------------------------
// toolBtnSettings onClick
procedure TfrmPortRedirect.toolBtnSettingsClick(Sender: TObject);
var
   frm: TfrmSettings;
begin
   frm:=TfrmSettings.Create(Self);
   try
      frm.ShowModal;
   finally
      frm.Free;
   end;
end;

end.
