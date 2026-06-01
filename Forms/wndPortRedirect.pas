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
   COMSendData;

//-------------------------------------------------------------------------------------------------
// CreateWnd
procedure TfrmPortRedirect.CreateWnd;
var
   hSysMenu: HMENU;
begin
   inherited;
   hSysMenu := GetSystemMenu(Handle, False);
   AppendMenu(hSysMenu, MF_SEPARATOR, 0, nil);
   AppendMenu(hSysMenu, MF_STRING,    SYSMENU_ABOUT_ID, 'About...');
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
procedure TfrmPortRedirect.FormShow(Sender: TObject);
begin
   AppSettings:=TAppSettings.Create;
   AppSettings.LoadSettings;

   toolBtnOpenClick(nil);
end;

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
         dcb.Flags   :=dcb.Flags or DCB_fBinary;
      end;

      1:
      begin
         dcb.Flags := dcb.Flags or $00000004; // fOutxCtsFlow
         dcb.Flags := dcb.Flags or (RTS_CONTROL_HANDSHAKE shl 12);
      end;

      2:
      begin
          dcb.Flags := dcb.Flags or $00000100; // fOutX
         dcb.Flags := dcb.Flags or $00000200; // fInX
      end;
   end;
{
   // Required
   dcb.Flags := dcb.Flags or DCB_fBinary;
   dcb.Flags := dcb.Flags or DCB_fParity;

   // Disable flow control
   dcb.Flags := dcb.Flags and not DCB_fOutxCtsFlow;
   dcb.Flags := dcb.Flags and not DCB_fOutxDsrFlow;
   dcb.Flags := dcb.Flags and not DCB_fOutX;
   dcb.Flags := dcb.Flags and not DCB_fInX;

   // Enable RTS/DTR
   dcb.Flags := dcb.Flags or (DTR_CONTROL_ENABLE shl 4);  // fDtrControl bits
   dcb.Flags := dcb.Flags or (RTS_CONTROL_ENABLE shl 12); // fRtsControl bits

   // No abort on error
   dcb.Flags := dcb.Flags and not DCB_fAbortOnError;

   // RTS/CTS (Hardware)
   dcb.Flags := dcb.Flags or $00000004; // fOutxCtsFlow = 1
   dcb.Flags := dcb.Flags or (RTS_CONTROL_HANDSHAKE shl 12);

   // XON/XOFF (Software)
   dcb.Flags := dcb.Flags or $00000100; // fOutX = 1
   dcb.Flags := dcb.Flags or $00000200; // fInX  = 1

 }

   Serial:=TSerialThread.Create(AppSettings.Port, dcb,
      procedure(const Data: string)
      begin
         MemoData.Lines.Add(Data);
         SendTextByTitle('Untitled - Notepad', data);
      end
   );

   StatusBar.SimpleText:='Port: '+AppSettings.Port+'  Baud Rate: '+IntToStr(dcb.BaudRate);
end;

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
   //toolBtnOpenClick(nil);
end;

end.
