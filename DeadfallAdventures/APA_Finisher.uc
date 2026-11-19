class APA_Finisher extends EvilPawnAction
    config(Finishers);

struct FinisherDef
{
    var class<EvilWeap_Base> WeaponClass;
    var class<EvilAttachment_Weap_Base> TEMPAttachmentClass;
    var float ActivationDistance;
    var float Lebensraum;
    var name AttackerAnim;
    var EvilAnimInfo VictimAnim;
    var CameraAnim CameraAnim;
    var float CameraAnimWeight;
    var float CameraAnimBlendTime;
    var bool bManualBlendToMotors;
    var bool bShouldPropagate;
    var bool bCheckFront;
    var bool bCheckBack;
    var float PlasmaCost;

    structdefaultproperties
    {
        WeaponClass=none
        TEMPAttachmentClass=none
        ActivationDistance=150.0000000
        Lebensraum=110.0000000
        AttackerAnim="None"
        VictimAnim=(AnimName="None",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000)
        CameraAnim=none
        CameraAnimWeight=1.0000000
        CameraAnimBlendTime=0.2000000
        bManualBlendToMotors=false
        bShouldPropagate=false
        bCheckFront=true
        bCheckBack=false
        PlasmaCost=0.0000000
    }
};

var transient AdvPawn TargetPawn;
var transient int FinisherIndex;
var transient float LastValidTargetTime;
var config array<config FinisherDef> FinisherDefs;
var config array<config string> PawnBlacklist;
var config float AINotificationRadius;
var Class LastMeleeWeapon;
var array<int> FinisherMatches;
var array< class<EvilPawn> > CachedPawnBlacklist;

function bool CanOverrideAction(byte inAction)
{
    return true;
    //return ReturnValue;    
}

