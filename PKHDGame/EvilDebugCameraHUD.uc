class EvilDebugCameraHUD extends DebugCameraHUD
    transient
    config(Game)
    hidecategories(Navigation);

var bool bShowCoverDebug;

exec function ShowCoverDebug()
{
    bShowCoverDebug = !bShowCoverDebug;
    //return;    
}

event DrawHUD()
{
    super(HUD).DrawHUD();
    // End:0x21
    if(bShowCoverDebug)
    {
        DrawCoverOverlays();
    }
    //return;    
}

function DrawCoverOverlays()
{
    local EvilCoverLink B;
    local Vector pos;
    local float XL, YL;
    local string Text;
    local int I;
    local DebugCameraController DCC;
    local EvilAIController Controller;

    DCC = DebugCameraController(PlayerOwner);
    // End:0x528
    if(DCC != none)
    {
        // End:0x108
        if(((DCC.SelectedActor != none) && EvilPawn(DCC.SelectedActor) != none) && EvilPawn(DCC.SelectedActor).MyEvilAI != none)
        {
            Controller = EvilPawn(DCC.SelectedActor).MyEvilAI;
        }
        Canvas.Font = GetFontSizeIndex(0);
        // End:0x527
        foreach WorldInfo.AllNavigationPoints(Class'EvilCoverLink', B)
        {
            I = 0;
            J0x171:

            // End:0x526 [Loop If]
            if(I < B.Slots.Length)
            {
                // End:0x518
                if(B != none)
                {
                    // End:0x518
                    if((Vector(PlayerOwner.Rotation) Dot (B.GetSlotLocation(I) - PlayerOwner.ViewTarget.Location)) > 0.0000000)
                    {
                        pos = Canvas.Project(B.GetSlotLocation(I));
                        Text = B.GetAIDebugString(I, Controller);
                        Canvas.StrLen(Text, XL, YL);
                        pos.X = FClamp(pos.X, 0.0000000, Canvas.ClipX - XL);
                        pos.Y = FClamp(pos.Y, 0.0000000, Canvas.ClipY - YL);
                        Canvas.SetPos(pos.X, pos.Y);
                        Canvas.DrawColor = ConsoleColor;
                        Canvas.DrawColor.A = ((FastTrace(B.GetSlotLocation(I), PlayerOwner.ViewTarget.Location,, true)) ? 255 : 128);
                        Canvas.DrawText(Text);
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x171;
            }            
        }        
    }
    //return;    
}
