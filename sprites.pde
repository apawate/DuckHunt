public class GameCharacter {
  int x;
  int y;
  int z; 
  int length;
  int height;
  public GameCharacter(int x, int y, int z, int length, int height) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.length = length;
    this.height = height;
  }
  
  public int[] getCoordinates() {
    return {x, y, z};
  }
  
  public int[] getBox() {
    return {length, height};
  }
  
  boolean hasCollided(GameCharacter other) {
    
