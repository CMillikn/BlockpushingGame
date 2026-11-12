using System;
using System.Collections.Generic;
using NUnit.Framework;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class PlayerScript : MonoBehaviour
{

    public GameObject camMain;
    public float rotY;
    public float rotX;
    public float turnSpeed;
    public float minTurnAngle = -90.0f;
    public float maxTurnAngle = 90.0f;
    public Mouse mainMouse;
    public LayerMask pusherMask;
    public LayerMask idleMask;
    public PushableBoxScript pushableBox;

    public PushableBoxScript visualBox;
    //public List<PushableBoxScript> pushableBoxes;
    public PushDirectTag pushDirectScript;
    public Image crosshairImage;
        
    private void Start()
    {
        mainMouse = Mouse.current;
        Cursor.lockState = CursorLockMode.Locked;
    }

    void Update()
    {
        mouseTurn();

        RaycastHit idleHit;
        if (Physics.Raycast(camMain.transform.position, camMain.transform.forward, out idleHit, 0.75f, idleMask))
        {
            visualBox = idleHit.transform.GetComponentInParent<PushableBoxScript>();
            if (visualBox != null)
            {
                if (visualBox.isPushable)
                {
                    crosshairImage.color = Color.green;
                }
                else if (!visualBox.isPushable)
                {
                    crosshairImage.color = Color.red;
                }
            }
        }
        else
        {
            crosshairImage.color = Color.white;
        }
        
        if (mainMouse.leftButton.wasPressedThisFrame)
        {
            RaycastHit hit;
            if (Physics.Raycast(camMain.transform.position, camMain.transform.forward, out hit, 0.75f, pusherMask))
            {
                pushableBox = hit.transform.GetComponentInParent<PushableBoxScript>();
                if (pushableBox != null)
                {
                    pushDirectScript =  hit.transform.gameObject.GetComponent<PushDirectTag>();
                    if (pushDirectScript != null)
                    {
                        if (pushDirectScript.direction == PushDirectTag.pushDirection.north)
                        {
                            pushableBox.PushObjectSouth();
                        }
                        else if (pushDirectScript.direction == PushDirectTag.pushDirection.south)
                        {
                            pushableBox.PushObjectNorth();
                        }
                        else if (pushDirectScript.direction == PushDirectTag.pushDirection.east)
                        {
                            pushableBox.PushObjectWest();
                        }
                        else if (pushDirectScript.direction == PushDirectTag.pushDirection.west)
                        {
                            pushableBox.PushObjectEast();
                        }
                    }
                }

            }
        }

        if (mainMouse.rightButton.wasPressedThisFrame)
        {
            RaycastHit hit;
            if (Physics.Raycast(camMain.transform.position, camMain.transform.forward, out hit, 0.75f, pusherMask))
            {
                pushableBox = hit.transform.GetComponentInParent<PushableBoxScript>();
                if (pushableBox != null)
                {
                    pushDirectScript =  hit.transform.gameObject.GetComponent<PushDirectTag>();
                    if (pushDirectScript != null)
                    {
                        if (pushDirectScript.direction == PushDirectTag.pushDirection.north)
                        {
                            pushableBox.PushObjectNorth();
                        }
                        else if (pushDirectScript.direction == PushDirectTag.pushDirection.south)
                        {
                            pushableBox.PushObjectSouth();
                        }
                        else if (pushDirectScript.direction == PushDirectTag.pushDirection.east)
                        {
                            pushableBox.PushObjectEast();
                        }
                        else if (pushDirectScript.direction == PushDirectTag.pushDirection.west)
                        {
                            pushableBox.PushObjectWest();
                        }
                    }
                }   
            }
        }
    }

    void mouseTurn()
    {
        // get the mouse inputs
        float y = Input.GetAxis("Mouse X") * turnSpeed;
        rotX += Input.GetAxis("Mouse Y") * turnSpeed;
        // clamp the vertical rotation
        rotX = Mathf.Clamp(rotX, minTurnAngle, maxTurnAngle);
        // rotate the camera
        transform.eulerAngles = new Vector3(-rotX, transform.eulerAngles.y + y, 0);
    }
}