protected function bool IsBlacklisted(class<EvilPawn> tested)
{
    local string S;
    local class<EvilPawn> C;

    // End:0x7A
    if(CachedPawnBlacklist.Length != PawnBlacklist.Length)
    {
        CachedPawnBlacklist.Remove(0, CachedPawnBlacklist.Length);        
        // End:0x79
        foreach PawnBlacklist(S)
        {
            CachedPawnBlacklist.AddItem(class<EvilPawn>(FindObject(S, Class'Core.Class')));                        
        }        
    }
    // End:0xAD
    foreach CachedPawnBlacklist(C)
    {
        // End:0xAC
        if(ClassIsChildOf(tested, C))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

function bool IsOwnerTouchingFBV()
{
    local AdvFinisherBlockingVolume FBV;

    // End:0x81
    foreach PawnOwner.AllActors(Class'AdvFinisherBlockingVolume', FBV)
    {
        // End:0x80
        if(FBV.bEnabled && FBV.Encompasses(PawnOwner))
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

protected function bool StillClose()
{
    // End:0x88
    if(((TargetPawn != none) && TargetPawn.GetCanBeFinished(PawnOwner)) && (PawnOwner.WorldInfo.TimeSeconds - LastValidTargetTime) <= 0.4000000)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

protected function bool HasEnoughRoom(Vector Offset)
{
    local Vector HitLocation, HitNormal;
    local Actor HitActor;
    local TraceHitInfo HitInfo;

    // End:0x18F
    if(FinisherDefs[FinisherIndex].bCheckFront)
    {
        HitActor = PawnOwner.Trace(HitLocation, HitNormal, PawnOwner.Location + Offset, PawnOwner.Location, true, (vect(0.5000000, 0.5000000, 0.0000000) * PawnOwner.CylinderComponent.CollisionRadius) + (vect(0.0000000, 0.0000000, 0.5000000) * PawnOwner.CylinderComponent.CollisionHeight), HitInfo);
        // End:0x18D
        if(HitActor != none)
        {
            // End:0x18B
            if(HitActor == PawnOwner.Controller.Enemy)
            {
                return true;                
            }
            return false;
        }
        return true;
    }
    //return ReturnValue;    
}

protected function bool OnTheSameHeight()
{
    local Vector Distance;

    Distance = PawnOwner.Controller.Enemy.Location - PawnOwner.Location;
    return Abs(Distance.Z) < 30.0000000;
    //return ReturnValue;    
}

protected function bool InternalCanDoPawnAction()
{
    local AdvPawn P, TP;
    local float C, Max, cosine;
    local Vector Loc, View;
    local Rotator Rot;
    local int I;

    // End:0x40
    if(int(PawnOwner.WorldInfo.NetMode) == int(NM_Client))
    {
        return true;
    }
    // End:0x89
    if((AdvPawn(PawnOwner) != none) && !AdvPawn(PawnOwner).CanDoFinisher())
    {
        return false;
    }
    // End:0x25B
    if(LastMeleeWeapon != PawnOwner.Weapon.Class)
    {
        FinisherMatches.Remove(0, FinisherMatches.Length);        
        LastMeleeWeapon = ((PawnOwner.Weapon.Class != none) ? PawnOwner.Weapon.Class : none);
        I = 0;
        J0x164:

        // End:0x25B [Loop If]
        if(I < FinisherDefs.Length)
        {
            // End:0x24D
            if((FinisherDefs[I].WeaponClass == none) || (FinisherDefs[I].WeaponClass != none) && ClassIsChildOf(PawnOwner.Weapon.Class, FinisherDefs[I].WeaponClass))
            {
                FinisherMatches.AddItem(I);                
            }
            ++I;
            // [Loop Continue]
            goto J0x164;
        }
    }
    // End:0x26D
    if(FinisherMatches.Length < 1)
    {
        return false;
    }
    FinisherIndex = FinisherMatches[Rand(FinisherMatches.Length)];
    PawnOwner.GetActorEyesViewPoint(Loc, Rot);
    View = Vector(Rot);
    // End:0x37B
    if((PawnOwner.Controller != none) && PawnOwner.Controller.Enemy != none)
    {
        TP = AdvPawn(PawnOwner.Controller.Enemy);        
    }
    else
    {
        TP = none;
        cosine = Cos((0.5000000 * 0.0174533) * EvilPlayerController(PawnOwner.Controller).GetFOVAngle());
        // End:0x563
        foreach PawnOwner.CollidingActors(Class'AdvPawn', P, FinisherDefs[FinisherIndex].ActivationDistance)
        {
            // End:0x492
            if(!P.GetCanBeFinished(PawnOwner) || IsBlacklisted(P.Class))
            {
                continue;                
            }
            C = View Dot Normal(P.Location - Loc);
            // End:0x4ED
            if(C < cosine)
            {
                continue;                
            }
            // End:0x525
            if(TP == none)
            {
                Max = C;
                TP = P;
                // End:0x562
                continue;
            }
            // End:0x562
            if(C > Max)
            {
                C = Max;
                TP = P;
            }            
        }        
    }
    // End:0x73A
    if(TP != none)
    {
        View = Normal(vect(1.0000000, 1.0000000, 0.0000000) * View);
        // End:0x5AD
        if(VSizeSq(View) ~= float(0))
        {
            return false;
        }
        // End:0x624
        if(FinisherDefs[FinisherIndex].bCheckFront && !HasEnoughRoom(View * FinisherDefs[FinisherIndex].Lebensraum))
        {
            return StillClose();
        }
        // End:0x69D
        if(FinisherDefs[FinisherIndex].bCheckBack && !HasEnoughRoom(View * -FinisherDefs[FinisherIndex].Lebensraum))
        {
            return StillClose();
        }
        // End:0x6B7
        if(!OnTheSameHeight())
        {
            return StillClose();
        }
        LastValidTargetTime = PawnOwner.WorldInfo.TimeSeconds;
        TargetPawn = TP;
        AdvPawn(PawnOwner).FinisherCandidate = TP;
        return true;
    }
    return StillClose();
    //return ReturnValue;    
}

function PawnActionStarted(bool bForced, byte PrevAction)
{
    local name Anim;
    local Actor OldBase;

    // End:0x6A
    if(PawnOwner.InteractionPawn == none)
    {
        PawnOwner.InteractionPawn = AdvPawn(PawnOwner).FinisherCandidate;
    }
    super.PawnActionStarted(bForced, PrevAction);
    FinisherIndex = ((PawnOwner.PawnActionFlags >= 0) ? PawnOwner.PawnActionFlags : FinisherIndex);
    FinisherIndex = ((FinisherIndex < 0) ? Rand(FinisherDefs.Length) : FinisherIndex);
    PawnOwner.InteractionPawn.GotoState('FinisherVictim');
    // End:0x1BA
    if(int(PawnOwner.InteractionPawn.Role) == int(ROLE_Authority))
    {
        PawnOwner.InteractionPawn.bTearOff = true;
    }
    // End:0x25D
    if(AdvPlayerController(PCOwner) != none)
    {
        PCOwner.GetComboManager().HandleEvent('Finisher', PawnOwner.InteractionPawn);
        AdvPlayerController(PCOwner).NotifyFinisherStart();        
    }
    else
    {
        // End:0x29D
        if(AdvAIController(AIOwner) != none)
        {
            AdvAIController(AIOwner).NotifyFinisherStart();
        }
    }
    // End:0x45A
    if(EvilAIController(PawnOwner.InteractionPawn.Controller) != none)
    {
        // End:0x3DA
        if(EvilAIController(PawnOwner.InteractionPawn.Controller).CommandList != none)
        {
            EvilAIController(PawnOwner.InteractionPawn.Controller).AbortCommand(EvilAIController(PawnOwner.InteractionPawn.Controller).CommandList);
        }
        EvilAIController(PawnOwner.InteractionPawn.Controller).Destroy();
        PawnOwner.InteractionPawn.Controller = none;
    }
    // End:0x52D
    if(!FinisherDefs[FinisherIndex].bShouldPropagate && !PawnOwner.IsLocallyControlled())
    {
        PawnOwner.InteractionPawn.DoPawnAction(61, true, PawnOwner, PawnOwner.PawnActionFlags);
        PawnOwner.EndPawnAction(60);
        return;
    }
    PawnOwner.InteractionPawn.bShouldPlayMeleeImpacts = false;
    Anim = FinisherDefs[FinisherIndex].AttackerAnim;
    // End:0x6A7
    if((PCOwner != none) && int(PCOwner.Role) == int(ROLE_Authority))
    {
        PCOwner.SetRotation(Rotator(PawnOwner.InteractionPawn.Location - PawnOwner.Location));
        PawnOwner.SetRotation(Rotator(PawnOwner.InteractionPawn.Location - PawnOwner.Location));
    }
    // End:0x73E
    if(PawnOwner.FullBodyAnimSlot.PlayCustomAnim(Anim, SpeedModifier, 0.2000000 / SpeedModifier, 0.2000000 / SpeedModifier, false) == 0.0000000)
    {
        PawnOwner.EndPawnAction(60);
        return;
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(true);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(2, 2, 0);
    PawnOwner.Mesh.RootMotionMode = 3;
    // End:0x955
    if(FinisherDefs[FinisherIndex].TEMPAttachmentClass != none)
    {
        PawnOwner.CurrentWeaponAttachmentClass = FinisherDefs[FinisherIndex].TEMPAttachmentClass;
        // End:0x955
        if(((int(PawnOwner.WorldInfo.NetMode) == int(NM_ListenServer)) || int(PawnOwner.WorldInfo.NetMode) == int(NM_Standalone)) || (int(PawnOwner.WorldInfo.NetMode) == int(NM_Client)) && PawnOwner.IsLocallyControlled())
        {
            PawnOwner.WeaponAttachmentChanged();
        }
    }
    // End:0xA4D
    if(((FinisherDefs[FinisherIndex].CameraAnim != none) && PCOwner != none) && PCOwner.CameraAnimPlayer != none)
    {
        PCOwner.PlayCameraAnim(FinisherDefs[FinisherIndex].CameraAnim, FinisherDefs[FinisherIndex].CameraAnimWeight,, FinisherDefs[FinisherIndex].CameraAnimBlendTime);
    }
    OldBase = PawnOwner.InteractionPawn.Base;
    PawnOwner.InteractionPawn.SetPhysics(0);
    PawnOwner.InteractionPawn.SetBase(OldBase);
    PawnOwner.InteractionPawn.FullBodyAnimSlot.StopCustomAnim(0.0000000);
    PawnOwner.InteractionPawn.TopHalfAnimSlot.StopCustomAnim(0.0000000);
    PawnOwner.InteractionPawn.DoPawnAction(61, true, PawnOwner, FinisherIndex);
    //return;    
}

function PawnActionEnded(byte PrevMove, byte NextMove)
{
    super.PawnActionEnded(PrevMove, NextMove);
    PawnOwner.EndMelee();
    // End:0x8F
    if(!FinisherDefs[FinisherIndex].bShouldPropagate && !PawnOwner.IsLocallyControlled())
    {
        return;
    }
    // End:0xD2
    if(AdvPlayerController(PCOwner) != none)
    {
        AdvPlayerController(PCOwner).NotifyFinisherEnd();        
    }
    else
    {
        // End:0x112
        if(AdvAIController(AIOwner) != none)
        {
            AdvAIController(AIOwner).NotifyFinisherEnd();
        }
    }
    PawnOwner.FullBodyAnimSlot.SetActorAnimEndNotification(false);
    PawnOwner.FullBodyAnimSlot.SetRootBoneAxisOption(1, 1, 1);
    PawnOwner.Mesh.RootMotionMode = PawnOwner.default.Mesh.RootMotionMode;
    // End:0x280
    if(((FinisherDefs[FinisherIndex].CameraAnim != none) && PCOwner != none) && PCOwner.CameraAnimPlayer != none)
    {
        PCOwner.CameraAnimPlayer.Stop();
    }
    //return;    
}

defaultproperties
{
    FinisherIndex=-1
    FinisherDefs[0]=(WeaponClass=Class'AdvWeap_Melee_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=90.0000000,AttackerAnim="Player_Shovel_Finisher_01",VictimAnim=(AnimName="Enemy_Shovel_Finisher_01",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[1]=(WeaponClass=Class'AdvWeap_Melee_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=140.0000000,AttackerAnim="Player_Shovel_Finisher_06",VictimAnim=(AnimName="Enemy_Shovel_Finisher_06",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[2]=(WeaponClass=Class'AdvWeap_Melee_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=170.0000000,AttackerAnim="Player_Shovel_Finisher_08",VictimAnim=(AnimName="Enemy_Shovel_Finisher_08",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[3]=(WeaponClass=Class'AdvWeap_Melee_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=170.0000000,AttackerAnim="Player_Shovel_Finisher_09",VictimAnim=(AnimName="Enemy_Shovel_Finisher_09",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[4]=(WeaponClass=none,TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=183.0000000,AttackerAnim="Player_Axe_Finisher_02",VictimAnim=(AnimName="Enemy_Axe_Finisher_02",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[5]=(WeaponClass=none,TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=140.0000000,AttackerAnim="Player_Axe_Finisher_07",VictimAnim=(AnimName="Enemy_Axe_Finisher_07",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[6]=(WeaponClass=none,TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=170.0000000,AttackerAnim="Player_Axe_Finisher_08",VictimAnim=(AnimName="Enemy_Axe_Finisher_08",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[7]=(WeaponClass=none,TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=145.0000000,AttackerAnim="Player_Axe_Finisher_10",VictimAnim=(AnimName="Enemy_Axe_Finisher_10",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[8]=(WeaponClass=Class'AdvWeap_Sword_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=110.0000000,AttackerAnim="Player_Sword_Finisher_01",VictimAnim=(AnimName="Enemy_Sword_Finisher_01",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[9]=(WeaponClass=Class'AdvWeap_Sword_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=160.0000000,AttackerAnim="Player_Sword_Finisher_03",VictimAnim=(AnimName="Enemy_Sword_Finisher_03",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[10]=(WeaponClass=Class'AdvWeap_Sword_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=150.0000000,AttackerAnim="Player_Sword_Finisher_06",VictimAnim=(AnimName="Enemy_Sword_Finisher_06",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[11]=(WeaponClass=Class'AdvWeap_Sword_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=150.0000000,AttackerAnim="Player_Sword_Finisher_07",VictimAnim=(AnimName="Enemy_Sword_Finisher_07",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    FinisherDefs[12]=(WeaponClass=Class'AdvWeap_Sword_Mummy',TEMPAttachmentClass=none,ActivationDistance=150.0000000,Lebensraum=200.0000000,AttackerAnim="Player_Sword_Finisher_08",VictimAnim=(AnimName="Enemy_Sword_Finisher_08",AnimSpeed=1.0000000,Chance=1.0000000,OverrideBlendTimes=false,BlendInTime=0.2000000,BlendOutTime=0.2000000),CameraAnim=CameraAnim'an_CameraAnims.Anim.CA_CameraShake',CameraAnimWeight=0.7000000,CameraAnimBlendTime=0.2000000,bManualBlendToMotors=true,bShouldPropagate=false,bCheckFront=true,bCheckBack=false,PlasmaCost=1.0000000)
    AINotificationRadius=500.0000000
    bLockPawnRotation=true
    bDisablePOIs=true
}