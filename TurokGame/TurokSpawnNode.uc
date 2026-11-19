class TurokSpawnNode extends Actor
    native
    placeable
    hidecategories(Navigation);

enum EActorSpawnState
{
    SSTATE_FactoryState,            // 0
    SSTATE_Idle,                    // 1
    SSTATE_Investigate,             // 2
    SSTATE_Scripted,                // 3
    SSTATE_LurkerHiding,            // 4
    SSTATE_MAX                      // 5
};

enum EActorSpawnAnim
{
    SANIM_None,                     // 0
    SANIM_JumpUp,                   // 1
    SANIM_JumpDown,                 // 2
    SANIM_JumpOver,                 // 3
    SANIM_RunOutLeft,               // 4
    SANIM_RunOutRight,              // 5
    SANIM_MAX                       // 6
};

var editoronly export editinline @NULL mSkelMesh;
var export editinline @NULL mSprite;
var export editinline @NULL mSpawnPlatform;
var export editinline @NULL mMaxRadiusComponent;
var export editinline @NULL mMinRadiusComponent;
var editoronly class<Class> mSpawnClass;
var export editinline array mInventoryMesh;
var export editinline @NULL mLightEnvironmentComponent;
var() editconst editinline @NULL mFactory;
var() bool mbEnabled;
var() bool mbSpawnOffScreen;
var() bool mbSpawnLineOfSightCheck;
var() bool mbIgnoreDamage;
var() bool mbIgnoreSight;
var() bool mbIgnoreHearing;
var() bool mbConsiderTRexAsBlocking;
var int mSpawnCountTotal;
var() int mSpawnCountMax;
var() int mSpawnRadiusMin;
var() int mSpawnRadiusMax;
var() int mSpawnRadiusOffsetX;
var() int mSpawnRadiusOffsetY;
var() @NULL mActorGoal;
var() @NULL mRouteGoal;
var() byte mActorSpawnState;
var() byte mActorSpawnAnim;
var() byte mScriptedSteerType;

simulated function OnToggle(@NULL Action)
{
    // End:0x26
    if(Action.InputLinks[0].bHasImpulse)
    {
        mbEnabled = true;
    }
    // End:0x4C
    if(Action.InputLinks[1].bHasImpulse)
    {
        mbEnabled = false;
    }
    // End:0x7A
    if(Action.InputLinks[2].bHasImpulse)
    {
        mbEnabled = !mbEnabled;
    }
    //return;    
}

