class AnimNode extends Object
    abstract
    native
    hidecategories(Object);

enum ESliderType
{
    ST_1D,                          // 0
    ST_2D,                          // 1
    ST_MAX                          // 2
};

struct BoneAtom
{
    var Quat Rotation;
    var Vector Translation;
    var float Scale;

    structdefaultproperties
    {
        Rotation=(X=0.0000000,Y=0.0000000,Z=0.0000000,W=0.0000000)
        Translation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Scale=0.0000000
    }
};

struct BaseAnim
{
    structcpptext
    {

    // Do any initialisation, and then call InitAnim on all children. Should not discard any existing anim state though. //
	virtual void InitAnim() = 0;

    // Called before updating the animnode.  Used to initialize node. //
    virtual	void PreTickAnim( FLOAT fDeltaSeconds ) = 0;

    // Update this node, then call TickAnim on all children. //
    virtual	void TickAnim( FLOAT fDeltaSeconds ) = 0;

    // Called when a node will be tick this frame but wasn't on the previous one. //
    virtual	void BecomeRelevant( FLOAT fDeltaSeconds ) = 0;

    // Add this node and all children to array. Node are added so a parent is always before its children in the array. //
	virtual UBOOL GetNodes( TArray<UAnimNode*>& Nodes ) = 0;

    // Add this node and all children to array //
    virtual UBOOL GetNodesAndLeafs( TArray<FBaseAnim*>& Anims ) = 0;

    // Return an array with all FAnimLeaf childs, including this node //
    virtual UBOOL GetAnimLeafs( TArray<struct FAnimLeaf*>& Leafs, TArray<UAnimNode*>& TempNodes, EAnimSyncType eAnimSyncType=ANIMSYNCTYPE_None ) = 0;

    // Return this when it is an UAnimNode or a derived class //
    virtual class UAnimNode* GetUAnimNode() = 0;

    // Return this when it is an FAnimLeaf or a derived class //
    virtual struct FAnimLeaf* GetFAnimLeaf() = 0;

    // Get the local transform for each bone. If a blend, will recursively ask children and blend etc. //
    // DesiredBones should be in strictly increasing order. //
	virtual void GetBoneAtoms( TArray<FBoneAtom>& Atoms, const TArray<BYTE>& DesiredBones, struct FBlendParams& BlendParams ) = 0;

    // Set the NodeTotalWeight of the node //
    virtual void SetNodeTotalWeight( FLOAT fWeight ) = 0;

    // Return the actual NodeTotalWeight of the node //
    virtual FLOAT GetNodeTotalWeight() const = 0;

    // Set the m_iNodeTickStatus of the node //
    virtual void SetNodeTicksStatus( INT iTicks )  = 0;

    // Return the actual m_iNodeTickStatus of the node //
    virtual INT GetNodeTickStatus() const = 0;

    // Return the actual return m_iPlayRootMotionTicks of the node //
    virtual INT GetPlayRootMotionTicks() const = 0;

    // Play animation //
	virtual void PlayAnim( UBOOL bLoop=FALSE, FLOAT Rate=1.0f, FLOAT StartTime=0.0f, UBOOL bAbsoluteTime = FALSE ) = 0;

    // Play animation with default bLooping and Rate //
    virtual void StartAnim( FLOAT fStartTime = 0.0f, UBOOL bAbsoluteTime = FALSE )= 0;

    // Stop animation //
    virtual void StopAnim() = 0;

    // Set animation time //
	virtual void SetPosition( FLOAT NewTime, UBOOL bFireNotifies, UBOOL bSendInTick = FALSE ) = 0;

    // Set animation time using the current m_bReverse status //
    virtual void SetAbsolutePosition( FLOAT fNewTime ) = 0;

    // Set animation rate //
    virtual void SetRate( FLOAT fRate, UBOOL bLowerBodyOnly ) = 0;

    // Return TRUE when animation is playing //
    virtual UBOOL IsPlaying() = 0;

    // Return the animation remaining time //
    virtual FLOAT GetRemainingTime() = 0;
//###+ dpunsetmartinez
    virtual FLOAT GetCurrentTime() const = 0;
//###-
    virtual void SetAnim( FName AnimSequenceName, UBOOL bIsScripted=FALSE ) = 0;
    virtual FLOAT GetRate() const = 0;
    virtual UBOOL IsLooping() const = 0;
    virtual void SetLoop( UBOOL bVal ) = 0;

    // Return the animation duration //
    virtual FLOAT GetAnimLength() = 0;

    // Reverse the animation from it initial m_bReverse value //
    virtual void ReverseAnim( UBOOL bReverse ) = 0;
    virtual void SetReverseFlag( UBOOL bReverse ) = 0;

    // Use supplied reference skeleton pose information to fill the in the array of FBoneAtoms with a 'default' pose. //
	static void FillWithRefPose( TArray<FBoneAtom>& Atoms, const TArray<BYTE>& DesiredBones, TArray<struct FMeshBone>& RefSkel );

    // TO BE REMOVED : Animation reset //
    virtual void ResetChild(UBOOL bPlay, DWORD dwResetFlag = ANIM_RESET_CHILD_DEFAULT ) = 0;
   
#ifndef  RETAIL 
    // Debug //
    virtual void DrawDebug( FRenderInterface* pRI, FLOAT fParentPosX, FLOAT fParentPosY, FLOAT fPosX, FLOAT fPosY, INT iScreenSizeY, UBOOL bShowRelevantOnly ) = 0;

    // Clean the AnimNode::m_bShowDebugTick flag for next render debug request //
    virtual UBOOL CleanDrawDebugFlag() = 0;

    // Recalculate heights used when displaying debug tree view //
	virtual FLOAT CalcDebugHeight( UBOOL bShowRelevantOnly ) = 0;

    // Return the heights used when displaying debug tree view //
    virtual FLOAT GetDebugHeight() = 0;

    // Set the m_bShowDebugTick of the node //
    virtual void SetShowDebugTick( UBOOL bTick ) = 0;
    
    // Return the actual m_bShowDebugTick of the node //
    virtual UBOOL GetShowDebugTick() const = 0;
#endif //#  RETAIL 

    }
};

