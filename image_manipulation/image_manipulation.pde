PImage img;
PImage imgBuffer;
int imgWidth;
int imgHeight;

/*Added extra functionality: when the user presses 5,
a saturation filter is added */

float[][] guassianKernel ={{  0.0625, 0.125,  0.0625},
                         {0.125, 0.25, 0.125},
                         { 0.0625, 0.125, 0.0625}};
                         
// This is the one used by the program when the user presses 3
float[][] guassianKernel7 = { {0, 0, 1, 2, 1 ,0, 0},
                              {0, 3, 13, 22,13, 3, 0},
                              {1, 13, 59, 97, 59, 13, 1},
                              {2, 22, 97, 159, 97, 22, 2},
                              {1, 13, 49, 97, 59, 13, 1},
                              {0, 3, 13, 22, 13, 3, 0},
                              {0, 0, 1, 2, 1, 0,0,}};


float[][] xKernel ={{-1,0,1},
                   {-2,0,2},
                   {-1,0,1}};

float[][] yKernel ={{-1,-2,-1},
                    {0,0,0},
                    {1,2,1}};
                    
void setup() {
  surface.setResizable(true);
  img = loadImage("illustration.jpg");
  imgBuffer = loadImage("illustration.jpg");
  imgWidth = img.width;
  imgHeight = img.height;
  surface.setSize(imgWidth, imgHeight);
}

void draw() {
  //

  //image(img, 0, 0); //Note: we must load an image before displaying it!
  image(imgBuffer, 0, 0);
  
 
}

void keyPressed() {
  print(key);
  if (key == '0') {
    imgBuffer.copy(img, 0, 0, img.width, img.height, 0, 0, imgBuffer.width, imgBuffer.height);
    
  } else if (key == '1') {
    //apply grayscale
      println("applying grayscale!");
      img.loadPixels();
      for (int x = 0; x < imgWidth; x++) {
        for (int y = 0; y < imgHeight; y++) {
          //access pixel at index and set c to its value
          int index = x + y*imgWidth;
          colorMode(RGB, 255, 255, 255);
          color c = img.pixels[index];
          float average = (red(c) + green(c) + blue(c))/3;
           imgBuffer.pixels[index] = color(average, average, average);
        }    
     
      } //ends first for loop
    imgBuffer.updatePixels();
  
  } else if (key == '2') {
    println("applying contrast!");
    img.loadPixels();
    for (int x = 0; x < imgWidth; x++) {
      for (int y = 0; y < imgHeight; y++) {
        //access pixel at index and set c to its value
        int index = x + y*imgWidth;
        colorMode(HSB, 360,100,100);
        color c = img.pixels[index];
        if (brightness(c)<50){
         int newBrightness = round(brightness(c)*.2);
         img.pixels[index] = color(hue(c), saturation(c),newBrightness);
        }else{
         int newBrightness =round(brightness(c)*1.2);
         if (newBrightness>100){
           newBrightness = 100;
         }
         imgBuffer.pixels[index] = color(hue(c), saturation(c),newBrightness);
      }    
     }
  } //ends first for loop
  imgBuffer.updatePixels();
  
  } else if (key == '3') {
    //apply guassian blur
    println("applying guassian blur");
    colorMode(RGB, 255, 255, 255);
    for (int x = 0; x < imgWidth; x++) {
    for (int y = 0; y < imgHeight; y++) {
      //access pixel at index and set c to its value
      int index = x + y*imgWidth;
      color c = img.pixels[index];
      //traversing the neighborhood
      int offset = guassianKernel7.length/2;
      if ((offset-1) < x && x < imgWidth - offset  && (offset-1) < y && y < imgHeight-offset ){ //avoid edges
      float red = 0;
      float blue = 0;
      float green = 0;
      for (int i=0; i<guassianKernel7.length; i++){
        for (int j=0; j<guassianKernel7.length; j++){
            int indexNhood = (x + i - guassianKernel7.length/2) + imgWidth *(y + j - guassianKernel7.length/2);
             //         println(indexNhood);
            red += red(img.pixels[indexNhood]) * guassianKernel7[i][j];
            green += green(img.pixels[indexNhood]) * guassianKernel7[i][j];
            blue += blue(img.pixels[indexNhood]) * guassianKernel7[i][j];
        }
       }
       red = constrain(abs(red/1003), 0, 255);
       green = constrain(abs(green/1003), 0, 255);
       blue = constrain(abs(blue/1003), 0, 255);
       imgBuffer.pixels[index] = color(red,green,blue);
       } //closes conditional
      }
    }// closes first for loop
  imgBuffer.updatePixels();
    
   } else if (key == '4') {
    //apply edge detection
    println("detecting edges");
    for (int x = 0; x < imgWidth; x++) {
    for (int y = 0; y < imgHeight; y++) {
      //access pixel at index and set c to its value
      int index = x + y*imgWidth;
      color c = img.pixels[index];
      //traversing the neighborhood
      if (0 < x && x < imgWidth -1  && 0 < y && y < imgHeight-1 ){ //avoid edges
      float redX = 0;
      float blueX = 0;
      float greenX = 0;
      float redY = 0;
      float blueY = 0;
      float greenY = 0;
      // z denotes magnitude
      float redZ = 0;
      float blueZ = 0;
      float greenZ = 0;
      for (int i=0; i<xKernel.length; i++){
        for (int j=0; j<xKernel.length; j++){
            int indexNhood = (x + i - xKernel.length/2) + imgWidth *(y + j - xKernel.length/2);
            redX += red(img.pixels[indexNhood]) * xKernel[i][j];
            greenX += green(img.pixels[indexNhood]) * xKernel[i][j];
            blueX += blue(img.pixels[indexNhood]) * xKernel[i][j];
            redY += red(img.pixels[indexNhood]) * yKernel[i][j];
            greenY += green(img.pixels[indexNhood]) * yKernel[i][j];
            blueY += blue(img.pixels[indexNhood]) * yKernel[i][j];
        }
       }
       redZ = sqrt(sq(redX)+sq(redY));
       greenZ = sqrt(sq(greenX)+sq(greenY));
       blueZ = sqrt(sq(blueX)+sq(blueY));
       
       redZ = constrain(redZ, 0, 255);
       greenZ = constrain(greenZ, 0, 255);
       blueZ = constrain(blueZ, 0, 255);
       
       imgBuffer.pixels[index] = color(redZ,greenZ,blueZ);
       } //closes conditional
      }
    }// closes first for loop
  imgBuffer.updatePixels();
   } else if (key == '5'){
     for (int x = 0; x < imgWidth; x++) {
       for (int y = 0; y < imgHeight; y++) {
        //access pixel at index and set c to its value
        int index = x + y*imgWidth;
        colorMode(HSB, 360,100,100);
        color c = img.pixels[index];
        int newSat =round(saturation(c)*1.8);
       newSat = constrain(newSat,0,100);
        imgBuffer.pixels[index] = color(hue(c), newSat, brightness(c));
       }
    }
    imgBuffer.updatePixels();
   }

}//ends keyPressed()
