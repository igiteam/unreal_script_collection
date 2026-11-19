class NavigationPoint extends Actor
    native
    notplaceable
    hidecategories(lighting,lighting,LightColor,Force);

const INFINITE_PATH_COST = 10000000;

struct NavigationOctreeObject
{
    structcpptext
    {

	 enum ENavOctreeObjectType
	 {
	 	NAV_NavigationPoint = 0x01,
	 	NAV_ReachSpec = 0x02,
	 };
	 private:
	 	UObject* Owner;
	 	BYTE OwnerType;
	 public:
	 	/** constructor, makes sure OctreeNode is NULL */
	 	FNavigationOctreeObject()
	 	{
	 		OctreeNode = NULL;
	 	}
	 	/** destructor, removes us from the octree if we're still there */
	 	~FNavigationOctreeObject();
		/** sets the object's owner and initializes the OwnerType for fast cast to common types */
		void SetOwner(UObject* InOwner)
		{
			Owner = InOwner;
			if (Cast<ANavigationPoint>(Owner))
			{
				OwnerType |= NAV_NavigationPoint;
			}
			else if (Cast<UReachSpec>(Owner))
			{
				OwnerType |= NAV_ReachSpec;
			}
		}

		/** sets the object's bounding box
		 * if the object is currently in the octree, re-adds it
		 * @param InBoundingBox the new bounding box to use
		 */
		void SetBox(const FBox& InBoundingBox);

		/** overlap check function called after the axis aligned bounding box check succeeds
		 * allows for more precise checks for certain object types
		 * @param TestBox the box to check
		 * @return true if the box doesn't overlap this object, false if it does
		 */
		UBOOL OverlapCheck(const FBox& TestBox);

		/** templated accessor to Owner, to avoid casting for common cases
		 * @note T must be UObject or a subclass, or this function will not compile
		 */
		template<class T> FORCEINLINE T* GetOwner()
		{
			return Cast<T>(Owner);
		}
		//@note the specializations for this template are in UnPath.h because they must be outside the struct definition

		void Serialize(FArchive& Ar);
	
    }

    var Box BoundingBox;
    var Vector BoxCenter;
    var native const transient Pointer OctreeNode;
    var const noexport Object Owner;
    var const noexport byte OwnerType;

    structdefaultproperties
    {
        BoundingBox=(Min=(X=0.0000000,Y=0.0000000,Z=0.0000000),Max=(X=0.0000000,Y=0.0000000,Z=0.0000000),IsValid=None)
        BoxCenter=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Owner=none
        OwnerType=0
    }
};

var transient bool bEndPoint;
var transient bool bTransientEndPoint;
var transient bool bHideEditorPaths;
var transient bool bCanReach;
var native const transient NavigationOctreeObject NavOctreeObject;
var bool taken;
var() bool bBlocked;
var() bool bPropagatesSound;
var() bool bOneWayPath;
var bool bNeverUseStrafing;
var bool bAlwaysUseStrafing;
var const bool bForceNoStrafing;
var const bool bAutoBuilt;
var bool bSpecialMove;
var bool bNoAutoConnect;
var const bool bNotBased;
var const bool bPathsChanged;
var bool bDestinationOnly;
var bool bSourceOnly;
var bool bSpecialForced;
var bool bMustBeReachable;
var bool bBlockable;
var bool bFlyingPreferred;
var bool bMayCausePain;
var bool bAlreadyVisited;
var() bool bVehicleDestination;
var() bool bMakeSourceOnly;
var bool bMustTouchToReach;
var() const editinline array<editinline ReachSpec> PathList;
var array<NavigationPoint> ProscribedPaths;
var array<NavigationPoint> ForcedPaths;
var int visitedWeight;
var const int bestPathWeight;
var private const transient NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;
var const NavigationPoint prevOrdered;
var const NavigationPoint previousPath;
var int cost;
var() int ExtraCost;
var transient int TransientCost;
var transient int FearCost;
var transient int PathCost;
var transient array<int> InfluenceCost;
var DroppedPickup InventoryCache;
var float InventoryDist;
var const float LastDetourWeight;
var export editinline CylinderComponent CylinderComponent;
var Objective NearestObjective;
var float ObjectiveDistance;
var const Cylinder MaxPathSize;
var const Cylinder NavOctreeSize;
var const Guid NavGuid;

event int SpecialCost(Pawn Seeker, ReachSpec Path)
{
    return;
}

event bool Accept(Actor Incoming, Actor Source)
{
    taken = Incoming.SetLocation(Location);
    // End:0x50
    if(taken)
    {
        Incoming.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Incoming.SetRotation(Rotation);
    }
    Incoming.PlayTeleportEffect(true, false);
    return taken;
    return;
}

event bool SuggestMovePreparation(Pawn other)
{
    return false;
    return;
}

function bool ProceedWithMove(Pawn other)
{
    return true;
    return;
}

function bool IsAvailableTo(Actor chkActor)
{
    return true;
    return;
}

static final function NavigationPoint GetNearestNav(Actor chkActor, optional class<NavigationPoint> filterClass, optional array<NavigationPoint> excludeList)
{
    local NavigationPoint nav, bestNav;
    local float Dist, bestDist;
    local int idx;
    local bool bExcluded;

    // End:0x129
    if(chkActor != none)
    {
        // End:0x128
        foreach chkActor.WorldInfo.AllNavigationPoints(Class'NavigationPoint', nav)
        {
            // End:0x127
            if(((filterClass == none) || nav.Class == filterClass) && nav.IsAvailableTo(chkActor))
            {
                bExcluded = false;
                idx = 0;
                J0x80:

                // End:0xC4 [Loop If]
                if((idx < excludeList.Length) && !bExcluded)
                {
                    // End:0xBA
                    if(excludeList[idx] == nav)
                    {
                        bExcluded = true;
                    }
                    idx++;
                    // [Loop Continue]
                    goto J0x80;
                }
                // End:0x127
                if(!bExcluded)
                {
                    Dist = VSize(nav.Location - chkActor.Location);
                    // End:0x127
                    if((bestNav == none) || Dist < bestDist)
                    {
                        bestNav = nav;
                        bestDist = Dist;
                    }
                }
            }            
        }        
    }
    return bestNav;
    return;
}

function OnToggle(SeqAct_Toggle inAction)
{
    // End:0x24
    if(inAction.InputLinks[0].bHasImpulse)
    {
        bBlocked = false;        
    }
    else
    {
        // End:0x48
        if(inAction.InputLinks[1].bHasImpulse)
        {
            bBlocked = true;            
        }
        else
        {
            // End:0x71
            if(inAction.InputLinks[2].bHasImpulse)
            {
                bBlocked = !bBlocked;
            }
        }
    }
    return;
}

defaultproperties
{
    bPropagatesSound=true
    bMayCausePain=true
    bMustTouchToReach=true
    // Reference: CylinderComponent'Default__NavigationPoint.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'CylinderComponent'
        CollisionHeight=50.0000000
        CollisionRadius=50.0000000
    end object
    CylinderComponent=CollisionCylinder
    bStatic=true
    bHidden=true
    bNoDelete=true
    bCollideWhenPlacing=true
    // Reference: SpriteComponent'Default__NavigationPoint.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_NavP'
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: PathRenderingComponent'Default__NavigationPoint.PathRenderer'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="PathRenderer" class=Class'PathRenderingComponent'
    end object
    Components[2]=PathRenderer
    CollisionComponent=CollisionCylinder
}