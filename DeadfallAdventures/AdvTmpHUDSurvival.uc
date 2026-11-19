class AdvTmpHUDSurvival extends AdvTmpHUD
    transient
    config(Game)
    hidecategories(Navigation);

function drawBoardScore()
{
    local PlayerReplicationInfo PRI;
    local int offsetX1, offsetX2, OffsetY;

    offsetX1 = int(Canvas.ClipX * 0.0500000);
    offsetX2 = int(Canvas.ClipX * 0.1500000);
    OffsetY = int(Canvas.ClipY * 0.0600000);
    Canvas.SetPos(float(offsetX1), float(OffsetY));
    Canvas.DrawText("Player:");
    Canvas.SetPos(float(offsetX2), float(OffsetY));
    Canvas.DrawText("Score:");
    OffsetY += 40;
    // End:0x27A
    foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
    {
        Canvas.SetPos(float(offsetX1), float(OffsetY));
        Canvas.DrawText(PRI.PlayerName);
        Canvas.SetPos(float(offsetX2), float(OffsetY));
        Canvas.DrawText(string(PRI.Score));
        OffsetY += 25;        
    }    
    //return;    
}

function writeRemainingTime()
{
    //return;    
}

function writeFinalInfo()
{
    //return;    
}
