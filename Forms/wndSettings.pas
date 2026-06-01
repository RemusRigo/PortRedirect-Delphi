unit wndSettings;

interface

uses
   Winapi.Windows, Winapi.Messages,
   System.SysUtils, System.Variants, System.Classes,
   Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
   AppSettings, SerialCommunication;

type
   TfrmSettings = class(TForm)
      grpBoxInput: TGroupBox;
      grpBoxOutput: TGroupBox;
      cbPort: TComboBox;
      lblPort: TLabel;
    lblBaudRate: TLabel;
    cbBaudRate: TComboBox;
    lblDataBits: TLabel;
    cbDataBits: TComboBox;
    lblParity: TLabel;
    cbParity: TComboBox;
    lblStopBits: TLabel;
    cbStopBits: TComboBox;
    lblFlowControl: TLabel;
    cbFlowControl: TComboBox;
      procedure FormShow(Sender: TObject);
      procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
      AppSettings: TAppSettings;
      procedure LoadDefaults;
   public
   end;

var
   frmSettings: TfrmSettings;

implementation

{$R *.dfm}

procedure TfrmSettings.LoadDefaults;
var
   ports: TStrings;
begin
   // Port
   ports:=EnumComPorts;
   try
      cbPort.Items.Assign(ports);
   finally
      ports.Free;
   end;

   // Baud Rate
   cbBaudRate.Items.Add(IntToStr(110));    //legacy teletype speed
   cbBaudRate.Items.Add(IntToStr(300));    // modems, industrial
   cbBaudRate.Items.Add(IntToStr(600));
   cbBaudRate.Items.Add(IntToStr(1200));   // old serial devices
   cbBaudRate.Items.Add(IntToStr(2400));
   cbBaudRate.Items.Add(IntToStr(4800));
   cbBaudRate.Items.Add(IntToStr(9600));   // default for most scanners
   cbBaudRate.Items.Add(IntToStr(14400));
   cbBaudRate.Items.Add(IntToStr(19200));
   cbBaudRate.Items.Add(IntToStr(38400));
   cbBaudRate.Items.Add(IntToStr(56000));
   cbBaudRate.Items.Add(IntToStr(57600));
   cbBaudRate.Items.Add(IntToStr(115200)); // most common high‑speed
   cbBaudRate.Items.Add(IntToStr(128000));
   cbBaudRate.Items.Add(IntToStr(256000));

   // Data Bits
   cbDataBits.Items.Add(IntToStr(5)); // Baudot, teletype
   cbDataBits.Items.Add(IntToStr(6)); // rarely used
   cbDataBits.Items.Add(IntToStr(7)); // ASCII + parity
   cbDataBits.Items.Add(IntToStr(8)); // default for modern devices

   // Parity
   cbParity.Items.Add(IntToStr(0)); // NOPARITY
   cbParity.Items.Add(IntToStr(1)); // ODDPARITY
   cbParity.Items.Add(IntToStr(2)); // EVENPARITY
   cbParity.Items.Add(IntToStr(3)); // MARKPARITY
   cbParity.Items.Add(IntToStr(4)); // SPACEPARITY

   // Stop Bits
   cbStopBits.Items.Add(IntToStr(0)); // ONESTOPBIT - default
   cbStopBits.Items.Add(IntToStr(1)); // ONE5STOPBITS - only valid with 5 data bits
   cbStopBits.Items.Add(IntToStr(2)); // TWOSTOPBITS - industrial devices

   // Flow Control
   cbFlowControl.Items.Add('None');
   cbFlowControl.Items.Add('RTS/CTS');
   cbFlowControl.Items.Add('XON/XOFF');
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
   AppSettings:=TAppSettings.Create;
   AppSettings.LoadSettings;

   LoadDefaults;

   cbPort.Text:=AppSettings.Port;
   cbBaudRate.Text:=IntToStr(AppSettings.BaudRate);
   cbDataBits.Text:=IntToStr(AppSettings.DataBits);
   cbParity.Text:=IntToStr(AppSettings.Parity);
   cbStopBits.Text:=IntToStr(AppSettings.StopBits);
   cbFlowControl.ItemIndex:=AppSettings.FlowControl;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   AppSettings.Port       :=cbPort.Text;
   AppSettings.BaudRate   :=StrToInt(cbBaudRate.Text);
   AppSettings.DataBits   :=StrToInt(cbDataBits.Text);
   AppSettings.Parity     :=StrToInt(cbParity.Text);
   AppSettings.StopBits   :=StrToInt(cbStopBits.Text);
   AppSettings.FlowControl:=cbFlowControl.ItemIndex;

   AppSettings.SaveSettings;
   AppSettings.Free;
end;

end.
