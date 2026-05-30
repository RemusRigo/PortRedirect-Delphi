unit SerialThread;

interface

uses
  System.Classes, Winapi.Windows, System.SysUtils;

type
  TSerialDataEvent = reference to procedure(const Data: string);

  TSerialThread = class(TThread)
  private
    hCom: THandle;
    FOnData: TSerialDataEvent;
    FPort: string;
    FDCB: TDCB;
    procedure DoData(const S: string);
  protected
    procedure Execute; override;
  public
    constructor Create(const Port: string; const DCB: TDCB; OnData: TSerialDataEvent);
    procedure Stop;
    destructor Destroy; override;
  end;

implementation

constructor TSerialThread.Create(const Port: string; const DCB: TDCB; OnData: TSerialDataEvent);
begin
   inherited Create(False);
   FreeOnTerminate := False;

  FPort := Port;
  FDCB := DCB;
  FOnData := OnData;

  hCom := CreateFile(PChar(Port),
    GENERIC_READ or GENERIC_WRITE,
    0,
    nil,
    OPEN_EXISTING,
    0,   // blocking mode
    0
  );

  if hCom = INVALID_HANDLE_VALUE then
    Exit;

  SetCommState(hCom, FDCB);
end;

destructor TSerialThread.Destroy;
begin
  if hCom <> 0 then
    CloseHandle(hCom);
  inherited;
end;

procedure TSerialThread.Stop;
begin
   Terminate;
   CancelSynchronousIo(Self.Handle);

   if hCom <> 0 then
      CloseHandle(hCom);  // unblocks ReadFile
   hCom := 0;
end;

procedure TSerialThread.DoData(const S: string);
begin
  if Assigned(FOnData) then
    FOnData(S);
end;

procedure TSerialThread.Execute;
var
  buffer: array[0..255] of Byte;
  bytesRead: DWORD;
  s: string;
  i: Integer;
begin
  while not Terminated do
  begin
    if ReadFile(hCom, buffer, SizeOf(buffer), bytesRead, nil) then
    begin
      if bytesRead > 0 then
      begin
        s := '';
        for i := 0 to bytesRead - 1 do
          s := s + Chr(buffer[i]);

        Synchronize(
          procedure begin DoData(s); end
        );
      end;
    end
    else
      Break; // handle closed → exit thread
  end;
end;

end.

