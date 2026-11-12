using System.Collections;
using UnityEngine;

public class SelfDestruct : MonoBehaviour
{
    public float selfDesTime;
    void Start()
    {
        StartCoroutine(DestroySelf());
    }

    IEnumerator DestroySelf()
    {
        yield return new WaitForSeconds(selfDesTime);
        {
            Destroy(this.gameObject);
        }
    }
}