simulated event PostSpawned(@NULL NewActor, @NULL ActorGoal, optional @NULL Factory)
{
    local @NULL TurokPawn, tpController, turokFactory, animInfo;
    local bool playingAnim;
    local @NULL ScriptedMoves;

    playingAnim = false;
    // End:0xB20
    if(NewActor != none)
    {
        mSpawnCountTotal++;
        TurokPawn = TurokPawn(NewActor);
        // End:0xB20
        if((TurokPawn != none) && TurokAIController(TurokPawn.Controller) != none)
        {
            tpController = TurokAIController(TurokPawn.Controller);
            turokFactory = TurokActorFactoryAI(Factory);
            // End:0x6E8
            if(int(mActorSpawnAnim) != int(0))
            {
                switch(mActorSpawnAnim)
                {
                    // End:0x1B1
                    case 2:
                        // End:0x100
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mJumpDown.graphSet != none)
                        {
                            animInfo.graphSet = turokFactory.mSpawnAnims.mJumpDown.graphSet;                            
                        }
                        else
                        {
                            animInfo.graphSet = TurokPawn.mJumpGraphSet;
                        }
                        // End:0x190
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mJumpDown.graphName != 'None')
                        {
                            animInfo.graphName = turokFactory.mSpawnAnims.mJumpDown.graphName;                            
                        }
                        else
                        {
                            animInfo.graphName = TurokPawn.mJumpDownGraphName;
                        }
                        // End:0x634
                        break;
                    // End:0x2D1
                    case 1:
                        // End:0x220
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mJumpUp.graphSet != none)
                        {
                            animInfo.graphSet = turokFactory.mSpawnAnims.mJumpUp.graphSet;                            
                        }
                        else
                        {
                            animInfo.graphSet = TurokPawn.mJumpGraphSet;
                        }
                        // End:0x2B0
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mJumpUp.graphName != 'None')
                        {
                            animInfo.graphName = turokFactory.mSpawnAnims.mJumpUp.graphName;                            
                        }
                        else
                        {
                            animInfo.graphName = TurokPawn.mJumpUpGraphName;
                        }
                        // End:0x634
                        break;
                    // End:0x3F1
                    case 3:
                        // End:0x340
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mJumpOver.graphSet != none)
                        {
                            animInfo.graphSet = turokFactory.mSpawnAnims.mJumpOver.graphSet;                            
                        }
                        else
                        {
                            animInfo.graphSet = TurokPawn.mJumpGraphSet;
                        }
                        // End:0x3D0
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mJumpOver.graphName != 'None')
                        {
                            animInfo.graphName = turokFactory.mSpawnAnims.mJumpOver.graphName;                            
                        }
                        else
                        {
                            animInfo.graphName = TurokPawn.mJumpOverGraphName;
                        }
                        // End:0x634
                        break;
                    // End:0x511
                    case 4:
                        // End:0x460
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mRunOutLeft.graphSet != none)
                        {
                            animInfo.graphSet = turokFactory.mSpawnAnims.mRunOutLeft.graphSet;                            
                        }
                        else
                        {
                            animInfo.graphSet = TurokPawn.mRunGraphSet;
                        }
                        // End:0x4F0
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mRunOutLeft.graphName != 'None')
                        {
                            animInfo.graphName = turokFactory.mSpawnAnims.mRunOutLeft.graphName;                            
                        }
                        else
                        {
                            animInfo.graphName = TurokPawn.mRunOutLeftGraphName;
                        }
                        // End:0x634
                        break;
                    // End:0x631
                    case 5:
                        // End:0x580
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mRunOutRight.graphSet != none)
                        {
                            animInfo.graphSet = turokFactory.mSpawnAnims.mRunOutRight.graphSet;                            
                        }
                        else
                        {
                            animInfo.graphSet = TurokPawn.mRunGraphSet;
                        }
                        // End:0x610
                        if((turokFactory != none) && turokFactory.mSpawnAnims.mRunOutRight.graphName != 'None')
                        {
                            animInfo.graphName = turokFactory.mSpawnAnims.mRunOutRight.graphName;                            
                        }
                        else
                        {
                            animInfo.graphName = TurokPawn.mRunOutRightGraphName;
                        }
                        // End:0x634
                        break;
                    // End:0xFFFF
                    default:
                        break;
                }
                // End:0x6E8
                if((animInfo.graphSet != none) && animInfo.graphName != 'None')
                {
                    tpController.mPlayTransitionGraphGraphSet = animInfo.graphSet;
                    tpController.mPlayTransitionGraphGraphName = animInfo.graphName;
                    tpController.mPlayTransitionGraphPrimaryController = tpController;
                    tpController.mPlayTransitionGraphSecondaryController = none;
                    tpController.mStartStateName = 'PlayTransitionGraphState';
                    playingAnim = true;
                }
            }
            // End:0xB20
            if(!playingAnim)
            {
                // End:0x890
                if((int(mActorSpawnState) == int(0)) && ActorGoal != none)
                {
                    tpController.StopLatentExecution();
                    tpController.GetScriptedMoves(ScriptedMoves);
                    ScriptedMoves.mGoalActor = ActorGoal;
                    ScriptedMoves.mGoalRoute = none;
                    // End:0x7B6
                    if(Pawn(ActorGoal) != none)
                    {
                        ScriptedMoves.mGoalRadius = 30.0000000;
                        ScriptedMoves.mScriptedSteerType = 2;
                        ScriptedMoves.mLookAtActor = ScriptedMoves.mGoalActor;                        
                    }
                    else
                    {
                        ScriptedMoves.mGoalRadius = 10.0000000;
                        ScriptedMoves.mScriptedSteerType = mScriptedSteerType;
                        ScriptedMoves.mLookAtActor = none;
                    }
                    ScriptedMoves.mbLooping = false;
                    ScriptedMoves.mIgnoreSight = mbIgnoreSight;
                    ScriptedMoves.mIgnoreHearing = mbIgnoreHearing;
                    ScriptedMoves.mIgnoreDamage = mbIgnoreDamage;
                    tpController.SetSequenceAction(none, false);
                    tpController.mStartStateName = 'ScriptedMoveState';
                    tpController.SetScriptedMoves(ScriptedMoves);                    
                }
                else
                {
                    // End:0x8BB
                    if(int(mActorSpawnState) == int(2))
                    {
                        tpController.mStartStateName = 'Investigate';                        
                    }
                    else
                    {
                        // End:0x8E6
                        if(int(mActorSpawnState) == int(1))
                        {
                            tpController.mStartStateName = 'WanderIdle';                            
                        }
                        else
                        {
                            // End:0xAF8
                            if((mActorGoal != none) || mRouteGoal != none)
                            {
                                tpController.StopLatentExecution();
                                tpController.GetScriptedMoves(ScriptedMoves);
                                // End:0x9ED
                                if(mActorGoal != none)
                                {
                                    ScriptedMoves.mGoalActor = mActorGoal;
                                    ScriptedMoves.mGoalRoute = none;
                                    // End:0x9AF
                                    if(Pawn(ActorGoal) != none)
                                    {
                                        ScriptedMoves.mGoalRadius = 30.0000000;
                                        ScriptedMoves.mScriptedSteerType = 2;
                                        ScriptedMoves.mLookAtActor = ScriptedMoves.mGoalActor;                                        
                                    }
                                    else
                                    {
                                        ScriptedMoves.mGoalRadius = 10.0000000;
                                        ScriptedMoves.mScriptedSteerType = mScriptedSteerType;
                                        ScriptedMoves.mLookAtActor = none;
                                    }                                    
                                }
                                else
                                {
                                    // End:0xA59
                                    if(mRouteGoal != none)
                                    {
                                        ScriptedMoves.mGoalActor = none;
                                        ScriptedMoves.mGoalRoute = mRouteGoal;
                                        ScriptedMoves.mGoalRadius = 10.0000000;
                                        ScriptedMoves.mScriptedSteerType = mScriptedSteerType;
                                        ScriptedMoves.mLookAtActor = none;
                                    }
                                }
                                ScriptedMoves.mbLooping = false;
                                ScriptedMoves.mIgnoreSight = mbIgnoreSight;
                                ScriptedMoves.mIgnoreHearing = mbIgnoreHearing;
                                ScriptedMoves.mIgnoreDamage = mbIgnoreDamage;
                                tpController.SetSequenceAction(none, false);
                                tpController.mStartStateName = 'ScriptedMoveState';
                                tpController.SetScriptedMoves(ScriptedMoves);                                
                            }
                            else
                            {
                                // End:0xB20
                                if(int(mActorSpawnState) == int(4))
                                {
                                    tpController.mStartStateName = 'UseLurkerSurfaceWithHiding';
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__TurokSpawnNode.TurokMeshComponent'
    begin object name=TurokMeshComponent class=Class'Engine.SkeletalMeshComponent'
        SkeletalMesh=SkeletalMesh'CinematicCameraMesh.CameraBox'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokSpawnNode.MyLightEnvironment'
        HiddenGame=true
        CastShadow=false
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    mSkelMesh=TurokMeshComponent
    // Reference: SpriteComponent'Default__TurokSpawnNode.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        Sprite=Texture2D'TurokEditorResources.TurokSpawnNode'
        HiddenGame=true
        RBCollideWithChannels=(Default=true,Vehicle=true,GameplayPhysics=true,EffectPhysics=true)
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    mSprite=Sprite
    // Reference: DrawConeComponent'Default__TurokSpawnNode.SpawnPlatform'
    begin object name=SpawnPlatform class=Class'Engine.DrawConeComponent'
        ConeRadius=5.0000000
        HiddenEditor=true
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
        Rotation=(Pitch=-16384,Yaw=0,Roll=0)
        AbsoluteScale=true
    end object
    mSpawnPlatform=SpawnPlatform
    // Reference: TurokDrawCylinderComponent'Default__TurokSpawnNode.MaxRadiusComponent'
    begin object name=MaxRadiusComponent class=Class'Engine.TurokDrawCylinderComponent'
        CylinderColor=(R=0,G=255,B=0,A=255)
        bRenderOnlyIfSelected=true
        Rotation=(Pitch=-16384,Yaw=0,Roll=0)
        AbsoluteScale=true
    end object
    mMaxRadiusComponent=MaxRadiusComponent
    // Reference: TurokDrawCylinderComponent'Default__TurokSpawnNode.MinRadiusComponent'
    begin object name=MinRadiusComponent class=Class'Engine.TurokDrawCylinderComponent'
        CylinderColor=(R=255,G=0,B=0,A=255)
        bRenderOnlyIfSelected=true
        Rotation=(Pitch=-16384,Yaw=0,Roll=0)
        AbsoluteScale=true
    end object
    mMinRadiusComponent=MinRadiusComponent
    mbEnabled=true
    mbSpawnOffScreen=true
    mbSpawnLineOfSightCheck=true
    mScriptedSteerType=1
    bStatic=true
    bNoDelete=true
    bCollideWhenPlacing=true
    // Reference: DynamicLightEnvironmentComponent'Default__TurokSpawnNode.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
        AlwaysLoadOnClient=false
        AlwaysLoadOnServer=false
    end object
    Components[0]=MyLightEnvironment
    Components[1]=Sprite
    Components[2]=SpawnPlatform
    Components[3]=MaxRadiusComponent
    Components[4]=MinRadiusComponent
    Components[5]=TurokMeshComponent
    mSnapOffset=(X=0.0000000,Y=0.0000000,Z=32.0000000)
}