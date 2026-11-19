class SkyVehicleWheel extends SVehicleWheel
    native;

struct native VWheelParticleType
{
    var ParticleSystem Effect;
    var name Material;

    structdefaultproperties
    {
        Effect=none
        Material="None"
    }
};

var array<VWheelParticleType> MaterialEffects;

simulated event DisplayDebug(SVehicle Vehicle, HUD HUD, out float out_XPos, out float out_YL, out float out_YPos)
{
    local Vector WheelScreenPos;
    local float SuspensionScale;
    local int J;
    local Vector ScreenLoc;
    local Color SaveColor;
    local float LastForceValue, GraphScale, ForceValue;
    local Vector ForceValueLoc;
    local Vector2D StartPos;

    StartPos.X = out_XPos;
    StartPos.Y = out_YPos;
    out_XPos += float(5);
    out_YPos += float(5);
    GraphScale = 100.0000000;
    SaveColor = HUD.Canvas.DrawColor;
    ScreenLoc.Y = out_YPos + GraphScale;
    ScreenLoc.X = out_XPos + float(200);
    WheelScreenPos = HUD.Canvas.Project((WheelPosition >> Vehicle.Rotation) + Vehicle.Location);
    HUD.Canvas.SetDrawColor(255, 255, 0);
    HUD.Canvas.SetPos(out_XPos, out_YPos);
    HUD.Canvas.DrawText("Wheel: " $ string(Name));
    out_YPos += out_YL;
    SuspensionScale = 100.0000000 / SuspensionTravel;
    HUD.Canvas.SetDrawColor(255, 0, 0, 128);
    // End:0x20E
    if(DesiredSuspensionPosition > float(0))
    {
        HUD.Canvas.SetPos(out_XPos + float(2), out_YPos + float(2));
        HUD.Canvas.DrawRect(DesiredSuspensionPosition * SuspensionScale, 8.0000000);        
    }
    else
    {
        HUD.Canvas.SetPos((out_XPos + (DesiredSuspensionPosition * SuspensionScale)) + float(2), out_YPos + float(2));
        HUD.Canvas.DrawRect(-DesiredSuspensionPosition * SuspensionScale, 8.0000000);
    }
    HUD.Canvas.SetDrawColor(255, 255, 255);
    HUD.Canvas.SetPos(out_XPos, out_YPos);
    HUD.Canvas.DrawBox(102.0000000, 10.0000000);
    HUD.Canvas.SetDrawColor(0, 255, 0);
    // End:0x377
    if(SuspensionPosition > float(0))
    {
        HUD.Canvas.SetPos(out_XPos + float(2), out_YPos + float(2));
        HUD.Canvas.DrawRect(FMin(SuspensionPosition * SuspensionScale, 100.0000000), 8.0000000);        
    }
    else
    {
        HUD.Canvas.SetPos((out_XPos + (SuspensionPosition * SuspensionScale)) + float(2), out_YPos + float(2));
        HUD.Canvas.DrawRect(FMin(-SuspensionPosition * SuspensionScale, 100.0000000), 8.0000000);
    }
    out_YPos += float(12);
    HUD.Canvas.SetDrawColor(255, 255, 255);
    HUD.Canvas.SetPos(out_XPos, out_YPos);
    HUD.Canvas.DrawText((string(DesiredSuspensionPosition) @ "/") @ string(SuspensionTravel));
    out_YPos += out_YL;
    HUD.Canvas.SetPos(out_XPos, out_YPos);
    HUD.Canvas.DrawText(("Spinning at " $ string(SpinVel)) $ " radians per second.");
    out_YPos += out_YL;
    out_XPos += float(10);
    HUD.Canvas.DrawColor = MakeColor(255, 255, 255, 255);
    HUD.Draw2DLine(int(ScreenLoc.X), int(ScreenLoc.Y), int(ScreenLoc.X + GraphScale), int(ScreenLoc.Y), MakeColor(0, 0, 255, 255));
    HUD.Canvas.SetPos(ScreenLoc.X + GraphScale, ScreenLoc.Y);
    HUD.Canvas.DrawText(string(3.1415930 * 0.5000000));
    HUD.Draw2DLine(int(ScreenLoc.X), int(ScreenLoc.Y), int(ScreenLoc.X), int(ScreenLoc.Y - GraphScale), MakeColor(0, 0, 255, 255));
    HUD.Canvas.SetPos(ScreenLoc.X, ScreenLoc.Y - GraphScale);
    HUD.Canvas.DrawText(string(Vehicle.SimObj.WheelLatExtremumValue));
    LastForceValue = 0.0000000;
    J = 0;
    J0x6FC:

    // End:0x80E [Loop If]
    if(float(J) <= GraphScale)
    {
        ForceValue = Vehicle.HermiteEval(float(J) * ((3.1415930 * 0.5000000) / GraphScale));
        ForceValue = (ForceValue / Vehicle.SimObj.WheelLatExtremumValue) * GraphScale;
        HUD.Draw2DLine(int(ScreenLoc.X + float(J - 1)), int(ScreenLoc.Y - LastForceValue), int(ScreenLoc.X + float(J)), int(ScreenLoc.Y - ForceValue), MakeColor(0, 255, 0, 255));
        LastForceValue = ForceValue;
        J++;
        // [Loop Continue]
        goto J0x6FC;
    }
    ForceValue = Vehicle.HermiteEval(Abs(LatSlipAngle));
    ForceValueLoc.X = ScreenLoc.X + ((Abs(LatSlipAngle) / (3.1415930 * 0.5000000)) * GraphScale);
    ForceValueLoc.Y = ScreenLoc.Y - ((ForceValue / Vehicle.SimObj.WheelLatExtremumValue) * GraphScale);
    HUD.Draw2DLine(int(ForceValueLoc.X - float(5)), int(ForceValueLoc.Y), int(ForceValueLoc.X + float(5)), int(ForceValueLoc.Y), MakeColor(255, 0, 0, 255));
    HUD.Draw2DLine(int(ForceValueLoc.X), int(ForceValueLoc.Y - float(5)), int(ForceValueLoc.X), int(ForceValueLoc.Y + float(5)), MakeColor(255, 0, 0, 255));
    HUD.Canvas.SetPos(ScreenLoc.X, ForceValueLoc.Y);
    HUD.Canvas.DrawText(string(ForceValue));
    HUD.Canvas.SetPos(ForceValueLoc.X, ScreenLoc.Y + out_YL);
    HUD.Canvas.DrawText(string(LatSlipAngle));
    // End:0xAAD
    if((out_YPos - ScreenLoc.Y) < (GraphScale * 0.3000000))
    {
        out_YPos = ScreenLoc.Y + (GraphScale * 0.3000000);
    }
    out_YPos += float(5);
    HUD.Canvas.SetDrawColor(255, 255, 0);
    HUD.Canvas.SetPos(StartPos.X - float(10), StartPos.Y + float(10));
    HUD.Canvas.DrawRect(10.0000000, 1.0000000);
    HUD.Canvas.SetPos(StartPos.X - float(10), StartPos.Y + float(10));
    HUD.Canvas.DrawRect(1.0000000, WheelScreenPos.Y - (StartPos.Y + float(10)));
    // End:0xC82
    if(WheelScreenPos.X < (StartPos.X - float(10)))
    {
        HUD.Canvas.SetPos(WheelScreenPos.X, WheelScreenPos.Y);
        HUD.Canvas.DrawRect((StartPos.X - float(10)) - WheelScreenPos.X, 1.0000000);        
    }
    else
    {
        HUD.Canvas.SetPos(StartPos.X - float(10), WheelScreenPos.Y);
        HUD.Canvas.DrawRect(WheelScreenPos.X - (StartPos.X - float(10)), 1.0000000);
    }
    HUD.Canvas.SetPos(StartPos.X, StartPos.Y);
    HUD.Canvas.DrawBox((ScreenLoc.X - StartPos.X) + (GraphScale * 1.5000000), out_YPos - StartPos.Y);
    HUD.Canvas.DrawColor = SaveColor;
    //return;    
}
