package couk.psyked.box2d.utils
{
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2Fixture;
    import Box2D.Dynamics.b2World;
    
    import flash.display.Sprite;
    import flash.geom.Point;

    public class PointUtils
    {

        private static var accuracy:Number = 0.1; //0.001;

        private static var k_maxCount:int = 100; //10;

        private static var m_physScale:Number;
        private static var m_sprite:Sprite;
        private static var m_world:b2World;

        private static var mousePVec:b2Vec2 = new b2Vec2();

        public static function getAllBodiesAtPoint( point:Point, includeStatic:Boolean = false ):Array
        {
            //trace( "Getting all bodies at", point.x, ",", point.y );
            var mousePVec:b2Vec2 = new b2Vec2();
            var real_x_mouse:Number;
            var real_y_mouse:Number;

            real_x_mouse = ( point.x ) / m_physScale;
            real_y_mouse = ( point.y ) / m_physScale;
            mousePVec.Set( real_x_mouse, real_y_mouse );
            var aabb:b2AABB = new b2AABB();
            aabb.lowerBound.Set( real_x_mouse - accuracy, real_y_mouse - accuracy );
            aabb.upperBound.Set( real_x_mouse + accuracy, real_y_mouse + accuracy );
			var body:b2Body = null;
			var fixture:b2Fixture;
			var bodies:Array = new Array();
			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), mousePVec);
					if (inside)
					{
						bodies.push(fixture.GetBody());
						//return false;
					}
				}
				return true;
			}
			m_world.QueryAABB(GetBodyCallback, aabb);
			return bodies;
        }

        public static function getTopBodyAtPoint( point:Point, includeStatic:Boolean = false ):b2Body
        {
            var mousePVec:b2Vec2 = new b2Vec2();
            var real_x_mouse:Number;
            var real_y_mouse:Number;

            real_x_mouse = ( point.x ) / m_physScale;
            real_y_mouse = ( point.y ) / m_physScale;
            mousePVec.Set( real_x_mouse, real_y_mouse );
            var aabb:b2AABB = new b2AABB();
            aabb.lowerBound.Set( real_x_mouse - accuracy, real_y_mouse - accuracy );
            aabb.upperBound.Set( real_x_mouse + accuracy, real_y_mouse + accuracy );
			var body:b2Body = null;
			var fixture:b2Fixture;
			
			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), mousePVec);
					if (inside)
					{
						body = fixture.GetBody();
						return false;
					}
				}
				return true;
			}
			m_world.QueryAABB(GetBodyCallback, aabb);
			return body;
        }

        public static function initialise( _m_world:b2World, _m_physScale:Number, _m_sprite:Sprite ):void
        {
            m_world = _m_world;
            m_physScale = _m_physScale;
            m_sprite = _m_sprite;
        }
    }
}