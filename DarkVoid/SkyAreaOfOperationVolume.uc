class SkyAreaOfOperationVolume extends Volume
    native;

var() editconst int AreaGUID;
var() editfixedsize editconst array<editconst NavigationPoint> NavPointsContained;

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Vector FocusLoc, ToVect;
    local Font OldFont;

    ToVect = Normal(Location - HUD.PlayerOwner.PlayerCamera.Location);
    // End:0x6A
    if((ToVect Dot Vector(HUD.PlayerOwner.PlayerCamera.Rotation)) < 0.7500000)
    {
        return;
    }
    FocusLoc = HUD.Canvas.Project(Location + vect(0.0000000, 0.0000000, 100.0000000));
    HUD.Canvas.SetPos(FocusLoc.X, FocusLoc.Y);
    HUD.Canvas.DrawColor = BrushColor;
    OldFont = HUD.Canvas.Font;
    HUD.Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    HUD.Canvas.DrawTextClipped("AreaOfOperation: " $ string(AreaGUID));
    HUD.Canvas.Font = OldFont;
    //return;    
}
