package sn.ds;

private typedef Point_ = {x:Float,y:Float};

abstract Point(Point_) {

	public static final ZERO : Point = new Point();

	////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function new(?x:Float = 0, ?y:Float = 0) this = {x:x,y:y};

	#if heaps
	inline public static function fromObject(o : h2d.Object) : Point return new Point(o.x, o.y);
	inline public static function fromCamera(o : h2d.Camera) : Point return new Point(o.x, o.y);
	#end

	////////////////////////////////////////////////////////////////////////////////////////////////

	/**
		* gets the angle between the two points
		*
		* assumes thate +X,+Y is where we start the axis and that we rotate clockwise
		* towards -X,+Y
		*/
	inline public static function angleBetween(p1 : Point, p2 : Point) : Float {
		return Angle.between(p1.x, p1.y, p2.x, p2.y);
	}

	inline public static function distance(p1 : Point, p2 : Point) : Float {
		return Math.sqrt(Math.pow(p1.x-p2.x,2)+(Math.pow(p1.y-p2.y,2)));
	}

	inline public static function normalize(point : Point, d : Float) {
		point.x /= d;
		point.y /= d;
	}

	////////////////////////////////////////////////////////////////////////////////////////////////

	public var x(get, set) : Float;
	inline private function get_x() : Float return this.x;
	inline private function set_x(newX : Float) : Float return this.x = newX;

	public var y(get, set) : Float;
	inline private function get_y() : Float return this.y;
	inline private function set_y(newY : Float) : Float return this.y = newY;

	////////////////////////////////////////////////////////////////////////////////////////////////

	@:op(A + B) public function add(p2 : Point) : Point {
		return new Point(x + p2.x, y + p2.y);
	}

	@:op(A - B) public function subtract(p2 : Point) : Point {
		return new Point(x - p2.x, y - p2.y);
	}

	@:op(A * B) @:commutative public function multiplyScaler(s : Float) : Point {
		return new Point(x * s, y * s);
	}

	@:op(A / B) public function divideScaler(s : Float) : Point {
		return new Point(x / s, y / s);
	}

	inline private static var COMPARISON_DIFF : Float = 0.001;
	@:op(A == B) public function equals(p2 : Point) : Bool {
		return Math.abs(x - p2.x) < COMPARISON_DIFF && Math.abs(y - p2.y) < COMPARISON_DIFF;
	}

}

	////////////////////////////////////////////////////////////////////////////////////////////////

