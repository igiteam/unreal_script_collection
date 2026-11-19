class TurokWeapTripleShotgunNative extends TurokWeapon
    config(Weapon)
    hidecategories(Navigation);

var() array mNumBurstPellets;

function ConsumeAmmo(byte FireModeNum)
{
    local int burstAmmo;

    burstAmmo = 1;
    // End:0x1A1
    if(int(FireModeNum) == 1)
    {
        burstAmmo = Min(3, mCurrentClipAmmo);
        mNumPellets[1] = int(mNumBurstPellets[burstAmmo - 1]);
        InstantHitDamage[1] = ((InstantHitDamage[0] * float(mNumPellets[0])) * float(burstAmmo)) / float(mNumPellets[1]);
        mAccuracyFireDemerit[1] = mAccuracyFireDemerit[0] * float(burstAmmo);
        mBestAccuracyMinSpread[1] = mBestAccuracyMinSpread[0] * float(burstAmmo);
        mBestAccuracyMaxSpread[1] = mBestAccuracyMaxSpread[0] * float(burstAmmo);
        mWorstAccuracyMinSpread[1] = mWorstAccuracyMinSpread[0] * float(burstAmmo);
        mWorstAccuracyMaxSpread[1] = mWorstAccuracyMaxSpread[0] * float(burstAmmo);
        mRecoilMinTranslation[1] = mRecoilMinTranslation[0] * float(burstAmmo);
        mRecoilMaxTranslation[1] = mRecoilMaxTranslation[0] * float(burstAmmo);
        mRecoilMinRotation[1] = mRecoilMinRotation[0] * float(burstAmmo);
        mRecoilMaxRotation[1] = mRecoilMaxRotation[0] * float(burstAmmo);
        mBestAccuracyMinShake[1] = mBestAccuracyMinShake[0] * float(burstAmmo);
        mBestAccuracyMaxShake[1] = mBestAccuracyMaxShake[0] * float(burstAmmo);
        mWorstAccuracyMinShake[1] = mWorstAccuracyMinShake[0] * float(burstAmmo);
        mWorstAccuracyMaxShake[1] = mWorstAccuracyMaxShake[0] * float(burstAmmo);
    }
    mCurrentClipAmmo = Max(0, mCurrentClipAmmo - burstAmmo);
    //return;    
}

simulated function bool HasAmmo(byte FireModeNum, optional int Amount)
{
    return mCurrentClipAmmo != 0;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapTripleShotgunNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}