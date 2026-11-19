class PKRailCar_Rollercoaster_Base extends EvilRailCar_Base
    hidecategories(Navigation);

var() PKRailCarBreadCrumb FirstBreadCrumb;
var PKRailCarBreadCrumb CurrentBreadCrumb;
var int LastCrumbIndex;
var() float CrumbPeriod;
var() float RideLength;
var float RideTime;
var Rotator RideStartRotation;
var() SoundCue StartStopCue;
var() SoundCue SlowMoveCue;
var() SoundCue FastMoveCue;
var() SoundCue ScrapeCue;
var export editinline AudioComponent SlowMoveComponent;
var export editinline AudioComponent FastMoveComponent;
var float NextScrapeTime;

replication
{
    // Pos:0x000
    if(bInterpolating && int(Role) == int(ROLE_Authority))
        RideTime;
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x6C
    if(SlowMoveCue != none)
    {
        SlowMoveComponent = new (self) Class'Engine.AudioComponent';
        AttachComponent(SlowMoveComponent);
        SlowMoveComponent.SoundCue = SlowMoveCue;
    }
    // End:0xCE
    if(FastMoveCue != none)
    {
        FastMoveComponent = new (self) Class'Engine.AudioComponent';
        AttachComponent(FastMoveComponent);
        FastMoveComponent.SoundCue = FastMoveCue;
    }
    // End:0xDF
    if(FirstBreadCrumb == none)
    {
        return;
    }
    SetLocation(FirstBreadCrumb.Location);
    //return;    
}

function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x15
    if(RideTime > 0.0000000)
    {
        return;
    }
    // End:0x26
    if(FirstBreadCrumb == none)
    {
        return;
    }
    // End:0x71
    if(inAction.InputLinks[0].bHasImpulse)
    {
        PushState('Riding');
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x38
    if(VarName == 'bInterpolating')
    {
        // End:0x38
        if(bInterpolating)
        {
            PushState('Riding');
        }
    }
    super(DynamicSMActor).ReplicatedEvent(VarName);
    //return;    
}

simulated function ReattachCoopGhost(PKPlayerPawn P)
{
    local SeqAct_AttachToActor FakeAction;

    // End:0x43
    if(P != none)
    {
        FakeAction = new Class'Engine.SeqAct_AttachToActor';
        DoKismetAttachment(P, FakeAction);
    }
    //return;    
}

simulated event Attach(Actor Other)
{
    local EvilPawn P;

    // End:0x138
    if(!IsInState('Riding'))
    {
        P = EvilPawn(Other);
        // End:0x138
        if(P != none)
        {
            // End:0x138
            if(bClampedBaseEnabled)
            {
                // End:0x138
                if(((bDisallowPawnMovement || !P.ConfineToClampedBase()) || P.bJustTeleported) || int(P.Physics) == int(10))
                {
                    // End:0x138
                    if(P.IsInState('Ghost') || P.IsInState('Demon'))
                    {
                        P.PopState();
                    }
                }
            }
        }
    }
    super.Attach(Other);
    //return;    
}

