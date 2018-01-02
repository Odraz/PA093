ArrayList<Point> giftWrapping(){
  ArrayList<Point> hull = new ArrayList<Point>();
  if(points.size() == 0){
    return hull;
  }
  
 Point leftmostPoint = new Point(Integer.MAX_VALUE, 0);
 
 for(Point point : points){
   if(point.x < leftmostPoint.x)
     leftmostPoint = point;
 }
  
 Point pointOnHull = leftmostPoint;
 Point endpoint = new Point(0, 0);
 
 int i = 0;
 do{
    hull.add(pointOnHull);
    endpoint = points.get(0);      // initial endpoint for a candidate edge on the hull
    for(int j = 1; j < points.size(); j++){
       if ((endpoint == pointOnHull) || ((endpoint.x - hull.get(i).x)*(points.get(j).y - hull.get(i).y) - (points.get(j).x - hull.get(i).x)*(endpoint.y - hull.get(i).y) > 0)){
          endpoint = points.get(j);   // found greater left turn, update endpoint
       }
    }
    i++;
    pointOnHull = endpoint;
 }while(endpoint != hull.get(0));
 
 return hull;
}

ArrayList<Point> grahamScan(){
  ArrayList<Point> hull = new ArrayList<Point>();
  ArrayList<Point> tmpPoints = (ArrayList<Point>)points.clone();
  int n = points.size();
  
  if(n < 3){
    return hull;
  }
      
  Point lowestPoint = new Point(Integer.MAX_VALUE, Integer.MAX_VALUE);
  int lowestPointIndex = 0;
  for(int i = 0; i < n; i++){
    if(tmpPoints.get(i).y < lowestPoint.y){
      lowestPoint = tmpPoints.get(i);
      lowestPointIndex = i;        
    }
  }
  
  Point tmpPoint = tmpPoints.get(0);
  points.set(0, lowestPoint);
  points.set(lowestPointIndex, tmpPoint);
  
  Collections.sort(tmpPoints, new PolarComparator(lowestPoint)); 
   
  hull.add(lowestPoint);
  hull.add(tmpPoints.get(1));    
  
  int i = 2;    
  while(i < n){
    if(counterClockwise(hull.get(hull.size() - 2), hull.get(hull.size() - 1), tmpPoints.get(i)) > 0){
      hull.add(tmpPoints.get(i)); 
      i++;
    }else{
      hull.remove(hull.size() - 1);
    }
  }
  
  return hull;
}

ArrayList<Edge> triangulate(ArrayList<Point> hull){
  ArrayList<Point> leftPath = new ArrayList<Point>();
  ArrayList<Point> rightPath = new ArrayList<Point>();
  
  Point previousPoint = hull.get(0);
  leftPath.add(previousPoint);
  
  for(Point point : hull){
    if(previousPoint == point){
      continue;
    }
    
    if(point.y > previousPoint.y)
    {
      leftPath.add(point);
    }else{
      rightPath.add(point);
    }
    
    previousPoint = point;
  }
  
  //sort vertices v1, v2, …, vn lexicographically
  ArrayList<Point> sortedHull = new ArrayList<Point>(hull);
  Collections.sort(sortedHull, new VerticalComparator());
  
  //put v1 , v2 to stack
  Stack<Point> stack = new Stack<Point>();
  stack.push(sortedHull.get(0));
  stack.push(sortedHull.get(1));
  
  ArrayList<Edge> edges = new ArrayList<Edge>();
  //for i = 3 to n:
  for(int i = 2; i < sortedHull.size(); i++){          
    Point pointi = sortedHull.get(i);
    //println("Point " + i + ": " + pointi + ", stack size: " + stack.size());
  //  if vi and the top of the stack lie on the same path (left or right)
  //    add edges vi, vj, …, vi, vk, where vk is the last vertex forming the “correct” line
  //    pop vj, …, vk and push vi
    if(leftPath.contains(stack.peek()) && leftPath.contains(pointi)){
      while(stack.size() >= 2){        
        Point pointj = stack.pop();
        Point pointk = stack.pop();
        if(counterClockwise(pointk, pointj, pointi) < 0){
          edges.add(new Edge(pointi, pointk));
        }else{
          stack.push(pointk);
          stack.push(pointj);            
          break;
        }
      }
    }else if(rightPath.contains(stack.peek()) && rightPath.contains(pointi)){
      while(stack.size() >= 2){
        Point pointj = stack.pop();
        Point pointk = stack.pop();
        if(counterClockwise(pointk, pointj, pointi) > 0){
          edges.add(new Edge(pointi, pointk));
        }else{
          stack.push(pointk);
          stack.push(pointj);
          break;
        }
      }
  //  else
  //    add edges from vi to all vertices stored in stack and remove (pop) them from stack
  //    store vtop
  //    push vtop and vi
    }else{
      Point pointTop = stack.peek();
      while(stack.size() > 0){    
        edges.add(new Edge(pointi, stack.pop()));
      }
      
      stack.push(pointTop);
    }
    
    stack.push(pointi);
  }
  
  for(int i = 0; i < hull.size() - 1; i++){
    Edge hullEdge = new Edge(hull.get(i), hull.get(i + 1));
    if(!edges.contains(hullEdge)){
      edges.add(hullEdge);
    }  
  }
  
  Edge hullEdge = new Edge(hull.get(hull.size() - 1), hull.get(0));
  if(!edges.contains(hullEdge)){
    edges.add(hullEdge);
  }
  
  return new ArrayList(edges);
}

