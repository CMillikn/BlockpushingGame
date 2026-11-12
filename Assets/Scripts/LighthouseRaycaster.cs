using UnityEngine;
using System.Collections.Generic;

public class LighthouseRaycaster : MonoBehaviour
{
    public List<GameObject> seaSpiders;
    public LayerMask lighthouseRaycastMask; 
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (seaSpiders.Count > 0)
        {
           foreach (GameObject seaSpider in seaSpiders)
           {
               RaycastHit raycastHit;
               Debug.DrawRay(transform.position, seaSpider.transform.position-transform.position, Color.red);
               if (Physics.Raycast(this.transform.position, seaSpider.transform.position-transform.position, out raycastHit, Mathf.Infinity,
                       lighthouseRaycastMask))
               {
                   SeaSpiderChaserScript testSpider = raycastHit.collider.GetComponent<SeaSpiderChaserScript>();
                   if (testSpider != null)
                   {
                       testSpider.canWalk = false;
                   }
                   else
                   {
                       SeaSpiderChaserScript failSpider = seaSpider.GetComponent<SeaSpiderChaserScript>();
                       {
                           failSpider.canWalk = true;
                       }
                   }
               }
           } 
        }
    }
}
