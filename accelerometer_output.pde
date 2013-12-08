#define Y_AXIS 6
#define X_AXIS 5
#define BUTTON 12

double x = 0;
double y = 0;
double xg = 0;
double yg = 0;
double defX = 0;
double defY = 0;
double maxXg = 0;
double maxYg = 0;
double button_read = 0;
double old_read = 0;

void setup() {
  Serial.begin(9600);
  pinMode( X_AXIS, INPUT );
  pinMode( Y_AXIS, INPUT );
  pinMode( BUTTON, INPUT );
}

void loop() {
  button_read = digitalRead( BUTTON );
  
  x = pulseIn( X_AXIS, HIGH );
  y = pulseIn( Y_AXIS, HIGH );

  if (Serial.available() > 0) {
    // read the incoming byte:
    int incomingByte = Serial.read();
    if( incomingByte == 32 ) {
      defX = x;
      defY = y;
      Serial.print( "Reset offset for X to: " );
      Serial.println( defX );
      Serial.print( "Reset offset for Y to: " );
      Serial.println( defY );
    }
    if( incomingByte == 114 || incomingByte == 82 ) {
      maxXg = 0;
      maxYg = 0;
      Serial.println("Max values reset.  Please remember to reset offsets if necessary." );
    }
  }

//  xg = abs((x-defX) * 8.0)/10000.0;
  xg = abs(( x - defX )) * 8.0/10000.0;
  yg = abs((y-defY) * 8.0)/10000.0;
  if( xg > maxXg ) {
    maxXg = xg;
    Serial.println( "********************" );
    Serial.print( "X: " );
    Serial.println( maxXg );
    Serial.print( "Raw point acceleration: " );
    Serial.print( maxXg * 9.8 );
    Serial.println( "m/s^2" );
    Serial.println( "********************" );    
  }
  if( yg > maxYg ) {
    maxYg = yg;
    Serial.println( "********************" );
    Serial.print( "Y: " );
    Serial.println( maxYg );
    Serial.print( "Raw point acceleration: " );
    Serial.print( maxYg * 9.8 );
    Serial.println( "m/s^2" );
    Serial.println( "********************" );    
  }
  old_read = button_read;
}
