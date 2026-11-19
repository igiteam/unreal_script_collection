class SPFontPool extends Object
    native
    editinlinenew;

struct native FontData
{
    /** The actual UFont object that makes up this font */
    var() editinlineuse Font FontSource;
    /** What is the Maximum resolution this font should be used for */
    var() editinline float HeightTest;

    structdefaultproperties
    {
        FontSource=Font'EngineFonts.TinyFont'
        HeightTest=0.0000000
    }
};

/** A Descriptor for this font that is used for lookup */
var(Font) editinline name FontTag;
/** Holds the font data */
var(Font) editinline array<editinline FontData> Fonts;
var(Font) bool bRestrictScaling;
var(Font) float ForcedScalingFactor;

// Export USPFontPool::execGetFont(FFrame&, void* const)
native function Font GetFont(optional int SceneHeight);

// Export USPFontPool::execGetScalingFactor(FFrame&, void* const)
native function float GetScalingFactor(optional int SceneHeight);

defaultproperties
{
    FontTag="ConsoleFont"
    Fonts[0]=(FontSource=Font'EngineFonts.TinyFont',HeightTest=0.0000000)
    ForcedScalingFactor=1.0000000
}