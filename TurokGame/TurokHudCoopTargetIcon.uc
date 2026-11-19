class TurokHudCoopTargetIcon extends TurokHudTargetIcon
    transient;

function Draw()
{
    local @NULL pos, iconSize;

    // End:0x11
    if(!CheckDraw())
    {
        return;
    }
    CalculateTextScale();
    CalculateIconScale();
    pos = CalcScreenPos();
    iconSize = CalcScaledIconSize();
    // End:0x64
    if((ShowIcon()) == true)
    {
        RenderIcon(pos);
    }
    // End:0x88
    if((ShowName()) == true)
    {
        RenderName(pos, iconSize);
    }
    // End:0xAC
    if((ShowArrow()) == true)
    {
        RenderArrow(pos, iconSize);
    }
    //return;    
}

protected function UpdateFadeTimer()
{
    // End:0x24
    if(mDamageTimer < 0.0625000)
    {
        mDamageTimer += mHud.RenderDelta;
    }
    // End:0x67
    if(mFadeTimerActive == true)
    {
        mFadeTimer -= mHud.RenderDelta;
        // End:0x67
        if(mFadeTimer <= 0.0000000)
        {
            mFadeTimer = 0.0000000;
            mFadeTimerActive = false;
        }
    }
    // End:0xC2
    if(mTarget.mIsUnderFire && !mIsTargetDead)
    {
        // End:0xB7
        if((mShowName == false) && (SameTeam()) == true)
        {
            mFadeTimerActive = true;
            mFadeTimer = 0.1250000;
        }
        mDamageTimer = 0.0000000;
    }
    // End:0x127
    if((mTarget.Health <= 0) && !mIsTargetDead)
    {
        mIsTargetDead = true;
        // End:0x11C
        if((mShowName == false) && (SameTeam()) == true)
        {
            mFadeTimerActive = true;
            mFadeTimer = 0.1250000;
        }
        mDamageTimer = 0.0625000;
    }
    //return;    
}

protected function bool ShowIcon()
{
    return (ShowUnderFire()) || (CanSeeTarget()) && mShowName || ShowLocator();
    //return ReturnValue;    
}

protected function bool ShowArrow()
{
    return (mFadeTimerActive && SameTeam()) && !CanSeeTarget();
    //return ReturnValue;    
}
