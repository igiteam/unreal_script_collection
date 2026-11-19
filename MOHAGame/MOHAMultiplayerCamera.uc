class MOHAMultiplayerCamera extends MOHAPlayerCamera
    config(Game)
    hidecategories(Navigation);

var config int ITPCamYawRange;
var config int ITPCamPitchRange;

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
    local Vector Loc, pos, HitLocation, HitNormal;
    local Rotator Rot, TempPCRot;
    local Actor HitActor;
    local CameraActor CamActor;
    local bool bDoNotApplyModifiers;
    local TPOV OrigPOV;
    local Pawn VTPawn;
    local int ITPMeshIndex;
    local NavigationPoint lStartPoint;

    OrigPOV = OutVT.POV;
    OutVT.POV.FOV = DefaultFOV;
    CamActor = CameraActor(OutVT.Target);
    lStartPoint = NavigationPoint(OutVT.Target);
    // End:0xDC
    if(CamActor != none)
    {
        CamActor.GetCameraView(DeltaTime, OutVT.POV);
        bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
        OutVT.AspectRatio = CamActor.AspectRatio;        
    }
    else
    {
        // End:0x149
        if(lStartPoint != none)
        {
            OutVT.POV.Location = lStartPoint.Location + vect(0.0000000, 0.0000000, 75.0000000);
            OutVT.POV.Rotation = lStartPoint.Rotation;            
        }
        else
        {
            VTPawn = Pawn(OutVT.Target);
            // End:0x1AD
            if((VTPawn == none) && Controller(OutVT.Target) != none)
            {
                VTPawn = Controller(OutVT.Target).Pawn;
            }
            // End:0xAFE
            if((((VTPawn == none) || !VTPawn.CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV)) || CameraStyle == 'Spectator') || CameraStyle == 'Cinematic')
            {
                bDoNotApplyModifiers = true;
                // End:0x502
                if(PCOwner.IsLocalPlayerController())
                {
                    // End:0x502
                    if(VTPawn != none)
                    {
                        // End:0x45B
                        if(!VTPawn.bNetOwner)
                        {
                            // End:0x2DA
                            if(VTPawn.Mesh != none)
                            {
                                VTPawn.Mesh.SetOwnerNoSee((CameraStyle == 'FirstPerson') || CameraStyle == 'Cinematic');
                            }
                            // End:0x33E
                            if((VTPawn.Weapon != none) && VTPawn.Weapon.Mesh != none)
                            {
                                VTPawn.Weapon.Mesh.SetOwnerNoSee(CameraStyle != 'FirstPerson');
                            }
                            // End:0x458
                            if(MOHAPlayerPawn(OutVT.Target) != none)
                            {
                                // End:0x3B2
                                if(MOHAPlayerPawn(OutVT.Target).FPArms != none)
                                {
                                    MOHAPlayerPawn(OutVT.Target).FPArms.SetOwnerNoSee(CameraStyle != 'FirstPerson');
                                }
                                // End:0x458
                                if((MOHAPlayerPawn(OutVT.Target).CurrentWeaponAttachment != none) && MOHAPlayerPawn(OutVT.Target).CurrentWeaponAttachment.ThirdPersonMesh != none)
                                {
                                    MOHAPlayerPawn(OutVT.Target).CurrentWeaponAttachment.ThirdPersonMesh.SetOwnerNoSee((CameraStyle == 'FirstPerson') || CameraStyle == 'Cinematic');
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x502
                            if(CameraStyle == 'Cinematic')
                            {
                                // End:0x49B
                                if(VTPawn.Mesh != none)
                                {
                                    VTPawn.Mesh.SetOwnerNoSee(true);
                                }
                                // End:0x502
                                if((MOHAPlayerPawn(OutVT.Target) != none) && MOHAPlayerPawn(OutVT.Target).FPArms != none)
                                {
                                    MOHAPlayerPawn(OutVT.Target).FPArms.SetOwnerNoSee(true);
                                }
                            }
                        }
                    }
                }
                switch(CameraStyle)
                {
                    // End:0x79D
                    case 'Cinematic':
                        Loc = PCOwner.Location;
                        // End:0x648
                        if(PCOwner.IsA('MOHAMultiplayerController'))
                        {
                            ITPMeshIndex = MOHAMultiplayerController(PCOwner).m_iCinematicActorMeshIndex;
                            // End:0x648
                            if((ITPMeshIndex >= 0) && ITPMeshIndex < 8)
                            {
                                // End:0x648
                                if(MultiplayerCinematicActor(OutVT.Target) != none)
                                {
                                    Loc = MultiplayerCinematicActor(OutVT.Target).FPMesh.GetBoneLocation('Camera', 0);
                                    Rot = QuatToRotator(MultiplayerCinematicActor(OutVT.Target).FPMesh.GetBoneQuaternion('Camera', 0));
                                    Rot -= MultiplayerCinematicActor(OutVT.Target).FPMesh.SkeletalMesh.RotOrigin;
                                    Rot = Normalize(Rot);
                                }
                            }
                        }
                        TempPCRot = PCOwner.Rotation;
                        TempPCRot.Yaw = Clamp(PCOwner.Rotation.Yaw, -ITPCamYawRange, ITPCamYawRange);
                        // End:0x6EC
                        if((TempPCRot.Pitch > 32768) && TempPCRot.Pitch < (65535 - ITPCamPitchRange))
                        {
                            TempPCRot.Pitch = 65535 - ITPCamPitchRange;                            
                        }
                        else
                        {
                            // End:0x735
                            if((TempPCRot.Pitch < 32768) && TempPCRot.Pitch > ITPCamPitchRange)
                            {
                                TempPCRot.Pitch = ITPCamPitchRange;
                            }
                        }
                        PCOwner.SetRotation(TempPCRot);
                        Rot += PCOwner.Rotation;
                        OutVT.POV.Location = Loc;
                        OutVT.POV.Rotation = Rot;
                        // End:0xAFE
                        break;
                    // End:0x7C1
                    case 'Fixed':
                        OutVT.POV = OrigPOV;
                        // End:0xAFE
                        break;
                    // End:0x7CD
                    case 'ThirdPerson':
                    // End:0x90A
                    case 'FreeCam':
                        Loc = OutVT.Target.Location;
                        Rot = OutVT.Target.Rotation;
                        // End:0x83C
                        if(CameraStyle == 'FreeCam')
                        {
                            Rot = PCOwner.Rotation;
                        }
                        Loc += (FreeCamOffset >> Rot);
                        pos = Loc - (Vector(Rot) * FreeCamDistance);
                        HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(0.0000000, 0.0000000, 0.0000000));
                        // End:0x8BE
                        if(HitActor != none)
                        {
                            Loc = HitLocation + (HitNormal * float(2));                            
                        }
                        else
                        {
                            Loc = pos;
                        }
                        OutVT.POV.Location = Loc;
                        OutVT.POV.Rotation = Rot;
                        // End:0xAFE
                        break;
                    // End:0xA9D
                    case 'Spectator':
                        // End:0x974
                        if(OutVT.Target.IsA('MOHAMultiplayerPawn') && MOHAMultiplayerPawn(OutVT.Target).IsInState('Dying'))
                        {
                            super.UpdateViewTarget(OutVT, DeltaTime);                            
                        }
                        else
                        {
                            OutVT.Target.GetActorEyesViewPoint(Loc, Rot);
                            Rot = OutVT.Target.Rotation;
                            Rot += PCOwner.Rotation;
                            Loc += (FreeCamOffset >> Rot);
                            pos = Loc - (Vector(Rot) * FreeCamDistance);
                            HitActor = Trace(HitLocation, HitNormal, pos, Loc, false, vect(0.0000000, 0.0000000, 0.0000000));
                            // End:0xA51
                            if(HitActor != none)
                            {
                                Loc = HitLocation + (HitNormal * float(10));                                
                            }
                            else
                            {
                                Loc = pos;
                            }
                            OutVT.POV.Location = Loc;
                            OutVT.POV.Rotation = Rot;
                        }
                        // End:0xAFE
                        break;
                    // End:0xAA9
                    case 'FirstPerson':
                    // End:0xFFFF
                    default:
                        OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
                        // End:0xAFE
                        break;
                        break;
                }
            }
        }
    }
    // End:0xB27
    if(!bDoNotApplyModifiers)
    {
        ApplyCameraModifiers(DeltaTime, OutVT.POV);
    }
    //return;    
}

defaultproperties
{
    ITPCamYawRange=15000
    ITPCamPitchRange=8000
    DefaultFOV=72.0000000
}