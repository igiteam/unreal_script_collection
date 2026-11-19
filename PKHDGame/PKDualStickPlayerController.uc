class PKDualStickPlayerController extends PKPlayerController
    config(Game)
    hidecategories(Navigation);

var() Vector VirtualCursor;
var() Vector2D ScreenSpaceCursor;
var() float VirtualCursorMouseScale;
var() float VirtualCursorMouseDistance;
var() float VirtualCursorGamepadDistance;
var() float VirtualCursorGamepadInterpSpeed;

function SetBehindView(bool bNewBehindView)
{
    super(UTPlayerController).SetBehindView(true);
    //return;    
}

state PlayerWalking
{
    function PlayerMove(float DeltaTime)
    {
        local Vector newAccel;
        local Actor.EDoubleClickDir DoubleClickMove;
        local Rotator OldRotation;
        local bool bSaveJump;

        // End:0x20
        if(Pawn == none)
        {
            GotoState('Dead');            
        }
        else
        {
            newAccel.X = PlayerInput.aForward;
            newAccel.Y = PlayerInput.aStrafe;
            newAccel.Z = 0.0000000;
            newAccel = Pawn.AccelRate * Normal(newAccel);
            // End:0x10D
            if(IsLocalPlayerController())
            {
                AdjustPlayerWalkingMoveAccel(newAccel);
            }
            DoubleClickMove = PlayerInput.CheckForDoubleClickMove(DeltaTime / WorldInfo.TimeDilation);
            OldRotation = Rotation;
            UpdateRotation(DeltaTime);
            bDoubleJump = false;
            // End:0x1DD
            if(bPressedJump && Pawn.CannotJumpNow())
            {
                bSaveJump = true;
                bPressedJump = false;                
            }
            else
            {
                bSaveJump = false;
            }
            // End:0x23A
            if(int(Role) < int(ROLE_Authority))
            {
                ReplicateMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);                
            }
            else
            {
                ProcessMove(DeltaTime, newAccel, DoubleClickMove, OldRotation - Rotation);
            }
            bPressedJump = bSaveJump;
        }
        //return;        
    }

    function UpdateRotation(float DeltaTime)
    {
        local Rotator DeltaRot, NewRotation, ViewRotation;
        local Vector NewCursor, Loc, Dir;
        local Vector2D ViewportSize;

        ViewRotation = Rotation;
        // End:0x4E
        if(Pawn != none)
        {
            Pawn.SetDesiredRotation(ViewRotation);
        }
        DeltaRot.Pitch = 0;
        // End:0x23A
        if(PlayerInput.bUsingGamepad)
        {
            // End:0x1AE
            if(!((PlayerInput.aTurn * PlayerInput.aTurn) + (PlayerInput.aLookUp * PlayerInput.aLookUp)) ~= 0.0000000)
            {
                NewCursor.X = PlayerInput.aLookUp;
                NewCursor.Y = PlayerInput.aTurn;
                VirtualCursor = Normal(NewCursor) * VirtualCursorGamepadDistance;
            }
            DeltaRot.Yaw = NormalizeRotAxis(RInterpTo(ViewRotation, Rotator(VirtualCursor), DeltaTime, VirtualCursorGamepadInterpSpeed).Yaw - ViewRotation.Yaw);            
        }
        else
        {
            // End:0x45E
            if(LocalPlayer(Player) != none)
            {
                LocalPlayer(Player).ViewportClient.GetViewportSize(ViewportSize);
                ScreenSpaceCursor.X = FClamp(ScreenSpaceCursor.X + (PlayerInput.aTurn * VirtualCursorMouseScale), 0.0000000, 1.0000000);
                ScreenSpaceCursor.Y = FClamp(ScreenSpaceCursor.Y - (((PlayerInput.aLookUp * VirtualCursorMouseScale) * ViewportSize.X) / ViewportSize.Y), 0.0000000, 1.0000000);
                LocalPlayer(Player).DeProject(ScreenSpaceCursor, Loc, Dir);
                VirtualCursor = (Loc + (Dir * PKDualStickPlayerPawn(Pawn).CameraFollowingDistance)) - Pawn.Location;
            }
            DeltaRot.Yaw = NormalizeRotAxis(Rotator(VirtualCursor).Yaw - NormalizeRotAxis(ViewRotation.Yaw));
        }
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        NewRotation = ViewRotation;
        NewRotation.Roll = Rotation.Roll;
        // End:0x59B
        if(Pawn != none)
        {
            Pawn.FaceRotation(NewRotation, DeltaTime);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    ScreenSpaceCursor=(X=0.5000000,Y=0.5000000)
    VirtualCursorMouseScale=0.0000500
    VirtualCursorMouseDistance=1024.0000000
    VirtualCursorGamepadDistance=250.0000000
    VirtualCursorGamepadInterpSpeed=8.0000000
    // Reference: EvilSceneCaptureHighlightComponent'Default__PKDualStickPlayerController.HighlightComponent'
    // Archetype: EvilSceneCaptureHighlightComponent'Default__PKPlayerController.HighlightComponent'
    begin object name="HighlightComponent"
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    bBehindView=true
    // Reference: ForceFeedbackWaveform'Default__PKDualStickPlayerController.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__PKDualStickPlayerController.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__PKDualStickPlayerController.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}