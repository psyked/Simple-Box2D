package couk.psyked.box2d.utils
{
    import Box2D.Collision.Shapes.b2Shape;
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2World;
    
    import flash.display.Sprite;

    public class Box2DMouseUtils
    {
        private static var mousePVec:b2Vec2 = new b2Vec2();
        private static var m_world:b2World;
        private static var m_physScale:Number;
        private static var m_sprite:Sprite;

        private static var accuracy:Number = 2; //0.001;
        private static var k_maxCount:int = 100; //10;

        public static function initialise( _m_world:b2World, _m_physScale:Number, _m_sprite:Sprite ):void
        {
            m_world = _m_world;
            m_physScale = _m_physScale;
            m_sprite = _m_sprite;
        }

        public static function getTopBodyAtMouse( includeStatic:Boolean = false ):b2Body
        {
            var mousePVec:b2Vec2 = new b2Vec2();
            var real_x_mouse:Number;
            var real_y_mouse:Number;

            real_x_mouse = ( m_sprite.mouseX ) / m_physScale;
            real_y_mouse = ( m_sprite.mouseY ) / m_physScale;
            mousePVec.Set( real_x_mouse, real_y_mouse );
            var aabb:b2AABB = new b2AABB();
            aabb.lowerBound.Set( real_x_mouse - accuracy, real_y_mouse - accuracy );
            aabb.upperBound.Set( real_x_mouse + accuracy, real_y_mouse + accuracy );
            var shapes:Array = new Array();
            var count:int = m_world.Query( aabb, shapes, k_maxCount );
            var body:b2Body = null;
            for ( var i:int = 0; i < count; ++i )
            {
                if ( shapes[ i ].GetBody().IsStatic() == false || includeStatic )
                {
                    var tShape:b2Shape = shapes[ i ] as b2Shape;
                    var inside:Boolean = tShape.TestPoint( tShape.GetBody().GetXForm(), mousePVec );
                    if ( inside )
                    {
                        body = tShape.GetBody();
                        break;
                    }
                }
            }
            return body;
        }

        public static function getAllBodiesAtMouse( includeStatic:Boolean = false ):Array
        {
            var mousePVec:b2Vec2 = new b2Vec2();
            var real_x_mouse:Number;
            var real_y_mouse:Number;

            real_x_mouse = ( m_sprite.mouseX ) / m_physScale;
            real_y_mouse = ( m_sprite.mouseY ) / m_physScale;
            mousePVec.Set( real_x_mouse, real_y_mouse );
            var aabb:b2AABB = new b2AABB();
            aabb.lowerBound.Set( real_x_mouse - accuracy, real_y_mouse - accuracy );
            aabb.upperBound.Set( real_x_mouse + accuracy, real_y_mouse + accuracy );
            var shapes:Array = new Array();
            var count:int = m_world.Query( aabb, shapes, k_maxCount );
            var bodies:Array = new Array();
            for ( var i:int = 0; i < count; ++i )
            {
                if ( shapes[ i ].GetBody().IsStatic() == false || includeStatic )
                {
                    var tShape:b2Shape = shapes[ i ] as b2Shape;
                    var inside:Boolean = tShape.TestPoint( tShape.GetBody().GetXForm(), mousePVec );
                    if ( inside )
                    {
                        bodies.push( tShape.GetBody() );
                        //break;
                    }
                }
            }
            return bodies;
        }
    }
}