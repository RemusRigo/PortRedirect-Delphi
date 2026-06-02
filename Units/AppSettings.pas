unit AppSettings;

interface

uses
   Winapi.Windows, System.SysUtils, System.Classes, System.JSON;

const
   DCB_BINARY = $0001;

type
   TAppSettings = class
   private
      _Port       : string;
      _BaudRate   : Integer;
      _DataBits   : Integer;
      _Parity     : Integer;
      _StopBits   : Integer;
      _FlowControl: Integer;
      _WindowTitle: String;
      function GetSettingsFile: String;
   public
      property Port       : String  read _Port        write _Port;
      property BaudRate   : Integer read _BaudRate    write _BaudRate;
      property DataBits   : Integer read _DataBits    write _DataBits;
      property Parity     : Integer read _Parity      write _Parity;
      property StopBits   : Integer read _StopBits    write _StopBits;
      property FlowControl: Integer read _FlowControl write _FlowControl;
      property WindowTitle: String  read _WindowTitle write _WindowTitle;
      procedure LoadSettings;
      procedure SaveSettings;
   end;

implementation

uses
   System.IOUtils;

function TAppSettings.GetSettingsFile: string;
begin
   Result:=IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ChangeFileExt(ExtractFileName(ParamStr(0)), '.json');
end;

//-------------------------------------------------------------------------------------------------
// Load Settings from JSON file
procedure TAppSettings.LoadSettings;
var
   root, com  : TJSONObject;
   jsonData: String;
begin
   if not TFile.Exists(GetSettingsFile) then
   begin
      _Port        := 'COM1';
      _BaudRate    := 9600;
      _DataBits    := 8;
      _Parity      := 0;
      _StopBits    := 1;
      _FlowControl := 0;
      _WindowTitle := 'Untitled - Notepad';
      Exit;
   end;

   jsonData:=TFile.ReadAllText(GetSettingsFile);
   root:=TJSONObject.ParseJSONValue(jsonData) as TJSONObject;
   if Assigned(root) then
   try
      com:=root.GetValue('Connection') as TJSONObject;
      if Assigned(com) then
      begin
         _Port       :=com.GetValue<String>('Port', 'COM1');
         _BaudRate   :=com.GetValue<Integer>('BaudRate', 9600);
         _DataBits   :=com.GetValue<Integer>('DataBits', 8);
         _Parity     :=com.GetValue<Integer>('Parity', 0);
         _StopBits   :=com.GetValue<Integer>('StopBits', 1);
         _FlowControl:=com.GetValue<Integer>('FlowControl', 0);
         _WindowTitle:=com.GetValue<String>('WindowTitle', 'Untitled - Notepad');
      end;
   finally
      root.Free;
   end;
end;

//-------------------------------------------------------------------------------------------------
// Save Settings to JSON file
procedure TAppSettings.SaveSettings;
var
   root, com: TJSONObject;
begin
   com:=TJSONObject.Create;
   root:=TJSONObject.Create;
   try
      com.AddPair('Port', _Port);
      com.AddPair('BaudRate', TJSONNumber.Create(_BaudRate));
      com.AddPair('DataBits', TJSONNumber.Create(_DataBits));
      com.AddPair('Parity', TJSONNumber.Create(_Parity));
      com.AddPair('StopBits', TJSONNumber.Create(_StopBits));
      com.AddPair('FlowControl', TJSONNumber.Create(_FlowControl));
      com.AddPair('WindowTitle', _WindowTitle);

      root.AddPair('Connection', com);

      TFile.WriteAllText(GetSettingsFile, root.Format(3));
   finally
      root.Free; // frees com too
   end;
end;

end.

