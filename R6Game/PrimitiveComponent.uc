class PrimitiveComponent extends ActorComponent
    abstract
    native
    noexport;

enum ESceneDepthPriorityGroup
{
    SDPG_Background,                // 0
    SDPG_World,                     // 1
    SDPG_Foreground,                // 2
    SDPG_MAX                        // 3
};

enum ERadialImpulseFalloff
{
    RIF_Constant,                   // 0
    RIF_Linear,                     // 1
    RIF_MAX                         // 2
};

struct MeshElementLightInfo
{
    var export editinline LightComponent Light;
    var native Pointer ShadowVertexBuffer;
    var int ShadowChannelIndex;
    var native ShadowMap2D ShadowMap;

    structdefaultproperties
    {
        Light=none
        ShadowChannelIndex=0
    }
};

var native const Guid ComponentGuid;
var native const transient Matrix LocalToWorld;
var native const transient Matrix PreviousLocalToWorld;
var native const transient Matrix WorldToLocal;
var native const transient float LocalToWorldDeterminant;
var native const transient array<Pointer> AttachedLights;
var const export editinline PrimitiveComponent ShadowParent;
var native const export editinline PrimitiveComponent FirstShadowChild;
var native const export editinline PrimitiveComponent NextShadowChild;
var native const transient BoxSphereBounds NonHashlessBounds;
var native const transient BoxSphereBounds NoUpdateBounds;
var native const transient BoxSphereBounds Bounds;
var native const transient array<int> CachedShadowVolumes;
var native const export editinline array<export editinline DecalComponent> AttachedDecals;
var native const transient int Tag;
var native const transient int RendererTag;
var(lighting) float CullDistance;
var(lighting) float CullDistanceShadow;
var(lighting) float m_fShadowFadeDistanceRatio;
var const PrimitiveComponent.ESceneDepthPriorityGroup DepthPriorityGroup;
var(Rendering) float MotionBlurScale;
var(Rendering) byte m_bSortingPriority;
var(Rendering) const bool HiddenGame;
var(Rendering) const bool HiddenEditor;
var(Rendering) bool bAllowApproximateOcclusion;
var(Rendering) const bool bAcceptsDecals;
var(Rendering) const bool bAcceptsDecalsDuringGameplay;
var(lighting) bool CastShadow;
var(lighting) const bool bForceDirectLightMap;
var(lighting) bool bCastDynamicShadow;
var(lighting) bool bAcceptsLights;
var(lighting) const bool bAcceptsDynamicLights;
var(lighting) const bool bSpecialForceDynamicShadow;
var(Collision) const bool CollideActors;
var(Collision) const bool BlockActors;
var(Collision) const bool BlockZeroExtent;
var(Collision) const bool BlockNonZeroExtent;
var(Collision) const bool BlockRigidBody;
var(Collision) const bool RigidBodyIgnoreVehicles;
var(Collision) const bool bNotifyRigidBodyCollision;
var private const bool AlwaysLoadOnClient;
var private const bool AlwaysLoadOnServer;
var native const transient bool bUseNoUpdateBounds;
var native const transient bool bWasSNFiltered;
var native const transient array<int> OctreeNodes;
var native const transient QWord ZoneMask;
var const transient int m_iSingleZoneVisibility;
var(Physics) PhysicalMaterial PhysMaterialOverride;
var native const RB_BodyInstance BodyInstance;
var transient int m_iLastTimeCacheUpdate;
var transient Pointer m_pMTCache[2];
var bool m_bIsLightbeam;
var native transient bool m_bCacheMTDataRef;
var(Fire) export editinline R6FireParameters FireParameters;
var native const transient Matrix CachedParentToWorld;
var() const Vector Translation;
var() const Rotator Rotation;
var() const float Scale;
var() const Vector Scale3D;
var() const bool AbsoluteTranslation;
var() const bool AbsoluteRotation;
var() const bool AbsoluteScale;
var const transient float LastRenderTime;
var const transient int m_iLastRenderTick;
var const transient int m_bIsShownCached[2];
var const transient int m_dwIsShownCachedGlobalID[2];
var const transient int m_dwIsShownCachedID[2];
var(lighting) float fShadowDepthOffset;

