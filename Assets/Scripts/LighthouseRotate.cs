using UnityEngine;

public class LighthouseRotate : MonoBehaviour
{
    public float blockerSpinSpeed;

    // Update is called once per frame
    void Update()
    {
        transform.localEulerAngles = new Vector3(0, this.transform.localEulerAngles.y + (blockerSpinSpeed * Time.deltaTime), 0);
    }
}
