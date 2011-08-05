package couk.psyked.box2d.utils.shape
{
	/***
	 * Feel free to use this code however you wish.
	 * Created by Joacim Magnusson (www.splashdust.net)
	 */

	import flash.geom.Point;

	public class PolygonTool
	{

		public static function earClip(p_vertices:Vector.<Point>):Vector.<Vector.<Point>>
		{
			// Touchmypixel's triangulator needs an array of points.
			var points:Vector.<Point> = new Vector.<Point>();
			for each (var v in p_vertices)
			{
				points.push(new Point(v.x, v.y));
			}
			var triangles:Vector.<Triangle> = Triangulator.triangulatePolygon(points);
			var polys:Vector.<Polygon> = Triangulator.polygonizeTriangles(triangles);

			//trace( polys );

			// We want to return an Array<Array<Dynamic>>
			var polyArray:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			if (polys != null)
			{
				//for ( i in 0...polys.length - 1 )
				for (var i:int = 0; i < polys.length - 1; i++)
				{ // The last poly seem to always be a copy of the next last one for some reason.
					var poly:Vector.<Point> = new Vector.<Point>();
					if (polys[i] != null)
					{
						//for ( j in 0...polys[ i ].x.length )
						for (var j:int = 0; j < polys[i].x.length; j++)
						{
							poly.push(new Point(polys[i].x[j], polys[i].y[j]));
						}
					}
					polyArray.push(poly);
				}
			}
			else
			{
				return null;
			}

			return polyArray;
		}

		public static function getConvexPoly(p_vertices:Vector.<Point>):Vector.<Point>
		{
			var grahamScan:GrahamScan = new GrahamScan();
			return grahamScan.convexHull(p_vertices.slice(0));
		}

		public static function getTriangulatedPoly(p_vertices:Vector.<Point>):Vector.<Point>
		{
			var triangulate:Triangulate = new Triangulate();
			return triangulate.process(p_vertices.slice(0));
		}

		// Originally posted as C code at http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
		public static function isPolyClockwise(p_vertices:Vector.<Point>):Boolean
		{
			var i:int;
			var j:int;
			var k:int;
			var count:int = 0;
			var z:Number;

			if (p_vertices.length < 3)
			{
				return false;
			}

			//for ( i in 0...p_vertices.length )
			for (i = 0; i < p_vertices.length; i++)
			{
				j = (i + 1) % p_vertices.length;
				k = (i + 2) % p_vertices.length;
				z = (p_vertices[j].x - p_vertices[i].x) * (p_vertices[k].y - p_vertices[j].y);
				z -= (p_vertices[j].y - p_vertices[i].y) * (p_vertices[k].x - p_vertices[j].x);
				if (z < 0)
				{
					count--;
				}
				else if (z > 0)
				{
					count++;
				}
			}
			if (count > 0)
			{
				return false;
			}
			else if (count < 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		// Originally posted as C code at http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
		public static function isPolyConvex(p_poly:Vector.<Point>):Boolean
		{
			var i:int;
			var j:int;
			var k:int;
			var flag:int = 0;
			var z:Number;
			var n:int = p_poly.length;

			if (n < 3)
			{
				return false;
			}
			//for ( i in 0...n )
			for (i = 0; i < n; i++)
			{
				j = (i + 1) % n;
				k = (i + 2) % n;
				z = (p_poly[j].x - p_poly[i].x) * (p_poly[k].y - p_poly[j].y);
				z -= (p_poly[j].y - p_poly[i].y) * (p_poly[k].x - p_poly[j].x);
				if (z < 0)
				{
					flag |= 1;
				}
				else if (z > 0)
				{
					flag |= 2;
				}
				if (flag == 3)
				{
					return false;
				}
			}
			if (flag != 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public function PolygonTool()
		{
			// constructor
		}
	/* public static function lengthOfLine( p1, p2 ):Number
	   {
	   var dx:Number, dy:Number;
	   dx = p2.x - p1.x;
	   dy = p2.y - p1.y;
	   return Math.sqrt( dx * dx + dy * dy );
	 } */
	}

}
