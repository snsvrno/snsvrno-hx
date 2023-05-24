package sn.ds;

abstract Vector(Array<Float>) {

	// inlines used to compair values, when trying to test with equality
	inline private static var ANGLESAMENESS : Float = 0.001;
	inline private static var MAGNITUDESAMENESS : Float = 0.025;

	// indecies
	inline private static var MAGNITUDE : Int = 0;
	inline private static var DIRECTION : Int = 1;

	////////////////////////////////////////////////////////////////////////////////////////////////

	public var magnitude(get, set) : Float;
	inline private function get_magnitude() : Float return this[MAGNITUDE];
	inline private function set_magnitude(mag : Float) : Float return this[MAGNITUDE] = mag;

	public var direction(get, set) : Float;
	inline private function get_direction() : Float return this[DIRECTION];
	inline private function set_direction(dir : Float) : Float return this[DIRECTION] = dir;

	public var x(get, never) : Float;
	inline private function get_x() : Float return magnitude * Math.cos(direction);

	public var y(get, never) : Float;
	inline private function get_y() : Float return magnitude * Math.sin(direction);

	////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function new(?magnitude: Float = 0, ?direction : Float = 0) this = [magnitude,direction];

	inline public static function fromPoint(point : Point, ?origin : Point) : Vector {
		var vector = new Vector();
		if (origin == null) origin = Point.ZERO;

		if(point - origin == Point.ZERO) return new Vector(0,0);
		else {
			vector.setFromPoint(origin, point);
			return vector;
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function setFromPoint(p1 : Point, ?p2 : Point) {
		if (p2 == null) {
			p2 = p1;
			p1 = Point.ZERO;
		}

		direction = Point.angleBetween(p1, p2);
		magnitude = Point.distance(p1, p2);
	}

	inline public function asPoint(?origin : Point) : Point {
		var point = if (origin == null) new Point();
		else origin;
		point.x += x;
		point.y += y;
		return point;
	}
/*
	inline private static var FLOATROUND : Int = 3;
	inline public function toString() : String {
		var factor = Math.pow(10,3);
		return 'vec[magnitude: ${Math.floor(magnitude/factor)*factor}, direction: ${Math.floor(direction/factor)*factor}]';
	}
*/
	////////////////////////////////////////////////////////////////////////////////////////////////

	@:op(A + B) @:commutative public function addVector(vector2 : Vector) : Vector {
		var result : Point = asPoint() + vector2.asPoint();
		return fromPoint(result);
	}

	@:op(A - B) public function subtractVector(vector2 : Vector) : Vector {
		var result : Point = asPoint() - vector2.asPoint();
		return fromPoint(result);
	}

	@:op(A * B) @:commutative public function multiplyScaler(scaler : Float) : Vector {
		return new Vector(magnitude * scaler, direction);
	}

	@:op(A / B) public function divideScaler(scaler : Float) : Vector {
		if (scaler == 0) throw ('cannot divide by 0');
		return new Vector(magnitude / scaler, direction);
	}


	/**
		* we treat angles that are +/- 2PI as the same angle, because they
		* will give the same effect when used.
		*/
	@:op(A == B) public function isEquals(vector2 : Vector) : Bool {
		return (Math.abs(magnitude - vector2.magnitude) < MAGNITUDESAMENESS)
			&& (Math.abs(Angle.normalize(direction) - Angle.normalize(vector2.direction)) < ANGLESAMENESS);
	}

}

////////////////////////////////////////////////////////////////////////////////////////////////

#if utest class VectorTest extends utest.Test {

	public function testFromPoint() {

		// random points
		equals(new Vector(1.000,1.571),Vector.fromPoint(new Point(0.000,1.000)));
		equals(new Vector(1.000,4.712),Vector.fromPoint(new Point(0.000,-1.000)));
		equals(new Vector(38.740,0.341),Vector.fromPoint(new Point(36.514,12.942)));
		equals(new Vector(41.682,0.138),Vector.fromPoint(new Point(41.284,5.750)));
		equals(new Vector(44.446,3.920),Vector.fromPoint(new Point(-31.649,-31.205)));
		equals(new Vector(30.357,2.031),Vector.fromPoint(new Point(-13.486,27.197)));
		equals(new Vector(28.081,2.123),Vector.fromPoint(new Point(-14.742,23.900)));
		equals(new Vector(47.004,1.688),Vector.fromPoint(new Point(-5.504,46.681)));
		equals(new Vector(30.969,0.169),Vector.fromPoint(new Point(30.529,5.206)));
	}

	public function testAddVector() {

		// random points
		equals(new Vector(37.431,1.711),new Vector(41.668,5.063).addVector(new Vector(78.672,1.822)));
		equals(new Vector(43.946,1.907),new Vector(36.956,2.399).addVector(new Vector(20.839,0.913)));
		equals(new Vector(28.239,5.722),new Vector(14.617,4.177).addVector(new Vector(31.469,6.205)));
		equals(new Vector(127.481,5.871),new Vector(82.331,0.270).addVector(new Vector(82.100,5.186)));
		equals(new Vector(125.929,3.198),new Vector(58.241,3.606).addVector(new Vector(76.057,2.890)));
		equals(new Vector(67.628,1.012),new Vector(66.795,1.000).addVector(new Vector(1.163,1.779)));
		equals(new Vector(29.285,2.829),new Vector(21.633,2.660).addVector(new Vector(8.755,3.259)));
	}

	public function testSubtractVector() {

		// random points
		equals(new Vector(0.000000,0.000000),new Vector(1.000000,0.000000).subtractVector(new Vector(1.000000,0.000000)));
		equals(new Vector(1.000000,1.000000),new Vector(2.000000,1.000000).subtractVector(new Vector(1.000000,1.000000)));
		equals(new Vector(10.000000,1.570796),new Vector(5.000000,1.570796).subtractVector(new Vector(5.000000,4.712389)));
		equals(new Vector(85.977008,1.707561),new Vector(95.757178,1.968297).subtractVector(new Vector(25.537989,3.019237)));
		equals(new Vector(34.474643,5.130205),new Vector(8.808780,5.349571).subtractVector(new Vector(25.947862,1.914670)));
		equals(new Vector(8.343350,0.701298),new Vector(6.725432,0.843757).subtractVector(new Vector(1.937659,3.327594)));
		equals(new Vector(105.196542,1.378132),new Vector(89.831349,1.647356).subtractVector(new Vector(30.280498,3.610419)));
		equals(new Vector(64.999684,6.255580),new Vector(7.774146,4.956418).subtractVector(new Vector(63.358010,3.232468)));
		equals(new Vector(92.015873,5.444115),new Vector(100.159950,5.591397).subtractVector(new Vector(16.306041,0.283963)));
		equals(new Vector(16.600632,4.629941),new Vector(1.589064,2.651624).subtractVector(new Vector(17.292088,1.572819)));
	}

	public function testMultiplyScaler() {
		equals(new Vector(2.000000,0.000000),new Vector(1.000000,0.000000).multiplyScaler(2.000000));
		equals(new Vector(-973.531825,3.517273),new Vector(-22.314056,3.517273).multiplyScaler(43.628636));
		equals(new Vector(-1997.145175,4.686988),new Vector(-42.546063,4.686988).multiplyScaler(46.940775));
		equals(new Vector(-1417.775508,0.574617),new Vector(-34.203093,0.574617).multiplyScaler(41.451675));
		equals(new Vector(-429.751618,3.416500),new Vector(-14.335318,3.416500).multiplyScaler(29.978520));
		equals(new Vector(-1185.159526,3.607946),new Vector(-32.645540,3.607946).multiplyScaler(36.303872));
		equals(new Vector(-693.267211,0.712775),new Vector(15.881635,0.712775).multiplyScaler(-43.652131));
		equals(new Vector(178.953242,0.984160),new Vector(37.136616,0.984160).multiplyScaler(4.818782));
		equals(new Vector(-0.953254,3.856364),new Vector(0.038312,3.856364).multiplyScaler(-24.881231));
		equals(new Vector(1960.967662,2.836043),new Vector(-43.605373,2.836043).multiplyScaler(-44.970781));
	}

	public function testDivideScaler() {
		// egde cases
		utest.Assert.raises(() -> { new Vector(1.000000,0.000000).divideScaler(0.000000); });

		// random points
		equals(new Vector(0.500000,0.000000),new Vector(1.000000,0.000000).divideScaler(2.000000));
		equals(new Vector(-1.095463,0.318239),new Vector(-24.631886,0.318239).divideScaler(22.485375));
		equals(new Vector(-1.973832,0.599749),new Vector(36.634154,0.599749).divideScaler(-18.559915));
		equals(new Vector(0.963199,3.620331),new Vector(45.729855,3.620331).divideScaler(47.477042));
		equals(new Vector(-4.934332,2.144414),new Vector(-32.743761,2.144414).divideScaler(6.635905));
		equals(new Vector(-0.752223,1.450834),new Vector(19.911951,1.450834).divideScaler(-26.470802));
		equals(new Vector(-2.271175,5.002957),new Vector(49.812866,5.002957).divideScaler(-21.932644));
		equals(new Vector(-25.994035,1.043577),new Vector(-43.725760,1.043577).divideScaler(1.682146));
		equals(new Vector(-2.868978,5.345010),new Vector(38.836940,5.345010).divideScaler(-13.536854));
		equals(new Vector(-1.749430,4.370869),new Vector(48.707897,4.370869).divideScaler(-27.842154));
 }
	/**
		* helper function that wraps the unit test function.
		*
		* using because i cannot figure out how to have utest
		* use the overriding comparison operatons
		*/
	inline public function equals(v1 : Vector, v2 : Vector) {
		utest.Assert.equals(true, v1 == v2, 'expected $v1 but it is $v2');
	}

} #end
