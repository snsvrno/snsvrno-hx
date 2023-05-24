package sn.ds;

class Angle {
	public static function normalize(angle : Float) : Float {
		while (angle < 0) angle += 2 * Math.PI;
		while (angle > 2 * Math.PI) angle -= 2 * Math.PI;
		return angle;
	}

	public static function between(x1 : Float, y1 : Float, x2 : Float, y2 : Float) : Float {
		var dy = y2 - y1;
		var dx = x2 - x1;
		var angle = Math.atan(Math.abs(dy/dx));

		if (Math.isNaN(angle)) angle = Math.PI/2;

		angle = if (dx >= 0 && dy >= 0) angle;
		else if (dx < 0 && dy >= 0) Math.PI - angle;
		else if (dx < 0 && dy < 0) Math.PI + angle;
		else 2 * Math.PI - angle;

		return angle;
	}
}

#if utest class AngleTest extends utest.Test {

	public function testBetween() {
		sn.Tests.equalsF(1.571,Angle.between(0,0,0,1));
		sn.Tests.equalsF(0.000,Angle.between(0,0,1,0));
		sn.Tests.equalsF(3.142,Angle.between(0,0,-1,0));
		sn.Tests.equalsF(4.712,Angle.between(0,0,0,-1));

		sn.Tests.equalsF(1.623,Angle.between(-23.878425818850047,-30.90439359856174,-26.5276302127764,19.64566561969814));
		sn.Tests.equalsF(1.800,Angle.between(-2.8762079380976857,-33.681015811524134,-17.82835633935815,30.300937938795048));
		sn.Tests.equalsF(2.781,Angle.between(10.457523515283263,-34.91969232446408,-42.000807068165315,-15.148331619448442));
		sn.Tests.equalsF(5.802,Angle.between(-15.865473048236709,45.46889157275913,34.920330661083774,18.932762669377688));
		sn.Tests.equalsF(3.900,Angle.between(5.321063089724973,12.082629409417201,-10.068653423341736,-2.487211579898066));
		sn.Tests.equalsF(2.267,Angle.between(23.831702624604834,-26.456507125408436,-25.373532238015173,32.37499375398745));
		sn.Tests.equalsF(1.183,Angle.between(-33.70325166220631,24.70742913199104,-24.888972243112846,46.306522166510454));
		sn.Tests.equalsF(6.147,Angle.between(-38.017638642644755,-8.065042102721677,44.98219168391451,-19.401065825080053));
		sn.Tests.equalsF(5.417,Angle.between(-22.850790810263305,9.549235144229584,8.282002072619555,-27.036012221113225));
		sn.Tests.equalsF(4.297,Angle.between(39.862870806961915,35.224929335080105,2.4616735504616045,-49.46825052074688));
		sn.Tests.equalsF(5.526,Angle.between(-14.47008708487752,-12.159322457491669,12.051347161635938,-37.23282942038446));
		sn.Tests.equalsF(3.995,Angle.between(-15.141314572718429,32.578471183817335,-24.76997371291823,21.54993631425508));
	}

} #end
