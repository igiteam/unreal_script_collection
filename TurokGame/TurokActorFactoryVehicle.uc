class TurokActorFactoryVehicle extends ActorFactoryVehicle
    native
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

struct native SeatDescription
{
    var() class<Class> mMyPawn;
    var() class<Class> mMyController;
    var() int mSeatIndex;

    structdefaultproperties
    {
        mMyPawn=none
        mMyController=none
        mSeatIndex=0
    }
};

var() array mSeats;

defaultproperties
{
    VehicleClass=none
}