simulated state Riding
{
    ignores OnToggle;

    simulated event PushedState()
    {
        local EvilPawn P;
        local SeqAct_AttachToActor FakeAction;

        super(Object).PushedState();
        RideStartRotation = Rotation - FirstBreadCrumb.Rotation;
        CurrentBreadCrumb = FirstBreadCrumb;
        RideTime = 0.0000000;
        bInterpolating = true;
        // End:0xA4
        if(SlowMoveComponent != none)
        {
            SlowMoveComponent.FadeIn(0.5000000, 1.0000000);
        }
        // End:0xDC
        if(FastMoveComponent != none)
        {
            FastMoveComponent.FadeIn(0.5000000, 1.0000000);
        }
        NextScrapeTime = WorldInfo.TimeSeconds + (3.0000000 * FRand());
        // End:0x136
        if(StartStopCue != none)
        {
            PlaySound(StartStopCue);
        }
        // End:0x1B1
        if(int(Role) < int(ROLE_Authority))
        {
            FakeAction = new Class'Engine.SeqAct_AttachToActor';
            // End:0x1B0
            foreach DynamicActors(Class'EvilGame.EvilPawn', P)
            {
                // End:0x1AF
                if(PKPlayerPawn(P) != none)
                {
                    DoKismetAttachment(P, FakeAction);
                }                
            }            
        }
        // End:0x25D
        if((PKGame(WorldInfo.Game) != none) && PKGame(WorldInfo.Game).IsDeamonMode())
        {
            PKGame(WorldInfo.Game).StopDaemonMode();
        }
        // End:0x480
        foreach AttachedPawnList(P)
        {
            // End:0x47F
            if(P.Controller != none)
            {
                // End:0x351
                if(P.Controller.IsInState('CoopGhost'))
                {
                    PKPlayerController(P.Controller).TimeRemainingInGhost = 0.0000000;
                    PKPlayerController(P.Controller).RespawnInSamePlace();
                }
                // End:0x400
                if(!P.Controller.IsInState('PlayerWalking') && !P.Controller.IsInState('Dead'))
                {
                    P.Controller.PopState(true);
                }
                P.Controller.GotoState('Rollercoaster');
                PlayerController(P.Controller).ClientGotoState('Rollercoaster');
            }            
        }        
        //return;        
    }

    simulated event PoppedState()
    {
        local int I;
        local EvilPawn P;

        super(Object).PoppedState();
        bInterpolating = false;
        // End:0x4E
        if(SlowMoveComponent != none)
        {
            SlowMoveComponent.FadeOut(0.5000000, 0.0000000);
        }
        // End:0x86
        if(FastMoveComponent != none)
        {
            FastMoveComponent.FadeOut(0.5000000, 0.0000000);
        }
        // End:0xAD
        if(StartStopCue != none)
        {
            PlaySound(StartStopCue);
        }
        SetPhysics(0);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        I = AttachedPawnList.Length - 1;
        J0xE0:

        // End:0x17D [Loop If]
        if(I >= 0)
        {
            P = AttachedPawnList[I];
            P.Controller.PopState();
            DetachPawn(P);
            P.SetPhysics(0);
            --I;
            // [Loop Continue]
            goto J0xE0;
        }
        //return;        
    }

    simulated event Tick(float DeltaTime)
    {
        local float Alpha;
        local int CrumbIndex, I;
        local float Speed, SlowVolume, FastVolume;
        local Vector Diff, Target;

        super(EvilRailCar_Base).Tick(DeltaTime);
        RideTime += DeltaTime;
        // End:0x4B
        if(RideTime >= RideLength)
        {
            PopState();
            return;
        }
        Alpha = RideTime / CrumbPeriod;
        CrumbIndex = FFloor(Alpha);
        // End:0x2DC
        if(LastCrumbIndex != CrumbIndex)
        {
            I = CrumbIndex - LastCrumbIndex;
            J0xBB:

            // End:0x111 [Loop If]
            if((I > 0) && CurrentBreadCrumb != none)
            {
                CurrentBreadCrumb = CurrentBreadCrumb.NextNode;
                --I;
                // [Loop Continue]
                goto J0xBB;
            }
            // End:0x153
            if((CurrentBreadCrumb == none) || CurrentBreadCrumb.NextNode == none)
            {
                PopState();
                return;
            }
            Diff = CurrentBreadCrumb.NextNode.Location - CurrentBreadCrumb.Location;
            Speed = float(Min(168, int(VSize(Diff) / CrumbPeriod)));
            SlowVolume = ((Speed < 50.4000000) ? (0.7000000 * (1.0000000 - (Speed / 50.4000000))) + 0.3000000 : 0.0000000);
            FastVolume = ((0.8500000 * Speed) / 168.0000000) + 0.1500000;
            // End:0x289
            if(SlowMoveComponent != none)
            {
                SlowMoveComponent.AdjustVolume(CrumbPeriod, SlowVolume);
            }
            // End:0x2C9
            if(FastMoveComponent != none)
            {
                FastMoveComponent.AdjustVolume(CrumbPeriod, FastVolume);
            }
            LastCrumbIndex = CrumbIndex;
        }
        Alpha -= float(CrumbIndex);
        SetRotation(RideStartRotation + QuatToRotator(QuatSlerp(QuatFromRotator(CurrentBreadCrumb.Rotation), QuatFromRotator(CurrentBreadCrumb.NextNode.Rotation), Alpha, true)));
        Target = VLerp(CurrentBreadCrumb.Location, CurrentBreadCrumb.NextNode.Location, Alpha);
        Move(Target - Location);
        // End:0x435
        if(VSizeSq(Target - Location) > 0.1000000)
        {
            SetLocation(Target);
        }
        // End:0x4BD
        if((ScrapeCue != none) && WorldInfo.TimeSeconds >= NextScrapeTime)
        {
            PlaySound(ScrapeCue);
            NextScrapeTime = WorldInfo.TimeSeconds + (2.0000000 * FRand());
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    bClampedBaseEnabled=true
    bAlwaysConfineToClampedBase=true
    bDisallowPawnMovement=true
    bForceStickToClosestNavPoint=true
    // Reference: StaticMeshComponent'Default__PKRailCar_Rollercoaster_Base.StaticMeshComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'StaticMeshComponent0'
    // Archetype: StaticMeshComponent'EvilGame.Default__EvilRailCar_Base.StaticMeshComponent0'
    begin object name="StaticMeshComponent0"
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__PKRailCar_Rollercoaster_Base.MyLightEnvironment'
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__PKRailCar_Rollercoaster_Base.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'EvilGame.Default__EvilRailCar_Base.MyLightEnvironment'
    begin object name="MyLightEnvironment"
    end object
    LightEnvironment=MyLightEnvironment
    Components[0]=MyLightEnvironment
    Components[1]=StaticMeshComponent0
    BlockRigidBody=true
    bBlockActors=true
    CollisionComponent=StaticMeshComponent0
}