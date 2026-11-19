class TurokHudTutorialText extends TurokHudElement
    transient
    native;

var string mTutorialText1;
var string mTutorialText2;
var string mTutorialText3;
var @NULL mTextFont;
var float mTextScale;
var float mTextScaleSD;
var float mModifiedTextScale;
var float mLongestLineWidth;
var int mText1Width;
var int mText2Width;
var int mText3Width;
var int mTextHeight;
var int mTextSpacing;
var int mLineCount;
var float mAnimTime;
var float mAnimLength;
var float mFadeInAnimTime;
var float mFadeInAnimLength;
var float mFadeOutAnimTime;
var float mFadeOutAnimLength;
var float mAlpha;
var float mBgAlpha;
var @NULL mColor;
var @NULL mButtonImageXBox360;
var @NULL mButtonImageXBox360_A;
var @NULL mButtonImageXBox360_B;
var @NULL mButtonImageXBox360_X;
var @NULL mButtonImageXBox360_Y;
var @NULL mButtonImageXBox360_LT;
var @NULL mButtonImageXBox360_LB;
var @NULL mButtonImageXBox360_RT;
var @NULL mButtonImageXBox360_RB;
var @NULL mButtonImageXBox360_L3;
var @NULL mButtonImagePS3;
var @NULL mButtonImagePS3_X;
var @NULL mButtonImagePS3_Circle;
var @NULL mButtonImagePS3_Triangle;
var @NULL mButtonImagePS3_Square;
var @NULL mButtonImagePS3_L1;
var @NULL mButtonImagePS3_L2;
var @NULL mButtonImagePS3_R1;
var @NULL mButtonImagePS3_R2;
var @NULL mButtonImagePS3_L3;
var @NULL mBackgroundTexture;
var @NULL mBackgroundEdgeTexture;
var @NULL mTutorialTextColor;
var bool mCanDrawTutorial;

// Export UTurokHudTutorialText::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudTutorialText::execShowTutorialText(FFrame&, void* const)
native function ShowTutorialText(int textHash, byte buttonImage);

// Export UTurokHudTutorialText::execSplitString(FFrame&, void* const)
native function SplitString(string Text);

// Export UTurokHudTutorialText::execHideTutorialText(FFrame&, void* const)
native function HideTutorialText();

defaultproperties
{
    mTextFont=TurokFont'TurokFontsNew.TurokConduitTCBold'
    mTextScale=0.8570000
    mTextScaleSD=1.0000000
    mTextSpacing=20
    mAnimTime=5.0000000
    mAnimLength=6.0000000
    mFadeInAnimTime=2.0000000
    mFadeInAnimLength=0.1250000
    mFadeOutAnimTime=3.0000000
    mFadeOutAnimLength=2.0000000
    mAlpha=255.0000000
    mBgAlpha=110.0000000
    mColor=(R=255,G=255,B=255,A=0)
    mButtonImageXBox360=Texture2D'TurokControllerButtons.HUD_360_B'
    mButtonImageXBox360_A=Texture2D'TurokControllerButtons.HUD_360_A'
    mButtonImageXBox360_B=Texture2D'TurokControllerButtons.HUD_360_B'
    mButtonImageXBox360_X=Texture2D'TurokControllerButtons.HUD_360_X'
    mButtonImageXBox360_Y=Texture2D'TurokControllerButtons.HUD_360_Y'
    mButtonImageXBox360_LT=Texture2D'TurokControllerButtons.LT_HD'
    mButtonImageXBox360_LB=Texture2D'TurokControllerButtons.LB_HD'
    mButtonImageXBox360_RT=Texture2D'TurokControllerButtons.RT_HD'
    mButtonImageXBox360_RB=Texture2D'TurokControllerButtons.RB_HD'
    mButtonImageXBox360_L3=Texture2D'TurokControllerButtons.L_Stick_Push_HD'
    mButtonImagePS3=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImagePS3_X=Texture2D'TurokControllerButtons.PS3_X_0_HD'
    mButtonImagePS3_Circle=Texture2D'TurokControllerButtons.PS3_Circle_0_HD'
    mButtonImagePS3_Triangle=Texture2D'TurokControllerButtons.PS3_Triangle_0_HD'
    mButtonImagePS3_Square=Texture2D'TurokControllerButtons.PS3_Square_0_HD'
    mButtonImagePS3_L1=Texture2D'TurokControllerButtons.PS3_L1_HD'
    mButtonImagePS3_L2=Texture2D'TurokControllerButtons.PS3_L2_HD'
    mButtonImagePS3_R1=Texture2D'TurokControllerButtons.PS3_R1_HD'
    mButtonImagePS3_R2=Texture2D'TurokControllerButtons.PS3_R2_HD'
    mButtonImagePS3_L3=Texture2D'TurokControllerButtons.PS3_L3_HD'
    mBackgroundTexture=Texture2D'TurokHud.Tutorials.Tutorials_BG_Fill'
    mBackgroundEdgeTexture=Texture2D'TurokHud.Tutorials.Tutorials_BG_Edge'
    mTutorialTextColor=(R=235,G=235,B=235,A=255)
}