class TextureFlipBook extends Texture2D
    native
    noexport
    hidecategories(Object,Object);

enum TextureFlipBookMethod
{
    TFBM_UL_ROW,                    // 0
    TFBM_UL_COL,                    // 1
    TFBM_UR_ROW,                    // 2
    TFBM_UR_COL,                    // 3
    TFBM_LL_ROW,                    // 4
    TFBM_LL_COL,                    // 5
    TFBM_LR_ROW,                    // 6
    TFBM_LR_COL,                    // 7
    TFBM_RANDOM,                    // 8
    TFBM_MAX                        // 9
};

var native const noexport Pointer FTickableObjectVfTable;
var const transient float TimeIntoMovie;
var const transient float TimeSinceLastFrame;
var const transient float HorizontalScale;
var const transient float VerticalScale;
var const bool bPaused;
var const bool bStopped;
var(FlipBook) bool bLooping;
var(FlipBook) bool bAutoPlay;
var(FlipBook) int HorizontalImages;
var(FlipBook) int VerticalImages;
var(FlipBook) TextureFlipBook.TextureFlipBookMethod FBMethod;
var(FlipBook) float FrameRate;
var private float FrameTime;
var const transient int CurrentRow;
var const transient int CurrentColumn;

// Export UTextureFlipBook::execPlay(FFrame&, void* const)
native function Play();

// Export UTextureFlipBook::execPause(FFrame&, void* const)
native function Pause();

// Export UTextureFlipBook::execStop(FFrame&, void* const)
native function Stop();

// Export UTextureFlipBook::execSetCurrentFrame(FFrame&, void* const)
native function SetCurrentFrame(int Row, int Col);

defaultproperties
{
    bLooping=true
    bAutoPlay=true
    HorizontalImages=1
    VerticalImages=1
    FrameTime=0.0160000
    AddressX=1
    AddressY=1
    bFlipBook=true
}