KDNode createKDTree(ArrayList<Point> points, int depth){  //point belongs to left and below  
  if(points.isEmpty()){
    return null;
  }
  
  
  ArrayList<Point> points1 = new ArrayList<Point>();
  ArrayList<Point> points2 = new ArrayList<Point>();
  
  Point pointl;
  
  if(points.size() == 1){
    return new KDNode(points.get(0), depth);
  }else if((depth % 2) == 0 ){ //DEPTH! NOT the number of points!
    ArrayList<Point> sortedPoints = new ArrayList<Point>(points);
    Collections.sort(sortedPoints, new HorizontalComparator()); // FROM LEFT TO RIGHT

    for(int i = 0; i < (sortedPoints.size() / 2);i++){ // LEFT
      points1.add(sortedPoints.get(i));
    }
    
    for(int i = (points.size() / 2); i < sortedPoints.size();i++){ // RIGHT
      points2.add(sortedPoints.get(i));
    }
    
    //pointl = sortedPoints.get(sortedPoints.size() /2);
    pointl = sortedPoints.get(sortedPoints.size() / 2 - 1); // THE POINT ON L BELONGS TO LEFT
  }else{
    ArrayList<Point> sortedPoints = new ArrayList<Point>(points);
    Collections.sort(sortedPoints, new VerticalComparator()); // FROM THE TOP TO THE BOTTOM

    for(int i = 0; i < (sortedPoints.size() / 2);i++){ // ABOVE
      points1.add(sortedPoints.get(i));
    }
    
    for(int i = (sortedPoints.size() / 2); i < sortedPoints.size();i++){ // BELOW
      points2.add(sortedPoints.get(i));
    }
    
    pointl = sortedPoints.get(sortedPoints.size()/2); // POINT ON L BELONGS BELOW
  }
  
  KDNode v = new KDNode(pointl, depth);
  KDNode vLeft = createKDTree(points1, depth + 1);
  KDNode vRight = createKDTree(points2, depth + 1);
  
      
  if(vLeft != null){
    vLeft.parent = v;
  }
  
  if(vRight != null){
    vRight.parent = v;
  }
 
  v.lesser = vLeft;
  v.greater = vRight;

  return v;
}

ArrayList<Edge> delaunayTriangulation(ArrayList<Point> points){
  if(points.isEmpty()){
    return null;
  }
  
  boolean isTriangleCW = true;
  ArrayList<Edge> dt = new ArrayList<Edge>();
  Queue<Edge> ael = new LinkedList<Edge>();

  Point p1 = getLeftmostPoint(points); //p1 = random point
  //p1.clr = color(255,0,0);
  Point p2 = p1.getClosestPoint(points); //p2 = closest point to p1
  //p2.clr = color(0,255,0);
  
  Edge e = new Edge(p1, p2);
  Point p = e.findDelaunayPoint(points); //p = smallest Delaunay distance from e
  if(p == null){ // IF SO, THE FIRST TRIANGLE WONT BE STORED CLOCKWISE
    isTriangleCW = false;
    e = new Edge(p2, p1);
    p = e.findDelaunayPoint(points);
  }
  //p.clr = color(0,0,255);
  
  Edge e2 = new Edge(p2, p);
  Edge e3 = new Edge(p, p1);

  Triangle triangle = new Triangle(); // THE FIRST TRIANGLE HAS TO BE STORED CLOCKWISE
  if(!isTriangleCW){
    //e = new Edge(p1, p2);
    e2 = new Edge(p, p2);
    e3 = new Edge(p1, p);
    
    triangle = new Triangle(p, p2, p1);
  }else{
    triangle = new Triangle(p, p1, p2);
  }

  ael.add(e);
  ael.add(e2);
  ael.add(e3);
  
  trianglesToDisplay.add(triangle);
      
  while (!ael.isEmpty()){
    e = ael.poll();
    e = new Edge(e.point2, e.point1);
    p = e.findDelaunayPoint(points); //p = smallest Delaunay distance from e
    if(p != null){
      e2 = new Edge(e.point2, p);
      e3 = new Edge(p, e.point1);
      addToAEL(e2, ael, dt); //Add e2, e3 to AEL
      addToAEL(e3, ael, dt);
      triangle = new Triangle(p, e.point1, e.point2);
      trianglesToDisplay.add(triangle);
    }
    dt.add(e);
    ael.remove(e);
  }
  
  return dt;
} //<>//

void addToAEL(Edge e, Queue<Edge> ael, ArrayList<Edge> dt){
  Edge eReversed = new Edge(e.point2, e.point1);
  if(ael.contains(eReversed)){
    ael.remove(e);
  }else{
    ael.add(e);
  }
  
  dt.add(e);
}

