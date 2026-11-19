class TurokHudTargetIcon extends Object
    transient
    native;

const DEFAULT_EDGE_GUTTER = 5;
const ICON_FADE_TIME = 0.125f;
const ICON_DAMAGE_TIME = 0.0625f;
const LEVELS_PER_RANK = 5;
const ARROW_ICON_X = 473.f;
const ARROW_ICON_Y = 108.f;
const ARROW_ICON_WIDTH = 28.f;
const ARROW_ICON_HEIGHT = 31.f;
const UNREAL_TO_RAD = 0.0000958737992f;
const DEG_TO_UNREAL = 182.04444444444f;
const DEG_360 = 65536;
const DEG_180 = 32768;
const DEG_90 = 16384;
const DEG_270 = 49152;
const RAD_TO_DEG = 57.295779513082321600;

var @NULL mNext;
var private float mCurrentIconScale;
var private float mCurrentTextScale;
var private @NULL mFont;
var private int mIconNameOpacity;
var private @NULL mIconTex;
var private @NULL mFriendColor;
var private @NULL mFoeColor;
var private @NULL mFoeColorSD;
var @NULL mRankIconInformation;
var protected @NULL mHud;
var protected @NULL mTarget;
var private @NULL mTargetTeamColor;
var protected bool mIsTargetDead;
var protected bool mShowName;
var protected bool mShowRelativeDirection;
var protected bool mRankedGame;
var protected bool mTeamGame;
var protected bool mIsLocatorOn;
var protected bool mFadeTimerActive;
var private bool mRunRankTest;
var protected float mFadeTimer;
var protected float mDamageTimer;
var private float mRankIconScaleMinRange;
var private float mRankIconScaleMaxRange;
var private @NULL mScreenMinBounds;
var private @NULL mScreenMaxBounds;
var private int mTestRank;

function ToggleLocatorState()
{
    mIsLocatorOn = !mIsLocatorOn;
    //return;    
}

function ToggleRankTest()
{
    mRunRankTest = !mRunRankTest;
    //return;    
}

function SetTestRank(int Rank)
{
    mTestRank = Rank;
    //return;    
}

function IncTestRank()
{
    ++mTestRank;
    // End:0x1A
    if(mTestRank > 50)
    {
        mTestRank = 1;
    }
    //return;    
}

function DecTestRank()
{
    --mTestRank;
    // End:0x1A
    if(mTestRank < 1)
    {
        mTestRank = 50;
    }
    //return;    
}

event bool Init(@NULL HUD, @NULL Target, @NULL TGRI)
{
    local int targetTeamId;

    // DebugMode: 0
    assert(Target != none);
    mHud = HUD;
    mFadeTimerActive = false;
    mFadeTimer = 0.0000000;
    mDamageTimer = 0.0625000;
    mShowName = false;
    mShowRelativeDirection = false;
    mTarget = Target;
    mTargetTeamColor = default.mTargetTeamColor;
    mIsTargetDead = false;
    mTestRank = 1;
    mRunRankTest = false;
    mRankedGame = TGRI.IsRankedGame();
    // End:0x128
    if(TurokTeamGameReplicationInfo(TGRI) != none)
    {
        mTeamGame = true;
        targetTeamId = int(mTarget.GetTeamNum());
        // End:0x128
        if(targetTeamId != 255)
        {
            mTargetTeamColor = TurokTeamInfo(TGRI.Teams[targetTeamId]).GetTeamColor();
            // End:0x128
            if(targetTeamId == int(mHud.mPawnOwner.GetTeamNum()))
            {
                mShowRelativeDirection = true;
            }
        }
    }
    Update();
    return true;
    //return ReturnValue;    
}

// Export UTurokHudTargetIcon::execClear(FFrame&, void* const)
native function Clear();

// Export UTurokHudTargetIcon::execDraw(FFrame&, void* const)
native function Draw();

// Export UTurokHudTargetIcon::execUpdate(FFrame&, void* const)
native function Update();

// Export UTurokHudTargetIcon::execSetObjectiveLocatorState(FFrame&, void* const)
native function SetObjectiveLocatorState(bool isLocatorOn);

// Export UTurokHudTargetIcon::execUpdateFadeTimer(FFrame&, void* const)
protected native function UpdateFadeTimer();

// Export UTurokHudTargetIcon::execGetTarget(FFrame&, void* const)
native function @NULL GetTarget();

// Export UTurokHudTargetIcon::execIsOrphaned(FFrame&, void* const)
native function bool IsOrphaned();

