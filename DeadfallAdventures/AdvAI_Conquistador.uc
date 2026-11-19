class AdvAI_Conquistador extends AdvAIController_Cover
    config(AI)
    hidecategories(Navigation);

var AdvPawn_Conquistador_Base MyAdvPawn_Conquistador_Base;
var bool bCanFireFromWeapon;

event Possess(Pawn NewPawn, bool bVehicleTransition)
{
    super.Possess(NewPawn, bVehicleTransition);
    MyAdvPawn_Conquistador_Base = AdvPawn_Conquistador_Base(NewPawn);
    //return;    
}

function BeginFireFromOpenWrapper(Actor EventInstigator, EvilAIReactChannel OrigChannel)
{
    FireFromOpen();
    //return;    
}

simulated function OnStartFire()
{
    //return;    
}

function bool IsFiring()
{
    return super(EvilAIController).IsFiring() || int(MyEvilPawn.PawnAction) == 11;
    //return ReturnValue;    
}

function bool NeedReload()
{
    return false;
    //return ReturnValue;    
}

function float OnRateStrafeByFlankEnemy(EvilStrafeData StrafeData, const out array<EvilStrafeData> StrafeDataArray)
{
    local float Rating;

    // End:0x3E3
    if(MyAdvPawn.bOnLightInfluenceFromVolume || MyAdvPawn.bOnLightInfluenceFromFlashLight)
    {
        switch(StrafeData.StrafeDirection)
        {
            // End:0x1D1
            case 5:
                // End:0x12C
                if(((CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds) || MyAdvPawn.bOnLightInfluenceFromVolume && !MyAdvPawn.bOnLightInfluenceFromFlashLight)
                {
                    StrafeData.DefaultRating = 1.0000000;                    
                }
                else
                {
                    StrafeData.DefaultRating *= ((MyAdvPawn.IsBurning()) ? 0.0500000 : 0.1000000 * FClamp(FPctByRange(GetEnemyInfo().DistanceToEnemy, EnemyDistance_Melee * 1.5000000, EnemyDistance_Melee * 3.0000000), 0.0000000, 1.0000000));
                }
                // End:0x3E0
                break;
            // End:0x2B4
            case 4:
                // End:0x244
                if((CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds)
                {
                    StrafeData.DefaultRating = 0.0000000;
                }
                StrafeData.DefaultRating *= ((MyAdvPawn.bOnLightInfluenceFromFlashLight) ? 1.0000000 * MyEvilPawn.GetHitsPerSec() : 0.0000000);
                // End:0x3E0
                break;
            // End:0x2B9
            case 2:
            // End:0x3DD
            case 3:
                // End:0x32C
                if((CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds)
                {
                    StrafeData.DefaultRating = 0.0000000;
                }
                StrafeData.DefaultRating *= FMin(2.0000000, 1.0000000 + (Normal(GetEnemyInfo().KnownLocation - StrafeData.StrafePoint) Dot Normal(Vector(Normalize(GetEnemyInfo().Pawn.GetBaseAimRotation())))));
                // End:0x3E0
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        // End:0x43C
        if(int(StrafeData.StrafeDirection) == int(5))
        {
            StrafeData.DefaultRating *= RandRange(0.9500000, 1.0000000);
        }
    }
    Rating = super(EvilAIController).OnRateStrafeByFlankEnemy(StrafeData, StrafeDataArray);
    return Rating;
    //return ReturnValue;    
}

function bool CanStartBurnBehaviour()
{
    local float FrozenAmount;

    return ((super(EvilAIController).CanStartBurnBehaviour() && !MyEvilPawn.HasShield()) && !MyEvilPawn.IsFrozen(FrozenAmount) || FrozenAmount < 0.2000000) && (CoverFromLightStartTime < 0.0000000) || (CoverFromLightStartTime + CoverFromLightTime) > WorldInfo.TimeSeconds;
    //return ReturnValue;    
}

function bool CanMeleeAttack()
{
    return (super.CanMeleeAttack() && HasValidEnemy()) && ((!MyAdvPawn.bOnLightInfluenceFromFlashLight || MyEvilPawn.HasShield()) || MyAdvPawn_Conquistador_Base.bBerserkerMode) || (CoverFromLightStartTime >= 0.0000000) && (CoverFromLightStartTime + CoverFromLightTime) < WorldInfo.TimeSeconds;
    //return ReturnValue;    
}

function NotifyStartBurn(float InTotalTime, float InDamageInterval, float InFDamageAmount)
{
    super(EvilAIController).NotifyStartBurn(InTotalTime, InDamageInterval, InFDamageAmount);
    // End:0xB1
    if(!MyAdvPawn_Conquistador_Base.bBerserkerMode && !MyEvilPawn.HasShield())
    {
        MyEvilPawn.bShouldWalkFast = true;
        MyEvilPawn.ForceLimitedMoveMode(1);
    }
    //return;    
}

function float GetShootingPriority()
{
    return super(EvilAIController).GetShootingPriority() * ((MyEvilPawn.bInMoveLatent && int(WorldInfo.NetMode) == int(NM_Standalone)) ? 0.0000000 : 1.0000000);
    //return ReturnValue;    
}

defaultproperties
{
    bShouldThrowWeapon=true
    DefaultCommand=Class'AdvAICmd_Base_Conquistador'
    MeleeCommand=Class'AdvAICmd_AztecMummy_Melee'
    BurningCommand=Class'AdvAICmd_CoverFromLight'
    StrafesData=/* Array type was not detected. */
    NumOfCheckedStrafesInRating=8
    DelayBetweenOppositeStrafes=5.0000000
    StrafeRatingThreshold=0.0000000
    EnemyDistance_Shoot=3000.0000000
    EnemyDistance_MeleeCharge=350.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_Conquistador.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    MaxTimeBetweenFireBurst=5.0000000
    MinTimeBetweenFireBurst=4.0000000
}