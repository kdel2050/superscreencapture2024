unit main_unit;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Windows, Graphics, Classes, Forms, Controls, Dialogs, Buttons,
  StdCtrls, LCLIntf, LCLType, ExtCtrls, Menus, StrUtils, LazFileUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PopupMenu1: TPopupMenu;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    TrayIcon1: TTrayIcon;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GetScreenToFile();
    procedure FormWindowStateChange(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);


  private
    //HotKeyID: Integer;
    HotKeyIDPrintKey: Integer;
    procedure WMHotKey(var Msg:TMessage);message WM_HOTKEY;

  public

  end;

var
  Form1: TForm1;
  take_scr_key: Integer;
  save_screen_path: string;

implementation

{$R *.lfm}

{ TForm1 }

procedure SaveToPng(const bmp: TBitmap; PngFileName: String);
var
  png : TPortableNetworkGraphic;
begin
  png := TPortableNetworkGraphic.Create;
  try
    png.Assign(bmp);
    png.SaveToFile(PngFileName);
  finally
    png.Free;
  end;
end;




procedure TForm1.GetScreenToFile();
var
  ScreenDC: HDC;
  LocalBitmap: TBitmap;
  cur_date, cur_time, timestamp: String;
  YY,MM,DD : Word;


begin
  Hide;
  Application.ProcessMessages;
  LocalBitmap := TBitmap.Create;
  ScreenDC := GetDC(0);
  try
    LocalBitmap.LoadFromDevice(ScreenDC);
    DeCodeDate (Date,YY,MM,DD);
    cur_date := format('%d/%d/%d ',[dd,mm,yy]);
    cur_time := TimeToStr(Time);
    timestamp := 'scr-' + cur_date + '-' + cur_time;
    timestamp := stringreplace(timestamp,':','-',[rfReplaceAll]);
    timestamp := stringreplace(timestamp,'/','-',[rfReplaceAll]);
    timestamp := DelSpace(timestamp);

    //save_screen_path := 'C:\folders\screen\';

    //save_screen_path :=

    SaveToPng(LocalBitmap, save_screen_path + timestamp + '.png');

    //SaveToPng(LocalBitmap,  + timestamp + '.png');


  finally
    LocalBitmap.Free;
    ReleaseDC(0, ScreenDC);
    //Show;
      Hide;
      ShowInTaskBar := stNever;
    //Application.Minimize;
  end;
end;





procedure TForm1.WMHotKey(var Msg: TMessage);

begin

  if Msg.wParam = HotKeyIDPrintKey  then GetScreenToFile();

end;




procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  try
    begin
      take_scr_key := 1;
      // HotKey Print Key
      HotKeyIDPrintKey := GlobalAddAtom('HotKey1');
      if take_scr_key = 1 then
            RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_F4)
      else
            RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_SNAPSHOT);


    end;

  finally

  end;

end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin

  //SystrayIcon.Icon.LoadFromFile('/path_to_icon/icon.ico');
  //TrayIcon1.ShowHint := True;
  //TrayIcon1.Hint := 'Super Screen Capture';
  //SystrayIcon.PopUpMenu := MyPopUpMenu;
  //TrayIcon1.Show;
  //TrayIcon1.Visible := true;
  //Application.Minimize;
  //TForm1.ShowInTaskBar:=false;
  //if WindowState = wsMinimized then begin
  //WindowState := wsNormal;
  Hide;
  ShowInTaskBar := stNever;

end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin

  if SelectDirectoryDialog1.Execute then
       save_screen_path := SelectDirectoryDialog1.FileName + PathDelim;

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin

  if ComboBox1.Text = 'PrintScreen' then
     begin
       take_scr_key := 2;
     end;

  if ComboBox1.Text = 'F4' then
     begin
          take_scr_key := 1;
     end;

  UnRegisterHotKey(Handle, HotKeyIDPrintKey);
  GlobalDeleteAtom(HotKeyIDPrintKey);

  HotKeyIDPrintKey := GlobalAddAtom('HotKey1');

  if take_scr_key = 1 then
        RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_F4)
  else
        RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_SNAPSHOT);



end;


procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  //UnRegisterHotKey(Handle, HotKeyID);
  //GlobalDeleteAtom(HotKeyID);

  UnRegisterHotKey(Handle, HotKeyIDPrintKey);
  GlobalDeleteAtom(HotKeyIDPrintKey);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  try
    begin
      // HotKey Print Key

      take_scr_key := 1;

      save_screen_path := AppendPathDelim(GetUserDir + 'Documents');

      HotKeyIDPrintKey := GlobalAddAtom('HotKey1');
      if take_scr_key = 1 then
            RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_F4)
      else
            RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_SNAPSHOT);

      TrayIcon1.Visible := true;
      Hide;
      ShowInTaskBar := stNever;
      Self.WindowState := wsMinimized;
      //ShowInTaskBar := stNever;
    end;

  finally

  end;
end;



procedure TForm1.FormDestroy(Sender: TObject);
begin
  //UnRegisterHotKey(Handle, HotKeyID);
  //GlobalDeleteAtom(HotKeyID);

  UnRegisterHotKey(Handle, HotKeyIDPrintKey);
  GlobalDeleteAtom(HotKeyIDPrintKey);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  //form1.Hide;
  //Form1.ShowInTaskBar := stNever;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
   if Form1.WindowState = wsMinimized then
   begin
      //form1.WindowState := wsNormal;
      form1.Hide;
      Form1.ShowInTaskBar := stNever;
   end;
end;





procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  HotKeyIDPrintKey := GlobalAddAtom('HotKey1');
    if take_scr_key = 1 then
        RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_F4)
  else
        RegisterHotKey(Handle, HotKeyIDPrintKey, 0, VK_SNAPSHOT);

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  //UnRegisterHotKey(Handle, HotKeyID);
  //GlobalDeleteAtom(HotKeyID);

  UnRegisterHotKey(Handle, HotKeyIDPrintKey);
  GlobalDeleteAtom(HotKeyIDPrintKey);

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  //UnRegisterHotKey(Handle, HotKeyID);
  //GlobalDeleteAtom(HotKeyID);

  UnRegisterHotKey(Handle, HotKeyIDPrintKey);
  GlobalDeleteAtom(HotKeyIDPrintKey);
  Application.Terminate;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Show;
  Form1.ShowInTaskBar := stAlways;
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  Show;
  Form1.ShowInTaskBar := stAlways;
end;

end.



