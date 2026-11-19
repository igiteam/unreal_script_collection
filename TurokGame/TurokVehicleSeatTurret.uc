class TurokVehicleSeatTurret extends TurokVehicleSeat;

simulated function PlayDeathAnim()
{
    local @NULL gunnerViewRot, gunnerViewDir, vehicleForwards, vehicleRight;
    local float dpForward, dpRight;
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // End:0x5C
    if(tph == none)
    {
        // DebugMode: 0
        assert((GetEnteringPawn()) != none);
        EntryFinished();
        tph = TurokPawnHuman(GetSeatedPawn());
        // DebugMode: 0
        assert(tph != none);
    }
    tph.GetActorEyesViewPoint(vehicleForwards, gunnerViewRot);
    gunnerViewDir = Vector(gunnerViewRot);
    gunnerViewDir.Z = 0.0000000;
    vehicleForwards = Vector(MyVehicle.Rotation);
    vehicleForwards.Z = 0.0000000;
    vehicleRight = Normal(vehicleForwards Cross vect(0.0000000, 0.0000000, 1.0000000));
    dpForward = vehicleForwards Dot gunnerViewDir;
    dpRight = vehicleRight Dot gunnerViewDir;
    // End:0x18C
    if(dpForward >= 0.0000000)
    {
        // End:0x157
        if(dpRight >= 0.0000000)
        {
            // End:0x145
            if(dpForward > dpRight)
            {
                mDyingAnimName = 'DeathLeft';                
            }
            else
            {
                mDyingAnimName = 'DeathLeft';
            }            
        }
        else
        {
            // End:0x17A
            if(dpForward > -dpRight)
            {
                mDyingAnimName = 'deathright';                
            }
            else
            {
                mDyingAnimName = 'deathright';
            }
        }        
    }
    else
    {
        // End:0x1D0
        if(dpRight >= 0.0000000)
        {
            // End:0x1BE
            if(-dpForward > dpRight)
            {
                mDyingAnimName = 'deathfrontright';                
            }
            else
            {
                mDyingAnimName = 'deathright';
            }            
        }
        else
        {
            // End:0x1F5
            if(-dpForward > -dpRight)
            {
                mDyingAnimName = 'DeathFrontLeft';                
            }
            else
            {
                mDyingAnimName = 'DeathLeft';
            }
        }
    }
    super.PlayDeathAnim();
    //return;    
}

simulated function NotifyGraphStart(@NULL graph, byte actorType)
{
    local @NULL TPC, Cam, tph;

    // End:0x24F
    if(int(actorType) == int(0))
    {
        // End:0x140
        if(graph.mName == mEntryAnimName)
        {
            tph = TurokPawnHuman(GetEnteringPawn());
            // DebugMode: 0
            assert(tph != none);
            TPC = TurokPlayerController(tph.Controller);
            // End:0x13D
            if(TPC != none)
            {
                // DebugMode: 0
                assert((int(TPC.Role) == int(ROLE_Authority)) || int(TPC.Role) == int(ROLE_AutonomousProxy));
                Cam = TurokPlayerCamera(TPC.PlayerCamera);
                // DebugMode: 0
                assert(Cam != none);
                Cam.mParameters.blendTime = mCamEnterBlendTime;
                Cam.mParameters.DelayTime = mCamEnterDelayTime;
                Cam.mParameters.RelatedActor = MyVehicle;
                TPC.SimulatedSetTurokCamera('TurretVehicle');
            }            
        }
        else
        {
            // End:0x24F
            if(graph.mName == mDyingAnimName)
            {
                tph = TurokPawnHuman(GetSeatedPawn());
                // DebugMode: 0
                assert(tph != none);
                TPC = TurokPlayerController(tph.Controller);
                // End:0x24F
                if(TPC != none)
                {
                    // DebugMode: 0
                    assert((int(TPC.Role) == int(ROLE_Authority)) || int(TPC.Role) == int(ROLE_AutonomousProxy));
                    Cam = TurokPlayerCamera(TPC.PlayerCamera);
                    // DebugMode: 0
                    assert(Cam != none);
                    Cam.mParameters.blendTime = 1.5000000;
                    Cam.mParameters.RelatedActor = MyVehicle;
                    TPC.SimulatedSetTurokCamera('TurretVehicle');
                }
            }
        }
    }
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    // End:0x72
    if(int(actorType) == int(0))
    {
        // End:0x35
        if(graph.mName == mEntryAnimName)
        {
            EntryFinished();            
        }
        else
        {
            // End:0x5A
            if(graph.mName == mExitAnimName)
            {
                ExitFinished();                
            }
            else
            {
                // End:0x72
                if(graph.mName == mDyingAnimName)
                {
                }
            }
        }
    }
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    // End:0x4D
    if(int(actorType) == int(0))
    {
        // End:0x30
        if(prevGraph.mName == mEntryAnimName)
        {
            // DebugMode: 0
            assert(false);            
        }
        else
        {
            // End:0x4D
            if(prevGraph.mName == mExitAnimName)
            {
                // DebugMode: 0
                assert(false);
            }
        }
    }
    //return;    
}