struct AnimNotifyInfo
{
    var AnimNotify m_AnimNotify;
    var float m_fTimeToGo;

    structdefaultproperties
    {
        m_AnimNotify=none
        m_fTimeToGo=0.0000000
    }
};

struct AnimLeaf extends BaseAnim
{
    structcpptext
    {

	// AnimNode interface //

    FAnimLeaf();

    // Needed to assign correctly the virtual table //
    explicit FAnimLeaf( INT i ) {}
    void* FAnimLeaf::operator new( size_t s, void* p );
	
    // Do any initialisation, and then call InitAnim on all children. Should not discard any existing anim state though. //
	virtual void InitAnim();

    // Called before updating the animnode.  Used to initialize node. //
    virtual	void PreTickAnim( FLOAT fDeltaSeconds ) {}

    // Update this node, then call TickAnim on all children. //
    virtual	void TickAnim( FLOAT fDeltaSeconds );

    // Called when a node will be tick this frame but wasn't on the previous one. //
    virtual	void BecomeRelevant( FLOAT fDeltaSeconds ) {}

    // Get the local transform for each bone. If a blend, will recursively ask children and blend etc. //
    // DesiredBones should be in strictly increasing order. //
	virtual void GetBoneAtoms( TArray<FBoneAtom>& Atoms, const TArray<BYTE>& DesiredBones, struct FBlendParams& BlendParams );

    // Set the NodeTotalWeight of the node //
    virtual void SetNodeTotalWeight( FLOAT fWeight ) { m_fNodeTotalWeight = fWeight; }

    // Return the actual NodeTotalWeight of the node //
    virtual FLOAT GetNodeTotalWeight() const;

    // Set the m_iNodeTickStatus of the node //
    virtual void SetNodeTicksStatus( INT iTicks ) { m_iNodeTickStatus = iTicks; }

    // Return the actual m_iNodeTickStatus of the node //
    virtual INT GetNodeTickStatus() const { return m_iNodeTickStatus; }

    // Return the actual return m_iPlayRootMotionTicks of the node //
    virtual INT GetPlayRootMotionTicks() const { return m_iPlayRootMotionTicks; }

    // Add this node and all children to array. Node are added so a parent is always before its children in the array. //
    virtual UBOOL GetNodes( TArray<UAnimNode*>& Nodes ) { return TRUE; };

    // Add this node and all children to array //
    virtual UBOOL GetNodesAndLeafs( TArray<FBaseAnim*>& Anims );

    // Return an array with all FAnimLeaf childs, including this node //
    virtual UBOOL GetAnimLeafs( TArray<struct FAnimLeaf*>& Leafs, TArray<UAnimNode*>& TempNodes, EAnimSyncType eAnimSyncType=ANIMSYNCTYPE_None );

    // Return this when it is an UAnimNode or a derived class //
    virtual class UAnimNode* GetUAnimNode() { return NULL; }

    // Return this when it is an FAnimLeaf or a derived class //
    virtual struct FAnimLeaf* GetFAnimLeaf() { return this; }

    // Play animation //
	virtual void PlayAnim( UBOOL bLoop=FALSE, FLOAT fRate=1.0f, FLOAT fStartTime=0.0f, UBOOL bAbsoluteTime=FALSE );

    // Play animation with default bLooping and Rate //
    virtual void StartAnim( FLOAT fStartTime = 0.0f, UBOOL bAbsoluteTime = FALSE );

    // Stop animation //
    virtual void StopAnim();

    // Set animation time //
	virtual void SetPosition( FLOAT NewTime, UBOOL bFireNotifies, UBOOL bSendInTick = FALSE );

    // Set animation time using the current m_bReverse status //
    virtual void SetAbsolutePosition( FLOAT fNewTime );

    // Set animation rate //
    virtual void SetRate( FLOAT fRate, UBOOL bLowerBodyOnly );

    // Return TRUE when animation is playing //
    virtual UBOOL IsPlaying() { return m_bPlaying; }

    // Return the animation remaining time //
    virtual FLOAT GetRemainingTime();

//###+ dpunsetmartinez
    virtual FLOAT GetCurrentTime() const;
//###-

    // Return the animation duration //
    virtual FLOAT GetAnimLength();

    // Reverse the animation from it initial m_bReverse value //
    virtual void ReverseAnim( UBOOL bReverse );
    virtual void SetReverseFlag( UBOOL bReverse );

    // TO BE REMOVED //
    virtual void ResetChild( UBOOL bPlay, DWORD dwResetFlag = ANIM_RESET_CHILD_DEFAULT );

    // AnimLeaf Interface //

    // Set a new animation by name //
    //###+ lpseguin: Added optional parameter to search animset in the level info for scripted anims
    virtual void SetAnim( FName AnimSequenceName, UBOOL bIsScripted=FALSE );
    //###-

    virtual FLOAT GetRate() const { return m_fRate; };
    virtual UBOOL IsLooping() const { return m_bLooping; };
    virtual void SetLoop( UBOOL bVal ) { m_bLooping = bVal; };

	// Advance animation time. Take care of issuing notifies, looping and so on //
	void AdvanceBy( FLOAT fMoveDelta, UBOOL bSendNotifies=TRUE );

	// Issue any notifies tha are passed when moving from the current position to DeltaSeconds in the future. Called from TickAnim. //
	void IssueNotifies( FLOAT fDeltaSeconds, UBOOL bSendInTick = FALSE );
    void UpdateNotifies( FLOAT fDeltaSeconds, UBOOL bSendInTick = FALSE );
    void UpdateNotifiesReverse( FLOAT fDeltaSeconds, UBOOL bSendInTick = FALSE );

    // Get current time ratio of this sequence ( CurrentTime / SequenceLenght ) //
    FLOAT GetCurrentTimeRatio();

#ifndef RETAIL
    // Debug //
    virtual void DrawDebug( FRenderInterface* pRI, FLOAT fParentPosX, FLOAT fParentPosY, FLOAT fPosX, FLOAT fPosY, INT iScreenSizeY, UBOOL bShowRelevantOnly );

    // Clean the AnimNode::m_bShowDebugTick flag for next render debug request //
    virtual UBOOL CleanDrawDebugFlag();

    // Recalculate heights used when displaying debug tree view //
	virtual FLOAT CalcDebugHeight( UBOOL bShowRelevantOnly );

    // Return the heights used when displaying debug tree view //
    virtual FLOAT GetDebugHeight();

    // Set the m_bShowDebugTick of the node //
    virtual void SetShowDebugTick( UBOOL bTick ) { m_bShowDebugTick = bTick; }

    // Return the actual m_bShowDebugTick of the node //
    virtual UBOOL GetShowDebugTick() const { return m_bShowDebugTick; }
#endif //RETAIL

    virtual void  Initialize();

private:

    // Computes the root translation and rotation for this animation at a given time //
    void GetAnimRoot( FVector& vRootLoc, FRotator& rRootRot, INT iTrackIndex, INT iTrackIndexCrouch, FLOAT fTime );

    // Return FALSE when returning ref pose //
    FORCEINLINE UBOOL GetBoneAtomWithPosture( struct FBoneAtom& Atom, INT iTrackIndex, INT iTrackIndexCrouch, INT iBoneIndex, FLOAT fTime, FLOAT fStand, FLOAT fCrouch );

    FORCEINLINE UBOOL GetAtom( struct FBoneAtom& Atom, INT iTrackIndex, INT iBoneIndex, FLOAT fTime, UBOOL bCrouch );

    }

