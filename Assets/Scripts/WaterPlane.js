public class WaterPlane extends MonoBehaviour {
	public var waterDensity : float = 1f;
	public var waterDrag : float = 1.5f;
	public var waterAngularDrag : float = 1f;
	public var currentStrength : float = 2f;
	public var currents : Texture2D;
	private static var s_Instance : WaterPlane = null;
	
	public static function getInstance() : WaterPlane {
		if (s_Instance == null)
			s_Instance = FindObjectOfType(WaterPlane);
		return s_Instance;
	}
    
    function OnApplicationQuit() {
        s_Instance = null;
    }
}