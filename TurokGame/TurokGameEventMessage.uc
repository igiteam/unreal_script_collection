class TurokGameEventMessage extends TurokLocalizedMessage
    abstract
    transient;

var float mTextScale;

function Draw(@NULL HUD, float X, float Y)
{
    local int textWidth, textHeight;
    local float MaxScale;
    local @NULL font_offset, shadow_offset;

    HUD.Canvas.DrawColor = DrawColor;
    HUD.Canvas.DrawColor.A = byte(GetOpacity());
    mFont.GetFont(MaxScale, font_offset, shadow_offset, HUD.Canvas.Font, 1.0000000);
    HUD.Canvas.TurokStrLen(mText, mTextScale, mTextScale, mFont, textWidth, textHeight);
    HUD.Canvas.SetPos(X - float(textWidth / 2), Y);
    HUD.Canvas.TurokDrawText(mText, mFont, mTextScale, mTextScale, 0, true);
    //return;    
}

defaultproperties
{
    mTextScale=0.3580000
}