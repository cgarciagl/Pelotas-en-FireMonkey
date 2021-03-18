unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Ani;

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
  private
    procedure CalculaColisiones;
    { Private declarations }
  public
    { Public declarations }
    TamanioDelCirculo: single;
    Centros, Velocidades: Array of TPointF;
    Color: Array of Cardinal;
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
  Cuantos: integer;
  i: integer;
begin
  for i := 1 to 10 do
  begin
    Cuantos := Length(Centros);
    SetLength(Centros, Cuantos + 1);
    SetLength(Velocidades, Cuantos + 1);
    SetLength(Color, Cuantos + 1);
    Centros[Cuantos] := TPointF.Create(random, random);
    Velocidades[Cuantos] := TPointF.Create(random, random).Normalize * 0.01;
    if random(100) > 50 then
      Color[Cuantos] := TAlphaColorRec.Orange
    else
      Color[Cuantos] := TAlphaColorRec.Chocolate;
  end;
end;

procedure TForm3.FloatAnimation1Process(Sender: TObject);
begin
  Rectangle1.Repaint;

end;

procedure TForm3.CalculaColisiones;
var
  Cuantos: integer;
  S: TPointF;
  i: integer;
  j: integer;
  V1: TPointF;
  V2: TPointF;
  V3: TPointF;
  temp: single;
begin
  Cuantos := Length(Centros);
  S := TPointF.Create(Rectangle1.Width - TamanioDelCirculo,
    Rectangle1.Height - TamanioDelCirculo);
  for i := 0 to Cuantos - 2 do
    for j := i + 1 to Cuantos - 1 do
    begin
      V1 := S * (Centros[i] + Velocidades[i]);
      V2 := S * (Centros[j] + Velocidades[j]);
      if (V1 - V2).Length < TamanioDelCirculo then
      begin
        V3 := Centros[j] - Centros[i];
        temp := V3.DotProduct(V3);
        V1.X := Velocidades[i].DotProduct(V3);
        V1.Y := Velocidades[j].DotProduct(V3);
        Velocidades[j] := Velocidades[j] - V3 * (V1.Y - V1.X) / temp;
        Velocidades[i] := Velocidades[i] - V3 * (V1.X - V1.Y) / temp;
      end;
    end;
  for i := 0 to Cuantos - 1 do
  begin
    V1 := Centros[i] + Velocidades[i];
    if (V1.X < 0) or (V1.X > 1) then
      Velocidades[i].X := -Velocidades[i].X;
    if (V1.Y < 0) or (V1.Y > 1) then
      Velocidades[i].Y := -Velocidades[i].Y;
    V1 := Centros[i] + Velocidades[i];
    Centros[i] := V1;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  randomize();
  TamanioDelCirculo := 23;
end;

procedure TForm3.Rectangle1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  i, Cuantos: integer;
  R: TRectF;
  S: TPointF;
begin
  Canvas.BeginScene;
  Cuantos := Length(Centros);
  S := TPointF.Create(Rectangle1.Width - TamanioDelCirculo,
    Rectangle1.Height - TamanioDelCirculo);
  for i := 0 to Cuantos - 1 do
  begin
    R := TRectF.Empty;
    R.Offset(TPointF.Create(TamanioDelCirculo, TamanioDelCirculo) * 0.5 +
      Centros[i] * S);
    R.Inflate(TamanioDelCirculo * 0.5, TamanioDelCirculo * 0.5);
    Canvas.Fill.Color := Color[i];
    Canvas.FillEllipse(R, 1);
  end;
  Canvas.EndScene;

  CalculaColisiones;
end;

procedure TForm3.TrackBar1Change(Sender: TObject);
begin
  TamanioDelCirculo := TrackBar1.Value;
  Rectangle1.Repaint;
end;

end.
