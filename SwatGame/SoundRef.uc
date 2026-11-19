class SoundRef extends Core.Object
	abstract
    native;

// ============================================================================
// SoundRef
//  
// A soundref object is a simple wrapper for the low level engine specifics
// of playing a sound or a stream.  This is the abstract base class.  There is 
// also a StreamSoundRef and a NormalSoundRef, which are wrappers for streaming 
// sounds and normal unreal usound objects respectively.  This class is used 
// across multiple classes and specifically helps decouple SoundSets, SoundSpecifications,
// and SoundInstances.
//
// This abstract base class is mainly for the shared C++ code between the subclasses
// as can be seen in cpptext.
// ============================================================================

// UGLY!! Index into the SoundSet which owns this SoundRef
var int SoundSetIndex;

// Simple equality, base classes can override 
simulated function bool Equals (SoundRef inOtherRef)
{
	return (self == inOtherRef);
}

simulated event string toString();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
