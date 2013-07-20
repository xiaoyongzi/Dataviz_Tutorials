import de.fhpotsdam.unfolding.mapdisplay.MapDisplayFactory;
//import processing.opengl.*;
//import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.marker.*;

Location beijinglocation = new Location(39.9,116.39);

de.fhpotsdam.unfolding.Map map1;
de.fhpotsdam.unfolding.Map map2;
int rowCount;

SimplePointMarker[] haidianBorder;
ScreenPosition[] borderPos;

void setup() {
  size(800, 600);
  smooth();
  String[] rows = loadStrings("haidian.tsv");
  rowCount = rows.length;
  
  haidianBorder = new SimplePointMarker[rowCount];
  borderPos = new ScreenPosition[rowCount];
  
  for(int i=0;i<rowCount;i++){
    String[] pieces = split(rows[i], TAB); 
    Location loc = new Location(float(pieces[1]),float(pieces[0]));
    haidianBorder[i] = new SimplePointMarker(loc);
  }
  
  //map2 = new de.fhpotsdam.unfolding.Map(this, 10, 10, 385, 580, new Google.GoogleTerrainProvider());//new OpenStreetMap.OpenStreetMapProvider());
  //map2 = new de.fhpotsdam.unfolding.Map(this, new OpenStreetMap.CloudmadeProvider("8ee2a50541944fb9bcedded5165f09d9", 65678));
  map1 = new de.fhpotsdam.unfolding.Map(this,new streamProvider("localhost", "ayay412.map-kzs1eguk"));//new MapBox.WorldLightProvider());
  
  MapUtils.createDefaultEventDispatcher(this, map1);

  map1.zoomAndPanTo(beijinglocation, 12);
  
  float maxPanningDistance = 50; // in km
  map1.setPanningRestriction(beijinglocation, maxPanningDistance);
  
 
}

void draw() {
  background(0);
  for(int i =0;i<rowCount;i++){
    borderPos[i] = haidianBorder[i].getScreenPosition(map1);
  }
  map1.draw();
  beginShape();
  stroke(100,100);
  strokeWeight(3);
  fill(23,255,238,70);
  for(int i=0;i<rowCount;i++){
   vertex(borderPos[i].x,borderPos[i].y);
  }
  endShape();
   //Location location = map1.getLocation(mouseX, mouseY);
    //fill(0);
    //text(location.getLat() + ", " + location.getLon(), mouseX, mouseY);
  //map2.draw();
}



class streamProvider extends MapBox.MapBoxProvider {
  String hostname, mapname;

  streamProvider(String _hostname, String _mapname) {
    hostname = _hostname;
    mapname = _mapname;
  }
  
  public String getPositiveZoomString(Coordinate coordinate) {
			// Rows are numbered from bottom to top (opposite to OSM)
			float gridSize = pow(2, coordinate.zoom);
                        float negativeRow = gridSize - coordinate.row - 1;

			return (int) coordinate.zoom + "/" + (int) coordinate.column + "/" + (int) coordinate.row;
		}
	

  public String getZoomString(Coordinate coordinate) {
    float gridSize = pow(2, coordinate.zoom);
    float negativeRow = gridSize - coordinate.row - 1;
    return (int) coordinate.zoom + "/" + (int) coordinate.column + "/" + (int) coordinate.row;
  }

  public String[] getTileUrls(Coordinate coordinate) {
    //String url = "http://"+hostname+": 20009/tile/"+mapname+"/"
     // + getZoomString(coordinate) + ".png?updated=" + int(random(0, 10000));
    
    String url = "http://a.tiles.mapbox.com/v3/"+mapname+"/" + getZoomString(coordinate) +".png";
      
      //http://a.tiles.mapbox.com/v3/ayay412.map-kzs1eguk.html#3.00/0.00/0.00
      
    return new String[] { 
      url
    };
  }
}


