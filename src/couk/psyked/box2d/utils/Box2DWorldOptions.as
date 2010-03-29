package couk.psyked.box2d.utils
{
    import Box2D.Collision.b2AABB;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2World;

    public class Box2DWorldOptions
    {

        public var aabb:b2AABB;
        public var edgeBottom:Boolean;
        public var edgeLeft:Boolean;
        public var edgeRight:Boolean;
        public var edgeTop:Boolean;
        public var gravity:b2Vec2;
        public var height:int;
        public var scale:Number;
        public var width:int;
        public var world:b2World;

        public function Box2DWorldOptions( _width:int = 800, _height:int = 600, _scale:int = 30, _gravity:Number = 9.8, _aabb:b2AABB = null )
        {

            scale = _scale;
            width = _width;
            height = _height;

            if ( !_aabb )
            {
                aabb = new b2AABB();
                aabb.lowerBound.Set( -1000.0, -1000.0 );
                aabb.upperBound.Set( 1000.0, 1000.0 );
            }
            else
            {
                aabb = _aabb;
            }

            gravity = new b2Vec2( 0, _gravity );

        }

        public function setWorldEdges( bottom:Boolean = false, top:Boolean = false, left:Boolean = false, right:Boolean = false ):void
        {
            edgeBottom = bottom;
            edgeTop = top;
            edgeLeft = left;
            edgeRight = right;
        }
    }
}