class PandoraGameHUD extends HUD
    transient
    config(Game);

function DrawEngineHUD()
{
    local float CrosshairSize, XL, YL, Y;
    local string myText;
    local bool canDebug;

    // End:0x39
    if((PandoraPlayerController(PlayerOwner) != none) && PandoraPlayerController(PlayerOwner).CanIDebug())
    {
        canDebug = true;        
    }
    else
    {
        canDebug = false;
    }
    // End:0x109
    if(canDebug)
    {
        Canvas.SetDrawColor(75, 75, 75, 255);
        myText = "SP LETMEDEBUG";
        Canvas.Font = Class'Engine.Engine'.static.GetLargeFont();
        Canvas.StrLen(myText, XL, YL);
        Y = YL + float(72);
        Canvas.SetPos(CenterX - (XL / float(2)), 72.0000000);
        Canvas.DrawText(myText, true);        
    }
    else
    {
        Canvas.SetDrawColor(255, 255, 255, 255);
        myText = "Pandora";
        Canvas.Font = Class'Engine.Engine'.static.GetSmallFont();
        Canvas.StrLen(myText, XL, YL);
        Y = YL + float(72);
        Canvas.SetPos(CenterX - (XL / float(2)), 72.0000000);
        Canvas.DrawText(myText, true);
        Canvas.SetDrawColor(200, 200, 200, 255);
        myText = "Copyright (C) 2005, Spark Unlimited, Inc.";
        Canvas.Font = Class'Engine.Engine'.static.GetTinyFont();
        Canvas.StrLen(myText, XL, YL);
        Canvas.SetPos(CenterX - (XL / float(2)), Y);
        Canvas.DrawText(myText, true);
    }
    // End:0x2FA
    if((PlayerOwner != none) && Pawn(PlayerOwner.ViewTarget) != none)
    {
        CrosshairSize = 4.0000000;
        Canvas.SetPos(CenterX - CrosshairSize, CenterY);
        Canvas.SetPos(CenterX, CenterY - CrosshairSize);
    }
    //return;    
}
