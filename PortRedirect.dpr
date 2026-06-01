program PortRedirect;

uses
  Vcl.Forms,
  wndPortRedirect in 'Forms\wndPortRedirect.pas' {frmPortRedirect},
  wndSettings in 'Forms\wndSettings.pas' {frmSettings},
  wndLog in 'Forms\wndLog.pas' {frmLog},
  AppSettings in 'Units\AppSettings.pas',
  wndAbout in 'Forms\wndAbout.pas' {frmAbout},
  AppData in 'Units\AppData.pas',
  SerialCommunication in 'Units\SerialCommunication.pas',
  COMSendData in 'Units\COMSendData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPortRedirect, frmPortRedirect);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TfrmLog, frmLog);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
