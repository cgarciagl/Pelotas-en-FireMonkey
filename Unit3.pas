unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Ani, Ball;

type
  TForm3 = class(TForm)
    ToolBar1: TToolBar;
    btnAgregar10: TButton;
    TrackBar1: TTrackBar;
    Rectangle1: TRectangle;
    FloatAnimation1: TFloatAnimation;
    StyleBook1: TStyleBook;
    procedure btnAgregar10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Rectangle1Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure TrackBar1Change(Sender: TObject);
    procedure FloatAnimation1Process(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure CalculaColisiones;
    { Private declarations }
  public
    { Public declarations }
    TamanioDelCirculo: single;
    Centros, Velocidades: Array of TPointF;
    Color: Array of Cardinal;
    Pelotas: TObjectList<TBall>;
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}

uses System.UIConsts;

procedure TForm3.btnAgregar10Click(Sender: TObject);
var
  i: integer;
  B: TBall;
begin
  for i := 1 to 10 do
  begin
    B := TBall.Create(Rectangle1, TrackBar1.Value);
    Pelotas.Add(B);
    if random(100) > 50 then
      B.Color := TAlphaColorRec.Orange
    else
      B.Color := TAlphaColorRec.Chocolate;
  end;
end;

procedure TForm3.FloatAnimation1Process(Sender: TObject);
begin
  Rectangle1.Repaint;
end;

procedure TForm3.CalculaColisiones;
var
  i: integer;
  j: integer;
begin
  for i := 0 to Pelotas.count - 2 do
    for j := i + 1 to Pelotas.count - 1 do
    begin
      Pelotas[i].collisionwith(Pelotas[j]);
    end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  randomize();
  TamanioDelCirculo := 23;
  Pelotas := TObjectList<TBall>.Create;
end;

procedure TForm3.FormResize(Sender: TObject);
begin
   TrackBar1Change(Sender);
end;

procedure TForm3.Rectangle1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  i: integer;
begin
  for i := 0 to Pelotas.count - 1 do
  begin
    Pelotas[i].update();
    Pelotas[i].dibuja();
  end;
  CalculaColisiones;
end;

procedure TForm3.TrackBar1Change(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Pelotas.count - 1 do
  begin
    Pelotas[i].tamanio := TrackBar1.Value;
  end;
  Rectangle1.Repaint;
end;

end.
