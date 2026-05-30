unit wndSettings;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   AppSettings;

type
   TfrmSettings = class(TForm)
      grpBoxInput: TGroupBox;
      grpBoxOutput: TGroupBox;
      cbPort: TComboBox;
      lblPort: TLabel;
    lblBaudRate: TLabel;
    cbBaudRate: TComboBox;
      procedure FormShow(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      AppSettings: TAppSettings;
   public
   end;

var
   frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.FormShow(Sender: TObject);
begin
   AppSettings:=TAppSettings.Create;
   AppSettings.LoadSettings;

   cbPort.Text    :=AppSettings.Port;
   cbBaudRate.Text:=IntToStr(AppSettings.BaudRate);
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   AppSettings.Port    := cbPort.Text;
   AppSettings.BaudRate:= StrToInt(cbBaudRate.Text);

   AppSettings.SaveSettings;
   AppSettings.Free;
end;

end.
