/*
   CurveToArray
   Author: Will Dady
   Email: willdady@gmail.com
   Creation Date: 29-12-07
   Description: This static class takes the 3 points of a bezier curve and returns an array containing the x & y positions of
   all points along the curve. The array holds the values as Numbers rather than Integers for better line accuracy.

   Version: 1.2

   Methods:
   CurveToArray(point1X:int, point1Y:int, controlX:int, controlY:int, point2X:int, point2Y:int):Array
   Example:
   var myCurveArray:Array = CurveToArray.getCurveArray(xPos1,yPos1,cPosX,cPosY,xPos2,yPos2);
   for (var i:int = 0; i <= curveArray.length-1; i++) {
   trace("x: " + myCurveArray[i][0]);
   trace("y: " + myCurveArray[i][1]);
   }
 */

package couk.psyked.box2d.utils.shape
{
    import flash.geom.Point;

    public class CurveToArray
    {
        /**
         *
         * @param x1
         * @param y1
         * @param xC
         * @param yC
         * @param x2
         * @param y2
         * @param levelOfDetail Maximum angle to trace.
         * @return
         */
        public static function getCurveArray( x1:int, y1:int, xC:int, yC:int, x2:int, y2:int, levelOfDetail:uint ):Array
        {
            // Create the array that will be returned.
            var finalCurveArray:Array = new Array();
            // Calculate the angle of the the 2 lines.
            var line1_dx:Number = xC - x1;
            var line1_dy:Number = yC - y1;
            var line2_dx:Number = x2 - xC;
            var line2_dy:Number = y2 - yC;
            var line1_angle:Number = Math.atan2( line1_dy, line1_dx );
            var line2_angle:Number = Math.atan2( line2_dy, line2_dx );
            // Get the length (measurement) of each line.
            var line1_length:Number = distanceCoords( x1, y1, xC, yC );
            var line2_length:Number = distanceCoords( xC, yC, x2, y2 );
            //
            //trace( "levelOfDetail =", levelOfDetail );
            //trace( "New curve:" );
            //
            var lastPoint:Point = new Point( x1, y1 );
            var lastAngle:int;
            //
            for ( var i:int = 0; i <= line1_length; i++ )
            {
                // As the loop advances the below values increment along the angle of line1 until reaching the total length of the line.
                var line1_xpos:Number = x1 + Math.cos( line1_angle ) * i;
                var line1_ypos:Number = y1 + Math.sin( line1_angle ) * i;
                // Get the distance of how far the values have advanced from the initial start position.
                var line1_increment:Number = distanceCoords( line1_xpos, line1_ypos, x1, y1 );
                // Do the same as above for line2 but increment along line2 relative to the current position along line1.
                var line2_increment:Number = relativeRatio( line1_increment, line1_length, line2_length );
                var line2_xpos:Number = xC + Math.cos( line2_angle ) * line2_increment;
                var line2_ypos:Number = yC + Math.sin( line2_angle ) * line2_increment;
                /* For line3 the angle is between the line1 and line2 increment positions calculated above. As these values
                   shift with each loop iteration the angle is calculated here inside the loop. Like line2, this also gets it's
                 increment position relative to line1. */
                var line3_length:Number = distanceCoords( line1_xpos, line1_ypos, line2_xpos, line2_ypos );
                var line3_increment:Number = relativeRatio( line1_increment, line1_length, line3_length );
                var line3_dx:Number = line2_xpos - line1_xpos;
                var line3_dy:Number = line2_ypos - line1_ypos;
                var line3_angle:Number = Math.atan2( line3_dy, line3_dx );
                /* Final x & y values are pushed into an new array which is added to the finalCurveArray which
                 was created in the method scope. */
                var line3_xpos:Number = line1_xpos + Math.cos( line3_angle ) * line3_increment;
                var line3_ypos:Number = line1_ypos + Math.sin( line3_angle ) * line3_increment;
                var xyValues:Array = new Array( line3_xpos, line3_ypos );

                /* if ( distanceCoords( lastPoint.x, lastPoint.y, line3_xpos, line3_ypos ) > levelOfDetail || i == line1_length )
                   {
                   if ( i == line1_length && finalCurveArray.length == 0 )
                   {
                   trace( "Adding additional curve points!" );
                   //todo: This would be better if we could calculate a proper bezier curve (using 2 control points) rather than a single one.
                   //todo: Also, this should work out the distance to the control point, rather than the control point itself.
                   finalCurveArray.push( new Array( xC, yC ));
                   }
                   finalCurveArray.push( xyValues );
                   lastPoint = new Point( line3_xpos, line3_ypos );
                 } */
                var angleToPoint:int = ( Math.atan2(( y1 - line3_ypos ), ( x1 - line3_xpos )) * ( 180 / Math.PI )) + 180;
                var angleDiff:int = angleToPoint - lastAngle;
                //trace( angleToPoint, angleDiff );
                if ( angleDiff > levelOfDetail || angleDiff < -levelOfDetail )
                {
                    finalCurveArray.push( xyValues );
                    lastPoint = new Point( line3_xpos, line3_ypos );
                    lastAngle = angleToPoint;
                }
            }
            return finalCurveArray;
        }

        /**
         *
         * @param x1
         * @param y1
         * @param x2
         * @param y2
         * @return
         */
        static public function distanceCoords( x1:int, y1:int, x2:int, y2:int ):Number
        {
            var dx:int = x2 - x1;
            var dy:int = y2 - y1;
            return Math.sqrt( dx * dx + dy * dy )
        }

        internal static function relativeRatio( num1:Number, num2:Number, num3:Number ):Number
        {
            var relativeRatio:Number = num1 * num3 / num2;
            return relativeRatio;
        }
    }
}