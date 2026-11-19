class TurokAnimHealthAsset extends Object
    native
    hidecategories(Object);

struct native DamageTypeModifiers
{
    var() class<Class> mWeaponDamageType;
    var() float mDamageScale;

    structdefaultproperties
    {
        mWeaponDamageType=Class'TurokDamageTypeBow'
        mDamageScale=1.0000000
    }
};

struct native BodyPartDamageInfo
{
    var() byte mBodyPart;
    var() float mDefaultDamageScale;
    var() array mWeaponDamageModifiers;

    structdefaultproperties
    {
        mBodyPart=0
        mDefaultDamageScale=1.0000000
        mWeaponDamageModifiers=none
    }
};

var(Regions) export editinline array mBodyRegions;

defaultproperties
{
    mBodyRegions=/* Array type was not detected. */
}