class TurokHudHitIndicator extends TurokHudElement
    transient
    native;

const HIT_DMG_MAX_NUM_HITS = 4;
const HIT_DMG_WIDTH = 256.0;
const HIT_DMG_HEIGHT_LRG = 75.0;
const HIT_DMG_HEIGHT_SML = 53.0;
const HIT_DMG_RADIUS_LRG = 235.0;
const HIT_DMG_RADIUS_SML = 223.0;
const HIT_DMG_ORIGX_LRG = 127.0;
const HIT_DMG_ORIGY_LRG = 40.0;
const HIT_DMG_ORIGX_SML = 127.0;
const HIT_DMG_ORIGY_SML = 28.0;
const HIT_DMG_TEX_VMIN_SML = 0.0;
const HIT_DMG_TEX_VMIN_LRG = 53.0;

enum EDamageType
{
    HIT_DMG_TYPE_SMALL,             // 0
    HIT_DMG_TYPE_LARGE,             // 1
    HIT_DMG_TYPE_MAX                // 2
};

var float mDamageTime[4];
var @NULL mMomentum[4];
var @NULL mMomentumPlayerSpace[4];
var byte mDamageType[4];
var int mFirstDmgIndex;
var int mNumDmgElems;
var @NULL mHitIndicatorTex;

// Export UTurokHudHitIndicator::execDrawNative(FFrame&, void* const)
native function DrawNative();

function DisplayHit(@NULL hitFromLocation, int Damage, class<Class> DamageType)
{
    local int nextElemIndex;

    // End:0x16
    if(mHud.mPawnOwner == none)
    {
        return;
    }
    mNumDmgElems++;
    nextElemIndex = int(float((mFirstDmgIndex + mNumDmgElems) - 1) % float(4));
    // End:0x78
    if((nextElemIndex == mFirstDmgIndex) && mNumDmgElems > 4)
    {
        mFirstDmgIndex = int(float(mFirstDmgIndex + 1) % float(4));
        mNumDmgElems--;
    }
    mMomentum[nextElemIndex] = hitFromLocation;
    // End:0xA6
    if(Damage <= 100)
    {
        mDamageType[nextElemIndex] = 0;        
    }
    else
    {
        mDamageType[nextElemIndex] = 1;
    }
    mDamageTime[nextElemIndex] = 255.0000000;
    mHud.ResetFadeTimer();
    //return;    
}

function Reset()
{
    mNumDmgElems = 0;
    mFirstDmgIndex = 0;
    mDamageTime[0] = 0.0000000;
    mDamageTime[1] = 0.0000000;
    mDamageTime[2] = 0.0000000;
    mDamageTime[3] = 0.0000000;
    //return;    
}

function Draw()
{
    local int I, curIndex, prevFirstIndex, prevNumDmgElems;
    local @NULL Momentum;

    prevNumDmgElems = mNumDmgElems;
    prevFirstIndex = mFirstDmgIndex;
    I = 0;
    J0x1D:

    // End:0x149 [Loop If]
    if(I < prevNumDmgElems)
    {
        curIndex = int(float(prevFirstIndex + I) % float(4));
        // End:0xBF
        if(mDamageTime[curIndex] > float(0))
        {
            mDamageTime[curIndex] -= (float(128) * mHud.RenderDelta);
            // End:0xBF
            if(mDamageTime[curIndex] < float(1))
            {
                mDamageTime[curIndex] = 0.0000000;
                mFirstDmgIndex = int(float(mFirstDmgIndex + 1) % float(4));
                mNumDmgElems--;
            }
        }
        // End:0x13F
        if(mDamageTime[curIndex] > float(0))
        {
            Momentum = mHud.mPawnOwner.Location - mMomentum[curIndex];
            mMomentumPlayerSpace[curIndex] = QuatRotateVector(QuatFromRotator(mHud.mPawnOwner.GetBaseAimRotation() * float(-1)), Momentum);
        }
        I++;
        // [Loop Continue]
        goto J0x1D;
    }
    DrawNative();
    //return;    
}

defaultproperties
{
    mHitIndicatorTex=Texture2D'TurokHud.HitDamageIcons'
}