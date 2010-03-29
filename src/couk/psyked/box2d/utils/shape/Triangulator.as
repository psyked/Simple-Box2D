package couk.psyked.box2d.utils.shape
{
    import flash.geom.Point;

    public class Triangulator
    {

        /* give it an array of points (vertexes)
         * returns an array of Triangles
         * */
        public static function triangulatePolygon( v:Array ):Array
        {
            var xA:Array = new Array();
            var yA:Array = new Array();

            for each ( var p:Point in v )
            {
                xA.push( p.x );
                yA.push( p.y );
            }

            return ( triangulatePolygonFromFlatArray( xA, yA ));
        }

        /* give it a list of vertexes as flat arrays
         * returns an array of Triangles
         * */
        public static function triangulatePolygonFromFlatArray( xv:Array, yv:Array ):Array
        {
            if ( xv.length < 3 || yv.length < 3 || yv.length != xv.length )
            {
                trace( "Please make sure both arrays or of the same length and have at least 3 vertices in them!" );
                return null;
            }

            var i:int = 0;
            var vNum:int = xv.length;

            var buffer:Array = new Array();
            var bufferSize:int = 0;
            var xrem:Array = new Array();
            var yrem:Array = new Array();

            //for ( i in 0...vNum )
            for ( var i:int = 0; i < vNum; i++ )
            {
                xrem[ i ] = xv[ i ];
                yrem[ i ] = yv[ i ];
            }

            while ( vNum > 3 )
            {
                //Find an ear
                var earIndex = -1;
                //for ( i in 0...vNum )
                for ( var i:int = 0; i < vNum; i++ )
                {
                    if ( isEar( i, xrem, yrem ))
                    {
                        earIndex = i;
                        break;
                    }
                }

                //If we still haven't found an ear, we're screwed.
                //The user did Something Bad, so return null.
                //This will probably crash their program, since
                //they won't bother to check the return value.
                //At this we shall laugh, heartily and with great gusto.
                if ( earIndex == -1 )
                {
                    //trace('no ear found');
                    return null;
                }

                //Clip off the ear:
                //  - remove the ear tip from the list

                //Opt note: actually creates a new list, maybe
                //this should be done in-place instead.  A linked
                //list would be even better to avoid array-fu.
                --vNum;
                var newx:Array = new Array();
                var newy:Array = new Array();
                var currDest:int = 0;
                //for ( i in 0...vNum )
                for ( var i:int = 0; i < vNum; i++ )
                {
                    if ( currDest == earIndex )
                        ++currDest;
                    newx[ i ] = xrem[ currDest ];
                    newy[ i ] = yrem[ currDest ];
                    ++currDest;
                }

                //  - add the clipped triangle to the triangle list
                var under:int = ( earIndex == 0 ) ? ( xrem.length - 1 ) : ( earIndex - 1 );
                var over:int = ( earIndex == xrem.length - 1 ) ? 0 : ( earIndex + 1 );

                //if(5 < getSmallestAngle(xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]))

                var toAdd:Triangle = new Triangle( xrem[ earIndex ], yrem[ earIndex ], xrem[ over ], yrem[ over ], xrem[ under ], yrem[ under ]);
                buffer[ bufferSize ] = toAdd;
                ++bufferSize;

                //  - replace the old list with the new one
                xrem = newx;
                yrem = newy;
            }

            var toAddMore:Triangle = new Triangle( xrem[ 1 ], yrem[ 1 ], xrem[ 2 ], yrem[ 2 ], xrem[ 0 ], yrem[ 0 ]);
            buffer[ bufferSize ] = toAddMore;
            ++bufferSize;

            var res:Array = new Array();
            //for ( i in 0...bufferSize )
            for ( var i:int = 0; i < bufferSize; i++ )
            {
                res[ i ] = buffer[ i ];
            }
            return buffer;
        }

        public static function getSmallestAngle( pax:Number, pay:Number, pbx:Number, pby:Number, pcx:Number, pcy:Number ):Number
        {
            var angles:Array = new Array();
            /* var pax = pax;
               var pay = pay;
               var pbx = pbx;
               var pby = pby;
               var pcx = pcx;
             var pcy = pcy; */
            var abx:Number = pax - pbx;
            var aby:Number = pay - pby;
            var ab:Number = Math.sqrt( abx * abx + aby * aby );
            var bcx:Number = pbx - pcx;
            var bcy:Number = pby - pcy;
            var bc:Number = Math.sqrt( bcx * bcx + bcy * bcy );
            var cax:Number = pcx - pax;
            var cay:Number = pcy - pay;
            var ca:Number = Math.sqrt( cax * cax + cay * cay );
            var cosA:Number = -( bc * bc - ab * ab - ca * ca ) / ( 2 * ab * ca );
            var acosA:Number = Math.acos( cosA ) * 180 / Math.PI;
            var cosB:Number = -( ca * ca - bc * bc - ab * ab ) / ( 2 * bc * ab );
            var acosB:Number = Math.acos( cosB ) * 180 / Math.PI;
            var cosC:Number = -( ab * ab - ca * ca - bc * bc ) / ( 2 * ca * bc );
            var acosC:Number = Math.acos( cosC ) * 180 / Math.PI;
            angles.push( acosA );
            angles.push( acosB );
            angles.push( acosC );
            angles.sort( function( x, y )
                {
                    if ( x > y )
                        return 1;
                    else if ( y > x )
                        return -1;
                    else
                        return 0;
                });

            return angles[ 0 ];
        }

        /* takes: array of Triangles
         * returns: array of Polygons
         * */
        public static function polygonizeTriangles( triangulated:Array ):Array
        {
            var polys:Array;
            var polyIndex:int = 0;
            var poly:Polygon = null;

            var i:int = 0;

            if ( triangulated == null )
            {
                return null;
            }
            else
            {
                polys = new Array();
                var covered:Array = new Array();
                //for ( i in 0...triangulated.length )
                for ( var i:int = 0; i < triangulated.length; i++ )
                {
                    covered[ i ] = false;
                }

                var notDone:Boolean = true;

                while ( notDone )
                {
                    var currTri:int = -1;
                    //for ( i in 0...triangulated.length )
                    for ( var i:int = 0; i < triangulated.length; i++ )
                    {
                        if ( covered[ i ])
                            continue;
                        currTri = i;
                        break;
                    }
                    if ( currTri == -1 )
                    {
                        notDone = false;
                    }
                    else
                    {
                        poly = new Polygon( triangulated[ currTri ].x, triangulated[ currTri ].y );
                        covered[ currTri ] = true;
                        //for ( i in 0...triangulated.length )
                        for ( var i:int = 0; i < triangulated.length; i++ )
                        {
                            if ( covered[ i ])
                                continue;
                            var newP:Polygon = poly.add( triangulated[ i ]);
                            if ( newP == null || newP.x.length > 7 )
                                continue;
                            if ( newP.isConvex())
                            {
                                poly = newP;
                                covered[ i ] = true;
                            }
                        }
                    }
                    polys[ polyIndex ] = poly;
                    polyIndex++;
                }
            }

            var ret:Array = new Array();
            //for ( i in 0...polyIndex )
            for ( var i:int = 0; i < polyIndex; i++ )
            {
                ret[ i ] = polys[ i ];
            }
            return ret;
        }

        //Checks if vertex i is the tip of an ear
        /*
         * */
        public static function isEar( i:int, xv:Array, yv:Array ):Boolean
        {
            var dx0:Number, dy0:Number, dx1:Number, dy1:Number;
            dx0 = dy0 = dx1 = dy1 = 0;
            if ( i >= xv.length || i < 0 || xv.length < 3 )
            {
                return false;
            }
            var upper:int = i + 1;
            var lower:int = i - 1;
            if ( i == 0 )
            {
                dx0 = xv[ 0 ] - xv[ xv.length - 1 ];
                dy0 = yv[ 0 ] - yv[ yv.length - 1 ];
                dx1 = xv[ 1 ] - xv[ 0 ];
                dy1 = yv[ 1 ] - yv[ 0 ];
                lower = xv.length - 1;
            }
            else if ( i == xv.length - 1 )
            {
                dx0 = xv[ i ] - xv[ i - 1 ];
                dy0 = yv[ i ] - yv[ i - 1 ];
                dx1 = xv[ 0 ] - xv[ i ];
                dy1 = yv[ 0 ] - yv[ i ];
                upper = 0;
            }
            else
            {
                dx0 = xv[ i ] - xv[ i - 1 ];
                dy0 = yv[ i ] - yv[ i - 1 ];
                dx1 = xv[ i + 1 ] - xv[ i ];
                dy1 = yv[ i + 1 ] - yv[ i ];
            }

            var cross:Number = ( dx0 * dy1 ) - ( dx1 * dy0 );
            if ( cross > 0 )
            {
                return false;
            }
            var myTri:Triangle = new Triangle( xv[ i ], yv[ i ], xv[ upper ], yv[ upper ], xv[ lower ], yv[ lower ]);

            //for ( j in 0...xv.length )
            for ( var j:int = 0; j < xv.length; j++ )
            {
                if ( !( j == i || j == lower || j == upper ))
                {
                    if ( myTri.isInside( xv[ j ], yv[ j ]))
                        return false;
                }
            }
            return true;
        }
    }
}