class ActiveEdge{
  Edge edge; //current edge
  ActiveEdge followingEdge; //next counterclockwise edge in a triangle
  ActiveEdge adjacentEdge; //the same edge in adjacent triangle or null
  
  public ActiveEdge(Edge edge){
    this.edge = edge;
  }
  
  @Override
  public boolean equals(Object obj){
    if (obj == null) {
        return false;
    }
    if (!ActiveEdge.class.isAssignableFrom(obj.getClass())) {
        return false;
    }
    final ActiveEdge other = (ActiveEdge) obj;
    
    return (edge.point1 == other.edge.point1 && edge.point2 == other.edge.point2);
  }
}