// Export UPrimitiveComponent::execAddImpulse(FFrame&, void* const)
native final function AddImpulse(Vector Impulse, optional Vector Position, optional name BoneName, optional bool bVelChange);

// Export UPrimitiveComponent::execAddRadialImpulse(FFrame&, void* const)
native final function AddRadialImpulse(Vector Origin, float Radius, float Strength, PrimitiveComponent.ERadialImpulseFalloff FallOff, optional bool bVelChange);

// Export UPrimitiveComponent::execAddForce(FFrame&, void* const)
native final function AddForce(Vector Force, optional Vector Position, optional name BoneName);

// Export UPrimitiveComponent::execSetRBLinearVelocity(FFrame&, void* const)
native final function SetRBLinearVelocity(Vector NewVel, optional bool bAddToCurrent);

// Export UPrimitiveComponent::execSetRBAngularVelocity(FFrame&, void* const)
native final function SetRBAngularVelocity(Vector NewAngVel, optional bool bAddToCurrent);

// Export UPrimitiveComponent::execSetRBPosition(FFrame&, void* const)
native final function SetRBPosition(Vector NewPos, Rotator newRot);

// Export UPrimitiveComponent::execGetRBLinearVelocity(FFrame&, void* const)
native final function GetRBLinearVelocity(out Vector CurVel);

// Export UPrimitiveComponent::execGetRBPosition(FFrame&, void* const)
native final function GetRBPosition(out Vector CurPos, out Rotator CurRot, optional name BoneName);

// Export UPrimitiveComponent::execWakeRigidBody(FFrame&, void* const)
native final function WakeRigidBody(optional name BoneName);

// Export UPrimitiveComponent::execRigidBodyIsAwake(FFrame&, void* const)
native final function bool RigidBodyIsAwake(optional name BoneName);

// Export UPrimitiveComponent::execSetBlockRigidBody(FFrame&, void* const)
native final function SetBlockRigidBody(bool bNewBlockRigidBody);

// Export UPrimitiveComponent::execSetRigidBodyIgnoreVehicles(FFrame&, void* const)
native final function SetRigidBodyIgnoreVehicles(bool bNewRigidBodyIgnoreVehicles);

// Export UPrimitiveComponent::execSetHidden(FFrame&, void* const)
native final function SetHidden(bool NewHidden);

// Export UPrimitiveComponent::execSetShadowParent(FFrame&, void* const)
native final function SetShadowParent(PrimitiveComponent NewShadowParent);

// Export UPrimitiveComponent::execSetDepthPriorityGroup(FFrame&, void* const)
native final function SetDepthPriorityGroup(PrimitiveComponent.ESceneDepthPriorityGroup NewDepthPriorityGroup);

// Export UPrimitiveComponent::execSetTraceBlocking(FFrame&, void* const)
native final function SetTraceBlocking(bool NewBlockZeroExtent, bool NewBlockNonZeroExtent);

// Export UPrimitiveComponent::execSetActorCollision(FFrame&, void* const)
native final function SetActorCollision(bool NewCollideActors, bool NewBlockActors);

// Export UPrimitiveComponent::execSetTranslation(FFrame&, void* const)
native function SetTranslation(Vector NewTranslation);

// Export UPrimitiveComponent::execSetRotation(FFrame&, void* const)
native function SetRotation(Rotator NewRotation);

// Export UPrimitiveComponent::execSetScale(FFrame&, void* const)
native function SetScale(float NewScale);

// Export UPrimitiveComponent::execSetScale3D(FFrame&, void* const)
native function SetScale3D(Vector NewScale3D);

// Export UPrimitiveComponent::execSetAbsolute(FFrame&, void* const)
native function SetAbsolute(optional bool NewAbsoluteTranslation, optional bool NewAbsoluteRotation, optional bool NewAbsoluteScale);

final function Vector GetPosition()
{
    local Vector Position;

    Position.X = LocalToWorld.WPlane.X;
    Position.Y = LocalToWorld.WPlane.Y;
    Position.Z = LocalToWorld.WPlane.Z;
    return Position;
    return;
}
