unit Ball;

interface

uses System.Types, FMX.Graphics, FMX.Objects;

type
  TBall = Class(TObject)
    canvas: TCanvas;
    Rectangle: TRectangle;
    puntoMaximo: TPointF;
  private
    Ftamanio: single;
    procedure Settamanio(const Value: single);
    procedure calculaPuntoMaximo;
  public
    Centro: TPointF;
    Velocidad: TPointF;
    Color: Cardinal;
    constructor Create(R: TRectangle; pTamanio: single);
    procedure borderCollision();
    procedure collisionwith(B: TBall);
    procedure Update();
    procedure Dibuja();
    property tamanio: single read Ftamanio write Settamanio;
  end;

implementation

uses System.UIConsts, FMX.Controls;

{ TBall }

procedure TBall.collisionwith(B: TBall);
var
  V1: TPointF;
  V2: TPointF;
  V3: TPointF;
  temp: single;
begin
  V1 := puntoMaximo * (Centro + Velocidad);
  V2 := puntoMaximo * (B.Centro + B.Velocidad);
  if (V1 - V2).Length < tamanio then
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
  canvas := R.canvas;
  tamanio := pTamanio;
  puntoMaximo := TPointF.Create(0, 0);
  calculaPuntoMaximo;
  Centro := TPointF.Create(random, random);
  Velocidad := TPointF.Create(random, random).Normalize * 0.01;
end;

procedure TBall.Dibuja;
var
  R: TRectF;
begin
  R := TRectF.Empty;
  R.Offset(TPointF.Create(tamanio, tamanio) * 0.5 + Centro * puntoMaximo);
  R.Inflate(tamanio * 0.5, tamanio * 0.5);
  canvas.Fill.Color := Color;
  canvas.FillEllipse(R, 1);
end;

procedure TBall.calculaPuntoMaximo;
begin
  puntoMaximo.X := Rectangle.Width - tamanio;
  puntoMaximo.Y := Rectangle.Height - tamanio;
end;

procedure TBall.Settamanio(const Value: single);
begin
  Ftamanio := Value;
  calculaPuntoMaximo;
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
