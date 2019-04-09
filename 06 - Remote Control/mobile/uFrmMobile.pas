unit uFrmMobile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Tether.Manager, System.Tether.AppProfile;

type
  TForm1 = class(TForm)
    TetheringAppProfile1: TTetheringAppProfile;
    TetheringManager1: TTetheringManager;
    btnConectar: TButton;
    ActionList1: TActionList;
    TakePhotoFromCameraAction1: TTakePhotoFromCameraAction;
    btnPhoto: TButton;
    Label1: TLabel;
    Button1: TButton;
    Action1: TAction;
    procedure btnPhotoClick(Sender: TObject);
    procedure TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
    procedure btnConectarClick(Sender: TObject);
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure TetheringManager1EndAutoConnect(Sender: TObject);
  private
    { Private declarations }
    PhotoStream : TMemoryStream;
  public
    { Public declarations }
    procedure Check;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

uses
  System.Tether.TCPProtocol;

procedure TForm1.btnConectarClick(Sender: TObject);
begin
  TetheringManager1.AutoConnect();
end;

procedure TForm1.btnPhotoClick(Sender: TObject);
begin
  TakePhotoFromCameraAction1.Execute;
end;

procedure TForm1.Check;
begin
 if TetheringManager1.RemoteProfiles.Count > 0 then
  Label1.Text := TetheringManager1.RemoteProfiles[0].ProfileGroup;
end;

procedure TForm1.TakePhotoFromCameraAction1DidFinishTaking(Image: TBitmap);
begin
  if PhotoStream = nil then
    PhotoStream := TMemoryStream.Create;

  Try
    PhotoStream.Position := 0;
    Image.SaveToStream(PhotoStream);
    PhotoStream.Position := 0;
    TetheringAppProfile1.Resources.Items[0].Value := PhotoStream;
  Except
    On E : Exception do
    ShowMessage(E.Message);
  End;
end;

procedure TForm1.TetheringManager1EndAutoConnect(Sender: TObject);
begin
  Check;
end;

procedure TForm1.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := 'delphi';
end;

end.
