class TurokCoverNodeNative extends TurokPathNode
    abstract
    native
    hidecategories(Navigation,Lighting,LightColor,Force);

enum TurokObjectType
{
    ETOT_Point,                     // 0
    ETOT_ObjectRadius,              // 1
    ETOT_MAX                        // 2
};

var @NULL mCoverUser;
var(Cover) bool mCoverAvail;
var(Cover) bool mAttackAvail;
var bool mAttackStepLeft;
var bool mAttackStepBack;
var bool mAttackStepRight;
var(Cover) bool mClamberable;
var(CoverObject) bool mObjectRadiusDefault;
var(CoverObject) bool mCalcObjectCenter;
var(AllowedPawns) bool mLilCanUse;
var(AllowedPawns) bool mMGCanUse;
var(AllowedPawns) bool mWCCanUse;
var(AllowedPawns) bool mScientistCanUse;
var bool bCanStepLeft;
var bool bCanStepBack;
var bool bCanStepRight;
var(Cover) float mCoverAngle;
var(Cover) float mAttackAngle;
var(Cover) byte mCoverPosture;
var(CoverObject) byte mObjectType;
var(CoverObject) float mObjectRadius;
var(CoverObject) @NULL mObjectCover;
var(CoverObject) float mManualAdjust;
var @NULL mObjectCenter;
var(DestroyCover) @NULL mDestroyableActor;
var(DestroyCover) float mDestroyedUsePercent;
var float mInvalidTime;
var editoronly export editinline @NULL mInnerRadius;
var editoronly export editinline @NULL mOuterRadius;
var editoronly @NULL mCoverCrouchMesh;
var editoronly @NULL mCoverStandMesh;
var editoronly @NULL mStepRightStaticMesh;
var editoronly @NULL mStepLeftStaticMesh;
var editoronly @NULL mStepBackStaticMesh;
var editoronly @NULL mClamberStaticMesh;
var editoronly export editinline @NULL mStepRightMeshComponent;
var editoronly export editinline @NULL mStepLeftMeshComponent;
var editoronly export editinline @NULL mStepBackMeshComponent;
var editoronly export editinline @NULL mClamberMeshComponent;
var private transient bool mIsAttachEditorMeshes;

// Export UTurokCoverNodeNative::execIsAvailableTo(FFrame&, void* const)
native function bool IsAvailableTo(@NULL chkActor);

// Export UTurokCoverNodeNative::execIsValid(FFrame&, void* const)
native function bool IsValid(@NULL testPawn);

