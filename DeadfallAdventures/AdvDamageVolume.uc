class AdvDamageVolume extends PhysicsVolume
    hidecategories(Navigation,Object,Movement,Display);

struct DamageValues
{
    var() int PlayerDamagePerSec;
    var() int EnemyDamagePerSec;

    structdefaultproperties
    {
        PlayerDamagePerSec=1
        EnemyDamagePerSec=50
    }
};

var() bool bEnabled;
var() array<AdvTypes.EAITypes> AITypesToDamage;
var() DamageValues DamageBehaviour;

simulated event PostBeginPlay()
{
    super(Volume).PostBeginPlay();
    bPainCausing = bEnabled;
    BACKUP_bPainCausing = bPainCausing;
    // End:0x4A
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    PainTimer = Spawn(Class'Engine.VolumeTimer', self);
    //return;    
}

function EnableDamage()
{
    bPainCausing = true;
    //return;    
}

function DisableDamage()
{
    bPainCausing = false;
    //return;    
}

simulated function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x46
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bPainCausing = true;        
    }
    else
    {
        // End:0x8C
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bPainCausing = false;            
        }
        else
        {
            // End:0xDB
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bPainCausing = !bPainCausing;
            }
        }
    }
    //return;    
}

function CausePainTo(Actor Other)
{
    local EvilPlayerController EPC;
    local AdvPawn P;
    local int Idx;
    local bool bSkipDamage;

    // End:0xCE
    if(AITypesToDamage.Length > 0)
    {
        bSkipDamage = true;
        P = AdvPawn(Other);
        // End:0xBF
        if(P != none)
        {
            Idx = 0;
            J0x52:

            // End:0xBF [Loop If]
            if(Idx < AITypesToDamage.Length)
            {
                // End:0xB1
                if(P.PawnAIType == int(AITypesToDamage[Idx]))
                {
                    bSkipDamage = false;
                    // [Explicit Break]
                    goto J0xBF;
                }
                ++Idx;
                // [Loop Continue]
                goto J0x52;
            }
        }
        J0xBF:

        // End:0xCE
        if(bSkipDamage)
        {
            return;
        }
    }
    EPC = EvilPlayerController(EvilPawn(Other).Controller);
    // End:0x32A
    if((DamageBehaviour.PlayerDamagePerSec > 0) || DamageBehaviour.EnemyDamagePerSec > 0)
    {
        // End:0x19D
        if(WorldInfo.bSoftKillZ && int(Other.Physics) != int(1))
        {
            return;
        }
        // End:0x1C5
        if((DamageType == none) || DamageType == Class'Engine.DamageType')
        {
        }
        // End:0x291
        if((EPC != none) && EPC.bIsPlayer)
        {
            // End:0x28E
            if(DamageBehaviour.PlayerDamagePerSec > 0)
            {
                Other.TakeDamage(int(float(DamageBehaviour.PlayerDamagePerSec) * PainInterval), DamageInstigator, Location, vect(0.0000000, 0.0000000, 1.0000000), DamageType,, self);
            }            
        }
        else
        {
            // End:0x327
            if(DamageBehaviour.EnemyDamagePerSec > 0)
            {
                Other.TakeDamage(int(float(DamageBehaviour.EnemyDamagePerSec) * PainInterval), DamageInstigator, Location, vect(0.0000000, 0.0000000, 1.0000000), DamageType,, self);
            }
        }        
    }
    else
    {
        // End:0x3BE
        if((EPC != none) && EPC.bIsPlayer)
        {
            Other.HealDamage(int(float(-DamageBehaviour.PlayerDamagePerSec) * PainInterval), DamageInstigator, DamageType);            
        }
        else
        {
            Other.HealDamage(int(float(-DamageBehaviour.EnemyDamagePerSec) * PainInterval), DamageInstigator, DamageType);
        }
    }
    //return;    
}

defaultproperties
{
    bEnabled=true
    DamageBehaviour=(PlayerDamagePerSec=1,EnemyDamagePerSec=50)
    bPainCausing=true
    FluidFriction=5.0000000
    // Reference: BrushComponent'Default__AdvDamageVolume.BrushComponent0'
    begin object name=BrushComponent0
        ReplacementPrimitive=none
    end object
    BrushComponent=BrushComponent0
    Components[0]=BrushComponent0
    bStatic=false
    CollisionComponent=BrushComponent0
}