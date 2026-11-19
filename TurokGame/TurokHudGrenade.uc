class TurokHudGrenade extends TurokHudElement
    transient
    native;

var @NULL mGrenadeTexture;
var @NULL mBackgroundTexture;
var @NULL mCornerTexture;
var @NULL mAmmoDisplay;
var @NULL mFont;
var float mTextScale;
var float mXTextScale;
var @NULL mTextFlashColor;
var float mTextFlashLength;
var float mTextFlashTime;
var int mLastGrenades;
var float mImageTranslucency;
var int mWidth;
var int mSpacing;
var int mGrenadeXSpacing;
var int mEdgeGrenadeSpacing;
var int mStartOffset;
var @NULL mBackgroundColor;
var @NULL mGrenadesColor;
var @NULL mLowAmmoColor;

// Export UTurokHudGrenade::execDrawContainer(FFrame&, void* const)
native function DrawContainer(int XPos, int YPos, int Width, int Height);

// Export UTurokHudGrenade::execDrawGrenades(FFrame&, void* const)
native function DrawGrenades();

event int CountGrenades()
{
    local @NULL theyCallHimInventoryMan, grenade;
    local int Count;

    theyCallHimInventoryMan = TurokInventoryManager(mHud.mPawnOwner.InvManager);
    // End:0x33
    if(theyCallHimInventoryMan == none)
    {
        return -1;
    }
    // End:0x57
    foreach theyCallHimInventoryMan.InventoryActors(Class'TurokGrenadeInventoryItem', grenade)
    {
        ++Count;        
    }    
    return Count;
    //return ReturnValue;    
}

function Draw()
{
    // End:0x1B
    if(mAmmoDisplay.IsDualWielding() == true)
    {
        return;
    }
    DrawGrenades();
    //return;    
}

defaultproperties
{
    mGrenadeTexture=Texture2D'TurokHud.AmmoDisplay.Grenade_HD'
    mBackgroundTexture=Texture2D'EngineResources.Black'
    mCornerTexture=Texture2D'TurokHud.AmmoDisplay.AmmoTankRoundedCorner_HD'
    mFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mTextScale=0.3280000
    mXTextScale=0.2800000
    mTextFlashColor=(R=255,G=255,B=255,A=179)
    mTextFlashLength=0.1250000
    mTextFlashTime=10.0000000
    mLastGrenades=-1
    mImageTranslucency=0.7000000
    mWidth=68
    mSpacing=1
    mGrenadeXSpacing=4
    mEdgeGrenadeSpacing=-3
    mStartOffset=10
    mBackgroundColor=(R=255,G=255,B=255,A=179)
    mGrenadesColor=(R=215,G=161,B=94,A=179)
    mLowAmmoColor=(R=210,G=10,B=0,A=255)
}