function bool GetClamberable()
{
    // End:0x0D
    if(!mClamberable)
    {
        return false;
    }
    // End:0x1F
    if(int(mCoverPosture) != int(0))
    {
        return false;
    }
    // End:0x4B
    if((mDestroyableActor != none) && mDestroyableActor.GetPercentDestroyed() > mDestroyedUsePercent)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export UTurokCoverNodeNative::execGetCoverMoveTo(FFrame&, void* const)
native function GetCoverMoveTo(@NULL coverUser, out @NULL coverMoveTarget, out @NULL TargetPosition, optional out @NULL targetRotation);

function GetCoverActionInfo(@NULL coverUser, out @NULL actionLocation, out @NULL actionRotation)
{
    local @NULL HitActor, HitNormal, moveToNode, moveToLocation;

    // End:0x0D
    if(coverUser == none)
    {
        return;
    }
    GetCoverMoveTo(coverUser, moveToNode, moveToLocation, actionRotation);
    // End:0x4A
    if(moveToNode != none)
    {
        moveToLocation = moveToNode.Location;
    }
    HitActor = Trace(actionLocation, HitNormal, moveToLocation + (vect(0.0000000, 0.0000000, -1.0000000) * float(100)), moveToLocation, false);
    // End:0xA6
    if(HitActor == none)
    {
        actionLocation = moveToLocation - vect(0.0000000, 0.0000000, 25.0000000);
    }
    //return;    
}

function bool IsExposedToAttack(@NULL coverUser, @NULL usingNode, @NULL coverUsePosition)
{
    local @NULL enemyPos, usePosToEnemy, coverLocation, usePosToCover, moveToNode;

    local float distToCover;

    // End:0x0D
    if(coverUser == none)
    {
        return false;
    }
    // End:0x1A
    if(!mCoverAvail)
    {
        return true;
    }
    enemyPos = TurokPawn(coverUser.Pawn).mTargetingSystem.GetTargetLocation(coverUser);
    // End:0x138
    if(int(mObjectType) == int(1))
    {
        coverLocation = mObjectCenter;
        // End:0x9A
        if(usingNode != self)
        {
            moveToNode = usingNode;
            GetCoverMoveTo(coverUser, moveToNode, coverUsePosition);
        }
        usePosToEnemy = enemyPos - coverUsePosition;
        usePosToEnemy.Z = 0.0000000;
        usePosToEnemy = Normal(usePosToEnemy);
        usePosToCover = coverLocation - coverUsePosition;
        usePosToCover.Z = 0.0000000;
        distToCover = VSize(usePosToCover);
        usePosToCover = Normal(usePosToCover);
        // End:0x133
        if((usePosToCover Dot usePosToEnemy) < Cos(Atan(mObjectRadius, distToCover)))
        {
            return true;            
        }
        else
        {
            return false;
        }        
    }
    else
    {
        // End:0x1AB
        if(int(mObjectType) == int(0))
        {
            usePosToEnemy = enemyPos - Location;
            usePosToEnemy.Z = 0.0000000;
            usePosToEnemy = Normal(usePosToEnemy);
            // End:0x1A9
            if((Vector(Rotation) Dot usePosToEnemy) < Cos((mCoverAngle / 2.0000000) / 57.2957800))
            {
                return true;                
            }
            else
            {
                return false;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

// Export UTurokCoverNodeNative::execGetTargetAttackInfo(FFrame&, void* const)
native function GetTargetAttackInfo(@NULL coverUser, @NULL usingNode, @NULL coverUsePosition, bool checkLOS, optional out int hasLOS, optional out int hasAngle, optional bool debugDraws);

defaultproperties
{
    mCoverAvail=true
    mAttackAvail=true
    mLilCanUse=true
    mMGCanUse=true
    mWCCanUse=true
    mScientistCanUse=true
    mCoverAngle=120.0000000
    mAttackAngle=90.0000000
    mDestroyedUsePercent=50.0000000
    // Reference: TurokDrawCylinderComponent'Default__TurokCoverNodeNative.InnerRadiusComponent'
    begin object name=InnerRadiusComponent class=Class'Engine.TurokDrawCylinderComponent'
        CylinderColor=(R=255,G=0,B=0,A=255)
        CylinderHeight=96.0000000
        CylinderRadius=44.0000000
        bRenderOnlyIfSelected=true
        Rotation=(Pitch=-16384,Yaw=0,Roll=0)
        AbsoluteScale=true
    end object
    mInnerRadius=InnerRadiusComponent
    // Reference: TurokDrawCylinderComponent'Default__TurokCoverNodeNative.OuterRadiusComponent'
    begin object name=OuterRadiusComponent class=Class'Engine.TurokDrawCylinderComponent'
        CylinderColor=(R=0,G=255,B=0,A=255)
        CylinderHeight=96.0000000
        CylinderRadius=22.0000000
        bRenderOnlyIfSelected=true
        Rotation=(Pitch=-16384,Yaw=0,Roll=0)
        AbsoluteScale=true
    end object
    mOuterRadius=OuterRadiusComponent
    bAutoConnectClosest=true
    // Reference: SpriteComponent'Default__TurokCoverNodeNative.Sprite4'
    begin object name=Sprite4
    end object
    NoSkipSprite=Sprite4
    // Reference: SpriteComponent'Default__TurokCoverNodeNative.Sprite3'
    begin object name=Sprite3
    end object
    BrokenSprite=Sprite3
    bNoAutoConnect=true
    // Reference: CylinderComponent'Default__TurokCoverNodeNative.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=48.0000000
        CollisionRadius=22.0000000
    end object
    CylinderComponent=CollisionCylinder
    // Reference: SpriteComponent'Default__TurokCoverNodeNative.Sprite'
    begin object name=Sprite
    end object
    GoodSprite=Sprite
    // Reference: SpriteComponent'Default__TurokCoverNodeNative.Sprite2'
    begin object name=Sprite2
    end object
    BadSprite=Sprite2
    Components[0]=Sprite
    Components[1]=Sprite2
    // Reference: ArrowComponent'Default__TurokCoverNodeNative.Arrow'
    begin object name=Arrow
    end object
    Components[2]=Arrow
    Components[3]=CollisionCylinder
    Components[4]=Sprite3
    Components[5]=Sprite4
    // Reference: TurokCoverRenderComponent'Default__TurokCoverNodeNative.TurokCoverRenderer'
    begin object name=TurokCoverRenderer class=Class'TurokCoverRenderComponent'
        HiddenGame=false
    end object
    Components[6]=TurokCoverRenderer
    Components[7]=OuterRadiusComponent
    Components[8]=InnerRadiusComponent
    CollisionComponent=CollisionCylinder
}