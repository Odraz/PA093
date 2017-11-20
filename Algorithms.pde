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
  
  for(Point point : hull){
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
  //  if vi and the top of the stack lie on the same path (left or right)
  //    add edges vi, vj, …, vi, vk, where vk is the last vertex forming the “correct” line
  //    pop vj, …, vk and push vi
    if(leftPath.contains(stack.peek()) && leftPath.contains(pointi)){
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
    }else if(rightPath.contains(stack.peek()) && rightPath.contains(pointi)){
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

KDNode createKDTree(ArrayList<Point> points, int depth){    
  if(points.isEmpty()){
    return null;
  }
  
  ArrayList<Point> points1 = new ArrayList<Point>();
  ArrayList<Point> points2 = new ArrayList<Point>();
  
  Point pointl;
  
  if(points.size() == 1){
    return new KDNode(points.get(0), depth);
  }else if((depth % 2) == 0 ){
    ArrayList<Point> sortedPoints = new ArrayList<Point>(points);
    Collections.sort(sortedPoints, new HorizontalComparator());

    /*
    for(Point point : sortedPoints){
      println(point);
    }
    */
    
    for(int i = 0; i < (sortedPoints.size() / 2);i++){ //(4/2 + 1)
      points1.add(sortedPoints.get(i));
    }
    
    for(int i = (points.size() / 2 + 1); i < sortedPoints.size();i++){
      points2.add(sortedPoints.get(i));
    }
    
    pointl = sortedPoints.get(sortedPoints.size() /2);
  }else{
    ArrayList<Point> sortedPoints = new ArrayList<Point>(points);
    Collections.sort(sortedPoints, new VerticalComparator());
    Collections.reverse(sortedPoints);
    
    println("-------------");
    for(Point point : sortedPoints){
      println(point);
    }
    
    for(int i = 0; i < (sortedPoints.size() / 2);i++){ //(3/2)
      points1.add(sortedPoints.get(i));
    }
    
    for(int i = (sortedPoints.size() / 2) + 1; i < sortedPoints.size();i++){
      points2.add(sortedPoints.get(i));
    }
    
    pointl = sortedPoints.get(sortedPoints.size()/2);
    //println("median: " + pointl);
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

ArrayList<Edge> delaunayTriangulation(ArrayList<Point> hull){
  ArrayList<Edge> dt = new ArrayList<Edge>();
  Queue<ActiveEdge> ael = new LinkedList<ActiveEdge>();

  Point p1 = hull.get(0); //p1 = random point
  Point p2 = null; //p2 = closest point to p1
  
  double closestDistance = Integer.MAX_VALUE;
  for(Point point : hull){
    if(point == p1){
      continue;
    }
    if(p1.distance(point) < closestDistance){
      closestDistance = p1.distance(point);
      p2 = point;
    }
  }
  
  Edge e = new Edge(p1, p2);
  Point p = findDelaunayPoint(hull, e); //p = smallest Delaunay distance from e
  if(p == null){
    e = new Edge(p2, p1);
    p = findDelaunayPoint(hull, e);
  }
  
  Edge e2 = new Edge(p2, p);
  Edge e3 = new Edge(p, p1);
  
  ActiveEdge aE = new ActiveEdge(e);
  ActiveEdge aE2 = new ActiveEdge(e2);
  ActiveEdge aE3 = new ActiveEdge(e3);
  
  aE.adjacentEdge = aE2;
  aE2.adjacentEdge = aE3;
  aE3.adjacentEdge = aE;
  
  ael.add(aE);
  ael.add(aE2);
  ael.add(aE3);
  
  while (!ael.isEmpty()){
    aE = ael.poll();
    aE.edge = new Edge(aE.edge.point2, aE.edge.point1);
    p = findDelaunayPoint(hull, aE.edge); //p = smallest Delaunay distance from e
    if(p != null){
      e2 = new Edge(aE.edge.point2, p);
      e3 = new Edge(p, aE.edge.point1);
      AddToAEL(e2, ael, dt); //Add e2, e3 to AEL
      AddToAEL(e3, ael, dt);
    }
    
    dt.add(aE.edge);
    ael.remove(aE);
  }
  
  return dt; //<>//
}

void AddToAEL(Edge e, Queue<ActiveEdge> ael, ArrayList<Edge> dt){
  Edge eReversed = new Edge(e.point2, e.point1);
  if(ael.contains(eReversed)){
    ael.remove(new ActiveEdge(e));
  }else{
    ActiveEdge aE = new ActiveEdge(e);
    //aE.adjacentEdge = aE2;
    ael.add(aE);
  }
  
  dt.add(e);
}

Point findDelaunayPoint(ArrayList<Point> hull, Edge e){
  double smallestDelaunayDistance = Integer.MAX_VALUE;
  Point p = null;
  
  for(Point point : hull){
    if((point == e.point1 || point == e.point2) || (e.direction(point) <= 0)){
      continue;
    }
    if(e.delaunayDistance(point) < smallestDelaunayDistance){
      smallestDelaunayDistance = e.delaunayDistance(point);
      p = point;
    }
  }
  
  return p;
}