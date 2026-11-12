using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerMoveScript : MonoBehaviour
{
    public GameObject mainCam;
    public float charSpeed;
    public Keyboard mainKB;
    public Vector3 camRotation;
    public Vector3 goDirection;
    
    void Start()
    {
        mainKB = Keyboard.current;
    }

    // Update is called once per frame
    void Update()
    {
        if (mainKB.wKey.isPressed)
        {
            this.transform.Translate(Vector3.forward * charSpeed * Time.deltaTime);
        }

        if (mainKB.sKey.isPressed)
        {
            this.transform.Translate(Vector3.back * charSpeed * Time.deltaTime);
        }

        if (mainKB.dKey.isPressed)
        {
            this.transform.Translate(Vector3.right * charSpeed * Time.deltaTime);
        }

        if (mainKB.aKey.isPressed)
        {
            this.transform.Translate(Vector3.left * charSpeed * Time.deltaTime);
        }
    }
}