#if utest class PointTest extends utest.Test {

	/**
		* testing basic addition of two vectors
		*
		* tests generated from a spreadsheet `sn.ds.vector.gnumeric`
		*/
	public function testAngleBetween() {
		sn.Tests.equalsF(0.7853981633974483,Point.angleBetween(new Point(0.000000,0.000000),new Point(1.000000,1.000000)));
		sn.Tests.equalsF(2.356194490192345,Point.angleBetween(new Point(0.000000,0.000000),new Point(-1.000000,1.000000)));
		sn.Tests.equalsF(3.9269908169872414,Point.angleBetween(new Point(0.000000,0.000000),new Point(-1.000000,-1.000000)));
		sn.Tests.equalsF(5.497787143782138,Point.angleBetween(new Point(0.000000,0.000000),new Point(1.000000,-1.000000)));

		sn.Tests.equalsF(4.291731073625264,Point.angleBetween(new Point(3.815159,46.224175),new Point(-24.030811,-16.020667)));
		sn.Tests.equalsF(4.606079866128777,Point.angleBetween(new Point(5.656743,34.024028),new Point(-1.899825,-36.789091)));
		sn.Tests.equalsF(1.7465801339334148,Point.angleBetween(new Point(11.582901,10.885289),new Point(4.989031,48.009374)));
		sn.Tests.equalsF(5.008767645407591,Point.angleBetween(new Point(-45.214212,30.500968),new Point(-26.867424,-29.578995)));
		sn.Tests.equalsF(1.6545016204550638,Point.angleBetween(new Point(-39.111754,-45.371336),new Point(-45.260644,27.915810)));
		sn.Tests.equalsF(1.7014569639056791,Point.angleBetween(new Point(-22.972135,3.629965),new Point(-27.678733,39.446285)));
		sn.Tests.equalsF(5.293016765616422,Point.angleBetween(new Point(-11.179737,2.606588),new Point(19.694036,-44.452350)));
		sn.Tests.equalsF(1.5524189735281033,Point.angleBetween(new Point(33.879002,-6.147296),new Point(34.787244,43.268926)));
		sn.Tests.equalsF(4.67850894537813,Point.angleBetween(new Point(0.193946,46.863571),new Point(-2.295486,-26.586170)));
		sn.Tests.equalsF(0.29433554581669813,Point.angleBetween(new Point(-26.581510,-21.025302),new Point(10.276012,-9.852292)));
		sn.Tests.equalsF(2.224656385696158,Point.angleBetween(new Point(-21.330195,16.728100),new Point(-38.462918,39.085438)));
		sn.Tests.equalsF(0.0125808594880338,Point.angleBetween(new Point(-15.805762,27.729367),new Point(45.689323,28.503069)));
		sn.Tests.equalsF(3.7600005758179504,Point.angleBetween(new Point(21.612429,-17.042380),new Point(-1.124125,-33.219625)));
		sn.Tests.equalsF(2.8111472222420804,Point.angleBetween(new Point(22.765783,20.818411),new Point(-33.490403,40.115556)));
		sn.Tests.equalsF(5.426711664139528,Point.angleBetween(new Point(-5.919313,8.136617),new Point(38.272917,-42.830523)));
		sn.Tests.equalsF(4.901159349704274,Point.angleBetween(new Point(-7.054704,48.050136),new Point(5.921283,-19.870958)));
	}

	public function testDistance() {
		sn.Tests.equalsF(1,Point.distance(new Point(0.000000,0.000000),new Point(1.000000,0.000000)));
		sn.Tests.equalsF(1,Point.distance(new Point(0.000000,0.000000),new Point(0.000000,1.000000)));
		sn.Tests.equalsF(1.4142135623730951,Point.distance(new Point(0.000000,0.000000),new Point(1.000000,1.000000)));
		sn.Tests.equalsF(52.30819589158079,Point.distance(new Point(-30.364737,1.257231),new Point(9.905586,34.640587)));
		sn.Tests.equalsF(54.25757544978849,Point.distance(new Point(43.908714,41.719895),new Point(-0.750650,10.907142)));
		sn.Tests.equalsF(76.78330280790874,Point.distance(new Point(-47.251573,-44.435961),new Point(14.792189,0.799502)));
		sn.Tests.equalsF(6.189574964482335,Point.distance(new Point(-47.486724,-31.673404),new Point(-44.941260,-37.315341)));
		sn.Tests.equalsF(110.51308799680595,Point.distance(new Point(38.681075,-25.265082),new Point(-42.484715,49.736632)));
		sn.Tests.equalsF(49.823502544722395,Point.distance(new Point(38.323150,18.170848),new Point(-0.930614,-12.513406)));
		sn.Tests.equalsF(89.77651474562515,Point.distance(new Point(-43.750092,44.062528),new Point(42.935314,20.707381)));
		sn.Tests.equalsF(45.02483293046615,Point.distance(new Point(30.922717,5.950891),new Point(-14.081429,4.586204)));
		sn.Tests.equalsF(11.33869467042145,Point.distance(new Point(40.195096,-43.009874),new Point(29.649282,-38.844324)));
		sn.Tests.equalsF(72.05446217790156,Point.distance(new Point(3.653507,44.468230),new Point(18.338228,-26.073988)));
		sn.Tests.equalsF(20.382731004869726,Point.distance(new Point(-3.373884,15.345860),new Point(15.261876,23.602018)));
		sn.Tests.equalsF(39.07076907282841,Point.distance(new Point(21.238870,31.874032),new Point(-13.925541,14.844963)));
		sn.Tests.equalsF(54.84397586528221,Point.distance(new Point(46.926131,-36.579020),new Point(35.456056,17.052119)));
		sn.Tests.equalsF(11.669183194147156,Point.distance(new Point(11.806544,-26.898220),new Point(5.962131,-36.998352)));
		sn.Tests.equalsF(14.802369443027938,Point.distance(new Point(39.521003,-5.841760),new Point(26.013789,0.213430)));
		sn.Tests.equalsF(22.874336409222167,Point.distance(new Point(3.559404,46.616010),new Point(-15.660107,34.212557)));
		sn.Tests.equalsF(42.593049321352176,Point.distance(new Point(-7.431178,32.461221),new Point(-35.999349,0.869648)));
		sn.Tests.equalsF(105.10072337754792,Point.distance(new Point(39.192909,-45.600559),new Point(-30.201077,33.333824)));
	}

	public function testOpAdd() {
		equals(new Point(1.000000,1.000000),new Point(0.000000,0.000000).add(new Point(1.000000,1.000000)));
		equals(new Point(54.983811,-0.362284),new Point(42.906627,30.240101).add(new Point(12.077184,-30.602384)));
		equals(new Point(0.291861,4.910363),new Point(-39.865430,-18.474424).add(new Point(40.157291,23.384788)));
		equals(new Point(22.810266,-15.431534),new Point(6.293141,-11.977993).add(new Point(16.517126,-3.453541)));
		equals(new Point(56.790324,-9.514153),new Point(28.487256,33.528566).add(new Point(28.303068,-43.042719)));
		equals(new Point(78.542603,42.610192),new Point(32.109051,5.312888).add(new Point(46.433552,37.297304)));
		equals(new Point(31.236387,12.134067),new Point(33.267702,-21.125117).add(new Point(-2.031315,33.259183)));
		equals(new Point(-15.581543,11.793612),new Point(-46.516216,11.238737).add(new Point(30.934673,0.554875)));
		equals(new Point(-2.035150,-12.520891),new Point(24.689676,22.849236).add(new Point(-26.724825,-35.370127)));
	}

	public function testOpSub() {
		equals(new Point(-1.000000,-1.000000),new Point(0.000000,0.000000).subtract(new Point(1.000000,1.000000)));
		equals(new Point(-36.582663,14.651681),new Point(-33.913518,33.276324).subtract(new Point(2.669145,18.624643)));
		equals(new Point(-65.689059,-55.040990),new Point(-17.386725,-24.243292).subtract(new Point(48.302334,30.797697)));
		equals(new Point(25.748559,15.115846),new Point(23.906374,-30.671335).subtract(new Point(-1.842184,-45.787181)));
		equals(new Point(-58.463758,0.139683),new Point(-16.264170,-11.173633).subtract(new Point(42.199588,-11.313316)));
		equals(new Point(8.866659,-30.930905),new Point(-29.275725,-2.931359).subtract(new Point(-38.142384,27.999545)));
		equals(new Point(-5.574906,-44.186385),new Point(22.537822,-34.866432).subtract(new Point(28.112728,9.319953)));
		equals(new Point(59.855983,-12.243236),new Point(26.211517,28.984088).subtract(new Point(-33.644466,41.227324)));
		equals(new Point(31.671233,50.687297),new Point(17.274745,49.385739).subtract(new Point(-14.396488,-1.301557)));
	}

	public function testOpMultiply() {
		// special cases
		equals(new Point(0.000000,0.000000),new Point(0.000000,0.000000).multiplyScaler(1));
		equals(new Point(0.000000,0.000000),new Point(13.000000,223.000000).multiplyScaler(0));
		// random data
		equals(new Point(2050.457067,1512.126083),new Point(-41.409260,-30.537592).multiplyScaler(-49.51687298746337));
		equals(new Point(-132.035803,-813.929443),new Point(7.438336,45.853323).multiplyScaler(-17.750718984392698));
		equals(new Point(-82.123885,1792.974605),new Point(2.023312,-44.174076).multiplyScaler(-40.58884219409204));
		equals(new Point(10.384633,-125.548038),new Point(3.118876,-37.706562).multiplyScaler(3.329607175117154));
		equals(new Point(-145.147427,-944.341152),new Point(-5.796670,-37.713612).multiplyScaler(25.03979607946212));
		equals(new Point(-755.294356,-689.626341),new Point(-33.218648,-30.330499).multiplyScaler(22.73705861297543));
		equals(new Point(362.642267,510.509616),new Point(-10.122306,-14.249675).multiplyScaler(-35.82605203940111));
		equals(new Point(499.637982,911.870518),new Point(14.873327,27.144750).multiplyScaler(33.59288670496588));
		equals(new Point(-2420.158253,1515.402286),new Point(-48.554774,30.402977).multiplyScaler(49.84387850056498));
	}

	public function testOpDivide() {
		// special cases
		// TODO : add a divide by zero case, should we deal with this gracefully?
		equals(new Point(0.000000,0.000000),new Point(0.000000,0.000000).divideScaler(1));
		// random data
		equals(new Point(-1.053897,-0.390058),new Point(24.179562,8.949107).divideScaler(-22.943013620807985));
		equals(new Point(-0.316263,0.572440),new Point(9.523785,-17.238193).divideScaler(-30.113513058314098));
		equals(new Point(-0.273186,0.451306),new Point(11.215502,-18.528128).divideScaler(-41.05444010264023));
		equals(new Point(-6.429486,3.296333),new Point(-40.282771,20.652569).divideScaler(6.2653171482295775));
		equals(new Point(-2.984883,4.470383),new Point(-16.759116,25.099703).divideScaler(5.614664594164566));
		equals(new Point(-0.004257,-0.665922),new Point(0.086483,13.528175).divideScaler(-20.314944798015013));
		equals(new Point(-0.100092,0.390288),new Point(-4.341295,16.928016).divideScaler(43.37317439834658));
		equals(new Point(-0.890942,0.729303),new Point(-36.119467,29.566473).divideScaler(40.540747637609826));
		equals(new Point(-0.470011,-0.091834),new Point(-21.795822,-4.258595).divideScaler(46.372985965404126));
	}

	/**
		* helper function that wraps the unit test function.
		*
		* using because i cannot figure out how to have utest
		* use the overriding comparison operatons
		*/
	inline public static function equalsF(f1 : Float, f2 : Float) {
		utest.Assert.equals(true, Math.abs(f1-f2) < 0.0005, 'expected $f1 but it is $f2');
	}

	inline public static function equals(p1 : Point, p2 : Point) {
		utest.Assert.equals(true, Math.abs(p1.x-p2.x) < 0.0005 && Math.abs(p1.y-p2.y) < 0.0005, 'expected $p1 but it is $p2');
	}

} #end
