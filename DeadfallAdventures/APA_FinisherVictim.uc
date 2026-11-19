class APA_FinisherVictim extends EPA_DeathAnimBase;

var FinisherDef FinisherDef;

function bool ShouldReplicate()
{
    return false;
    //return ReturnValue;    
}

function bool CanOverrideAction(byte inAction)
{
    return true;
    //return ReturnValue;    
}

function bool CanOverrideActionWith(byte inAction)
{
    return false;
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local Vector DesiredPos, Temp;
    local NavigationHandle NH;

    super(EvilPawnAction).PawnActionStarted(bForced, PrevAction);
    FinisherDef = APA_Finisher(PawnOwner.InteractionPawn.PawnActions[60]).FinisherDefs[PawnOwner.PawnActionFlags];
    // End:0x161
    if(!PawnOwner.InteractionPawn.IsLocallyControlled() && !FinisherDef.bShouldPropagate)
    {
        PawnOwner.EndPawnAction(61);
        PawnOwner.Died(none, Class'EvilGame.EvilDmgType_InstantGib', PawnOwner.Location);
        return;
    }
    PawnOwner.SetCollision(false, false, true);
    PawnOwner.Mesh.SetActorCollision(false, false, false);
    PawnOwner.Mesh.SetTraceBlocking(false, false);
    PawnOwner.Mesh.SetRBChannel(9);
    DesiredPos = PawnOwner.InteractionPawn.Location + (Vector(PawnOwner.InteractionPawn.Rotation) * FinisherDef.Lebensraum);
    // End:0x2EB
    if(AIOwner != none)
    {
        NH = AIOwner.NavigationHandle;        
    }
    else
    {
        // End:0x36E
        if(PawnOwner.ControllerClass.default.NavigationHandleClass != none)
        {
            NH = new (PawnOwner) PawnOwner.ControllerClass.default.NavigationHandleClass;
        }
    }
    // End:0x479
    if((NH != none) && NH.ObstaclePointCheck(DesiredPos, (vect(1.0000000, 1.0000000, 0.0000000) * PawnOwner.CylinderComponent.CollisionRadius) + (vect(0.0000000, 0.0000000, 1.0000000) * PawnOwner.CylinderComponent.CollisionHeight)))
    {
        PawnOwner.SetLocation(DesiredPos);
        PawnOwner.MoveSmooth(vect(0.0000000, 0.0000000, -100.0000000));        
    }
    else
    {
        PawnOwner.MoveSmooth(DesiredPos - PawnOwner.InteractionPawn.Location);
    }
    // End:0x652
    if(VSizeSq(DesiredPos - PawnOwner.Location) > (10.0000000 * 10.0000000))
    {
        Temp = DesiredPos;
        // End:0x631
        if(PawnOwner.FindSpot((vect(1.0000000, 1.0000000, 0.0000000) * PawnOwner.CylinderComponent.CollisionRadius) + (vect(0.0000000, 0.0000000, 1.0000000) * PawnOwner.CylinderComponent.CollisionHeight), Temp) && VSizeSq(Temp - PawnOwner.Location) < (10.0000000 * 10.0000000))
        {
            PawnOwner.SetLocation(Temp);            
        }
        else
        {
            PawnOwner.SetLocation(DesiredPos);
        }
    }
    // End:0x746
    if(PawnOwner.Controller != none)
    {
        PawnOwner.Controller.SetRotation(Rotator(PawnOwner.InteractionPawn.Location - PawnOwner.Location));
        PawnOwner.SetRotation(PawnOwner.Controller.Rotation);        
    }
    else
    {
        PawnOwner.SetRotation(Rotator(PawnOwner.InteractionPawn.Location - PawnOwner.Location));
    }
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    PlayDeathAnimation();
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super(EvilPawnAction).PawnActionEnded(PrevMove, NextMove);
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = 1;
    PawnOwner.GotoState('Auto');
    PawnOwner.bShouldPlayDeathAnimationToRagdoll = false;
    DeathAnimRagDoll();
    // End:0x220
    if(int(PawnOwner.WorldInfo.NetMode) < int(NM_Client))
    {
        PawnOwner.Died(PawnOwner.InteractionPawn.Controller, ((FinisherDef.WeaponClass != none) ? FinisherDef.WeaponClass.default.InstantHitDamageTypes[0] : Class'Engine.DmgType_Fell'), PawnOwner.Location);        
    }
    else
    {
        PawnOwner.TornOff();
    }
    //return;    
}

