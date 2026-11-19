class TurokHudStealthVignette extends TurokHudElement
    transient
    native;

var private @NULL mVignetteMat;
var private @NULL mVignetteMatInstance;
var private float mFadePcnt;
var private @NULL mColor;

// Export UTurokHudStealthVignette::execDrawNative(FFrame&, void* const)
native function DrawNative();

function SetFadePcnt(float Percent)
{
    mFadePcnt = FClamp(Percent, 0.0000000, 1.0000000);
    //return;    
}

function Init(@NULL hudRef)
{
    super.Init(hudRef);
    // End:0x45
    if(mVignetteMatInstance == none)
    {
        mVignetteMatInstance = new (none) Class'Engine.MaterialInstanceConstant';
        mVignetteMatInstance.SetParent(mVignetteMat);
        mVignetteMat = mVignetteMatInstance;
    }
    //return;    
}

function Draw()
{
    DrawNative();
    //return;    
}

defaultproperties
{
    mVignetteMat=Material'TurokEngineMaterials.StealthPPMat2'
    mColor=(R=0.0000000,G=0.0000000,B=0.1000000,A=0.0000000)
}