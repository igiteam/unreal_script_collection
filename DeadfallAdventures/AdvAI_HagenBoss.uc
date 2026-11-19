class AdvAI_HagenBoss extends AdvAI_GermanSoldier
    config(AI)
    hidecategories(Navigation);

var() float TossZMod;
var() float MinTossSpeed;
var() float TossAngle;

function bool ShouldThrowGrenade()
{
    return (CanThrowGrenade()) && bFailedToThrow || (WorldInfo.TimeSeconds - LastThrowGrenadeTime) > (TimeBetweenThrows * ((MyEvilPawn.Health == 1) ? 0.5000000 : 1.0000000));
    //return ReturnValue;    
}

function ThrowGrenade(Rotator Rot, optional out Vector SuggestedTossVelocity, optional name InGrenadeSocket = 'None')
{
    local Vector Loc, ThrowLocationShift;
    local name GrenadeSocket;
    local Vector ThrowLocation;

    GrenadeSocket = ((InGrenadeSocket == 'None') ? MyEvilPawn.GrenadeSocket : InGrenadeSocket);
    MyEvilPawn.Mesh.GetSocketWorldLocationAndRotation(GrenadeSocket, Loc,, 0);
    ThrowLocation = GetThrowLocation();
    ThrowLocationShift = Normal(ThrowLocation - Loc) * 50.0000000;
    ThrowLocationShift.Z = 0.0000000;
    ThrowLocation += ThrowLocationShift;
    // End:0x1B1
    if(IsZero(SuggestedTossVelocity) && int(MyEvilPawn.PawnAction) != 2)
    {
        SuggestTossVelocity(SuggestedTossVelocity, ThrowLocation, Loc, VSize(ThrowLocation - Loc) * TossZMod, MinTossSpeed, TossAngle, vect(5.0000000, 5.0000000, 5.0000000),,, false);
    }
    MyEvilPawn.ThrowGrenade(Rotator(Normal(SuggestedTossVelocity)), Loc, SuggestedTossVelocity);
    //return;    
}

function bool CanEvade()
{
    return false;
    //return ReturnValue;    
}

function OnTriggerDemonMode(SeqAct_TriggerDemonMode Action)
{
    DisableAI(true, true, true);
    EnemyInfoList.Remove(0, EnemyInfoList.Length);    
    FriendInfoList.Remove(0, FriendInfoList.Length);    
    Enemy = none;
    GotoState('Idle');
    MyAdvPawn.SetDemonMode(true);
    //return;    
}

defaultproperties
{
    TossZMod=1.0000000
    TossAngle=0.8000000
    MaxCoverTimeout_Covered=4.0000000
    MaxCoverTimeout_Low=3.0000000
    MaxCoverTimeout_Normal=2.0000000
    MaxCoverTimeout_High=2.0000000
    MinCoverTimeout_Covered=2.0000000
    MinCoverTimeout_Low=1.0000000
    MinCoverTimeout_Normal=1.0000000
    MinCoverTimeout_High=1.0000000
    TargettedAimEpsilon=0.9900000
    ProjectileAimHeightModifier=1.5000000
    DefaultCommand=Class'AdvAICmd_Base_HagenAI'
    StrafesData=/* Array type was not detected. */
    StrafeRatingThreshold=0.0000000
    EnemyDistance_Throw=20000.0000000
    // Reference: EvilAIReactManager'Default__AdvAI_HagenBoss.ReactionManager0'
    begin object name=ReactionManager0
    end object
    ReactionManager=ReactionManager0
    DefaultReactConditions=/* Array type was not detected. */
    TimeBetweenThrows=6.0000000
}