Point getLeftmostPoint(ArrayList<Point> points){
  Point leftmostPoint = points.get(0);
  for(Point point : points){
    if(leftmostPoint.x > point.x){      
      leftmostPoint = point;
    }
  }
  
  return leftmostPoint;
}

ArrayList<Edge> voronoi(ArrayList<Triangle> triangles){
  ArrayList<Edge> edges = new ArrayList<Edge>();
  ArrayList<Point> voronoiPoints = new ArrayList<Point>();
  
  for(Triangle triangle : triangles){
    Point voronoiPoint = new Point(triangle.getVoronoiPoint().x, triangle.getVoronoiPoint().y);
    voronoiPoint.clr = color(255, 0, 0);
    voronoiPoints.add(voronoiPoint);
    
    ArrayList<Triangle> neighbourTriangles = new ArrayList<Triangle>();  
    
    
    if(findTriangle(triangles, triangle, new Edge(triangle.point1, triangle.point2), voronoiPoint) != null){
      neighbourTriangles.add(findTriangle(triangles, triangle, new Edge(triangle.point1, triangle.point2), voronoiPoint));
    }else{
        Point edgeMiddle = new Point((triangle.point1.x + triangle.point2.x)/2, (triangle.point1.y + triangle.point2.y)/2);
        PVector normVector = (new PVector(voronoiPoint.x - edgeMiddle.x, voronoiPoint.y - edgeMiddle.y)).normalize();
        if((new Edge(triangle.point1, triangle.point2)).direction(voronoiPoint) > 0){
          normVector.mult(-1);
        }
        normVector.mult(500);
        edges.add(new Edge(voronoiPoint, new Point(normVector.x + voronoiPoint.x, normVector.y + voronoiPoint.y), color(255, 0, 0))); //<>//
    }
    
    if(findTriangle(triangles, triangle, new Edge(triangle.point2, triangle.point3), voronoiPoint) != null){
      neighbourTriangles.add(findTriangle(triangles, triangle, new Edge(triangle.point2, triangle.point3), voronoiPoint));
    }else{
        Point edgeMiddle = new Point((triangle.point2.x + triangle.point3.x)/2, (triangle.point2.y + triangle.point3.y)/2);
        PVector normVector = (new PVector(voronoiPoint.x - edgeMiddle.x, voronoiPoint.y - edgeMiddle.y)).normalize();
        if((new Edge(triangle.point2, triangle.point3)).direction(voronoiPoint) > 0){
          normVector.mult(-1);
        }
        normVector.mult(500);
        edges.add(new Edge(voronoiPoint, new Point(normVector.x + voronoiPoint.x, normVector.y + voronoiPoint.y), color(255, 0, 0)));
    }
    
    if(findTriangle(triangles, triangle, new Edge(triangle.point3, triangle.point1), voronoiPoint) != null){
      neighbourTriangles.add(findTriangle(triangles, triangle, new Edge(triangle.point3, triangle.point1), voronoiPoint));
    }else{
        Point edgeMiddle = new Point((triangle.point3.x + triangle.point1.x)/2, (triangle.point3.y + triangle.point1.y)/2);
        PVector normVector = (new PVector(voronoiPoint.x - edgeMiddle.x, voronoiPoint.y - edgeMiddle.y)).normalize();
        if((new Edge(triangle.point3, triangle.point1)).direction(voronoiPoint) > 0){
          normVector.mult(-1);
        }
        normVector.mult(500);
        edges.add(new Edge(voronoiPoint, new Point(normVector.x + voronoiPoint.x, normVector.y + voronoiPoint.y), color(255, 0, 0)));
    }
    
    /*
    neighbourTriangles.add(findTriangle(triangles, triangle, new Edge(triangle.point1, triangle.point2), voronoiPoint));
    neighbourTriangles.add(findTriangle(triangles, triangle, new Edge(triangle.point2, triangle.point3), voronoiPoint));
    neighbourTriangles.add(findTriangle(triangles, triangle, new Edge(triangle.point3, triangle.point1), voronoiPoint));
   */
   
    if(!neighbourTriangles.isEmpty()){
      for(Triangle neighbourTriangle : neighbourTriangles){   
        if(neighbourTriangle != null){
          edges.add(new Edge(voronoiPoint, neighbourTriangle.getVoronoiPoint(), color(255, 0, 0)));
        }
      }  
    }
  } 
  
  points.addAll(voronoiPoints);
  return edges;
}

Triangle findTriangle(ArrayList<Triangle> triangles, Triangle currentTriangle, Edge edge, Point voronoiPoint){
  for(Triangle triangle : triangles){
    if(triangle == currentTriangle){
      continue;
    }
    if(triangle.containsEdge(edge)){
      return triangle;
    }
  }
   //<>//
  //return edge.direction(voronoiPoint) > 0 ? new Triangle(edge.point1, edge.point2, voronoiPoint) : null;
  return null;
}