// Export UTurokHudTargetIcon::execCalculateIconSize(FFrame&, void* const)
private native final function CalculateIconSize(out float Width, out float Height);

// Export UTurokHudTargetIcon::execCalcScaledIconSize(FFrame&, void* const)
protected native function @NULL CalcScaledIconSize();

// Export UTurokHudTargetIcon::execCalculateTextScale(FFrame&, void* const)
native function CalculateTextScale();

// Export UTurokHudTargetIcon::execCalculateIconScale(FFrame&, void* const)
native function CalculateIconScale();

// Export UTurokHudTargetIcon::execCalcScaledStringSize(FFrame&, void* const)
native function @NULL CalcScaledStringSize();

// Export UTurokHudTargetIcon::execCalcTotalScaledSize(FFrame&, void* const)
native function @NULL CalcTotalScaledSize();

// Export UTurokHudTargetIcon::execCalcScreenPos(FFrame&, void* const)
protected native function @NULL CalcScreenPos();

// Export UTurokHudTargetIcon::execNormalizeDistance(FFrame&, void* const)
native function float NormalizeDistance();

// Export UTurokHudTargetIcon::execClampToScreen(FFrame&, void* const)
private native final function @NULL ClampToScreen(@NULL pos);

// Export UTurokHudTargetIcon::execShowDead(FFrame&, void* const)
protected native function bool ShowDead();

// Export UTurokHudTargetIcon::execCheckDraw(FFrame&, void* const)
protected native function bool CheckDraw();

// Export UTurokHudTargetIcon::execRenderIcon(FFrame&, void* const)
protected native function RenderIcon(@NULL pos);

// Export UTurokHudTargetIcon::execRenderName(FFrame&, void* const)
protected native function RenderName(@NULL pos, @NULL iconSize);

// Export UTurokHudTargetIcon::execCalcOpacity(FFrame&, void* const)
private native final function float CalcOpacity();

// Export UTurokHudTargetIcon::execShowName(FFrame&, void* const)
protected native event bool ShowName();

// Export UTurokHudTargetIcon::execShowUnderFire(FFrame&, void* const)
protected native function bool ShowUnderFire();

// Export UTurokHudTargetIcon::execShowLocator(FFrame&, void* const)
protected native function bool ShowLocator();

// Export UTurokHudTargetIcon::execSameTeam(FFrame&, void* const)
protected native function bool SameTeam();

// Export UTurokHudTargetIcon::execCanSeeTarget(FFrame&, void* const)
protected native function bool CanSeeTarget();

protected function RenderArrow(@NULL pos, @NULL Size)
{
    local @NULL clampedPos;
    local float DEG;

    mHud.Canvas.SetDrawColor(byte(255), byte(255), byte(255), byte(float(mIconNameOpacity) * CalcOpacity()));
    clampedPos = ClampArrowToScreen(pos);
    DEG = Atan((pos.Y - mHud.CenterY) * -1.0000000, pos.X - mHud.CenterX);
    mHud.Canvas.SetPos((clampedPos.X + Size.X) + float(5), (clampedPos.Y + (Size.Y / float(2))) - ((31.0000000 * mCurrentIconScale) / float(2)));
    mHud.Canvas.__NFUN_466__(mIconTex, 28.0000000 * mCurrentIconScale, 31.0000000 * mCurrentIconScale, 473.0000000, 108.0000000, 28.0000000, 31.0000000, DEG, int(clampedPos.X + (Size.X / float(2))), int(clampedPos.Y + (Size.Y / float(2))));
    //return;    
}

protected function @NULL CalcArrowSize()
{
    return CalcScaledIconSize();
    //return ReturnValue;    
}

private final function @NULL ClampArrowToScreen(@NULL pos)
{
    return ClampToScreen(pos);
    //return ReturnValue;    
}

defaultproperties
{
    mFont=TurokFont'TurokFontsNew.TurokTransferEGauge'
    mIconNameOpacity=216
    mIconTex=Texture2D'TurokHudMultiplayer.RankIcons_HD'
    mFriendColor=(R=204,G=204,B=204,A=0)
    mFoeColor=(R=255,G=0,B=0,A=0)
    mFoeColorSD=(R=126,G=44,B=47,A=0)
    // Reference: TurokRankInformation'Default__TurokHudTargetIcon.RankInformation'
    begin object name=RankInformation class=Class'TurokRankInformation'
    end object
    mRankIconInformation=RankInformation
    mTargetTeamColor=(R=255,G=255,B=255,A=255)
    mRankIconScaleMinRange=5.0000000
    mRankIconScaleMaxRange=75.0000000
}