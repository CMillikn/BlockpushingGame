using System;
using UnityEngine;

public class PushBoxDetectionCollider : MonoBehaviour
{
    public bool isColliding;
    public bool noBox;
    public GameObject pushPoint;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void OnTriggerEnter(Collider other)
    {
        LockPointTag validPoint = other.gameObject.GetComponent<LockPointTag>();
        PushableBoxScript pushBox = other.gameObject.GetComponent<PushableBoxScript>();
        if (pushBox != null)
        {
            noBox = false;
        }
        else if (validPoint != null)
        {
            if (validPoint.containingBox != true)
            {
                noBox = true;
                isColliding = true;
                pushPoint =  other.gameObject;
            }
        }
        else
        {
            return;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        LockPointTag validPoint = other.gameObject.GetComponent<LockPointTag>();
        PushableBoxScript pushBox = other.gameObject.GetComponent<PushableBoxScript>();
        if (pushBox != null)
        {
            noBox = false;
        }
        else if (validPoint != null)
        {
            if (validPoint.containingBox != true)
            {
                noBox = true;
                isColliding = true;
                pushPoint =  other.gameObject;
            }
        }
        else
        {
            return;
        }
    }

    void OnTriggerExit(Collider other)
    {
        LockPointTag validPoint = other.gameObject.GetComponent<LockPointTag>();
        PushableBoxScript pushBox = other.gameObject.GetComponent<PushableBoxScript>();
        if (pushBox != null)
        {
            noBox = true;
        }
        if (validPoint != null)
        {
            if (validPoint.containingBox != true)
            {
                noBox = true;
                isColliding = false;
                pushPoint =  other.gameObject;
            }
        }
        else
        {
            return;
        }
    }
}