simulated function EntryStart(@NULL tph)
{
    local @NULL C, TPC, Cam;

    tph.SetWeaponsVisibleIn3rdPerson(false);
    super.EntryStart(tph);
    MyVehicle.AttachPawn(tph, MyIndex);
    tph.Mesh.SetHasPhysicsAssetInstance(false);
    C = tph.Controller;
    // End:0x132
    if(C != none)
    {
        TPC = TurokPlayerController(C);
        // End:0x132
        if(TPC != none)
        {
            // DebugMode: 0
            assert((int(TPC.Role) == int(ROLE_Authority)) || int(TPC.Role) == int(ROLE_AutonomousProxy));
            Cam = TurokPlayerCamera(TPC.PlayerCamera);
            // DebugMode: 0
            assert(Cam != none);
            Cam.mParameters.CancelAnimatedCamUpdateCtrl = true;
            C = tph.Controller;
            TPC.SetRotation(MyVehicle.Rotation);
        }
    }
    //return;    
}

simulated function EntryFinished()
{
    local @NULL TPC, Cam, tph, C;

    tph = TurokPawnHuman(GetEnteringPawn());
    // DebugMode: 0
    assert(tph != none);
    tph.SetWeaponsVisibleIn3rdPerson(true);
    C = tph.Controller;
    // End:0x193
    if(C != none)
    {
        // DebugMode: 0
        assert(C.Pawn != none);
        // DebugMode: 0
        assert((int(C.Role) == int(ROLE_Authority)) || int(C.Role) == int(ROLE_AutonomousProxy));
        TPC = TurokPlayerController(C);
        // End:0x16B
        if(TPC != none)
        {
            Cam = TurokPlayerCamera(TPC.PlayerCamera);
            // DebugMode: 0
            assert(Cam != none);
            Cam.mParameters.blendTime = 0.0000000;
            Cam.mParameters.RelatedActor = MyVehicle;
            TPC.SimulatedSetTurokCamera('TurretVehicle');
            // End:0x168
            if(!TPC.IsInState('PlayerRiding'))
            {
                TPC.GotoState('PlayerRiding');
            }            
        }
        else
        {
            // End:0x193
            if(TurokAIControllerHumanNpc(C) != none)
            {
                TurokAIControllerHumanNpc(C).GotoStartState();
            }
        }
    }
    MyVehicle.EquipSeatWeapon(tph);
    super.EntryFinished();
    //return;    
}

simulated function ForceExitToAnim()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    super.ForceExitToAnim();
    MyVehicle.UnEquipSeatWeapon(tph, true);
    tph.SetWeaponsVisibleIn3rdPerson(true);
    tph.Mesh.SetHasPhysicsAssetInstance(true);
    //return;    
}

simulated function ExitStart()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    // End:0x72
    if(tph != none)
    {
        tph.StopFiring();
        tph.SetWeaponsVisibleIn3rdPerson(false);
        MyVehicle.UnEquipSeatWeapon(tph, true);
        super.ExitStart();
    }
    //return;    
}

simulated function ExitFinished()
{
    local @NULL C, tph, TPC;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    tph.SetWeaponsVisibleIn3rdPerson(true);
    C = tph.Controller;
    // End:0x12F
    if(C != none)
    {
        // DebugMode: 0
        assert((int(C.Role) == int(ROLE_Authority)) || int(C.Role) == int(ROLE_AutonomousProxy));
        // End:0x12F
        if(tph.Health > 0)
        {
            TPC = TurokPlayerController(C);
            // End:0x107
            if(TPC != none)
            {
                TPC.SetViewTarget(tph);
                TPC.SimulatedSetTurokCamera('FirstPerson');
                TPC.GotoState('PlayerWalking');                
            }
            else
            {
                // End:0x12F
                if(TurokAIControllerHumanNpc(C) != none)
                {
                    TurokAIControllerHumanNpc(C).GotoStartState();
                }
            }
        }
    }
    tph.Mesh.SetHasPhysicsAssetInstance(true);
    super.ExitFinished();
    //return;    
}

simulated function DyingFinished()
{
    super.DyingFinished();
    MyVehicle.GetTurretController().ReleaseCurrentRotation();
    //return;    
}

defaultproperties
{
    // Reference: TurokBoneShakePhysics'Default__TurokVehicleSeatTurret.ReactionPhysicsObj'
    begin object name=ReactionPhysicsObj
    end object
    mReactionPhysics=ReactionPhysicsObj
}