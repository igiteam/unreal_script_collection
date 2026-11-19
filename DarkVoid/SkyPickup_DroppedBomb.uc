class SkyPickup_DroppedBomb extends SkyWeaponPickup;

simulated function PostRenderFor(PlayerController PC, Canvas Canvas, Vector CameraPosition, Vector CameraDir)
{
    local string resetString;
    local Vector ScreenLoc;
    local float W, H;

    resetString = "Reset in " $ string(LifeSpan);
    ScreenLoc = Canvas.Project(Location);
    // End:0xB5
    if((((ScreenLoc.X < float(0)) || ScreenLoc.X >= Canvas.ClipX) || ScreenLoc.Y < float(0)) || ScreenLoc.Y >= Canvas.ClipY)
    {
        return;
    }
    Canvas.TextSize(resetString, W, H);
    Canvas.SetPos(ScreenLoc.X - (W / float(2)), ScreenLoc.Y);
    Canvas.Font = Class'Engine.Engine'.static.GetMediumFont();
    Canvas.DrawTextClipped(resetString);
    super(Actor).PostRenderFor(PC, Canvas, CameraPosition, CameraDir);
    //return;    
}
