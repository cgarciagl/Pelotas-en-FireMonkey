unit Ball;

interface

uses System.Types, FMX.Graphics, FMX.Objects;

type
  TBall = Class(TObject)
    Canvas: TCanvas;
    Rectangle: TRectangle;
    PuntoMaximo: TPointF;
  private
    Ftamanio: single;
    procedure SetTamanio(const Value: single);
    procedure CalculaPuntoMaximo;
  public
    Centro: TPointF;
    Velocidad: TPointF;
    Color: Cardinal;
    constructor Create(R: TRectangle; pTamanio: single);
    procedure borderCollision();
    procedure collisionWith(B: TBall);
    procedure Update();
    procedure Dibuja();
    property Tamanio: single read Ftamanio write SetTamanio;
  end;

implementation

uses System.UIConsts, FMX.Controls;

{ TBall }

procedure TBall.collisionWith(B: TBall);
var
  V1: TPointF;
  V2: TPointF;
  V3: TPointF;
  temp: single;
begin
  V1 := PuntoMaximo * (Centro + Velocidad);
  V2 := PuntoMaximo * (B.Centro + B.Velocidad);
  if (V1 - V2).Length < Tamanio then
  begin
    V3 := B.Centro - Centro;
    temp := V3.DotProduct(V3);
    V1.X := Velocidad.DotProduct(V3);
    V1.Y := B.Velocidad.DotProduct(V3);
    B.Velocidad := B.Velocidad - V3 * (V1.Y - V1.X) / temp;
    Velocidad := Velocidad - V3 * (V1.X - V1.Y) / temp;
  end;
end;

constructor TBall.Create(R: TRectangle; pTamanio: single);
begin
  Rectangle := R;
  Canvas := R.Canvas;
  Tamanio := pTamanio;
  PuntoMaximo := TPointF.Create(0, 0);
  CalculaPuntoMaximo;
  Centro := TPointF.Create(random, random);
  Velocidad := TPointF.Create(random, random).Normalize * 0.01;
end;

procedure TBall.Dibuja;
var
  R: TRectF;
begin
  R := TRectF.Empty;
  R.Offset(TPointF.Create(Tamanio, Tamanio) * 0.5 + Centro * PuntoMaximo);
  R.Inflate(Tamanio * 0.5, Tamanio * 0.5);
  Canvas.Fill.Color := Color;
  Canvas.FillEllipse(R, 1);
end;

procedure TBall.CalculaPuntoMaximo;
begin
  PuntoMaximo.X := Rectangle.Width - Tamanio;
  PuntoMaximo.Y := Rectangle.Height - Tamanio;
end;

procedure TBall.SetTamanio(const Value: single);
begin
  Ftamanio := Value;
  CalculaPuntoMaximo;
end;

procedure TBall.Update;
begin
  borderCollision;
end;

procedure TBall.borderCollision;
var
  V1: TPointF;
begin
  V1 := Centro + Velocidad;
  if (V1.X <= 0) or (V1.X >= 1) then
    Velocidad.X := -Velocidad.X;
  if (V1.Y <= 0) or (V1.Y >= 1) then
    Velocidad.Y := -Velocidad.Y;
  V1 := Centro + Velocidad;
  Centro := V1;
end;

end.
