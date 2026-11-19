/** this path constraint only allows movement along coverslots */
class Path_CoverSlotsOnly extends PathConstraint
	native(TGAI);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static final function CoverSlotsOnly(Pawn P)
{
	P.AddPathConstraint(P.CreatePathConstraint(default.class));
}

