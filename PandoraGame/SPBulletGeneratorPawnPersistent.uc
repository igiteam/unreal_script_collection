class SPBulletGeneratorPawnPersistent extends SPPawn
    native
    config(Game);

/** INCLUDES MACROS struct DECLARATIONS VARIABLE DECLARATIONS */
var(Squad) SPTeamInfoCreature.eSPSquad_Creature SquadAssignment;
var float IntervalOfAutoFire;
var float IntervalBetweenAutoFireSegments;
var float IntervalBetweenSingleFireSegments;
var float IntervalOfAutoFireRange;
var float IntervalBetweenAutoFireRange;
var float IntervalBetweenSingleFireRange;
var bool m_bIsSemiAuto;
var bool m_bActive;

simulated function Tick(float DeltaTime)
{
    ServerTick_SPBulletGeneratorPawnPersistent(DeltaTime);
    super.Tick(DeltaTime);
    //return;    
}

simulated event SetMovementType(SPPawn.SPEMovementType Type)
{
    //return;    
}

final function ServerTick_SPBulletGeneratorPawnPersistent(float DeltaTime)
{
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

k2override event ServerOnlyTakeDamage(float DamageAmount, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    //return;    
}

simulated function OnSPSetBulletGeneratorWeaponType(SeqAct_SPSetBulletGeneratorWeaponType inAction)
{
    local class<SPWeapon> spWeaponClass;
    local SPWeapon SPWeapon;
    local int randomValue;

    // End:0xD1
    if(inAction.m_bUseRandomizedWeapons)
    {
        randomValue = Rand(100);
        // End:0x46
        if(randomValue >= 75)
        {
            spWeaponClass = class<SPWeapon>(inAction.RandomWeaponType1);            
        }
        else
        {
            // End:0x7D
            if((randomValue >= 50) && randomValue < 75)
            {
                spWeaponClass = class<SPWeapon>(inAction.RandomWeaponType2);                
            }
            else
            {
                // End:0xB4
                if((randomValue >= 25) && randomValue < 50)
                {
                    spWeaponClass = class<SPWeapon>(inAction.RandomWeaponType3);                    
                }
                else
                {
                    spWeaponClass = class<SPWeapon>(inAction.RandomWeaponType4);
                }
            }
        }        
    }
    else
    {
        spWeaponClass = class<SPWeapon>(inAction.WeaponType);
    }
    Weapon = Spawn(spWeaponClass, self);
    // End:0x11F
    if(Weapon != none)
    {
        SPWeapon = SPWeapon(Weapon);
    }
    // End:0x351
    if(SPWeapon != none)
    {
        SPWeapon.AttachWeapon(Mesh, 'JO_Hip');
        InvManager.AddInventory(Weapon);
        InvManager.SetCurrentWeapon(SPWeapon(Weapon));
        SPWeapon.SetBulletGenerator(true);
        // End:0x1E1
        if(SPWeapon.bSemiAuto)
        {
            IntervalBetweenSingleFireSegments = inAction.IntervalBetweenSingleFireSegments;
            IntervalBetweenSingleFireRange = inAction.IntervalBetweenSingleFireRange;
            m_bIsSemiAuto = true;            
        }
        else
        {
            IntervalOfAutoFire = inAction.IntervalOfAutoFire;
            IntervalOfAutoFireRange = inAction.IntervalOfAutoFireRange;
            IntervalBetweenAutoFireSegments = inAction.IntervalBetweenAutoFireSegments;
            IntervalBetweenAutoFireRange = inAction.IntervalBetweenAutoFireRange;
        }
        SPWeapon.Sound_Fire.VolumeMultiplier = inAction.SoundMultiplier;
        SPWeapon.ShellCasingClass = none;
        // End:0x2B6
        if(inAction.m_bOverrideFiringSound)
        {
            // End:0x2B6
            if(inAction.m_FiringSound != none)
            {
                SPWeapon.Sound_Fire = inAction.m_FiringSound;
            }
        }
        // End:0x2F9
        if(SPWeapon.WeapID != 'RocketLauncher')
        {
            SPWeapon.m_bIgnoreCollisions = !inAction.bCollisionOn;            
        }
        else
        {
            SPWeapon.m_bRocketsHomingForGenerators = inAction.m_bRocketsHoming;
        }
        m_bActive = true;
        Weapon.Activate();
        SPWeapon.Mesh.SetHidden(true);
    }
    //return;    
}

function int GetSquadNameIndex()
{
    local int squadNameIdx;

    squadNameIdx = int(SquadAssignment);
    return squadNameIdx;
    //return ReturnValue;    
}
