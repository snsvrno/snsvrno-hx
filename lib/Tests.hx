package sn;

var tests = [
	new sn.ds.Vector.VectorTest(),
	new sn.ds.Point.PointTest(),
	new sn.ds.Angle.AngleTest(),
];


/**
	* helper function that wraps the unit test function.
	*
	* using because i cannot figure out how to have utest
	* use the overriding comparison operatons
	*/
inline function equalsF(f1 : Float, f2 : Float) {
	utest.Assert.equals(true, Math.abs(f1-f2) < 0.0005, 'expected $f1 but it is $f2');
}