    var noexport transient Pointer m_pVTable;
    var() /*0x10000000-0x00000000*/ name m_AnimSeqName;
    var const transient AnimSequence m_AnimSeq;
    var const transient AnimSequence m_AnimSeqCrouch;
    var const transient byte m_u8AnimLinkupIndex;
    var const transient byte m_u8AnimLinkupIndexCrouch;
    var const transient float m_fNodeTotalWeight;
    var transient int m_iNodeTickStatus;
    var() float m_fCurrentTime;
    var() float m_fRate;
    var() bool m_bPlaying;
    var() bool m_bLooping;
    var() bool m_bReverse;
    var() bool m_bNoInterpolate;
    var bool m_bIsIssuingNotifies;
    var() bool m_bHalfCycleDelay;
    var bool m_bSlaveLeaf;
    var() bool m_bCOMReference;
    var() bool m_bUseCrouchAnimWhenCrouched;
    var() bool m_bIsAdditiveAnimation;
    var() bool m_bRotateYawFromRoot;
    var() bool m_bDiscardRootYaw;
    var() bool m_bConstrainRootMotion;
    var() bool m_bAllowRootBlendWithAllAnim;
    var() bool m_bNoCollisionFail;
    var() bool m_bStartRootAtZeroAlways;
    var() R6EngineEnums.ERootMotion m_eRootMotion[3];
    var transient Vector m_vOldRootLoc;
    var transient Vector m_vFirstFrameRootLoc;
    var transient Rotator m_rFirstFrameRootRot;
    var transient Matrix m_mOriginalLocalToWorld;
    var transient int m_iOldRootYaw;
    var transient int m_iLastOldRootTranslateTick;
    var transient int m_iLastOldRootRotateTick;
    var transient int m_iPlayRootMotionTicks;
    var transient bool m_bNeedsRootMotionReset;
    var transient bool m_bInitialReverse;
    var transient bool m_bFirstInit;
    var transient bool m_bShowDebugTick;
    var transient float m_fDebugHeight;
    var() R6EngineEnums.EAnimSyncType m_eAnimSyncType;
    var() float m_fNotifyWeightThreshold;
    var transient array<AnimNotifyInfo> m_NotifiesToIssue;