simulated function OnDeathAnimBodyRest()
{
    // End:0x5F
    if(PawnOwner.IsTimerActive('DeathAnimRagDoll', self))
    {
        PawnOwner.ClearTimer('DeathAnimRagDoll', self);
        DeathAnimRagDoll();
    }
    //return;    
}

function OnFinisherAnimBlendToMotors()
{
    DeathAnimBlendToMotors();
    //return;    
}

function bool PlayDeathAnimation()
{
    local EvilTypesNative.EAnimationSetType AST;
    local int Index;
    local EvilAnimInfo AI;

    Class'EvilGame.EvilPawn'.static.UnpackAnimInfo(PawnOwner.PawnActionFlags, AST, Index);
    AI = FinisherDef.VictimAnim;
    PawnOwner.bEnableFootPlacement = false;
    PawnOwner.Mesh.ForceSkelUpdate();
    PawnOwner.Mesh.UpdateRBBonesFromSpaceBases(true, true);
    PawnOwner.ZeroMovementVariables();
    AnimName = AI.AnimName;
    SpeedModifier = AI.AnimSpeed;
    BlendInTime = AI.BlendInTime;
    BlendOutTime = AI.BlendOutTime;
    PlayAnimation();
    // End:0x242
    if(!APA_Finisher(PawnOwner.InteractionPawn.PawnActions[60]).FinisherDefs[Index].bManualBlendToMotors)
    {
        DeathAnimBlendToMotors();
    }
    return true;
    //return ReturnValue;    
}

simulated function DeathAnimBlendToMotors()
{
    local Actor PawnBase;
    local Vector HitLoc, HitNormal;

    PawnBase = PawnOwner.Base;
    // End:0xBA
    if(PawnBase == none)
    {
        PawnBase = PawnOwner.Trace(HitLoc, HitNormal, PawnOwner.Location + vect(0.0000000, 0.0000000, -128.0000000), PawnOwner.Location);
    }
    // End:0x1EF
    if((PawnBase != none) && PawnBase.bStatic)
    {
        SetSpringForBone(PawnOwner.HipsBoneName, true);
        SetSpringForBone(PawnOwner.RightHandBoneName, true);
        SetSpringForBone(PawnOwner.LeftHandBoneName, true);
        SetSpringForBone(PawnOwner.LeftFootBoneName, true);
        SetSpringForBone(PawnOwner.RightFootBoneName, true);
        super.DeathAnimBlendToMotors();
        PawnOwner.SetTimer(1.3300000, false, 'DeathAnimRagDoll', self);        
    }
    else
    {
        super.DeathAnimBlendToMotors();
        DeathAnimRagDoll();
    }
    //return;    
}

simulated function OnRigidBodySpringOverextension(RB_BodyInstance BodyInstance)
{
    local name HipsBoneName;
    local RB_BodyInstance HipsBodyInstance;

    HipsBoneName = PawnOwner.Mesh.GetSocketBoneName(PawnOwner.HipsBoneName);
    HipsBodyInstance = PawnOwner.Mesh.FindBodyInstanceNamed(HipsBoneName);
    // End:0xED
    if(HipsBodyInstance == BodyInstance)
    {
        PawnOwner.ClearTimer('DeathAnimRagDoll', self);
        DeathAnimRagDoll();
    }
    //return;    
}

simulated function DeathAnimRagDoll()
{
    SetSpringForBone(PawnOwner.HipsBoneName, false);
    SetSpringForBone(PawnOwner.RightHandBoneName, false);
    SetSpringForBone(PawnOwner.LeftHandBoneName, false);
    SetSpringForBone(PawnOwner.LeftFootBoneName, false);
    SetSpringForBone(PawnOwner.RightFootBoneName, false);
    super.DeathAnimRagDoll();
    PawnOwner.EndPawnAction();
    //return;    
}

function OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
    // End:0x39
    if((PlayedTime ~= 0.0000000) && AnimName != 'None')
    {
        PlayDeathAnimation();        
    }
    else
    {
        PawnOwner.EndPawnAction();
    }
    //return;    
}

defaultproperties
{
    FinisherDef=(WeaponClass=none,TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=110.0000000,AttackerAnim="None",VictimAnim=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=none,CameraAnimWeight=1.0000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=false,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=0.0000000)
    BlendInTime=0.0000000
}