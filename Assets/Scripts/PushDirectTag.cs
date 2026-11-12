using System;
using UnityEngine;

public class PushDirectTag : MonoBehaviour
{
    public enum pushDirection
    {
        north,
        south,
        east,
        west,
        middle,
    }
    public pushDirection direction;
    public LockPointTag lockPointScript;
    
    private void OnTriggerEnter(Collider other)
    {
        if (direction == pushDirection.middle)
        {
            lockPointScript =  other.gameObject.GetComponent<LockPointTag>();
            if (lockPointScript != null)
            {
                lockPointScript.containingBox = true;
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (direction == pushDirection.middle)
        {
            lockPointScript =  other.gameObject.GetComponent<LockPointTag>();
            if (lockPointScript != null)
            {
                lockPointScript.containingBox = false;
            }
        }
    }
}