    structdefaultproperties
    {
        m_pVTable=none
        m_AnimSeqName="None"
        m_AnimSeq=none
        m_AnimSeqCrouch=none
        m_u8AnimLinkupIndex=0
        m_u8AnimLinkupIndexCrouch=0
        m_fNodeTotalWeight=0.0000000
        m_iNodeTickStatus=0
        m_fCurrentTime=0.0000000
        m_fRate=1.0000000
        m_bPlaying=false
        m_bLooping=false
        m_bReverse=false
        m_bNoInterpolate=false
        m_bIsIssuingNotifies=false
        m_bHalfCycleDelay=false
        m_bSlaveLeaf=false
        m_bCOMReference=false
        m_bUseCrouchAnimWhenCrouched=false
        m_bIsAdditiveAnimation=false
        m_bRotateYawFromRoot=false
        m_bDiscardRootYaw=false
        m_bConstrainRootMotion=false
        m_bAllowRootBlendWithAllAnim=false
        m_bNoCollisionFail=false
        m_bStartRootAtZeroAlways=false
        m_eRootMotion[0]=0
        m_eRootMotion[1]=0
        m_eRootMotion[2]=0
        m_vOldRootLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vFirstFrameRootLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_rFirstFrameRootRot=(Pitch=0,Yaw=0,Roll=0)
        m_mOriginalLocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        m_iOldRootYaw=0
        m_iLastOldRootTranslateTick=0
        m_iLastOldRootRotateTick=0
        m_iPlayRootMotionTicks=0
        m_bNeedsRootMotionReset=false
        m_bInitialReverse=false
        m_bFirstInit=false
        m_bShowDebugTick=false
        m_fDebugHeight=0.0000000
        m_eAnimSyncType=0
        m_fNotifyWeightThreshold=0.0001000
        m_NotifiesToIssue=none
    }
};

var private native const noexport Pointer VfTable_FBaseAnim;
var transient array<AnimNodeBlendBase> ParentNodes;
var() name NodeName;
var transient int m_iNodeTickStatus;
var transient int m_iNodeInitAnimStatus;
var const transient float NodeTotalWeight;
var float DebugHeight;
var int DrawWidth;
var int DrawHeight;
var int NodePosX;
var int NodePosY;
var int OutDrawY;
var transient bool m_bChildOfPreviewNode;
var transient bool m_bShowDebugTick;
var transient bool m_bIsAnimNodeSequence;
var transient int m_iPlayRootMotionTicks;

// Export UAnimNode::execFindAnimNode(FFrame&, void* const)
native final function AnimNode FindAnimNode(name InNodeName);

// Export UAnimNode::execFindAnimNodes(FFrame&, void* const)
native final function FindAnimNodes(class<AnimNode> NodeType, out array<AnimNode> out_Nodes);

// Export UAnimNode::execResetAll(FFrame&, void* const)
native final function ResetAll(SkeletalMeshComponent pMesh);

defaultproperties
{
    m_iNodeInitAnimStatus=-1
}