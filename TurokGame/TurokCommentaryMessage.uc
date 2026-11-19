class TurokCommentaryMessage extends TurokLocalizedMessage
    abstract
    transient;

var @NULL mTurokFont;
var float mScale;

function Draw(@NULL HUD, float X, float Y)
{
    HUD.Canvas.DrawColor = DrawColor;
    HUD.Canvas.DrawColor.A = byte(GetOpacity());
    HUD.Canvas.SetPos(X + 3.0000000, Y - 40.0000000);
    HUD.Canvas.TurokDrawText(mText, mTurokFont, mScale, mScale, 0, true);
    //return;    
}

defaultproperties
{
    mTurokFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mScale=0.2990000
}