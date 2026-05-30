unit AppSettings;

interface

uses
   Winapi.Windows, System.SysUtils, System.Classes, System.JSON;

const
   DCB_BINARY = $0001;

type
   TAppSettings = class
   private
      _Port    : string;
      _BaudRate: Integer;
      _DataBits: Integer;
      _Parity  : Integer;
      _StopBits: Integer;
      _Flags   : Integer;
      function GetSettingsFile: String;
   public
      property Port: string read _Port write _Port;
      property BaudRate: Integer read _BaudRate write _BaudRate;
      property DataBits: Integer read _DataBits write _DataBits;
      property Parity:   Integer read _Parity   write _Parity;
      property StopBits: Integer read _StopBits write _StopBits;
      property Flags:    Integer read _Flags    write _Flags;
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
   jsonObj  : TJSONObject;
   jsonData : string;
begin
   // If file doesn't exist load defaults
   if not TFile.Exists(GetSettingsFile) then
   begin
      _Port     := 'COM1';
      _BaudRate := 9600;
      _DataBits := 8;
      _Parity   :=NOPARITY;
      _StopBits :=ONESTOPBIT;
      _Flags    :=DCB_BINARY;
   end
   else
   begin
      jsonData:=TFile.ReadAllText(GetSettingsFile);
      jsonObj:=TJSONObject.ParseJSONValue(jsonData) as TJSONObject;
      try
         _Port    :=jsonObj.GetValue<string>('Port', 'COM1');
         _BaudRate:=jsonObj.GetValue<Integer>('BaudRate', 9600);
         _DataBits:=jsonObj.GetValue<Integer>('DataBits', 8);
         _Parity  :=jsonObj.GetValue<Integer>('Parity', NOPARITY);
         _StopBits:=jsonObj.GetValue<Integer>('StopBits', ONESTOPBIT);
         _Flags   :=jsonObj.GetValue<Integer>('Flags', DCB_BINARY);
      finally
         jsonObj.Free;
      end;
   end;
end;

//-------------------------------------------------------------------------------------------------
// Save Settings to JSON file
procedure TAppSettings.SaveSettings;
var
   jsonObj: TJSONObject;
begin
   jsonObj:=TJSONObject.Create;
   try
      jsonObj.AddPair('Port', _Port);
      jsonObj.AddPair('BaudRate', TJSONNumber.Create(_BaudRate));
      jsonObj.AddPair('DataBits', TJSONNumber.Create(_DataBits));
      jsonObj.AddPair('Parity',   TJSONNumber.Create(_Parity));
      jsonObj.AddPair('StopBits', TJSONNumber.Create(_StopBits));
      jsonObj.AddPair('Flags',    TJSONNumber.Create(_Flags));

      TFile.WriteAllText(GetSettingsFile, jsonObj.ToJSON);
   finally
      jsonObj.Free;
   end;
end;

end.

